#!/bin/bash

set -e
set -v

cryptsetup luksOpen /dev/disk/by-partlabel/cryptsystem system