#!/bin/bash

echo "$LUKSPASS" | cryptsetup luksOpen /dev/disk/by-partlabel/cryptsystem system