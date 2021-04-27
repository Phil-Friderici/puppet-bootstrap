require 'spec_helper'

describe 'bootstrap::ec2' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts.merge(
          'ec2_metadata' => {
            'public-ipv4' => '54.1.2.3',
          },
        )
      end

      it do
        is_expected.to compile

        is_expected.to contain_exec('set-hostname') \
          .with_command('/usr/bin/hostnamectl set-hostname 54-1-2-3') \
          .with_unless('/usr/bin/test $(/bin/hostname) = 54-1-2-3').that_comes_before('Class[bootstrap::ddns]')

        is_expected.to contain_class('bootstrap::ddns').with(
          'host_name' => '54-1-2-3',
        )
      end
    end
  end
end
