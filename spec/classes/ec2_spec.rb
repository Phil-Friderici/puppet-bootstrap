require 'spec_helper'

describe 'bootstrap::ec2' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge('ec2_metadata' => { 'public-ipv4' => '54.1.2.3' }) }
      let(:params) { { 'ddns_key' => 'key "ec2.mysociety.org" { algorithm hmac-sha512; secret "foobar"; };' } }

      it do
        is_expected.to compile

        is_expected.to contain_exec('set-hostname') \
          .with_command('/usr/bin/hostnamectl set-hostname 54-1-2-3') \
          .with_unless('/usr/bin/test $(/bin/hostname) = 54-1-2-3')

        is_expected.to contain_package('dnsutils').with_ensure('present')

        is_expected.to contain_file('/etc/ddns-update').with_ensure('directory')

        is_expected.to contain_file('/etc/ddns-update/ec2.key') \
          .with(
            'mode'      => '0400',
            'owner'     => 'root',
            'group'     => 'root',
            'show_diff' => false,
          ) \
          .with_content(%r{hmac-sha512;}) \
          .that_comes_before('File[/usr/local/bin/ddns-update]')

        is_expected.to contain_file('/usr/local/bin/ddns-update') \
          .with('mode' => '0754') \
          .with_content(%r{update add 54-1-2-3.ec2.mysociety.org 60 A 54.1.2.3}) \
          .that_comes_before('File[/etc/systemd/system/ddns-update.service]')

        is_expected.to contain_file('/etc/systemd/system/ddns-update.service') \
          .that_notifies('Service[ddns-update]')

        is_expected.to contain_service('ddns-update') \
          .with(
            'ensure' => 'running',
            'enable' => true,
          )
      end
    end
  end
end
