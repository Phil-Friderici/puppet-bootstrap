require 'spec_helper'

describe 'bootstrap::packages' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:pre_condition) { 'class { "bootstrap": packages => ["git", "make", "gcc", "apt-transport-https", "gnupg", "dirmngr"] }' }

      it { is_expected.to compile }
      ['git', 'make', 'gcc', 'apt-transport-https', 'gnupg', 'dirmngr'].each do |package|
        it do
          is_expected.to contain_package(package)
        end
      end
    end
  end
end
