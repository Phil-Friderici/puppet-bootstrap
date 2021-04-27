#
# @summary Prepares a BrightBox server instance for provisioning
#
# This configures a BrightBox host with the necessary configuration to
# register its hostname with our dynamic ec2.mysociety.org domain.
#
# @param host_name
#     Hostname to use. Defaults to the instance-id, which is fine in
#     almost all cases.
#
# @example
#   include bootstrap::brightbox
#
class bootstrap::brightbox(
  String $host_name = $facts['ec2_metadata']['instance-id']
) {

  exec { 'set-hostname':
    command => "/usr/bin/hostnamectl set-hostname ${host_name}",
    unless  => "/usr/bin/test $(/bin/hostname) = ${host_name}",
  }

  -> class { '::bootstrap::ddns':
    host_name => $host_name,
  }

}
