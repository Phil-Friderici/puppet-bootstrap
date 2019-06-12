#
# @summary Manages a working copy of misc-scripts at `/data/mysociety`
#
# Manages a local working copy of the misc-scripts respository.
#
# @param repo_ensure
#     The `ensure` parameter to set on the `vcsrepo` resource.
#
# @example
#   include bootstrap::vcsrepo::scripts
#
# @see https://forge.puppet.com/puppetlabs/vcsrepo
#
class bootstrap::vcsrepo::scripts (
  String $repo_ensure = 'present',
) {

  file { '/data/mysociety':
    ensure => directory,
    owner  => 'root',
    group  => 'privatecvs',
    mode   => '2775',
  }

  vcsrepo { '/data/mysociety':
    ensure   => $repo_ensure,
    user     => 'maint',
    group    => 'privatecvs',
    provider => 'git',
    source   => 'ssh://git.mysociety.org/data/git/public/misc-scripts.git',
    notify   => Exec['fixperms-scripts'],
  }

  $fixperms = @(EOT/L)
    /bin/chgrp -R privatecvs ./mysociety && \
    /bin/chmod -R g+w ./mysociety && \
    /usr/bin/find ./mysociety -type d -exec /bin/chmod g+ws {} \\;
    |-EOT

  exec { 'fixperms-scripts':
    cwd         => '/data',
    command     => $fixperms,
    refreshonly => true,
  }

  exec { 'run-with-lockfile':
    cwd     => '/data/mysociety/run-with-lockfile',
    command => '/usr/bin/make',
    creates => '/data/mysociety/run-with-lockfile/run-with-lockfile',
    require => Vcsrepo['/data/mysociety'],
  }
}
