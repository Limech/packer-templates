
## Packer-templates

Packer ([https://packer.io/](https://packer.io/ "Packer")) templates for building base VM boxes for various flavors of Linux.

### Todo

* Pass location of share in command line and standardize source based on corporate NAS location.
* Pass build options like:
  * With or without desktop
  * With or without ClamAV
  * With or without Firefox
  * etc.

### Usage


#### Installing Packer

These packer files should work using the Windows or Linux versions of Packer but were only tested with the Windows version. Installer can be found under:

    {network-share}\Installs\Packer\v0.8.6\installer\packer_0.8.6_windows_amd64.zip

To use Packer, VirtualBox must also be installed.  Installer can be found under:

    {network-share}\Installs\VirtualBox\v5.0.2\installers\VirtualBox-5.0.2-102096-Win.exe

#### Preparing Packer

To run Packer, we require the packer files, the CIS-CAT Puppet manifests and some installation files.   
Assuming a working folder of `{packer}` (Ex: `c:\dev\packer\`), from that folder we require   

    $ git clone http://gitlab/devops/packer-templates.git

Then we need to create a `share` folder under `{packer}` and copy the contents from 

    {network-share}\Backups\Packer\share

This folder is rather large as it contains the ISO files from the various Linux distros.   
Finally from the `{packer}\share\puppet-modules\` folder we import the CIS-CAT Puppet manifests

    $ git clone http://gitlab/devops/cis-puppet.git cis
    $ rm -rf cis\.git

Thus creating a `cis` folder under `{packer}\share\puppet-modules\` and removing the `.git` folder since it is not needed for running packer. The git folder can be kept if the intent is to improve the CIS-CAT Puppet modules.

#### Share folder contents
The `share` folder should contain the following:

* cis-cat-full - CIS-CAT auditing tool files
* clamav - RPM files for installing clamav
* puppet-cis-el6 - Manifest invoking the cis::el6all module
* puppet-cis-el7 - Manifest invoking the cis::el7all module
* puppet-modules - Modules used by Puppet
  * cis - The `devops/cis-puppet` repo contents
* puppet-rpm - el6 RPM files for installing Puppet
* puppet-rpm-el7 - el7 RPM files for installing Puppet
* CentOS-6.4-x86_64-bin-DVD1.iso - CentOS 6.4 ISO
* CentOS-6.6-x86_64-bin-DVD1.iso - CentOS 6.6 ISO
* rhel-workstation-6.4-x86_64-dvd.iso - Red Hat 6.4 ISO
* rhel-workstation-6.6-x86_64-dvd.iso - Red Hat 6.6 ISO

#### Important check
The `ks.cfg` files under the various `http` folders must have Linux type line endings.
Load them up in Notepad++ and select 
    Edit->EOL Conversion->UNIX/OSX Format
and save the files. Failure to do so will result in an error as follows:

    sudo: sorry, you must have a tty to run sudo

#### Running Packer


    $ cd packer-templates/centos-6.6
    $ packer build -force --only virtualbox-iso template-centos.json

If the build is successful, there will be a `centos` folder under
    
    {packer}\packer-templates\centos-6.6\centos\
    
that contains a VirtualBox Virtual Machine (VM) of OVF format.
There will also be a `centos-6-6-x64-virtualbox.box` file, which is the Vagrant base box equivalent.
*Note version different than example for other versions.

#### Supported versions

These templates was tested using a packer 0.8.6.
Only the following templates have been tested/updated.  
Within most of these templates, only the Virtualbox builder has been tested.  The VMWare builder has not been tested.

* centos-6.4/template-centos.json
* centos-6.4/template-rhel.json
* centos-6.6/template-centos.json
* centos-6.6/template-rhel.json
* centos-7.0/template-centos.json
* centos-7.1/template-centos.json
* centos-7.1/template-centos-xenserver.json

All other configurations (scientific / ubuntu and other versions of CentOS) have not been verified.

## Box Details

### Passwords
The Virtual Machines and Vagrant base boxes that are created have the following accounts / passwords:

* 'vagrant' user with password 'vagrant' with sudo privileges without need for tty or password.
* 'root' password is 'vagrant'
* vagrant default SSH key (NOT a secure key!) under /home/vagrant/.shh/   

**All these passwords should be changed** once the base image/box have been morphed to their final form.

### Storage
The following Logical Volumes (LG) under a single Volume Group (VG) mapped to a single Physical Volume (PV).

|Partition |  Type     |     Size  |   Device |
|----------|-----------|-----------|----------|
|  boot    |  ext4     |    250MB  |  sda1    |
|  swap    |  swap     |      1GB  |  sda2    |
|  pv.01   | Linux LVM |   40GB    |  sda3    |
  
* vg_root
  * audit   1GB  /var/log/audit
  * home   25GB  /home
  * log     1GB  /var/log
  * root   10GB  /
  * tmp   512MB  /tmp
  * var    10GB  /var

### Virtual Machine Details  
Virtual Machines are created with 512MB of RAM, no floppy, audio or USB controllers.
They have 1 CPU and 40GB SATA virtual hard drive.
VirtualBox VMs are of type OVF with VMDK virtual drives.
Gnome desktop, ClamAV, Puppet, CIS-CAT and Firefox are installed by default.

### Known issues

### CentOS 7.0 X11 issue
For some reason, CentOS 7.0 on VirtualBox comes up with black screen when graphical desktop is enabled.
Therefore, this image is set to use the console.  To get the desktop, login and do `sudo startx`.

#### Drive size
The selected drive sizes might not be the same as what you want them to be.  If you want to resize the drive to make it **larger**, you can do the following:
For VirtualBox:

    VBoxManage modifyhd <absolute path including the name and extension> --resize 20480
In Linux (as su):

    fdisk /dev/sda
    d (for delete) then 2 (for partition)
    n (for new), then p (for primary), then 2 (for partition), then enter/enter for start/end cylinder for defaults
    t (for type), then 8e (for Linux LVM)
    w (for write)
    {reboot}
    pvresize /dev/sda2
    lvresize -l +100%FREE /dev/{vg-name}/{lv-name}
    resize2fs /dev/{vg-name}/{lv-name}


### Hardening
All images have been hardened with Puppet to Level 2 of the CIS-CAT benchmark.   
The pass rate varies and here is an incomplete list of failures with explanations for CentOS 6.4

List of failing tests:

#### CIS-CAT 1.1.8 Create Separate Partition for /var/log/audit
False positive.  `lvs` confirms the separate logical volume exists for /var/log/audit and folder exists.

#### CIS-CAT 1.1.14, 1.1.15, 1.1.16 /dev/shm failures
1.1.14 Add nodev Option to /dev/shm Partition   
1.1.15 Add nosuid Option to /dev/shm Partition   
1.1.16 Add noexec Option to /dev/shm Partition     
False positive.
The options are indeed on the `/dev/shm` logical volume mount in the `fstab` file.

#### CIS-CAT 1.4.6 Check for Unconfined Daemons
Failing due to /usr/sbin/VBoxService
This is a trusted daemon. Probably possible to investigate how to confine it, but didn't have time to investigate. No plans to fix at this time.

#### CIS-CAT 1.5.3 Set Boot Loader Password
Since images are used in manner where they are launched and destroyed automatically, such a password would prevent ability to used.  
Failing on purpose.

#### CIS-CAT 3.1 Set Daemon umask
/etc/sysconfig/init file has line

    UMASK=027
This is causing a false positive. Doesn't match exact text required but fills intent.

#### CIS-CAT 3.2 Remove the X Window System
Images have desktop by default since seen as a desired feature to have.
Failing on purpose.

#### CIS-CAT 5.1.4 Create and Set Permissions on rsyslog Log Files
Failing due to known issue with the distro where `Other Read` flag on `/var/log/boot.log` keeps getting set to true.  https://access.redhat.com/solutions/66805
Is shown as passed on report, but OS will change the flag again later, causing this to fail on some other runs of CIS-CAT.

#### CIS-CAT 5.1.5 Configure rsyslog to Send Logs to a Remote Log Host
This is a false pass since a remote host URL is entered, but it doesn't exist.  We don't have a remote host to use anyway so this usually would have been a fail on purpose.

#### CIS-CAT 5.2.12 Collect Use of Privileged Commands
Boxes only for use in lab environment. No need to audit log all commands.    
Failing on purpose.

#### CIS-CAT 7.1.1, 7.1.2, 7.1.3 Password rules failures
7.1.1 Set Password Expiration Days   
7.1.2 Set Password Change Minimum Number of Days   
7.1.3 Set Password Expiring Warning Days   
System accounts don't follow these rules, but cannot be used to login, so not much of an issue.   
Failing on purpose.

#### CIS-CAT 7.2 Disable System Accounts
CIS-CAT reports

     CIS-CAT expected: the Login Shell to not be set to /sbin/nologin
     CIS-CAT collected: /sbin/nologin
But above, it indicates in description: *"...it is also recommended that the shell field in the password file be set to /sbin/nologin."*

So indeed it is properly set to '/sbin/nologin'   
False positive.

#### CIS-CAT 7.4 Set Default umask for Users
Requires all shell to default mask to 77 but the failing files under '/etc/profile.d/' folder are not shell defaults, but other config files and scripts that would break if 'umask 77' would be added to them.   
Failing on purpose.
