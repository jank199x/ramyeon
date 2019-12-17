#!/bin/bash

arch-chroot /mnt pacman -S --noconfirm --needed --quiet networkmanager
arch-chroot /mnt systemctl enable NetworkManager
