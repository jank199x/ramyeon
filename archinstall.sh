#!/bin/bash

set -e

source 001-titlecard.sh

steptitle() { echo -e "\n  \e[7m Step $1 \e[27m $2\n"; }

steptitle "1-1" "Wipe filesystems."
source 110-wipe-fs.sh

steptitle "1-2" "Partition disk."
source 120-partition-disk.sh

steptitle "1-3" "Format boot partition."
source 130-format-boot.sh

steptitle "1-4" "Create LUKS container."
source 140-create-luks.sh

steptitle "1-5" "Unlock LUKS container."
source 150-unlock-luks.sh

steptitle "1-6" "Create LVM volume group."
source 160-create-lvm-group.sh

steptitle "1-7" "Create LVM partitions."
source 170-create-lvm-partitions.sh

steptitle "1-8" "Format root and home partitions."
source 180-format-root-home.sh

steptitle "1-9" "Create swap."
source 190-create-swap.sh

steptitle "2-1" "Mount swap."
source 210-mount-swap.sh

steptitle "2-2" "Mount root."
source 220-mount-root.sh

steptitle "2-3" "Mount boot."
source 230-mount-boot.sh

steptitle "2-4" "Mount home."
source 240-mount-home.sh

steptitle "2-5" "Generate fstab."
source 250-generate-fstab.sh

steptitle "3-1" "Install base system."
source 310-pacstrap-base.sh

steptitle "3-2" "Generate locales."
source 320-generate-locales.sh

steptitle "3-3" "Set timezone."
source 330-set-timezone.sh

steptitle "3-4" "Set hostname."
source 340-set-hostname.sh

steptitle "3-5" "Add user with sudo rights."
source 350-add-sudo-user.sh

steptitle "3-6" "Install networking requirements."
source 360-install-networking.sh

steptitle "4-1" "Add hooks to initcpio."
source 410-mkinitcpio-hooks.sh

steptitle "4-2" "Install grub."
source 420-install-grub.sh

steptitle "5-1" "Unmount partitions & swap."
source 510-unmount-all.sh

echo -e "\n  \e[1m\e[7mInstallation finished.\e[27m\e[21m\n"
echo -e "\n  \e[1mPress Enter to \e[7mreboot\e[27m or Ctrl+C to exit.\e[21m\n" && read

reboot
