#
# @summary Manages a local git repo at `/var/lib/server-state`
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

  file { '/var/lib/server-state':
    ensure => directory,
    owner  => 'root',
    group  => 'staff',
    mode   => '0775',
  }

  vcsrepo { '/var/lib/server-state':
    ensure   => $repo_ensure,
    user     => 'root',
    group    => 'staff',
    provider => 'git',
    notify   => Exec['fixperms-state'],
  }

  exec { 'fixperms-state':
    cwd         => '/var/lib',
    command     => '/bin/chgrp -R staff ./server-state',
    refreshonly => true,
  }

}
