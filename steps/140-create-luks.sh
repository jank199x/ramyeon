#!/bin/bash

echo "$LUKSPASS" | cryptsetup luksFormat -v --batch-mode /dev/disk/by-partlabel/cryptsystem