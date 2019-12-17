#!/bin/bash

set -e
set -v

mkdir /mnt/boot
mount /dev/disk/by-partlabel/bootloader /mnt/boot
