# Px201AI

Before connecting to live system via SSH:
```
passwd
systemctl start sshd
```

After that on main system:
```
ssh -l root host:port /bin/bash < 000-bootstrap.sh
```