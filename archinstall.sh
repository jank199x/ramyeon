#!/bin/bash

set -e

# ASCII art made at http://patorjk.com/software/taag/
ART="H4sIAAAAAAAA/9WSsRHAIAhFe6fgHMDaMSzS2Obcf4aIwIkGLinShMJwL/jJh4RMcSbAaJjDE0tNUnwD9OACCMRqL5DLGR5YJ4VTpShn0AxL522X2emmONqOY9a5jGVYStxqRYwS2YwaicM2Rc81t1+83NhBk33lWhagt2AwkqSV6QFYivw1S2eDkWSs2wCWvwe+jl8oXliHROiHAwAA"
echo -e "\n  $(base64 --decode <<<${ART} | gunzip)"
echo -e "\n  Papanic x201 Arch Installer \n\n  \e[1mPress Enter to continue or Ctrl+C to exit.\e[21m\n" && read

STEP=0
steptitle() { echo -e "\n  \e[7m Step $1 \e[27m $2\n"; }

((STEP += 1))
steptitle $STEP "Wipe filesystems."

wipefs --all /dev/sda

((STEP += 1))
steptitle $STEP "Partition disk."

sgdisk --clear \
  --new=1:0:+1MiB --typecode=1:ef02 --change-name=1:biosboot \
  --new=2:0:+256MiB --typecode=2:8300 --change-name=2:bootloader \
  --new=3:0:0 --typecode=3:8300 --change-name=3:cryptsystem \
  /dev/sda

((STEP += 1))
steptitle $STEP "Format boot partition."

# Pause for 3 seconds because mkfs can't find device
# if you try to format it immediately after partitioning
sleep 3
mkfs.ext4 -F /dev/disk/by-partlabel/bootloader

((STEP += 1))
steptitle $STEP "Create LUKS container."

cryptsetup luksFormat -v --batch-mode /dev/disk/by-partlabel/cryptsystem

((STEP += 1))
steptitle $STEP "Unlock LUKS container."

cryptsetup luksOpen /dev/disk/by-partlabel/cryptsystem system

((STEP += 1))
steptitle $STEP "Create LVM volume group."

pvcreate /dev/mapper/system
vgcreate lvs /dev/mapper/system

((STEP += 1))
steptitle $STEP "Create LVM partitions."

lvcreate --size 8G lvs --name swap
lvcreate --size 25G lvs --name root
lvcreate -l +100%FREE lvs --name home

((STEP += 1))
steptitle $STEP "Format root and home partitions."

mkfs.ext4 -F /dev/mapper/lvs-home
mkfs.ext4 -F /dev/mapper/lvs-root

((STEP += 1))
steptitle $STEP "Create and use swap."

mkswap /dev/mapper/lvs-swap
swapon /dev/mapper/lvs-swap

((STEP += 1))
steptitle $STEP "Mount root."

mount /dev/mapper/lvs-root /mnt

((STEP += 1))
steptitle $STEP "Mount boot."

mkdir /mnt/boot
mount /dev/disk/by-partlabel/bootloader /mnt/boot

((STEP += 1))
steptitle $STEP "Mount home."

mkdir /mnt/home
mount /dev/mapper/lvs-home /mnt/home

((STEP += 1))
steptitle $STEP "Install base system."

pacstrap /mnt base base-devel lvm2 mkinitcpio linux

((STEP += 1))
steptitle $STEP "Generate fstab."

genfstab -pUL /mnt >/mnt/etc/fstab

((STEP += 1))
steptitle $STEP "Generate locales."

echo "en_US.UTF-8 UTF-8" >>/mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" >/mnt/etc/locale.conf

((STEP += 1))
steptitle $STEP "Set timezone."

sudo rm -f /mnt/etc/localtime
arch-chroot /mnt ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
arch-chroot /mnt hwclock --systohc --utc

((STEP += 1))
steptitle $STEP "Set hostname."

echo blepbook >/mnt/etc/hostname
echo "127.0.0.1 blepbook.localdomain blepbook" >>/mnt/etc/hosts

((STEP += 1))
steptitle $STEP "Add user."

arch-chroot /mnt useradd -m -g users -G wheel blep
arch-chroot /mnt passwd blep
echo "%wheel ALL=(ALL) ALL" >>/mnt/etc/sudoers

((STEP += 1))
steptitle $STEP "Add hooks to initcpio."

mv /mnt/etc/mkinitcpio.conf /mnt/etc/mkinitcpio.conf.bak
echo "KEYMAP=us" >/mnt/etc/vconsole.conf
cat <<EOF >>/mnt/etc/mkinitcpio.conf
MODULES=(ext4)
BINARIES=()
FILES=()
HOOKS=(base systemd sd-vconsole autodetect modconf block sd-encrypt sd-lvm2 filesystems keyboard fsck)
EOF
arch-chroot /mnt mkinitcpio -p linux

((STEP += 1))
steptitle $STEP "Install grub."

arch-chroot /mnt pacman -S --noconfirm --needed --quiet grub
arch-chroot /mnt grub-install --target=i386-pc --recheck /dev/sda
CRYPTOSYSTEM_UUID=$(blkid -s UUID -o value /dev/disk/by-partlabel/cryptsystem)
sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"luks.name=${CRYPTOSYSTEM_UUID}=system\"/" /mnt/etc/default/grub
sed -i "s/GRUB_TIMEOUT=5/GRUB_TIMEOUT=2/" /mnt/etc/default/grub
sed -i "s/GRUB_TIMEOUT_STYLE=menu/GRUB_TIMEOUT_STYLE=countdown/" /mnt/etc/default/grub
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

((STEP += 1))
steptitle $STEP "Install networking requirements."

arch-chroot /mnt pacman -S --noconfirm --needed --quiet dhcpcd dialog wpa_supplicant

((STEP += 1))
steptitle $STEP "Unmount partitions & swap."

umount -R /mnt
swapoff -a

echo -e "\n  \e[1m\e[7mInstallation finished.\e[27m\e[21m\n"
echo -e "\n  \e[1mPress Enter to \e[7mreboot\e[27m or Ctrl+C to exit.\e[21m\n" && read

reboot
