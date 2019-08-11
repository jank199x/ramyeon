# Px201AI

A shell script which automatically installs Arch Linux on Lenovo Thinkpad x201.

Uses GPT with LVM on LUKS.

To clone the repository into USB live system, use:

```
mount -o remount,size=2G /run/archiso/cowspace
pacman -Sy git
git clone https://gitlab.com/papanic/Px201AI.git
```

# Instructions I've used:

* https://blog.m157q.tw/posts/2013/12/30/arch-linux-quick-installation-with-gpt-in-bios/
* https://gist.github.com/mjnaderi/28264ce68f87f52f2cabb823a503e673
* https://wiki.archlinux.org/index.php/User:Altercation/Bullet_Proof_Arch_Install