#!/bin/bash

set -e

mkdir /mnt/boot
mount /dev/disk/by-partlabel/bootloader /mnt/boot
