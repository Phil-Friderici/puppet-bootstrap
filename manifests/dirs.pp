#
# @summary Creates mySociety base directory structure
#
# Creates and manages necessary top-level directory structure
#
# @param dirs
#     List of core directories to create and manage.
#
# @example
#   include bootstrap::dirs
#
class bootstrap::dirs (
  Array $dirs = $bootstrap::dirs,
){

  file { $dirs: ensure => 'directory' }

}
