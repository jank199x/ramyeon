#!/bin/bash
set -v
# Adding 2G to cowspace
mount -o remount,size=2G /run/archiso/cowspace

# Setting up Git
pacman -Sy --noconfirm --needed --quiet git

# Cloning repo
rm -rf Px201AI && git clone https://gitlab.com/papanic/Px201AI.git

# Ready to execute
set +v
