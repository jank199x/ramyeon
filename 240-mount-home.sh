#!/bin/bash

set -e
set -v

mkdir /mnt/home
mount /dev/mapper/lvs-home /mnt/home
