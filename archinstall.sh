#!/bin/bash

set -e

# ASCII art made at http://patorjk.com/software/taag/
ART="H4sIAAAAAAAA/6WRyw3EMAhE766Cg+9uIKWMRCMUvx4+sZPNJbsoilGYB2PS5Cm6By6Z5LE0kPYMi6iyPMmVdbFNBFVrq3sNAwvDe1iUmEGDvsjbmoMUTk1IhDT8CY7v2bnMiJHOOcSJjHROAzNDed5nu62gq0Ko96N0uQFDv2lUN3q5nHNRG4rboaojv+BrdrqMXXGVfjeGSaajkrNmvvPbf3gXf9I08Dv9ASzVHEyrAgAA"

echo -e "\n  `base64 --decode <<< ${ART} | gunzip`"
echo -e "\n  Papanic x201 Arch Installer v0.1 \n\n  \e[1mPress Enter to continue or Ctrl+C to exit.\e[21m\n" && read

STEP=0

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Wipe filesystems.\n"

wipefs --all /dev/sda

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Partition disk.\n"

sgdisk --clear \
	 --new=1:0:+1MiB 	--typecode=1:ef02 --change-name=1:biosboot \
	 --new=2:0:+256MiB  --typecode=2:8300 --change-name=2:bootloader \
	 --new=3:0:0       	--typecode=3:8300 --change-name=3:cryptsystem \
	   /dev/sda

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Format boot partition.\n"

# Pause  for 3 seconds because mkfs can't find device 
# if you try to format it immediately after partitioning
sleep 3 
mkfs.ext4 -F /dev/disk/by-partlabel/bootloader

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Create LUKS container.\n"

cryptsetup luksFormat -v --batch-mode /dev/disk/by-partlabel/cryptsystem

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Unlock LUKS container.\n"

cryptsetup luksOpen /dev/disk/by-partlabel/cryptsystem system

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Create LVM volume group.\n"

pvcreate /dev/mapper/system
vgcreate lvs /dev/mapper/system

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Create LVM partitions.\n"

lvcreate --size 8G lvs --name swap
lvcreate --size 25G lvs --name root
lvcreate -l +100%FREE lvs --name home

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Format root and home partitions.\n"

mkfs.ext4 -F /dev/mapper/lvs-home
mkfs.ext4 -F /dev/mapper/lvs-root

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Create and use swap.\n"

mkswap /dev/mapper/lvs-swap
swapon /dev/mapper/lvs-swap

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Mount root.\n"

mount /dev/mapper/lvs-root /mnt

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Mount boot.\n"

mkdir /mnt/boot
mount /dev/disk/by-partlabel/bootloader /mnt/boot

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Mount home.\n"

mkdir /mnt/home
mount /dev/mapper/lvs-home /mnt/home

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Install base system.\n"

pacstrap /mnt base base-devel lvm2 mkinitcpio linux 

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Generate fstab.\n"

genfstab -pUL /mnt > /mnt/etc/fstab

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Generate locales.\n"

echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Set timezone.\n"

sudo rm -f /mnt/etc/localtime
arch-chroot /mnt ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
arch-chroot /mnt hwclock --systohc --utc

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Set hostname.\n"

echo blepbook > /mnt/etc/hostname
echo "127.0.0.1 blepbook.localdomain blepbook" >> /mnt/etc/hosts

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Add user.\n"

arch-chroot /mnt useradd -m -g users -G wheel blep
arch-chroot /mnt passwd blep
echo "%wheel ALL=(ALL) ALL" >> /mnt/etc/sudoers

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Add hooks to initcpio.\n"

mv /mnt/etc/mkinitcpio.conf /mnt/etc/mkinitcpio.conf.bak
echo "KEYMAP=us" > /mnt/etc/vconsole.conf
cat << EOF >> /mnt/etc/mkinitcpio.conf
MODULES=(ext4)
BINARIES=()
FILES=()
HOOKS=(base systemd sd-vconsole autodetect modconf block sd-encrypt sd-lvm2 filesystems keyboard fsck)
EOF
arch-chroot /mnt mkinitcpio -p linux

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Install grub.\n"

arch-chroot /mnt pacman -S --noconfirm --needed --quiet grub
arch-chroot /mnt grub-install --target=i386-pc --recheck /dev/sda
CRYPTOSYSTEM_UUID=$(blkid -s UUID -o value /dev/disk/by-partlabel/cryptsystem)
sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"luks.name=${CRYPTOSYSTEM_UUID}=system\"/" /mnt/etc/default/grub
sed -i "s/GRUB_TIMEOUT=5/GRUB_TIMEOUT=2/" /mnt/etc/default/grub
sed -i "s/GRUB_TIMEOUT_STYLE=menu/GRUB_TIMEOUT_STYLE=countdown/" /mnt/etc/default/grub
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Install networking requirements.\n"

arch-chroot /mnt pacman -S --noconfirm --needed --quiet dhcpcd dialog wpa_supplicant 

let STEP+=1
echo -e "\n  \e[7m Step ${STEP} \e[27m Unmount partitions & swap.\n"

umount -R /mnt
swapoff -a

echo -e "\n  \e[1m\e[7mInstallation finished.\e[27m\e[21m\n"
echo -e "\n  \e[1mPress Enter to \e[7mreboot\e[27m or Ctrl+C to exit.\e[21m\n" && read

reboot
