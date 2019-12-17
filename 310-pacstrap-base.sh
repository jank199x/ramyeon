#!/bin/bash

set -e

pacstrap /mnt base base-devel lvm2 mkinitcpio linux
