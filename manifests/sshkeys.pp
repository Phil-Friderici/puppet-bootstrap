#
# @summary Core SSH keys to trust
#
# Manages a core set of server SSH keys to trust system-wide.
# Expects these as a hash of sshkey resource definitions for use
# with `create_resources`.
#
# @param auth_keys
#     Hash of SSH keys for root to trust via the `ssh_authorized_key` type.
#
# @param keys
#     Hash of sshkey resource definitions
#
# @example
#   class { 'bootstrap::sshkeys':
#     auth_keys => {
#       'user' => {
#         'type' => 'ssh-rsa',
#         'key'  => 'KeyDataString',
#       },
#     },
#     keys => {
#       'server' => {
#         'host_aliases' => ['foo', 'bar'],
#         'type'         => 'ecdsa-sha2-nistp256',
#         'key'          => 'KeyDataString',
#       },
#     },
#   }
#
class bootstrap::sshkeys (
  Optional[Hash] $auth_keys = $bootstrap::root_auth_keys,
  Optional[Hash] $keys      = $bootstrap::ssh_keys,
) {

  if $auth_keys {
    create_resources(ssh_authorized_key, $auth_keys, {'user' => 'root'} )
  }

  if $keys {
    create_resources(sshkey, $keys)
  }

}
