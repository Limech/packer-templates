#!/bin/bash

# CIS 5.1.4 For some reason, this one doesn't stick with Puppet.. trying to fix it here.
chmod 0600 /var/log/boot.log

set -e
set -x


## Delete stuff we no longer need

yum -y clean all

rm -rf VBoxGuestAdditions_*.iso
rm -rf /tmp/rubygems-*

rm -rf /home/vagrant/puppet-rpm/*
rmdir /home/vagrant/puppet-rpm/

rm -rf /home/vagrant/clamav/*
rmdir /home/vagrant/clamav/

chmod -R +t /tmp/packer-puppet-masterless/module-0/cis

# Restart network in preparation for running CIS-CAT audit
sysctl -p






