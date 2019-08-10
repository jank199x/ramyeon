# x201-arch-install-script
A shell script which automatically installs Arch Linux on Lenovo Thinkpad x201.

Work in progress.

```
mount -o remount,size=2G /run/archiso/cowspace
pacman -Sy git
git clone https://gitlab.com/papanic/x201-arch-install-script.git
```