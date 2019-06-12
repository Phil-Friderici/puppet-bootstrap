require 'spec_helper'

describe 'bootstrap::vcsrepo::scripts' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it do
        is_expected.to compile

        is_expected.to contain_file('/data/mysociety') \
          .with(
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'privatecvs',
            'mode'   => '2775',
          )

        is_expected.to contain_vcsrepo('/data/mysociety') \
          .with(
            'ensure'   => 'present',
            'user'     => 'maint',
            'group'    => 'privatecvs',
            'provider' => 'git',
            'source'   => 'ssh://git.mysociety.org/data/git/public/misc-scripts.git',
          ) \
          .that_notifies('Exec[fixperms-scripts]')

        is_expected.to contain_exec('fixperms-scripts') \
          .with('refreshonly' => true, 'cwd' => '/data') \
          .with_command(%r{^/bin/chgrp.+ \\;$})

        is_expected.to contain_exec('run-with-lockfile') \
          .with(
            'cwd'     => '/data/mysociety/run-with-lockfile',
            'command' => '/usr/bin/make',
            'creates' => '/data/mysociety/run-with-lockfile/run-with-lockfile',
          ) \
          .that_requires('Vcsrepo[/data/mysociety]')
      end
    end
  end
end
