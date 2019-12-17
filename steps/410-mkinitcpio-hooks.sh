mv /mnt/etc/mkinitcpio.conf /mnt/etc/mkinitcpio.conf.bak
echo "KEYMAP=us" >/mnt/etc/vconsole.conf
cat <<EOF >>/mnt/etc/mkinitcpio.conf
MODULES=(ext4)
BINARIES=()
FILES=()
HOOKS=(base systemd sd-vconsole autodetect modconf block sd-encrypt sd-lvm2 filesystems keyboard fsck)
EOF
arch-chroot /mnt mkinitcpio -p linux
