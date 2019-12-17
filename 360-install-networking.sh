#!/bin/bash

set -e
set -v

arch-chroot /mnt pacman -S --noconfirm --needed --quiet dhcpcd dialog wpa_supplicant
