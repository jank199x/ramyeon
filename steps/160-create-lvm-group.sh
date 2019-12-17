#!/bin/bash

pvcreate -ff /dev/mapper/system
vgcreate lvs /dev/mapper/system