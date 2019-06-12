#
# @summary Manages a working copy of mysociety-servers at `/data/servers`
#
# Manages a local working copy of the mysociety-servers repository.
#
# @param repo_ensure
#     The `ensure` parameter to set on the `vcsrepo` resource.
#
# @example
#   include bootstrap::vcsrepo::servers
#
# @see https://forge.puppet.com/puppetlabs/vcsrepo
#
class bootstrap::vcsrepo::servers (
  String $repo_ensure = 'present',
) {

  file { '/data/servers':
    ensure => directory,
    owner  => 'root',
    group  => 'privatecvs',
    mode   => '2770',
  }

  vcsrepo { '/data/servers':
    ensure   => $repo_ensure,
    user     => 'maint',
    group    => 'privatecvs',
    provider => 'git',
    source   => 'ssh://git.mysociety.org/data/git/private/mysociety-servers.git',
    notify   => Exec['fixperms-servers'],
  }

  $fixperms = @(EOT/L)
    /bin/chgrp -R privatecvs ./servers && \
    chmod o-rwx ./servers && \
    chmod -R g+w ./servers && \
    /usr/bin/find ./servers -type d -exec /bin/chmod g+ws {} \\;
    |-EOT

  exec { 'fixperms-servers':
    cwd         => '/data',
    command     => $fixperms,
    refreshonly => true,
  }

  file { '/data/servers/.git/hooks/post-checkout':
    ensure  => file,
    mode    => '0775',
    group   => 'privatecvs',
    source  => 'puppet:///modules/bootstrap/vcsrepos/post-checkout',
    require => Vcsrepo['/data/servers'],
  }

  file { '/data/servers/.git/hooks/post-commit':
    ensure => 'link',
    group  => 'privatecvs',
    target => '/data/servers/.git/hooks/post-checkout',
  }

  file { '/data/servers/.git/hooks/post-merge':
    ensure => 'link',
    group  => 'privatecvs',
    target => '/data/servers/.git/hooks/post-checkout',
  }

  exec { '/data/fonts':
    command => '/bin/cp -r /data/servers/fonts /data/fonts',
    creates => '/data/fonts',
    require => Vcsrepo['/data/servers'],
  }

}
