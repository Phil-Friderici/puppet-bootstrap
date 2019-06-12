#
# @summary Install required packages
#
# Installs base packages required for subsequent steps.
# This is a dedicated class for resrouce chaining purposes.
#
# @param packages
#     List of packages to install
#
# @example
#   include bootstrap::packages
#
class bootstrap::packages (
  Array $packages = $bootstrap::packages,
) {
  ensure_packages($packages, { 'ensure' => 'present'})
}
