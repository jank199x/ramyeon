yes | pvcreate -ff /dev/mapper/system
vgcreate lvs /dev/mapper/system
vgchange -a y lvs
