#!/bin/bash



umount -R /mnt
swapoff -a
cryptsetup close system
