# PAPARCHI

On live system:
```
passwd
systemctl start sshd
```

On main system:
```
ssh -l root host:port /bin/bash < bootstrap.sh
```