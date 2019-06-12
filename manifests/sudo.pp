#
# @summary Baseline Sudo setup
#
# This class initialised the `sudo` module and optionally configures
# a sudo rule for an admin user to permit passwordless access to
# facilitate provisioning.
#
# @param admin_user
#     Username of an account to grant full passwordless sudo access
#
# @example
#   include bootstrap::sudo
#
class bootstrap::sudo (
  Optional[String] $admin_user = $bootstrap::admin_user,
) {

  class { '::sudo': }

  if $admin_user {
    sudo::conf { "${admin_user}-nopasswd":
      priority => 10,
      content  => "${admin_user} ALL=(ALL) NOPASSWD: ALL",
    }
  }

}
