require 'spec_helper'

describe 'bootstrap::maint' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include bootstrap' }

      it do
        is_expected.to compile

        is_expected.to contain_user('maint') \
          .with(
            'ensure'     => 'present',
            'uid'        => '3004',
            'gid'        => '3004',
            'groups'     => ['publiccvs', 'privatecvs', 'privategit-puppet'],
            'home'       => '/home/maint',
            'shell'      => '/bin/bash',
            'managehome' => true,
          )

        is_expected.to contain_file('/home/maint/.ssh') \
          .with('mode' => '0700', 'owner' => 'maint') \

        is_expected.to contain_file('/home/maint/.ssh/id_rsa') \
          .with('mode' => '0600', 'owner' => 'maint', 'show_diff' => false) \
          .with_content(%r{BEGIN RSA PRIVATE KEY})

        is_expected.to contain_file('/home/maint/.ssh/id_rsa.pub') \
          .with_content(%r{^ssh-rsa})

        is_expected.to contain_file('/home/maint/ssh-as-sudoer') \
          .with_content(%r{# ssh-as-sudoer:})
      end
    end
  end
end
