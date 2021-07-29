# Workspaces

Storage systems differ in terms of capacity, streaming bandwidth, IOPS rate, etc. Price and
efficiency don't allow to have it all in one. That is why fast parallel file systems at ZIH have
restrictions with regards to **age of files** and [quota](quotas.md). The mechanism of workspaces
enables users to better manage their HPC data.
<!--Workspaces are primarily login-related.-->
The concept of "workspaces" is common and used at a large number of HPC centers.

!!! note

    A workspace is a directory, with an associated expiration date, created on behalf of a user in a
    certain storage system.

Once the workspace has reached its expiration date, it gets moved to a hidden directory and enters a
grace period. Once the grace period ends, the workspace is deleted permanently. The maximum lifetime
of a workspace depends on the storage system. All workspaces can be extended a certain amount of
times.

!!! tip

    Use the faster file systems if you need to write temporary data in your computations, and use
    the capacity oriented file systems if you only need to read data for your computations. Please
    keep track of your data and move it to a capacity oriented filesystem after the end of your
    computations.

## Workspace Management

### List Available File Systems

To list all available file systems for using workspaces use:

```bash
zih$ ws_find -l
Available filesystems:
scratch
warm_archive
ssd
beegfs_global0
```

### List Current Workspaces

To list all workspaces you currently own, use:

```bash
zih$ ws_list
id: test-workspace
     workspace directory  : /scratch/ws/0/marie-test-workspace
     remaining time       : 89 days 23 hours
     creation time        : Thu Jul 29 10:30:04 2021
     expiration date      : Wed Oct 27 10:30:04 2021
     filesystem name      : scratch
     available extensions : 10
```

### Allocate a Workspace

To create a workspace in one of the listed filesystems use `ws_allocate`. It is necessary to specify
a unique name and the duration of the workspace.

```bash
ws_allocate: [options] workspace_name duration

Options:
  -h [ --help]               produce help message
  -V [ --version ]           show version
  -d [ --duration ] arg (=1) duration in days
  -n [ --name ] arg          workspace name
  -F [ --filesystem ] arg    filesystem
  -r [ --reminder ] arg      reminder to be sent n days before expiration
  -m [ --mailaddress ] arg   mailaddress to send reminder to (works only with tu-dresden.de mails)
  -x [ --extension ]         extend workspace
  -u [ --username ] arg      username
  -g [ --group ]             group workspace
  -c [ --comment ] arg       comment

```

!!! example

    ```bash
    zih$ ws_allocate -F scratch -r 7 -m marie.testuser@tu-dresden.de test-workspace 90
    Info: creating workspace.
    /scratch/ws/marie-test-workspace
    remaining extensions  : 10
    remaining time in days: 90
    ```

This will create a workspace with the name `test-workspace` on the `/scratch` file system for 90
days with an email reminder for 7 days before the expiration.

!!! Note

    Setting the reminder to `7` means you will get a reminder email on every day starting `7` prior
    to expiration date.

### Extention of a Workspace

The lifetime of a workspace is finite. Different file systems (storage systems) have different
maximum durations. A workspace can be extended multiple times, depending on the file system.

| Storage system (use with parameter -F ) | Duration, days | Extensions | Remarks |
|:------------------------------------------:|:----------:|:-------:|:---------------------------------------------------------------------------------------:|
| `ssd`                                       | 30 | 10 | High-IOPS file system (`/lustre/ssd`) on SSDs.                                          |
| `beegfs`                                     | 30 | 2 | High-IOPS file system (`/lustre/ssd`) onNVMes.                                          |
| `scratch`                                    | 100 | 2 | Scratch file system (/scratch) with high streaming bandwidth, based on spinning disks |
| `warm_archive`                               | 365 | 2 | Capacity file system based on spinning disks                                          |

To extend your workspace use the following command:

```
zih$ ws_extend -F scratch test-workspace 100      #extend the workspace for 100 days
Info: extending workspace.
/scratch/ws/marie-test-workspace
remaining extensions  : 1
remaining time in days: 100
```

!!!Attention

    With the `ws_extend` command, a new duration for the workspace is set. The new duration is not
    added!

This means when you extend a workspace that expires in 90 days with the `ws_extend -F scratch
my-workspace 40`, it will now expire in 40 days **not** 130 days.

### Deletion of a Workspace

To delete a workspace use the `ws_release` command. It is mandatory to specify the name of the
workspace and the file system in which it is located:

`ws_release -F <file system> <workspace name>`

### Restoring Expired Workspaces

At expiration time your workspace will be moved to a special, hidden directory. For a month (in
warm_archive: 2 months), you can still restore your data into an existing workspace.

!!!Warning

    When you release a workspace **by hand**, it will not receive a grace period and be
    **permanently deleted** the **next day**. The advantage of this design is that you can create
    and release workspaces inside jobs and not swamp the file system with data no one needs anymore
    in the hidden directories (when workspaces are in the grace period).

Use:

```
ws_restore -l -F scratch
```

to get a list of your expired workspaces, and then restore them like that into an existing, active
workspace 'new_ws':

```
ws_restore -F scratch marie-test-workspace-1234567 new_ws
```

The expired workspace has to be specified by its full name as listed by `ws_restore -l`, including
username prefix and timestamp suffix (otherwise, it cannot be uniquely identified). The target
workspace, on the other hand, must be given with just its short name, as listed by `ws_list`,
without the username prefix.

Both workspaces must be on the same file system. The data from the old workspace will be moved into
a directory in the new workspace with the name of the old one. This means a fresh workspace works as
well as a workspace that already contains data.

## Linking Workspaces in HOME

It might be valuable to have links to personal workspaces within a certain directory, e.g., your 
`home` directory. The command `ws_register DIR` will create and manage links to all personal
workspaces within in the directory `DIR`. Calling this command will do the following:

- The directory `DIR` will be created if necessary.
- Links to all personal workspaces will be managed:
  	- Create links to all available workspaces if not already present.
  	- Remove links to released workspaces.

**Remark**: An automatic update of the workspace links can be invoked by putting the command
`ws_register DIR` in your personal `shell` configuration file (e.g., `.bashrc`).

## How to use Workspaces

There are three typical options for the use of workspaces:

### Per-Job Storage

A batch job needs a directory for temporary data. This can be deleted afterwards.

!!! example "Use with Gaussian"

    ```
    #!/bin/bash
    #SBATCH --partition=haswell
    #SBATCH --time=96:00:00
    #SBATCH --nodes=1
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=24
    
    module load modenv/classic
    module load gaussian
    
    COMPUTE_DIR=gaussian_$SLURM_JOB_ID
    export GAUSS_SCRDIR=$(ws_allocate -F ssd $COMPUTE_DIR 7)
    echo $GAUSS_SCRDIR
    
    srun g16 inputfile.gjf logfile.log
    
    test -d $GAUSS_SCRDIR && rm -rf $GAUSS_SCRDIR/*
    ws_release -F ssd $COMPUTE_DIR
    ```

Likewise, other jobs can use temporary workspaces.

### Data for a Campaign

For a series of jobs or calculations that work on the same data, you should allocate a workspace
once, e.g., in `scratch` for 100 days:

```
zih$ ws_allocate -F scratch my_scratchdata 100
Info: creating workspace.
/scratch/ws/marie-my_scratchdata
remaining extensions  : 2
remaining time in days: 99
```

You can grant your project group access rights:

```
chmod g+wrx /scratch/ws/marie-my_scratchdata
```

And verify it with:

```
zih $ ls -la /scratch/ws/marie-my_scratchdata
total 8
drwxrwx--- 2 marie    hpcsupport 4096 Jul 10 09:03 .
drwxr-xr-x 5 operator adm        4096 Jul 10 09:01 ..
```

### Mid-Term Storage

For data that seldom changes but consumes a lot of space, the warm archive can be used. Note that
this is mounted read-only on the compute nodes, so you cannot use it as a work directory for your
jobs!

```
zih$ ws_allocate -F warm_archive my_inputdata 365
/warm_archive/ws/marie-my_inputdata
remaining extensions  : 2
remaining time in days: 365
```

!!!Attention 

    The warm archive is not built for billions of files. There
    is a quota for 100.000 files per group. Please archive data. 

To see your active quota use:

```
qinfo quota /warm_archive/ws/
```

Note that the workspaces reside under the mountpoint `/warm_archive/ws/` and not `/warm_archive`
anymore.

## F.A.Q

**Q**: I am getting the error `Error: could not create workspace directory!`

**A**: Please check the "locale" setting of your ssh client. Some clients (e.g. the one from MacOSX)
set values that are not valid on our ZIH systems. You should overwrite `LC_CTYPE` and set it to a
valid locale value like `export LC_CTYPE=de_DE.UTF-8`.

A list of valid locales can be retrieved via `locale -a`. Please only use UTF8 (or plain) settings.
Avoid "iso" codepages!

**Q**: I am getting the error `Error: target workspace does not exist!`  when trying to restore my
workspace.

**A**: The workspace you want to restore into is either not on the same file system or you used the
wrong name. Use only the short name that is listed after `id:` when using `ws_list`
