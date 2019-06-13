#
# @summary Manages a working copy of mysociety-puppet at `/data/puppet`
#
# Manages a local working copy of our core internal Puppet repository.
#
# @param repo_ensure
#     The `ensure` parameter to set on the `vcsrepo` resource.
#
# @example
#   include bootstrap::vcsrepo::puppet
#
# @see https://forge.puppet.com/puppetlabs/vcsrepo
#
class bootstrap::vcsrepo::puppet (
  String $repo_ensure = 'present',
) {

  file { '/data/puppet':
    ensure => directory,
    owner  => 'root',
    group  => 'privategit-puppet',
    mode   => '2770',
  }

  vcsrepo { '/data/puppet':
    ensure   => $repo_ensure,
    user     => 'maint',
    group    => 'privategit-puppet',
    provider => 'git',
    source   => 'ssh://git.mysociety.org/data/git/private/mysociety-puppet.git',
    notify   => Exec['fixperms-puppet'],
  }

  $fixperms = @(EOT/L)
    /bin/chgrp -R privategit-puppet ./puppet && \
    chmod o-rwx puppet && \
    /bin/chmod -R g+w ./puppet && \
    /usr/bin/find ./puppet -type d -exec /bin/chmod g+ws {} \\;
    |-EOT

  exec { 'fixperms-puppet':
    cwd         => '/data',
    command     => $fixperms,
    refreshonly => true,
  }

  file { '/data/puppet/.git/hooks/post-checkout':
    ensure  => file,
    mode    => '0775',
    group   => 'privategit-puppet',
    source  => 'puppet:///modules/bootstrap/vcsrepo/post-checkout',
    require => Vcsrepo['/data/puppet'],
  }

  file { '/data/puppet/.git/hooks/post-commit':
    ensure => 'link',
    group  => 'privategit-puppet',
    target => '/data/puppet/.git/hooks/post-checkout',
  }

  file { '/data/puppet/.git/hooks/post-merge':
    ensure => 'link',
    group  => 'privategit-puppet',
    target => '/data/puppet/.git/hooks/post-checkout',
  }


}
