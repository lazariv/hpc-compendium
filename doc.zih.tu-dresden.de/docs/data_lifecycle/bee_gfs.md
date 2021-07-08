# BeeGFS file system

%RED%Note: This page is under construction. %ENDCOLOR%%RED%The pipeline
will be changed soon%ENDCOLOR%

**Prerequisites:** To work with Tensorflow you obviously need \<a
href="Login" target="\_blank">access\</a> for the Taurus system and
basic knowledge about Linux, mounting, SLURM system.

**Aim** \<span style="font-size: 1em;"> of this page is to introduce
users how to start working with the BeeGFS file\</span>\<span
style="font-size: 1em;"> system - a high-performance parallel file
system.\</span>

## Mount point

Understanding of mounting and the concept of the mount point is
important for using file systems and object storage. A mount point is a
directory (typically an empty one) in the currently accessible file
system on which an additional file system is mounted (i.e., logically
attached). \<span style="font-size: 1em;">The default mount points for a
system are the directories in which file systems will be automatically
mounted unless told by the user to do otherwise. \</span>\<span
style="font-size: 1em;">All partitions are attached to the system via a
mount point. The mount point defines the place of a particular data set
in the file system. Usually, all partitions are connected through the
root partition. On this partition, which is indicated with the slash
(/), directories are created. \</span>

## BeeGFS introduction

\<span style="font-size: 1em;"> [BeeGFS](https://www.beegfs.io/content/)
is the parallel cluster file system. \</span>\<span style="font-size:
1em;">BeeGFS spreads data \</span>\<span style="font-size: 1em;">across
multiple \</span>\<span style="font-size: 1em;">servers to aggregate
\</span>\<span style="font-size: 1em;">capacity and \</span>\<span
style="font-size: 1em;">performance of all \</span>\<span
style="font-size: 1em;">servers to provide a highly scalable shared
network file system with striped file contents. This is made possible by
the separation of metadata and file contents. \</span>

BeeGFS is fast, flexible, and easy to manage storage if for your issue
filesystem plays an important role use BeeGFS. It addresses everyone,
who needs large and/or fast file storage

## Create BeeGFS file system

To reserve nodes for creating BeeGFS file system you need to create a
[batch](../jobs_and_resources/slurm.md) job

    #!/bin/bash
    #SBATCH -p nvme
    #SBATCH -N 4
    #SBATCH --exclusive
    #SBATCH --time=1-00:00:00
    #SBATCH --beegfs-create=yes

    srun sleep 1d  # sleep for one day

    ## when finished writing, submit with:  sbatch <script_name>

Example output with job id:

    Submitted batch job 11047414   #Job id n.1

Check the status of the job with 'squeue -u \<username>'

## Mount BeeGFS file system

You can mount BeeGFS file system on the ML partition (ppc64
architecture) or on the Haswell [partition](../jobs_and_resources/system_taurus.md) (x86_64
architecture)

### Mount BeeGFS file system on the ML

Job submission can be done with the command (use job id (n.1) from batch
job used for creating BeeGFS system):

    srun -p ml --beegfs-mount=yes --beegfs-jobid=11047414 --pty bash                #Job submission on ml nodes

Example output:

    srun: job 11054579 queued and waiting for resources         #Job id n.2
    srun: job 11054579 has been allocated resources

### Mount BeeGFS file system on the Haswell nodes (x86_64)

Job submission can be done with the command (use job id (n.1) from batch
job used for creating BeeGFS system):

    srun --constrain=DA --beegfs-mount=yes --beegfs-jobid=11047414 --pty bash       #Job submission on the Haswell nodes

Example output:

    srun: job 11054580 queued and waiting for resources          #Job id n.2
    srun: job 11054580 has been allocated resources

## Working with BeeGFS files for both types of nodes

Show contents of the previously created file, for example,
beegfs_11054579 (where 11054579 - job id **n.2** of srun job):

    cat .beegfs_11054579

Note: don't forget to go over to your home directory where the file
located

Example output:

    #!/bin/bash

    export BEEGFS_USER_DIR="/mnt/beegfs/<your_id>_<name_of_your_job>/<your_id>"
    export BEEGFS_PROJECT_DIR="/mnt/beegfs/<your_id>_<name_of_your_job>/<name of your project>" 

Execute the content of the file:

    source .beegfs_11054579

Show content of user's BeeGFS directory with the command:

    ls -la ${BEEGFS_USER_DIR}

Example output:

    total 0
    drwx--S--- 2 <username> swtest  6 21. Jun 10:54 .
    drwxr-xr-x 4 root        root  36 21. Jun 10:54 ..

Show content of the user's project BeeGFS directory with the command:

    ls -la ${BEEGFS_PROJECT_DIR}

Example output:

    total 0
    drwxrws--T 2 root swtest  6 21. Jun 10:54 .
    drwxr-xr-x 4 root root   36 21. Jun 10:54 ..

Note: If you want to mount the BeeGFS file system on an x86 instead of
an ML (power) node, you can either choose the partition "interactive" or
the partition "haswell64", but for the partition "haswell64" you have to
add the parameter "--exclude=taurusi\[4001-4104,5001- 5612\]" to your
job. This is necessary because the BeeGFS client is only installed on
the 6000 island.
