#
# @summary Ensures script called from git hooks is present and runnable
#
# Adds a script for fixing permissions called from various git hooks and
# ensures that the relevant groups have the ability to run this via sudo.
#
# @param groups
#    Groups for which to permit sudo access to the script
#
# @example
#   include bootstrap::git_fixperms
#
class bootstrap::git_fixperms (
  Array $groups = ['privatecvs', 'privategit-puppet'],
) {

  # Script called from post-checkout git hooks, and sudo config to ensure it can be used.
  file { '/usr/local/bin/git-shared-fixperms':
    ensure => file,
    mode   => '0775',
    source => 'puppet:///modules/bootstrap/git-shared-fixperms',
  }

  $groups.each |String $group| {
    sudo::conf { "${group}_hooks":
      priority => 10,
      content  => "%${group} ALL=(ALL) NOPASSWD: /usr/local/bin/git-shared-fixperms"
    }
  }

}
