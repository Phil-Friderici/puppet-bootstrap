# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include bootstrap::ec2
#
class bootstrap::ec2(
  String $ddns_key,
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
    content   => $ddns_key,
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
