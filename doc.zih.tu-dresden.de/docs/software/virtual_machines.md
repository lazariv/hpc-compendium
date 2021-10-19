# Virtual Machines

The following instructions are primarily aimed at users who want to build their own
[Singularity](containers.md) containers on ZIH systems.

The Singularity container setup requires a Linux machine with root privileges, the same architecture
and a compatible kernel. If some of these requirements cannot be fulfilled, then there is also the
option of using the provided virtual machines (VM) on ZIH systems.

Currently, starting VMs is only possible on partitions `ml` and `hpdlf`. The VMs on the ML nodes are
used to build singularity containers for the Power9 architecture and the HPDLF nodes to build
Singularity containers for the x86 architecture.

## Create a Virtual Machine

The Slurm parameter `--cloud=kvm` specifies that a virtual machine should be started.

### On Power9 Architecture

```console
marie@login$ srun --partition=ml --nodes=1 --cpus-per-task=4 --hint=nomultithread --cloud=kvm --pty /bin/bash
srun: job 6969616 queued and waiting for resources
srun: job 6969616 has been allocated resources
bash-4.2$
```

### On x86 Architecture

```console
marie@login$ srun --partition=hpdlf --nodes=1 --cpus-per-task=4 --hint=nomultithread --cloud=kvm --pty /bin/bash
srun: job 2969732 queued and waiting for resources
srun: job 2969732 has been allocated resources
bash-4.2$
```

## Access a Virtual Machine

After a security issue on ZIH systems, we restricted the filesystem permissions. Now, you have to
wait until the file `/tmp/${SLURM_JOB_USER}_${SLURM_JOB_ID}/activate` is created. Then, you can try
to connect via `ssh` into the virtual machine, but it could be that the virtual machine needs some
more seconds to boot and accept the connection. So you may need to try the `ssh` command multiple
times till it succeeds.

```console
bash-4.2$ cat /tmp/marie_2759627/activate
#!/bin/bash

if ! grep -q -- "Key for the VM on the partition ml" "/home/marie/.ssh/authorized_keys" > /dev/null; then
  cat "/tmp/marie_2759627/kvm.pub" >> "/home/marie/.ssh/authorized_keys"
else
  sed -i "s|.*Key for the VM on the partition ml.*|ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3siZfQ6vQ6PtXPG0RPZwtJXYYFY73TwGYgM6mhKoWHvg+ZzclbBWVU0OoU42B3Ddofld7TFE8sqkHM6M+9jh8u+pYH4rPZte0irw5/27yM73M93q1FyQLQ8Rbi2hurYl5gihCEqomda7NQVQUjdUNVc6fDAvF72giaoOxNYfvqAkw8lFyStpqTHSpcOIL7pm6f76Jx+DJg98sXAXkuf9QK8MurezYVj1qFMho570tY+83ukA04qQSMEY5QeZ+MJDhF0gh8NXjX/6+YQrdh8TklPgOCmcIOI8lwnPTUUieK109ndLsUFB5H0vKL27dA2LZ3ZK+XRCENdUbpdoG2Czz Key for the VM on the partition ml|" "/home/marie/.ssh/authorized_keys"
fi

ssh -i /tmp/marie_2759627/kvm root@192.168.0.6
bash-4.2$ source /tmp/marie_2759627/activate
Last login: Fri Jul 24 13:53:48 2020 from gateway
[root@marie_2759627 ~]#
```

## Example Usage

## Automation

We provide [tools](virtual_machines_tools.md) to automate these steps. You may just type `startInVM
--arch=power9` on a login node and you will be inside the VM with everything mounted.

## Known Issues

### Temporary Memory

The available space inside the VM can be queried with `df -h`. Currently the whole VM has 8 GB and
with the installed operating system, 6.6 GB of available space.

Sometimes, the Singularity build might fail because of a disk out-of-memory error. In this case, it
might be enough to delete leftover temporary files from Singularity:

```console
rm -rf /tmp/sbuild-*
```

If that does not help, e.g., because one build alone needs more than the available disk memory, then
it will be necessary to use the tmp folder on scratch. In order to ensure that the files in the
temporary folder will be owned by root, it is necessary to set up an image inside `/scratch/tmp`
instead of using it directly. E.g., to create a 25 GB of temporary memory image:

```console
tmpDir="$( mktemp -d --tmpdir=/host_data/tmp )" && tmpImg="$tmpDir/singularity-build-temp-dir"
export LANG_BACKUP=$LANG
unset LANG
truncate -s 25G "$tmpImg.ext4" && echo yes | mkfs.ext4 "$tmpImg.ext4"
export LANG=$LANG_BACKUP
```

The image can now be mounted and with the `SINGULARITY_TMPDIR` environment variable can be
specified as the temporary directory for Singularity builds. Unfortunately, because of an open
Singularity [bug](https://github.com/sylabs/singularity/issues/32) it is should be avoided to mount
the image using `/dev/loop0`.

```console
mkdir -p "$tmpImg" && i=1 && while test -e "/dev/loop$i"; do (( ++i )); done && mknod -m 0660 "/dev/loop$i" b 7 "$i"
mount -o loop="/dev/loop$i" "$tmpImg"{.ext4,}

export SINGULARITY_TMPDIR="$tmpImg"
singularity build my-container.{sif,def}
```

The architecture of the base image is automatically chosen when you use an image from DockerHub.
This may not work for Singularity Hub, so in order to build for the power architecture the
Bootstraps **shub** and **library** should be avoided.

### Transport Endpoint is not Connected

This happens when the SSHFS mount gets unmounted because it is not very stable. It is sufficient to
run `~/mount_host_data.sh` again or just the SSHFS command inside that script.
