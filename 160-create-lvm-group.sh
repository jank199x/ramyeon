#!/bin/bash

set -e
set -v

pvcreate /dev/mapper/system
vgcreate lvs /dev/mapper/system