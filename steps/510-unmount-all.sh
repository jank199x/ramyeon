#!/bin/bash

umount -R /mnt
swapoff -a
vgchange -an
cryptsetup close system
