# frozen_string_literal: true

require 'spec_helper'

describe 'bootstrap::brightbox' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts.merge(
          'ec2_metadata' => {
            'instance-id' => 'srv-ab1c2',
            'public-ipv4' => '54.1.2.3',
          },
        )
      end

      it do
        is_expected.to compile

        is_expected.to contain_exec('set-hostname') \
          .with_command('/usr/bin/hostnamectl set-hostname srv-ab1c2') \
          .with_unless('/usr/bin/test $(/bin/hostname) = srv-ab1c2').that_comes_before('Class[bootstrap::ddns]')

        is_expected.to contain_class('bootstrap::ddns').with(
          'host_name' => 'srv-ab1c2',
        )
      end
    end
  end
end
