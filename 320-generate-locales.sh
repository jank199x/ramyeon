#!/bin/bash

set -e

echo "en_US.UTF-8 UTF-8" >>/mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" >/mnt/etc/locale.conf
