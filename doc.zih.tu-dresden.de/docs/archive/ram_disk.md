# RAM Disk

!!! warning

    This page is outdated.

On systems with a very large main memory, it is for some workloads very attractive to use parts of
the main memory as a temporary file system.  This will reduce file access times dramatically and has
proven to speed up applications that are otherwise limited by I/O.

We provide tools to allow users to create and destroy their own ramdisks. Currently, this is only
allowed on the SGI UV2 (venus). Please note that the content of the ramdisk will vanish immediatelly
when the ramdisk is destroyed or the machine crashes. Always copy out result data written to the
ramdisk to another location.

### Creating a RAM Disk

On [Venus](hardware_venus.md), the creation of RAM disk is only allowed from within an LSF job. The
memory used for the RAM disk will be deducted from the memory assigned to the LSF job. Thus, the
amount of memory available for an LSF job determines the maximum size of the ramdisk. Per LSF job
only a single ramdisk can be created (but you can create and delete a ramdisk multiple times during
a job). You need to load the corresponding software module via

```Bash
module load ramdisk
```

Afterwards, the RAM disk can be created with the command

```Bash
make-ramdisk «size of the ramdisk in GB»
```

The path to the ramdisk is fixed to `/ramdisks/«JOBID»`.

### Putting data onto the ramdisk

The ramdisk itself works like a normal file system or directory. We
provide a script that uses multiple threads to copy a directory tree. It
can also be used to transfer single files but will only use one thread
in this case. It is used as follows

```Bash
parallel-copy.sh «source directory or file» «target directory»
```

It is not specifically tailored to be used with the ramdisk. It can be
used for any copy process between two locations.

### Destruction of the ramdisk

A ramdisk will automatically be deleted at the end of the job. As an
alternative, you can delete your own ramdisk via the command

```Bash
kill-ramdisk
```

It is possible, that the deletion of the ramdisk fails. The reason for
this is typically that some process still has a file open within the
ramdisk or that there is still a program using the ramdisk or having the
ramdisk as its current path. Locating these processes, that block the
destruction of the ramdisk is possible via using the command

```Bash
lsof +d /ramdisks/«JOBID»
```
