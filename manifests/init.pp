#
# @summary Bootstrap a mySociety server
#
# This module sets up baseline config for a mySociety server. The main
# class contains and orders the core subclasses so they should not be
# included directly.
#
# @param admin_user
#     If there is a default `admin` user that needs sudo access
#     during the bootstrap, specify the user name here and it will
#     be granted `NOPASSWD` access.
#
# @param dirs
#     List of core directories to create and manage.
#
# @param packages
#     List of core packages to be installed.
#
# @param groups
#     Hash of groups and `gid`s suitable for passing to the 
#     `group` resource via `create_resources`.
#
# @param ssh_keys
#     Hash of sshkey resource definitions
#
# @param maint_public_ssh_key
#     Contents of the public ssh key file for the `maint` user, as a string.
#
# @param maint_private_ssh_key
#     Contents of the private ssh key file for the `maint` user, as a string.
#
# @example
#   include bootstrap
#
class bootstrap(
  Optional[String] $admin_user,
  Array $dirs,
  Array $packages,
  Hash $groups,
  Optional[Hash] $ssh_keys,
  String $maint_public_ssh_key,
  String $maint_private_ssh_key,
) {

  class { 'bootstrap::packages': }
  -> class { 'bootstrap::sudo': }
  -> class { 'bootstrap::groups': }
  -> class { 'bootstrap::dirs': }
  -> class { 'bootstrap::maint': }
  -> class { 'bootstrap::sshkeys': }
  -> class { 'bootstrap::git_fixperms': }
  -> class { 'bootstrap::vcsrepo::scripts': }
  -> class { 'bootstrap::vcsrepo::puppet': }
  -> class { 'bootstrap::vcsrepo::servers': }
  -> class { 'bootstrap::vcsrepo::state': }

  contain bootstrap::packages
  contain bootstrap::sudo
  contain bootstrap::groups
  contain bootstrap::dirs
  contain bootstrap::maint
  contain bootstrap::sshkeys
  contain bootstrap::git_fixperms
  contain bootstrap::vcsrepo::scripts
  contain bootstrap::vcsrepo::puppet
  contain bootstrap::vcsrepo::servers
  contain bootstrap::vcsrepo::state

}
