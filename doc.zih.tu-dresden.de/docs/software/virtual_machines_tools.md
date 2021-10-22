# Singularity on Partition `ml`

!!! note "Root privileges"

    Building Singularity containers from a recipe on ZIH system is normally not possible due to the
    requirement of root (administrator) rights, see [Containers](containers.md). For obvious reasons
    users cannot be granted root permissions.

The solution is to build your container on your local Linux workstation using Singularity and copy
it to ZIH systems for execution.

**This does not work on the partition `ml`** as it uses the Power9 architecture which your
workstation likely doesn't.

For this, we provide a Virtual Machine (VM) on the partition `ml` which allows users to gain root
permissions in an isolated environment. The workflow to use this manually is described for
[virtual machines](virtual_machines.md) but is quite cumbersome.

To make this easier, two programs are provided: `buildSingularityImage` and `startInVM`, which do
what they say. The latter is for more advanced use cases, so you should be fine using
`buildSingularityImage`, see the following section.

!!! note "SSH key without password"

    You need to have your default SSH key without a password for the scripts to work as
    entering a password through the scripts is not supported.

**The recommended workflow** is to create and test a definition file locally. You usually start from
a base Docker container. Those typically exist for different architectures but with a common name
(e.g.  `ubuntu:18.04`). Singularity automatically uses the correct Docker container for your current
architecture when building. So, in most cases, you can write your definition file, build it and test
it locally, then move it to ZIH systems and build it on Power9 (partition `ml`) without any further
changes. However, sometimes Docker containers for different architectures have different suffixes,
in which case you'd need to change that when moving to ZIH systems.

## Build a Singularity Container in a Job

To build a Singularity container for the power9-architecture on ZIH systems simply run:

```console
marie@login$ buildSingularityImage --arch=power9 myContainer.sif myDefinition.def
```

To build a singularity image on the x86-architecture, run:

```console
marie@login$ buildSingularityImage --arch=x86 myContainer.sif myDefinition.def
```

These commands will submit a batch job and immediately return. If you want it to block while the
image is built and see live output, add the option `--interactive`:

```console
marie@login$ buildSingularityImage --arch=power9 --interactive myContainer.sif myDefinition.def
```

There are more options available, which can be shown by running `buildSingularityImage --help`. All
have reasonable defaults. The most important ones are:

* `--time <time>`: Set a higher job time if the default time is not
  enough to build your image and your job is canceled before completing. The format is the same as
  for Slurm.
* `--tmp-size=<size in GB>`: Set a size used for the temporary
  location of the Singularity container, basically the size of the extracted container.
* `--output=<file>`: Path to a file used for (log) output generated
  while building your container.
* Various Singularity options are passed through. E.g.
  `--notest, --force, --update`. See, e.g., `singularity --help` for details.

For **advanced users**, it is also possible to manually request a job with a VM (`srun -p ml
--cloud=kvm ...`) and then use this script to build a Singularity container from within the job. In
this case, the `--arch` and other Slurm related parameters are not required. The advantage of using
this script is that it automates the waiting for the VM and mounting of host directories into it
(can also be done with `startInVM`) and creates a temporary directory usable with Singularity inside
the VM controlled by the `--tmp-size` parameter.

## Filesystem

**Read here if you have problems like "File not found".**

As the build starts in a VM, you may not have access to all your files. It is usually bad practice
to refer to local files from inside a definition file anyway as this reduces reproducibility.
However, common directories are available by default. For others, care must be taken. In short:

* `/home/$USER`, `/scratch/$USER` are available and should be used `/scratch/<group>` also works for
  all groups the users is in
* `/projects/<group>` similar, but is read-only! So don't use this to store your generated
  container directly, but rather move it here afterwards
* `/tmp` is the VM local temporary directory. All files put here will be lost!

If the current directory is inside (or equal to) one of the above (except `/tmp`), then relative paths
for container and definition work as the script changes to the VM equivalent of the current
directory.  Otherwise, you need to use absolute paths. Using `~` in place of `$HOME` does work too.

Under the hood, the filesystem of ZIH systems is mounted via SSHFS at `/host_data`. So if you need any
other files, they can be found there.

There is also a new SSH key named `kvm` which is created by the scripts and authorized inside the VM
to allow for password-less access to SSHFS. This is stored at `~/.ssh/kvm` and regenerated if it
does not exist. It is also added to `~/.ssh/authorized_keys`. Note that removing the key file does
not remove it from `authorized_keys`, so remove it manually if you need to. It can be easily
identified by the comment on the key. However, removing this key is **NOT** recommended, as it
needs to be re-generated on every script run.

## Start a Job in a VM

Especially when developing a Singularity definition file, it might be useful to get a shell directly
on a VM. To do so on the power9-architecture, simply run:

```console
startInVM --arch=power9
```

To do so on the x86-architecture, run:

```console
startInVM --arch=x86
```

This will execute an `srun` command with the `--cloud=kvm` parameter, wait till the VM is ready,
mount all folders (just like `buildSingularityImage`, see the Filesystem section above) and come
back with a bash inside the VM. Inside that you are root, so you can directly execute `singularity
build` commands.

As usual, more options can be shown by running `startInVM --help`, the most important one being
`--time`.

There are two special use cases for this script:

1. Execute an arbitrary command inside the VM instead of getting a bash by appending the command to
   the script. Example: `startInVM --arch=power9 singularity build ~/myContainer.sif  ~/myDefinition.de`
1. Use the script in a job manually allocated via srun/sbatch. This will work the same as when
   running outside a job but will **not** start a new job. This is useful for using it inside batch
   scripts, when you already have an allocation or need special arguments for the job system. Again,
   you can run an arbitrary command by passing it to the script.
