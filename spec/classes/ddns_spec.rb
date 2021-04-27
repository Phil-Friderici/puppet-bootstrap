# frozen_string_literal: true

require 'spec_helper'

describe 'bootstrap::ddns' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts.merge(
          'ec2_metadata' => {
            'public-ipv4' => '54.1.2.3',
          },
          'networking' => {
            'hostname' => '54-1-2-3',
          },
        )
      end
      let(:params) do
        {
          'ddns_key'    => {
            'algorithm' => 'hmac-sha512',
            'secret'    => 'foobar'
          },
        'ddns_domain' => 'ec2.mysociety.org',
        }
      end

      context 'with defaults' do
        it do
          is_expected.to compile
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

      context 'with hostname override' do
        let(:params) do
          super().merge(
            {
              'host_name' => 'srv-ab1c2',
            },
          )
        end

        it do
          is_expected.to compile
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
            .with_content(%r{update add srv-ab1c2.ec2.mysociety.org 60 A 54.1.2.3}) \
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
end
