#!/bin/bash

set -e
set -v

mkfs.ext4 -F /dev/mapper/lvs-home
mkfs.ext4 -F /dev/mapper/lvs-root