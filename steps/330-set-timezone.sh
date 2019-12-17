#!/bin/bash

rm -f /mnt/etc/localtime
arch-chroot /mnt ln -s /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime
arch-chroot /mnt hwclock --systohc --utc
