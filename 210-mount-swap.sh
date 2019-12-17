#!/bin/bash

set -e
set -v

mkswap /dev/mapper/lvs-swap
