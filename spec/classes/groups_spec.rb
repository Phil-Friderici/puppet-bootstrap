require 'spec_helper'

describe 'bootstrap::groups' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'class { "bootstrap": }' }

      it do
        is_expected.to compile

        {
          'anoncvs'           => '3001',
          'maint'             => '3004',
          'privatecvs'        => '3015',
          'privategit-puppet' => '3055',
          'publiccvs'         => '3010',
        }.each do |group, gid|
          is_expected.to contain_group(group).with_gid(gid)
        end
      end
    end
  end
end
