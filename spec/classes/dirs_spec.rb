require 'spec_helper'

describe 'bootstrap::dirs' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'class { "bootstrap": }' }

      it do
        is_expected.to compile

        ['/data', '/data/vhost', '/etc/mysociety'].each do |dir|
          is_expected.to contain_file(dir).with_ensure('directory')
        end
      end
    end
  end
end
