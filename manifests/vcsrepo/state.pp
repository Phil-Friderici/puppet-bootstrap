#
# @summary Manages a working copy of state at `/data/state`
#
# Manages a local working copy of the state repository.
#
# @param repo_ensure
#     The `ensure` parameter to set on the `vcsrepo` resource.
#
# @example
#   include bootstrap::vcsrepo::state
#
# @see https://forge.puppet.com/puppetlabs/vcsrepo
#
class bootstrap::vcsrepo::state (
  String $repo_ensure = 'present',
) {

  file { '/data/state':
    ensure => directory,
    owner  => 'root',
    group  => 'privatecvs',
    mode   => '0775',
  }

  vcsrepo { '/data/state':
    ensure   => $repo_ensure,
    user     => 'maint',
    group    => 'privatecvs',
    provider => 'git',
    source   => 'ssh://git.mysociety.org/data/git/private/mysociety-state.git',
    notify   => Exec['fixperms-state'],
  }

  exec { 'fixperms-state':
    cwd         => '/data',
    command     => '/bin/chgrp -R privatecvs ./state',
    refreshonly => true,
  }

  file { "/data/state/${facts['networking']['hostname']}":
    ensure  => directory,
    require => Vcsrepo['/data/state'],
  }

}
