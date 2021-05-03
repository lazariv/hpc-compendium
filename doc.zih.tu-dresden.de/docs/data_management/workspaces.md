# Workspaces

## Introduction

Storage systems come in many different ways in terms of: size, streaming bandwidth, IOPS rate.

Price and efficiency don't allow to have it all in one. That is the reason why Taurus fast parallel
file systems have restrictions wrt. age of files. The mechanism of workspaces enables users to
better manage the data life cycle of their HPC data. Workspaces are primarily login-related. The
tool concept of "workspaces" is common in a large number of HPC centers. The idea is to request for
a workspace directory in a certain storage system - connected with an expiry date. After a grace
period the data is deleted automatically. The maximum lifetime of a workspace depends on the storage
system. All workspaces can be extended.

Use the fastest file systems according to recommendations. Please keep track of the data and move it
to a capacity oriented filesystem after the end of computations.

## Commands. Workspace Management.

The lifecycle of workspaces controls with commands. The basic commands will be presented below.

To list all available filesystems for using workspaces use `ws_find -l`

Output:

```
Available filesystems:
scratch
warm_archive
ssd
beegfs_global0
```

### Creation of the Workspace

To create a workspace in one of the listed filesystems use `ws_allocate`. It is necessary to specify
a unique name and the duration of the workspace.

``` ws_allocate: [options] <workspace_name>
duration

##

Options:
  -h [ --help]              produce help message
  -V [ --version ]           show version
  -d [ --duration ] arg (=1) duration in days
  -n [ --name ] arg          workspace name
  -F [ --filesystem ] arg    filesystem
  -r [ --reminder ] arg      reminder to be sent n days before expiration
  -m [ --mailaddress ] arg   mailaddress to send reminder to  (works only with tu-dresden.de addresses)
  -x [ --extension ]         extend workspace
  -u [ --username ] arg      username
  -g [ --group ]             group workspace
  -c [ --comment ] arg       comment

```

For example:

```
ws_allocate -F scratch -r 7 -m name.lastname@tu-dresden.de test-WS 90
```

The command creates a workspace with the name test-WS on the scratch filesystem for 90 days with an
e-mail reminder for 7 days before the expiration.

Output:

```
Info: creating workspace.
/scratch/ws/mark-SPECint
remaining extensions  : 10
remaining time in days: 90
```

<span style="color:red">Note:</span> The overview of currently used workspaces can be obtained with
the `ws_list` command.

### Extention of the Workspace

The lifetime of the workspace is finite. Different filesystems (storagesystems) have different
maximum durations. A workspace can be extended.

The maximum duration depends on the storage system:

| Storage system (use with parameter -F ) | Duration, days | Remarks                                                                                |
|:------------------------------------------:|:----------:|:---------------------------------------------------------------------------------------:|
| ssd                                        | 30  | High-IOPS file system (/lustre/ssd) on SSDs.                                          |
| beegfs                                     | 30  | High-IOPS file system (/lustre/ssd) onNVMes.                                          |
| scratch                                    | 100  | Scratch file system (/scratch) with high streaming bandwidth, based on spinning disks |
| warm_archive                               | 365  | Capacity file system based on spinning disks                                          |

```
ws_extend -F scratch test-WS 100      #extend the workspace for another 100 days
```

Output:

```
Info: extending workspace.
/scratch/ws/masterman-test_ws
remaining extensions  : 1
remaining time in days: 100
```

A workspace can be extended twice. With the `ws_extend` command, a new duration for the workspace is
set (not cumulative).

### Deletion of the Workspace

To delete workspace use the `ws_release` command. It is necessary to specify the name of the
workspace and the storage system in which it is located:

`ws_release -F <file system> <workspace name>`

For example:

```
ws_release -F scratch test_ws
```

### Restoring Expired Workspaces

At expiration time (or when you manually release your workspace), your workspace will be moved to a
special, hidden directory. For a month (in warm_archive: 2 months), you can still restore your data
into a valid workspace. For that, use

```
ws_restore -l -F scratch
```

to get a list of your expired workspaces, and then restore them like that into an existing, active
workspace 'new_ws':

```
ws_restore -F scratch myuser-test_ws-1234567 new_ws
```

<span style="color:red">Note:</span> the expired workspace has to be specified using the full name
as listed by `ws_restore -l`, including username prefix and timestamp suffix (otherwise, it cannot
be uniquely identified).  The target workspace, on the other hand, must be given with just its short
name as listed by `ws_list`, without the username prefix.

## Linking Workspaces in HOME

It might be valuable to have links to personal workspaces within a certain directory, e.g., the user
home directory. The command `ws_register DIR` will create and manage links to all personal
workspaces within in the directory `DIR`. Calling this command will do the following:

- The directory `DIR` will be created if necessary
- Links to all personal workspaces will be managed:
  	- Creates links to all available workspaces if not already present
  	- Removes links to released workspaces

**Remark**: An automatic update of the workspace links can be invoked by putting the command
`ws_register DIR` in the user's personal shell configuration file (e.g., .bashrc, .zshrc).

## How to Use Workspaces

There are three typical options for the use of workspaces:

### Per-job storage

A batch job needs a directory for temporary data. This can be deleted afterwards.

Here an example for the use with Gaussian:

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

### Data for a campaign

For a series of calculations that works on the same data, you could allocate a workspace in the
scratch for e.g. 100 days:

```
ws_allocate -F scratch my_scratchdata 100
```

Output:

```
Info: creating workspace.
/scratch/ws/mark-my_scratchdata
remaining extensions  : 2
remaining time in days: 99
```

If you want to share it with your project group, set the correct access attributes, e.g:

```
chmod g+wrx /scratch/ws/mark-my_scratchdata
```

And verify it with:

```
ls -la /scratch/ws/mark-my_scratchdata
```

Output:

```
total 8
drwxrwx--- 2 mark    hpcsupport 4096 Jul 10 09:03 .
drwxr-xr-x 5 operator adm       4096 Jul 10 09:01 ..
```

### Mid-Term storage

For data that seldomly changes but consumes a lot of space, the warm archive can be used. Note that
this is mounted read-only on the compute nodes, so you cannot use it as a work directory for your
jobs!

```
ws_allocate -F warm_archive my_inputdata 365
```

Output:

```
/warm_archive/ws/mark-my_inputdata
remaining extensions  : 2
remaining time in days: 365
```

<span style="color:red">Attention:</span> The warm archive is not built for billions of files. There
is a quota active of 100.000 files per group. Please archive data. To see your active quota use:

```
qinfo quota /warm_archive/ws/
```

Note that the workspaces reside under the mountpoint /warm_archive/ws/ and not /warm_archive anymore.

## F.A.Q

**Q**: I am getting the error `Error: could not create workspace directory!`

**A**: Please check the "locale" setting of your ssh client. Some clients (e.g. the one from MacOSX)
set values that are not valid on Taurus. You should overwrite LC_CTYPE and set it to a valid locale
value like:

```
export LC_CTYPE=de_DE.UTF-8
```

A list of valid locales can be retrieved via `locale -a`. Please use only UTF8 (or plain) settings.
Avoid "iso" codepages!
