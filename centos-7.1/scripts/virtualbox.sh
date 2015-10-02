VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
mkdir /mnt/vbox
mount -o loop /home/vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt/vbox
sh /mnt/vbox/VBoxLinuxAdditions.run
umount /mnt/vbox
rmdir /mnt/vbox
rm -rf /home/vagrant/VBoxGuestAdditions_*.iso

ln -s /opt/VBoxGuestAdditions_$VBOX_VERSION/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions

