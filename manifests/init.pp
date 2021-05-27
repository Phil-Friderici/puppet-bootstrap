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
# @param root_auth_keys
#     Hash of SSH keys for root to trust via the `ssh_authorized_key` type.
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
  Optional[Hash] $root_auth_keys,
  Optional[Hash] $ssh_keys,
  String $maint_public_ssh_key,
  String $maint_private_ssh_key,
) {

  contain bootstrap::packages
  contain bootstrap::sudo
  contain bootstrap::groups
  contain bootstrap::dirs
  contain bootstrap::maint
  contain bootstrap::sshkeys
  contain bootstrap::vcsrepo::scripts
  contain bootstrap::vcsrepo::state

  Class['bootstrap::packages']
  -> Class['bootstrap::sudo']
  -> Class['bootstrap::groups']
  -> Class['bootstrap::dirs']
  -> Class['bootstrap::maint']
  -> Class['bootstrap::sshkeys']
  -> Class['bootstrap::vcsrepo::scripts']
  -> Class['bootstrap::vcsrepo::state']

}
