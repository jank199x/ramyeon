#!/bin/bash

mkdir /mnt/etc
genfstab -pUL /mnt >/mnt/etc/fstab
