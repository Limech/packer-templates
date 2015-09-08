#!/bin/bash

set -e
set -x

# Mount DVD1 iso and setup as yum repo
mkdir /mnt/iso
mount -o loop CentOS-6.6-x86_64-bin-DVD1.iso /mnt/iso

echo "
[centos-iso] 
mediaid=1414159991.958686 
name=centos-iso
baseurl=file:///mnt/iso/ 
gpgkey=file:///mnt/iso/RPM-GPG-KEY-CentOS-6
enabled=1 
gpgcheck=1
" > /etc/yum.repos.d/CentOS-iso.repo

# By installing from matching DVD, we ensure the kernel headers match the current kernel version.
yum --disablerepo="*" --enablerepo="centos-iso" -y install gcc make gcc-c++ kernel-devel-`uname -r` perl java-1.7.0-openjdk

# Install Desktop (optional)
yum --disablerepo="*" --enablerepo="centos-iso" -y groupinstall basic-desktop desktop-platform x11 fonts

# Cleanup
umount /mnt/iso
rmdir /mnt/iso
rm /etc/yum.repos.d/CentOS-iso.repo
rm /home/vagrant/CentOS-6.6-x86_64-bin-DVD1.iso

 
