#!/bin/bash

set -e
set -v

arch-chroot /mnt pacman -S --noconfirm --needed --quiet grub
arch-chroot /mnt grub-install --target=i386-pc --recheck /dev/sda
CRYPTOSYSTEM_UUID=$(blkid -s UUID -o value /dev/disk/by-partlabel/cryptsystem)
sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"luks.name=${CRYPTOSYSTEM_UUID}=system\"/" /mnt/etc/default/grub
sed -i "s/GRUB_TIMEOUT=5/GRUB_TIMEOUT=2/" /mnt/etc/default/grub
sed -i "s/GRUB_TIMEOUT_STYLE=menu/GRUB_TIMEOUT_STYLE=countdown/" /mnt/etc/default/grub
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
