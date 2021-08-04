# File Systems

As soon as you have access to ZIH systems you have to manage your data. Several file systems are
available. Each file system serves for special purpose according to their respective capacity,
performance and permanence.

## Permanent File Systems

### Global /home File System

Each user has 50 GB in a `/home` directory independent of the granted capacity for the project.
Hints for the usage of the global home directory:

- If you need distinct `.bashrc` files for each machine, you should
  create separate files for them, named `.bashrc_<machine_name>`
- If you use various machines frequently, it might be useful to set
  the environment variable HISTFILE in `.bashrc_deimos` and
  `.bashrc_mars` to `$HOME/.bash_history_<machine_name>`. Setting
  HISTSIZE and HISTFILESIZE to 10000 helps as well.
- Further, you may use private module files to simplify the process of
  loading the right installation directories, see
  **todo link: private modules - AnchorPrivateModule**.

### Global /projects File System

For project data, we have a global project directory, that allows better collaboration between the
members of an HPC project. However, for compute nodes /projects is mounted as read-only, because it
is not a filesystem for parallel I/O. See below and also check the
**todo link: HPC introduction - %PUBURL%/Compendium/WebHome/HPC-Introduction.pdf** for more details.

### Backup and Snapshots of the File System

- Backup is **only** available in the `/home` and the `/projects` file systems!
- Files are backed up using snapshots of the NFS server and can be restored by the user
- A changed file can always be recovered as it was at the time of the snapshot
- Snapshots are taken:
  - From Monday through Saturday between 06:00 and 18:00 every two hours and kept for one day
    (7 snapshots)
  - From Monday through Saturday at 23:30 and kept for two weeks (12 snapshots)
  - Every Sunday st 23:45 and kept for 26 weeks
- To restore a previous version of a file:
  - Go into the directory of the file you want to restore
  - Run `cd .snapshot` (this subdirectory exists in every directory on the `/home` file system
    although it is not visible with `ls -a`)
  - In the .snapshot-directory are all available snapshots listed
  - Just `cd` into the directory of the point in time you wish to restore and copy the file you
    wish to restore to where you want it
  - **Attention** The `.snapshot` directory is not only hidden from normal view (`ls -a`), it is
    also embedded in a different directory structure. An `ls ../..` will not list the directory
    where you came from. Thus, we recommend to copy the file from the location where it
    originally resided:
    `pwd /home/username/directory_a % cp .snapshot/timestamp/lostfile lostfile.backup`
- `/home` and `/projects/` are definitely NOT made as a work directory:
  since all files are kept in the snapshots and in the backup tapes over a long time, they
  - Senseless fill the disks and
  - Prevent the backup process by their sheer number and volume from working efficiently.

### Group Quotas for the File System

The quotas of the home file system are meant to help the users to keep in touch with their data.
Especially in HPC, it happens that millions of temporary files are created within hours. This is the
main reason for performance degradation of the file system. If a project exceeds its quota (total
size OR total number of files) it cannot submit jobs into the batch system. The following commands
can be used for monitoring:

- `showquota` shows your projects' usage of the file system.
- `quota -s -f /home` shows the user's usage of the file system.

In case a project is above it's limits please ...

- Remove core dumps, temporary data
- Talk with your colleagues to identify the hotspots,
- Check your workflow and use /tmp or the scratch file systems for temporary files
- *Systematically* handle your important data:
  - For later use (weeks...months) at the HPC systems, build tar
    archives with meaningful names or IDs and store e.g. them in an
    [archive](intermediate_archive.md).
  - Refer to the hints for [long term preservation for research data](preservation_research_data.md).

## Work Directories

| File system | Usable directory  | Capacity | Availability | Backup | Remarks                                                                                                                                                         |
|:------------|:------------------|:---------|:-------------|:-------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Lustre`    | `/scratch/`       | 4 PB     | global       | No     | Only accessible via **todo link: workspaces - WorkSpaces**. Not made for billions of files!                                                                                   |
| `Lustre`    | `/lustre/ssd`     | 40 TB    | global       | No     | Only accessible via **todo link: workspaces - WorkSpaces**. For small I/O operations                                                                                          |
| `BeeGFS`    | `/beegfs/global0` | 232 TB   | global       | No     | Only accessible via **todo link: workspaces - WorkSpaces**. Fastest available file system, only for large parallel applications running with millions of small I/O operations |
| `ext4`      | `/tmp`            | 95.0 GB  | local        | No     | is cleaned up after the job automatically                                                                                                                       |


## Warm Archive

!!! warning
    This is under construction. The functionality is not there, yet.

The warm archive is intended a storage space for the duration of a running HPC-DA project. It can
NOT substitute a long-term archive. It consists of 20 storage nodes with a net capacity of 10 PB.
Within Taurus (including the HPC-DA nodes), the management software "Quobyte" enables access via

- native quobyte client - read-only from compute nodes, read-write
  from login and nvme nodes
- S3 - read-write from all nodes,
- Cinder (from OpenStack cluster).

For external access, you can use:

- S3 to `<bucket>.s3.taurusexport.hrsk.tu-dresden.de`
- or normal file transfer via our taurusexport nodes (see [DataManagement](overview.md)).

An HPC-DA project can apply for storage space in the warm archive. This is limited in capacity and
duration.
TODO

## Recommendations for File System Usage

To work as efficient as possible, consider the following points

- Save source code etc. in `/home` or /projects/...
- Store checkpoints and other temporary data in `/scratch/ws/...`
- Compilation in `/dev/shm` or `/tmp`

Getting high I/O-bandwitdh

- Use many clients
- Use many processes (writing in the same file at the same time is possible)
- Use large I/O transfer blocks

## Cheat Sheet for Debugging File System Issues

Every Taurus-User should normaly be able to perform the following commands to get some intel about
their data.

### General

For the first view, you can easily use the "df-command".

```Bash
df
```

Alternativly you can use the "findmnt"-command, which is also able to perform an `df` by adding the
"-D"-parameter.

```Bash
findmnt -D
```

Optional you can use the `-t`-parameter to specify the fs-type or the `-o`-parameter to alter the
output.

We do **not recommend** the usage of the "du"-command for this purpose.  It is able to cause issues
for other users, while reading data from the filesystem.



### BeeGFS

Commands to work with the BeeGFS file system.

#### Capacity and file system health

View storage and inode capacity and utilization for metadata and storage targets.

```Bash
beegfs-df -p /beegfs/global0
```

The `-p` parameter needs to be the mountpoint of the file system and is mandatory.

List storage and inode capacity, reachability and consistency information of each storage target.

```Bash
beegfs-ctl --listtargets --nodetype=storage --spaceinfo --longnodes --state --mount=/beegfs/global0
```

To check the capacity of the metadata server just toggle the `--nodetype` argument.

```Bash
beegfs-ctl --listtargets --nodetype=meta --spaceinfo --longnodes --state --mount=/beegfs/global0
```

#### Striping

View the stripe information of a given file on the file system and shows on which storage target the
file is stored.

```Bash
beegfs-ctl --getentryinfo /beegfs/global0/my-workspace/myfile --mount=/beegfs/global0
```

Set the stripe pattern for an directory. In BeeGFS the stripe pattern will be inherited form a
directory to its children.

```Bash
beegfs-ctl --setpattern --chunksize=1m --numtargets=16 /beegfs/global0/my-workspace/ --mount=/beegfs/global0
```

This will set the stripe pattern for `/beegfs/global0/path/to/mydir/` to a chunksize of 1M
distributed over 16 storage targets.

Find files located on certain server or targets. The following command searches all files that are
stored on the storage targets with id 4 or 30 und my-workspace directory.

```Bash
beegfs-ctl --find /beegfs/global0/my-workspace/ --targetid=4 --targetid=30 --mount=/beegfs/global0
```

#### Network

View the network addresses of the file system servers.

```Bash
beegfs-ctl --listnodes --nodetype=meta --nicdetails --mount=/beegfs/global0
beegfs-ctl --listnodes --nodetype=storage --nicdetails --mount=/beegfs/global0
beegfs-ctl --listnodes --nodetype=client --nicdetails --mount=/beegfs/global0
```

Display connections the client is actually using

```Bash
beegfs-net
```

Display possible connectivity of the services

```Bash
beegfs-check-servers -p /beegfs/global0
```
