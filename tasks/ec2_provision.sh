#!/bin/bash

# Get the Public IP from the instance meta-data
public_ip=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/public-ipv4`

# Derive hostname.
# Unless we've been given a hostname to use, use the Public IP.
if [ "$PT_host_name" = "auto" ] ; then
  my_hostname=$(echo $public_ip | sed -e 's/\./-/g')
else
  my_hostname=$PT_host_name
fi

# Set the hostname.
/usr/bin/hostnamectl --static set-hostname $my_hostname

# Set-up /etc/hosts.
cat <<EOF >/etc/hosts
127.0.1.1 ${my_hostname}.ec2.mysociety.org ${my_hostname}
127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF

# DNS
cat <<EOF >/etc/resolv.conf
search ukcod.org.uk
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

# Prevent dhclient from breaking resolv.conf
echo 'make_resolv_conf() { :; }' > /etc/dhcp/dhclient-enter-hooks.d/resolv-conf

# Prefer IPv4
echo 'precedence ::ffff:0:0/96  100' > /etc/gai.conf

# SSH keys for root
if [ ! -e "/root/.ssh/id_rsa" ] ; then
  /usr/bin/ssh-keygen -q -t rsa -f /root/.ssh/id_rsa -N ''
fi
ROOT_SSH_KEY=$(cat /root/.ssh/id_rsa.pub)

# remove admin user
/usr/sbin/userdel -f -r admin

# Output
cat <<EOF
{
  "root_ssh_key": "${ROOT_SSH_KEY}",
  "public_ip": "${public_ip}",
  "hostname": "${my_hostname}.ec2.mysociety.org"
}
EOF
