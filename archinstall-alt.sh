#!/bin/bash

set -e

source 001-titlecard.sh

steptitle() { echo -e "\n  \e[7m Step $1 \e[27m $2\n"; }

STEP=0

for file in steps/*; do
  if [ -f "$file" ]; then
    ((STEP+=1))
    steptitle $STEP $file
    . "$file"
  fi
done

echo -e "\n  \e[1m\e[7mInstallation finished.\e[27m\e[21m\n"
echo -e "\n  \e[1mPress Enter to \e[7mreboot\e[27m or Ctrl+C to exit.\e[21m\n" && read

reboot
