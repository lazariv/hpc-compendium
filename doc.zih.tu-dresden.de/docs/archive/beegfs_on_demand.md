# BeeGFS Filesystem

!!! warning

    This documentation page is outdated.
    Please see the [new BeeGFS page](../data_lifecycle/beegfs.md).

**Prerequisites:** To work with TensorFlow you obviously need a [login](../application/overview.md) to
the ZIH systems and basic knowledge about Linux, mounting, and batch system Slurm.

**Aim** of this page is to introduce
users how to start working with the BeeGFS filesystem - a high-performance parallel filesystem.

## Mount Point

Understanding of mounting and the concept of the mount point is important for using filesystems and
object storage. A mount point is a directory (typically an empty one) in the currently accessible
filesystem on which an additional filesystem is mounted (i.e., logically attached).  The default
mount points for a system are the directories in which filesystems will be automatically mounted
unless told by the user to do otherwise.  All partitions are attached to the system via a mount
point. The mount point defines the place of a particular data set in the filesystem. Usually, all
partitions are connected through the root partition. On this partition, which is indicated with the
slash (/), directories are created.

## BeeGFS Introduction

[BeeGFS](https://www.beegfs.io/content/) is the parallel cluster filesystem.  BeeGFS spreads data
across multiple servers to aggregate capacity and performance of all servers to provide a highly
scalable shared network filesystem with striped file contents. This is made possible by the
separation of metadata and file contents.

BeeGFS is fast, flexible, and easy to manage storage if for your issue
filesystem plays an important role use BeeGFS. It addresses everyone,
who needs large and/or fast file storage.

## Create BeeGFS Filesystem

To reserve nodes for creating BeeGFS filesystem you need to create a
[batch](../jobs_and_resources/slurm.md) job

```Bash
#!/bin/bash
#SBATCH -p nvme
#SBATCH -N 4
#SBATCH --exclusive
#SBATCH --time=1-00:00:00
#SBATCH --beegfs-create=yes

srun sleep 1d  # sleep for one day

## when finished writing, submit with:  sbatch <script_name>
```

Example output with job id:

```Bash
Submitted batch job 11047414   #Job id n.1
```

Check the status of the job with `squeue -u \<username>`.

## Mount BeeGFS Filesystem

You can mount BeeGFS filesystem on the partition ml (PowerPC architecture) or on the
partition haswell (x86_64 architecture), more information about [partitions](../jobs_and_resources/partitions_and_limits.md).

### Mount BeeGFS Filesystem on the Partition `ml`

Job submission can be done with the command (use job id (n.1) from batch job used for creating
BeeGFS system):

```console
srun -p ml --beegfs-mount=yes --beegfs-jobid=11047414 --pty bash                #Job submission on ml nodes
```console

Example output:

```console
srun: job 11054579 queued and waiting for resources         #Job id n.2
srun: job 11054579 has been allocated resources
```

### Mount BeeGFS Filesystem on the Haswell Nodes (x86_64)

Job submission can be done with the command (use job id (n.1) from batch
job used for creating BeeGFS system):

```console
srun --constrain=DA --beegfs-mount=yes --beegfs-jobid=11047414 --pty bash       #Job submission on the Haswell nodes
```

Example output:

```console
srun: job 11054580 queued and waiting for resources          #Job id n.2
srun: job 11054580 has been allocated resources
```

## Working with BeeGFS files for both types of nodes

Show contents of the previously created file, for example,
`beegfs_11054579` (where 11054579 - job id **n.2** of srun job):

```console
cat .beegfs_11054579
```

Note: don't forget to go over to your `home` directory where the file located

Example output:

```Bash
#!/bin/bash

export BEEGFS_USER_DIR="/mnt/beegfs/<your_id>_<name_of_your_job>/<your_id>"
export BEEGFS_PROJECT_DIR="/mnt/beegfs/<your_id>_<name_of_your_job>/<name of your project>"
```

Execute the content of the file:

```console
source .beegfs_11054579
```

Show content of user's BeeGFS directory with the command:

```console
ls -la ${BEEGFS_USER_DIR}
```

Example output:

```console
total 0
drwx--S--- 2 <username> swtest  6 21. Jun 10:54 .
drwxr-xr-x 4 root        root  36 21. Jun 10:54 ..
```

Show content of the user's project BeeGFS directory with the command:

```console
ls -la ${BEEGFS_PROJECT_DIR}
```

Example output:

```console
total 0
drwxrws--T 2 root swtest  6 21. Jun 10:54 .
drwxr-xr-x 4 root root   36 21. Jun 10:54 ..
```

!!! note

    If you want to mount the BeeGFS filesystem on an x86 instead of an ML (power) node, you can
    either choose the partition "interactive" or the partition `haswell64`, but for the partition
    `haswell64` you have to add the parameter `--exclude=taurusi[4001-4104,5001-5612]` to your job.
    This is necessary because the BeeGFS client is only installed on the 6000 island.
