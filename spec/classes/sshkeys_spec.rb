require 'spec_helper'

describe 'bootstrap::sshkeys' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) do
        "class { 'bootstrap': ssh_keys => { 'git.mysociety.org' => { 'type' => 'ecdsa-sha2-nistp256', 'host_aliases' => ['cvs.mysociety.org', '46.43.39.110'], 'key' => 'git-test-key-data'} } }"
      end

      it do
        is_expected.to compile
        is_expected.to contain_sshkey('git.mysociety.org') \
          .with(
            'type'         => 'ecdsa-sha2-nistp256',
            'host_aliases' => ['cvs.mysociety.org', '46.43.39.110'],
            'key'          => 'git-test-key-data',
          )
      end
    end
  end
end
