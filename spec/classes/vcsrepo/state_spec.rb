require 'spec_helper'

describe 'bootstrap::vcsrepo::state' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it do
        is_expected.to compile

        is_expected.to contain_file('/data/state') \
          .with(
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'privatecvs',
            'mode'   => '0775',
          )

        is_expected.to contain_vcsrepo('/data/state') \
          .with(
            'ensure'   => 'present',
            'user'     => 'maint',
            'group'    => 'privatecvs',
            'provider' => 'git',
            'source'   => 'ssh://git.mysociety.org/data/git/private/mysociety-state.git',
          ) \
          .that_notifies('Exec[fixperms-state]')

        is_expected.to contain_exec('fixperms-state') \
          .with(
            'cwd'         => '/data',
            'command'     => '/bin/chgrp -R privatecvs ./state',
            'refreshonly' => true,
          )

        is_expected.to contain_file('/data/state/test-host') \
          .with('ensure' => 'directory') \
          .that_requires('Vcsrepo[/data/state]')
      end
    end
  end
end
