require 'spec_helper'

describe 'bootstrap::sudo' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        let(:pre_condition) { 'include bootstrap' }

        it do
          is_expected.to compile
          is_expected.to contain_class('sudo')
          is_expected.not_to contain_sudo__conf('admin-nopasswd')
        end
      end

      context 'with admin_user => admin' do
        let(:pre_condition) { 'class { "bootstrap": admin_user => "admin" }' }

        it do
          is_expected.to compile
          is_expected.to contain_class('sudo')
          is_expected.to contain_sudo__conf('admin-nopasswd') \
            .with_content('admin ALL=(ALL) NOPASSWD: ALL')
        end
      end
    end
  end
end
