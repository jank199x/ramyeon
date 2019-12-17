#!/bin/bash

set -e

cryptsetup luksOpen /dev/disk/by-partlabel/cryptsystem system