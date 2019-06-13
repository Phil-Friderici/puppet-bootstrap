require 'spec_helper'

describe 'bootstrap::packages' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:pre_condition) { 'class { "bootstrap": packages => ["apt-transport-https", "curl", "dirmngr", "gcc", "git", "gnupg", "less", "lsb-release", "make", "man", "wget"] }' }

      it { is_expected.to compile }

      [
        'apt-transport-https',
        'curl',
        'dirmngr',
        'gcc',
        'git',
        'gnupg',
        'less',
        'lsb-release',
        'make',
        'man',
        'wget',
      ].each do |package|
        it do
          is_expected.to contain_package(package)
        end
      end
    end
  end
end
