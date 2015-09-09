# dd will fill drive and run out of space. 
# Must return true so that things can proceed.
dd if=/dev/zero of=/EMPTY bs=1M | true
rm -f /EMPTY


