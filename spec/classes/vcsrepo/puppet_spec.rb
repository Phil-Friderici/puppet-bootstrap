require 'spec_helper'

describe 'bootstrap::vcsrepo::puppet' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it do
        is_expected.to compile

        is_expected.to contain_file('/data/puppet') \
          .with(
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'privategit-puppet',
            'mode'   => '2770',
          )

        is_expected.to contain_vcsrepo('/data/puppet') \
          .with(
            'user'   => 'maint',
            'group'  => 'privategit-puppet',
            'source' => 'ssh://git.mysociety.org/data/git/private/mysociety-puppet.git',
          )

        is_expected.to contain_exec('fixperms-puppet') \
          .with('refreshonly' => true, 'cwd' => '/data') \
          .with_command(%r{^/bin/chgrp.+ \\;$})

        is_expected.to contain_file('/data/puppet/.git/hooks/post-checkout') \
          .with(
            'ensure'  => 'file',
            'mode'    => '0775',
            'group'   => 'privategit-puppet',
            'source'  => 'puppet:///modules/bootstrap/vcsrepo/post-checkout',
          ) \
          .that_requires('Vcsrepo[/data/puppet]')

        ['/data/puppet/.git/hooks/post-commit', '/data/puppet/.git/hooks/post-merge'].each do |hook|
          is_expected.to contain_file(hook) \
            .with(
              'ensure' => 'link',
              'group'  => 'privategit-puppet',
              'target' => '/data/puppet/.git/hooks/post-checkout',
            )
        end
      end
    end
  end
end
