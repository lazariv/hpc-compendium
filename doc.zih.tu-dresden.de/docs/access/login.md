# Login to the High Performance Computers

The best way to login to the Linux machines is via ssh. From a Linux console, the command syntax is
`ssh user@host`. The additional option `-XC` enables X11 forwarding for graphical applications (the
`-C` enables compression which usually improves usability in this case).

The following table gives an overview of all clusters.

| Host name                  | Description         |
|:--------------------------|:--------------------|
| taurus.hrsk.tu-dresden.de | BULL system - SLURM |

**Attention:** For security reasons, this port is only accessible for hosts within the domains of TU
Dresden. Guests from other research institutes can use the
[VPN](https://tu-dresden.de/zih/dienste/service-katalog/arbeitsumgebung/zugang_datennetz/vpn)
gateway of the ZIH. Information on these topics can be found on our web pages
<http://www.tu-dresden.de/zih>.

## Access from a Windows workstation

We suggest Windows users use MobaXTerm. **TODO Link MobaXTerm**.
Benefits of MobaXTerm include:

- easy to use
- graphical user interface
- file transfer via drag and drop

## Access from a Linux Workstation

### SSH Access

**Attention:** Please use an up-to-date SSH client. The login nodes accept the following encryption
algorithms: `aes128-ctr`, `aes192-ctr`, `aes256-ctr`, `aes128-gcm@openssh.com`,
`aes256-gcm@openssh.com`, `chacha20-poly1305@openssh.com`, `chacha20-poly1305@openssh.com`

If your workstation is within the campus network, you can connect to the
HPC login servers directly, e.g., for Taurus:

```Bash
ssh <zih-login>@taurus.hrsk.tu-dresden.de
```

If you connect for the fist time, the client will ask you to verify the host by the fingerprint:

```Bash
user@pc:~# ssh <zih-login>@taurus.hrsk.tu-dresden.de
The authenticity of host 'taurus.hrsk.tu-dresden.de (141.30.73.104)' can't be established.
RSA key fingerprint is SHA256:HjpVeymTpk0rqoc8Yvyc8d9KXQ/p2K0R8TJ27aFnIL8.
Are you sure you want to continue connecting (yes/no)?
```

Compare this fingerprint with the fingerprints in the table below. If
they match you can type "yes".

| Host                      | Fingerprint           |
|:--------------------------|:----------------------|
| tauruslogin3.hrsk.tu-dresden.de | SHA256:/M1lW1KTOlxj8UFZJS4tLi+8TyndcDqrZfLGX7KAU8s (RSA)      |
| tauruslogin4.hrsk.tu-dresden.de | SHA256:PeCpW/gAFLvHDzTP2Rb93NxD+rpUsyQY8WebjQC7kz0 (ECDSA)    |
| tauruslogin5.hrsk.tu-dresden.de | SHA256:nNxjtCny1kB0N0epHaOPeY1YFd0ri2Dvt2CK7rOGlXg (ED25519)  |
| tauruslogin6.hrsk.tu-dresden.de | or: MD5:b8:e1:21:ed:38:1a:ba:1a:5b:2b:bc:35:31:62:21:49 (RSA) |
| taurus.hrsk.tu-dresden.de       | MD5:47:7e:24:46:ab:30:59:2c:1f:e8:fd:37:2a:5d:ee:25 (ECDSA)   |
|                                 | MD5:7c:0c:2b:8b:83:21:b2:08:19:93:6d:03:80:76:8a:7b (ED25519) |
| taurusexport.hrsk.tu-dresden.de  | SHA256:Qjg79R+5x8jlyHhLBZYht599vRk+SujnG1yT1l2dYUM (RSA)   |
| taurusexport3.hrsk.tu-dresden.de | SHA256:qXTZnZMvdqTs3LziA12T1wkhNcFqTHe59fbbU67Qw3g (ECDSA) |
| taurusexport4.hrsk.tu-dresden.de | SHA256:jxWiddvDe0E6kpH55PHKF0AaBg/dQLefQaQZ2P4mb3o (ED25519)  |
|                                  | or: MD5:1e:4c:2d:81:ee:58:1b:d1:3c:0a:18:c4:f7:0b:23:20 (RSA) |
|                                  | MD5:96:62:c6:80:a8:1f:34:64:86:f3:cf:c5:9b:cd:af:da (ECDSA)   |
|                                  | MD5:fe:0a:d2:46:10:4a:08:40:fd:e1:99:b7:f2:06:4f:bc (ED25519) |

From outside the TUD campus network

Use a VPN (Virtual Private Network) to enter the campus network, which allows you to connect
directly to the HPC login servers.

For more information on our VPN and how to set it up, please visit the corresponding
[ZIH service catalogue page](https://tu-dresden.de/zih/dienste/service-katalog/arbeitsumgebung/zugang_datennetz/vpn).

### Access using JupyterHub

A JupyterHub installation offering IPython Notebook is available under
https://taurus.hrsk.tu-dresden.de/jupyter

See the documentation under [JupyterHub](../access/jupyterhub.md).
