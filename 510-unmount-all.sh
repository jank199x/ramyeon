#!/bin/bash

set -e
set -v

umount -R /mnt
swapoff -a
cryptsetup close system
