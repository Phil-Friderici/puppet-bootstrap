#
# @summary Manages the `maint` user
#
# Manages the `maint` user required to access our private Git repositories.
# The SSH key file contents need to be provided for both a a public and private
# keys, perhaps fed into the module from encryted Hiera.
#
# @param public_ssh_key
#     Contents of the public ssh key file for the `maint` user, as a string.
#
# @param private_ssh_key
#     Contents of the private ssh key file for the `maint` user, as a string.
#
# @example
#   include bootstrap::maint
#
class bootstrap::maint (
  String $public_ssh_key  = $bootstrap::maint_public_ssh_key,
  String $private_ssh_key = $bootstrap::maint_private_ssh_key,
){

  user { 'maint':
    ensure     => 'present',
    uid        => '3004',
    gid        => '3004',
    groups     => [ 'publiccvs', 'privatecvs', 'privategit-puppet' ],
    home       => '/home/maint',
    shell      => '/bin/bash',
    managehome => true,
  }

  -> file {
    default:
      ensure => 'file',
      owner  => 'maint',
      group  => 'maint',
      mode   => '0644';

    '/home/maint/.ssh':
      ensure => 'directory',
      mode   => '0700';

    '/home/maint/.ssh/id_rsa.pub':
      content => $public_ssh_key;

    '/home/maint/.ssh/id_rsa':
      content   => $private_ssh_key,
      mode      => '0600',
      show_diff => false;

    '/home/maint/ssh-as-sudoer':
      content => template('bootstrap/ssh-as-sudoer.erb'),
      mode    => '0755';
  }

}
