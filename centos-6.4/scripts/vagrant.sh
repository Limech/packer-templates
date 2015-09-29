date > /etc/vagrant_box_build_time

chmod 700 /home/vagrant/.ssh
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
