require 'spec_helper'

describe 'bootstrap::git_fixperms' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it do
        is_expected.to compile
        is_expected.to contain_file('/usr/local/bin/git-shared-fixperms')
        is_expected.to contain_sudo__conf('privatecvs_hooks')
        is_expected.to contain_sudo__conf('privategit-puppet_hooks')
      end
    end
  end
end
