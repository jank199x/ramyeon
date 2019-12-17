#!/bin/bash

arch-chroot /mnt pacman -S --noconfirm --needed --quiet dhcpcd dialog wpa_supplicant
