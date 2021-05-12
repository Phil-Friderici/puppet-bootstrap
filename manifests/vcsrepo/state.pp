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

  vcsrepo { '/var/lib/server-state':
    ensure   => $repo_ensure,
    user     => 'root',
    group    => 'staff',
    provider => 'git',
    notify   => Exec['fixperms-state'],
  }

  exec { 'fixperms-state':
    cwd         => '/var/lib',
    command     => '/bin/chgrp -R staff ./server-state && chmod o-rwx ./server-state',
    refreshonly => true,
  }

  file {
    default:
      ensure => 'file',
      owner  => 'root',
      group  => 'root',
      mode   => '0755';

    '/etc/cron.daily/save-package-list':
      source => 'puppet:///modules/bootstrap/vcsrepo/state/save-package-list';

    '/etc/cron.daily/save-passwd-group':
      source => 'puppet:///modules/bootstrap/vcsrepo/state/save-passwd-group';

    '/etc/cron.daily/save-vhost-list':
      source => 'puppet:///modules/bootstrap/vcsrepo/state/save-vhost-list';
  }

}
