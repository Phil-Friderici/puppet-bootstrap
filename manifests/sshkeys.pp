#
# @summary Core SSH keys to trust
#
# Manages a core set of server SSH keys to trust system-wide.
# Expects these as a hash of sshkey resource definitions for use
# with `create_resources`.
#
# @param keys
#     Hash of sshkey resource definitions
#
# @example
#   class { 'bootstrap::sshkeys':
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
  Optional[Hash] $keys = $bootstrap::ssh_keys,
) {

  if $keys {
    create_resources(sshkey, $keys)
  }

}
