#!/bin/bash

set -e
set -x

rpm -ivh /home/vagrant/puppet-rpm/*.rpm
 
#mkdir /home/vagrant/puppet-stage/
#chmod 777 /home/vagrant/puppet-stage/
chmod 755 /home/vagrant/cis-cat-full/CIS-CAT.sh

yum-config-manager --disable base
yum-config-manager --disable extras
yum-config-manager --disable updates
yum clean all

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

# CIS 3.4
chkconfig cups off

#CIS 1.1.6
echo "/tmp /var/tmp none bind 0 0" >> /etc/fstab 

#CIS 6.3.1 This causes /etc/libuser.conf to also be updated as doing it in kickstart file
# only updated /etc/login.defs
authconfig --enableshadow --passalgo=sha512 --update