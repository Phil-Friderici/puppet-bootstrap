#
# @summary This class sets up a DDNS registration service
#
# This sets up DDNS registration for provisioned server instances
#
# @param ddns_key
#     A hash containing at least `algorithm` and `secret` keys for the
#     DDNS key file.
#
# @param ddns_domain
#     Domain to use for the DDNS key.
#
# @example
#   include bootstrap::ddns
#
class bootstrap::ddns(
    Hash $ddns_key,
    String $ddns_domain,
    String $public_ipv4  = $facts['ec2_metadata']['public-ipv4'],
    String $ipv6_address = $facts['networking']['ip6'],
    String $host_name    = $facts['networking']['hostname'],
) {

  ensure_packages('dnsutils', {ensure => 'present'})

  file { '/etc/ddns-update':
    ensure => 'directory',
  }

  file { '/etc/ddns-update/ec2.key':
    ensure    => 'file',
    mode      => '0400',
    owner     => 'root',
    group     => 'root',
    show_diff => false,
    content   => template('bootstrap/ec2.key.erb'),
  }

  -> file { '/usr/local/bin/ddns-update':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0754',
    content => template('bootstrap/ddns-update.erb'),
  }

  -> file { '/etc/systemd/system/ddns-update.service':
    ensure => 'file',
    source => 'puppet:///modules/bootstrap/ddns-update.service',
  }

  ~> service { 'ddns-update':
    ensure => 'running',
    enable => true,
  }

}
