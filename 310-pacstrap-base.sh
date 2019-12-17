#!/bin/bash

set -e
set -v

pacstrap /mnt base base-devel lvm2 mkinitcpio linux
