#!/bin/bash
set -v
# Adding 2G to cowspace
mount -o remount,size=2G /run/archiso/cowspace

# Setting up Git
pacman -Sy --noconfirm --needed --quiet git

# Cloning repo
rm -rf ramyeon && git clone https://gitlab.com/papanic/ramyeon

# Ready to execute
set +v
