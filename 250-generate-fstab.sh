#!/bin/bash

set -e

genfstab -pUL /mnt >/mnt/etc/fstab
