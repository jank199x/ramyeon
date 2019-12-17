#!/bin/bash

arch-chroot /mnt useradd -m -g users -G wheel blep
arch-chroot /mnt passwd blep
echo "%wheel ALL=(ALL) ALL" >>/mnt/etc/sudoers
