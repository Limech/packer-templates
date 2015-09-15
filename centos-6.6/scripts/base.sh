#!/bin/bash

set -e
set -x

rpm -ivh /home/vagrant/puppet-rpm/*.rpm
 
#mkdir /home/vagrant/puppet-stage/
#chmod 777 /home/vagrant/puppet-stage/
chmod 755 /home/vagrant/cis-cat-full/CIS-CAT.sh