#!/bin/bash

set -e
set -v

cryptsetup luksFormat -v --batch-mode /dev/disk/by-partlabel/cryptsystem