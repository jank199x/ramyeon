#!/bin/bash

lvcreate --size 8G lvs --name swap
lvcreate --size 25G lvs --name root
lvcreate -l +100%FREE lvs --name home