#!/bin/bash

set -e

pvcreate /dev/mapper/system
vgcreate lvs /dev/mapper/system