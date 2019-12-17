#!/bin/bash

set -e
set -v

genfstab -pUL /mnt >/mnt/etc/fstab
