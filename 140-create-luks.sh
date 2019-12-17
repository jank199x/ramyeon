#!/bin/bash

set -e

cryptsetup luksFormat -v --batch-mode /dev/disk/by-partlabel/cryptsystem