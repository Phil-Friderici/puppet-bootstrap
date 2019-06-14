#
# @summary Sets up an EC2 host with DDNS
#
# This configures and EC2 host with the necessary configuration to
# register its hostname with our dynamic ec2.mysociety.org domain.
#
# @param ddns_key
#     A hash containing at least `algorithm` and `secret` keys for the
#     DDNS key file.
#
# @param host_name
#     Hostname to use. Defaults to a munged form of the Public IP.
#
# @param ddns_domain
#     Domain to use for the DDNS key.
#
# @example
#   include bootstrap::ec2
#
class bootstrap::ec2(
  Hash $ddns_key,
  String $host_name   = regsubst($facts['ec2_metadata']['public-ipv4'], '\.', '-', 'G'),
  String $ddns_domain = 'ec2.mysociety.org',
) {

  exec { 'set-hostname':
    command => "/usr/bin/hostnamectl set-hostname ${host_name}",
    unless  => "/usr/bin/test $(/bin/hostname) = ${host_name}",
  }

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
