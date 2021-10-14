# Connecting with SSH

For security reasons, ZIH systems are only accessible for hosts within the domains of TU Dresden.

## Virtual Private Network (VPN)

To access the ZIH systems from outside the campus networks it's recommended to set up a VPN
connection to enter the campus network. While active, it allows the user to connect directly to the
HPC login nodes.

For more information on our VPN and how to set it up, please visit the corresponding
[ZIH service catalogue page](https://tu-dresden.de/zih/dienste/service-katalog/arbeitsumgebung/zugang_datennetz/vpn).

## Connecting from Linux

Please use an up-to-date SSH client. The login nodes accept the following encryption algorithms:

* `aes128-ctr`
* `aes192-ctr`
* `aes256-ctr`
* `aes128-gcm@openssh.com`
* `aes256-gcm@openssh.com`
* `chacha20-poly1305@openssh.com`
* `chacha20-poly1305@openssh.com`

### SSH Session

If your workstation is within the campus network, you can connect to the HPC login nodes directly.

```console
marie@local$ ssh <zih-login>@taurus.hrsk.tu-dresden.de
```

If you connect for the fist time, the client will ask you to verify the host by its fingerprint:

```console
marie@local$: ssh <zih-login>@taurus.hrsk.tu-dresden.de
The authenticity of host 'taurus.hrsk.tu-dresden.de (141.30.73.104)' can't be established.
RSA key fingerprint is SHA256:HjpVeymTpk0rqoc8Yvyc8d9KXQ/p2K0R8TJ27aFnIL8.
Are you sure you want to continue connecting (yes/no)?
```

Compare the shown fingerprint with the [documented fingerprints](key_fingerprints.md). Make sure
they match. Than you can accept by typing `y` or `yes`.

### X11-Forwarding

If you plan to use an application with graphical user interface (GUI), you need to enable
X11-forwarding for the connection. Add the option `-X` or `-XC` to your SSH command. The `-C` enables
compression which usually improves usability in this case).

```console
marie@local$ ssh -XC <zih-login>@taurus.hrsk.tu-dresden.de
```

!!! info

    Also consider to use a [DCV session](desktop_cloud_visualization.md) for remote desktop
    visualization at ZIH systems.

### Password-Less SSH

Of course, password-less SSH connecting is supported at ZIH. All public SSH keys for ZIH systems
have to be generated following these rules:

  * The **ED25519** algorithm has to be used, e.g., `ssh-keygen -t ed25519`
  * A **non-empty** passphrase for the private key must be set.

The generated public key is usually saved at `~/.ssh/id_ed25519` at your local system. To allow for
password-less SSH connection to ZIH systems, it has to be added to the file `.ssh/authorized_keys` within
your home directory `/home/<zih-login>/` at ZIH systems. The public key can be transferred using
tools like `scp`, `rsync`, or `ssh-copy-id`. Please refer to the corresponding man page. After the
public key is in place, you can connect to ZIH systems via

```console
marie@local$ ssh -i id-ed25519 <zih-login>@taurus.hrsk.tu-dresden.de
Enter passphrase for key 'id-ed25519':
```

### SSH Config

You can make the SSH login process more comfortable by creating an entry in your SSH config file. For
that, you just add en entry like this

```bash
 Host <any_name>
   HostName taurus.hrsk.tu-dresden.de
   User <zih-login>
   IdentityFile <path_to_public_key>
```

to your `~/.ssh/config` and afterwards the ssh connection call is shortened to

```console
marie@local$ ssh <any_name>
```

## Connecting from Windows

We recommend one of the following applications:

  * [MobaXTerm](https://mobaxterm.mobatek.net): [ZIH documentation](misc/basic_usage_of_MobaXterm.pdf)
  * [PuTTY](https://www.putty.org): [ZIH documentation](misc/basic_usage_of_PuTTY.pdf)
  * OpenSSH Server: [docs](https://docs.microsoft.com/de-de/windows-server/administration/openssh/openssh_install_firstuse)

The page [key fingerprints](key_fingerprints.md) holds the up-to-date fingerprints for the login
nodes. Make sure they match.
