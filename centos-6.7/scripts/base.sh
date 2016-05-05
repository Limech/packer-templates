#!/bin/bash

set -e
set -x

# Install Puppet for CIS-CAT provisioning
rpm -ivh --replacefiles --replacepkgs /home/vagrant/puppet-rpm/*.rpm

# Ensure CIS-CAT audit script can be executed
chmod 755 /home/vagrant/cis-cat-full/CIS-CAT.sh

# Remove default repositories to prevent online updates during provisioning.
yum-config-manager --disable base
yum-config-manager --disable extras
yum-config-manager --disable updates
yum clean all


# CIS 3.4
chkconfig cups off

#CIS 1.1.6
echo "/tmp /var/tmp none bind 0 0" >> /etc/fstab 

## Eliminate DNS lookups during SSH connections
echo "OPTIONS='-u0'" >> /etc/sysconfig/sshd

#CIS 6.3.1 This causes /etc/libuser.conf to also be updated as doing it in kickstart file
# only updated /etc/login.defs
authconfig --enableshadow --passalgo=sha512 --update

#CIS 1.1.17
mkdir /vagrant
chmod +t /vagrant
chmod +t -R /home/vagrant/




