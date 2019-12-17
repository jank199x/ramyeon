#!/bin/bash

set -e
set -v

# Pause for 3 seconds because mkfs can't find device
# if you try to format it immediately after partitioning
sleep 3
mkfs.ext4 -F /dev/disk/by-partlabel/bootloader