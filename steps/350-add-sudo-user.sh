#!/bin/bash

arch-chroot /mnt useradd -m -g users -G wheel  -p "$(openssl passwd -1 "$NEWUSERPASS")" "$NEWUSERNAME"
echo "%wheel ALL=(ALL) ALL" >>/mnt/etc/sudoers
