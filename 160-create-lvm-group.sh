#!/bin/bash

pvcreate /dev/mapper/system
vgcreate lvs /dev/mapper/system