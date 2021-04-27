#
# @summary Sets up an EC2 host with DDNS
#
# This configures and EC2 host with the necessary configuration to
# register its hostname with our dynamic ec2.mysociety.org domain.
#
# @param host_name
#     Hostname to use. Defaults to a munged form of the Public IP.
#
# @example
#   include bootstrap::ec2
class bootstrap::ec2(
  String $host_name = regsubst($facts['ec2_metadata']['public-ipv4'], '\.', '-', 'G'),
) {

  exec { 'set-hostname':
    command => "/usr/bin/hostnamectl set-hostname ${host_name}",
    unless  => "/usr/bin/test $(/bin/hostname) = ${host_name}",
  }

  -> class { '::bootstrap::ddns':
    host_name => $host_name,
  }

}
