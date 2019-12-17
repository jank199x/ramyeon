#!/bin/bash

set -e

mkfs.ext4 -F /dev/mapper/lvs-home
mkfs.ext4 -F /dev/mapper/lvs-root