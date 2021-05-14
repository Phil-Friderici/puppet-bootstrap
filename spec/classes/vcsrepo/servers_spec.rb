require 'spec_helper'

describe 'bootstrap::vcsrepo::servers' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it do
        is_expected.to compile

        is_expected.to contain_file('/data/servers') \
          .with(
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'privatecvs',
            'mode'   => '2770',
          )

        is_expected.to contain_vcsrepo('/data/servers') \
          .with(
            'ensure'   => 'present',
            'user'     => 'maint',
            'group'    => 'privatecvs',
            'provider' => 'git',
            'source'   => 'ssh://git.mysociety.org/data/git/private/mysociety-servers.git',
          ) \
          .that_notifies('Exec[fixperms-servers]')

        is_expected.to contain_exec('fixperms-servers') \
          .with('refreshonly' => true, 'cwd' => '/data') \
          .with_command(%r{^/bin/chgrp.+ \\;$})

        is_expected.to contain_file('/data/servers/.git/hooks/post-checkout') \
          .with(
            'ensure'  => 'file',
            'mode'    => '0775',
            'group'   => 'privatecvs',
            'source'  => 'puppet:///modules/bootstrap/vcsrepo/post-checkout',
          ) \
          .that_requires('Vcsrepo[/data/servers]')

        ['/data/servers/.git/hooks/post-commit', '/data/servers/.git/hooks/post-merge'].each do |hook|
          is_expected.to contain_file(hook) \
            .with(
              'ensure' => 'link',
              'group'  => 'privatecvs',
              'target' => '/data/servers/.git/hooks/post-checkout',
            )
        end

        is_expected.to contain_exec('/data/fonts') \
          .with(
            'command' => '/bin/cp -r /data/servers/fonts /data/fonts',
            'creates' => '/data/fonts',
          ) \
          .that_requires('Vcsrepo[/data/servers]')

        is_expected.to contain_cron__job('check-uncommitted-servers') \
          .with(
            'ensure'      => 'present',
            'environment' => [ 'MAILTO=infrastructure@mysociety.org' ],
            'hour'        => '6',
            'minute'      => '57',
            'weekday'     => '7',
            'user'        => 'root',
            'command'     => 'cd /data/servers && git diff -u',
          )
      end
    end
  end
end
