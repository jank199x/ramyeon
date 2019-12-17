#!/bin/bash

lvcreate --size "$LVMSWAPSIZE" lvs --name swap
lvcreate --size "$LVMROOTSIZE" lvs --name root
lvcreate -l +100%FREE lvs --name home
