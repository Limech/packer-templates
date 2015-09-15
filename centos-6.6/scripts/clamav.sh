#!/bin/bash

set -e
set -x

rpm -ivh /home/vagrant/clamav/clamav-0.98.7-1.el6.x86_64.rpm
rpm -ivh /home/vagrant/clamav/clamav-db-0.98.7-1.el6.x86_64.rpm

echo "HTTPProxyServer=10.16.102.30" >> /etc/freshclam.conf
echo "HTTPProxyProxy=8080" >> /etc/freshclam.conf

echo "00 23 * * sun root /usr/local/sbin/clamav_scan > /dev/null 2>&1" >> /etc/crontab




