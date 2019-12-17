#!/bin/bash

set -e
set -v

sgdisk --clear \
  --new=1:0:+1MiB --typecode=1:ef02 --change-name=1:biosboot \
  --new=2:0:+256MiB --typecode=2:8300 --change-name=2:bootloader \
  --new=3:0:0 --typecode=3:8300 --change-name=3:cryptsystem \
  /dev/sda