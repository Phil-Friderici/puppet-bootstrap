#
# @summary Creates and manages core groups
#
# Creates and manages core groups required at the bootstrap
# stage. Users and Groups are subsequently managed with the
# `usersync` utility on a full mySociety build.
#
# @param groups
#     Hash of groups and `gid`s suitable for passing to the 
#     `group` resource via `create_resources`.
#
# @example
#   include bootstrap::groups
#
class bootstrap::groups (
  Hash $groups = $bootstrap::groups,
) {

  create_resources(group, $groups)

}
