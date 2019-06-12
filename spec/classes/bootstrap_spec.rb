require 'spec_helper'

describe 'bootstrap' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it do
        is_expected.to compile
        is_expected.to contain_class('bootstrap::packages').that_comes_before('Class[bootstrap::sudo]')
        is_expected.to contain_class('bootstrap::sudo').that_comes_before('Class[bootstrap::groups]')
        is_expected.to contain_class('bootstrap::groups').that_comes_before('Class[bootstrap::dirs]')
        is_expected.to contain_class('bootstrap::dirs').that_comes_before('Class[bootstrap::maint]')
        is_expected.to contain_class('bootstrap::maint').that_comes_before('Class[bootstrap::sshkeys]')
        is_expected.to contain_class('bootstrap::sshkeys').that_comes_before('Class[bootstrap::git_fixperms]')
        is_expected.to contain_class('bootstrap::git_fixperms').that_comes_before('Class[bootstrap::vcsrepo::scripts]')
        is_expected.to contain_class('bootstrap::vcsrepo::scripts').that_comes_before('Class[bootstrap::vcsrepo::puppet]')
        is_expected.to contain_class('bootstrap::vcsrepo::puppet').that_comes_before('Class[bootstrap::vcsrepo::servers]')
        is_expected.to contain_class('bootstrap::vcsrepo::servers').that_comes_before('Class[bootstrap::vcsrepo::state]')
        is_expected.to contain_class('bootstrap::vcsrepo::state')
      end
    end
  end
end
