#yum -y erase gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
yum -y clean all
rm -rf VBoxGuestAdditions_*.iso
rm -rf /tmp/rubygems-*
rm -rf /home/vagrant/puppet-rpm/*
rmdir /home/vagrant/puppet-rpm/
rm -rf /home/vagrant/clamav/*
rmdir /home/vagrant/clamav/