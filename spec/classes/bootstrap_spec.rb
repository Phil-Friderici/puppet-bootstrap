require 'spec_helper'

describe 'bootstrap' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it do
        is_expected.to compile
        is_expected.to contain_class('bootstrap::packages').that_comes_before('Class[bootstrap::groups]')
        is_expected.to contain_class('bootstrap::groups').that_comes_before('Class[bootstrap::dirs]')
        is_expected.to contain_class('bootstrap::dirs').that_comes_before('Class[bootstrap::sshkeys]')
        is_expected.to contain_class('bootstrap::sshkeys')
      end
    end
  end
end
