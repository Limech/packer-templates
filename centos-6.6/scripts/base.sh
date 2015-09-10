#!/bin/bash

set -e
set -x

rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
yum install -y puppet

#mkdir /home/vagrant/puppet-stage/
#chmod 777 /home/vagrant/puppet-stage/
chmod 755 /home/vagrant/cis-cat-full/CIS-CAT.sh