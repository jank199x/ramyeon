#!/bin/bash

rm -f /mnt/etc/localtime
arch-chroot /mnt ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
arch-chroot /mnt hwclock --systohc --utc
