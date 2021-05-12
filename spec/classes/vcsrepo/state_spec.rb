require 'spec_helper'

describe 'bootstrap::vcsrepo::state' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it do
        is_expected.to compile

        is_expected.to contain_vcsrepo('/var/lib/server-state') \
          .with(
            'ensure'   => 'present',
            'user'     => 'root',
            'group'    => 'staff',
            'provider' => 'git',
          ) \
          .that_notifies('Exec[fixperms-state]')

        is_expected.to contain_exec('fixperms-state') \
          .with(
            'cwd'         => '/var/lib',
            'refreshonly' => true,
          ) \
          .with_command('/bin/chgrp -R staff ./server-state && chmod o-rwx ./server-state')

        is_expected.to contain_file('/etc/cron.daily/save-package-list')
        is_expected.to contain_file('/etc/cron.daily/save-passwd-group')
        is_expected.to contain_file('/etc/cron.daily/save-vhost-list')
      end
    end
  end
end
