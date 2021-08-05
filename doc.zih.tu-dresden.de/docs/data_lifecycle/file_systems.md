# Overview

As soon as you have access to ZIH systems you have to manage your data. Several file systems are
available. Each file system serves for special purpose according to their respective capacity,
performance and permanence.

## Work Directories

| File system | Usable directory  | Capacity | Availability | Backup | Remarks                                                                                                                                                         |
|:------------|:------------------|:---------|:-------------|:-------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Lustre`    | `/scratch/`       | 4 PB     | global       | No     | Only accessible via [Workspaces](workspaces.md). Not made for billions of files!                                                                                   |
| `Lustre`    | `/lustre/ssd`     | 40 TB    | global       | No     | Only accessible via [Workspaces](workspaces.md). For small I/O operations                                                                                          |
| `BeeGFS`    | `/beegfs/global0` | 232 TB   | global       | No     | Only accessible via [Workspaces](workspaces.md). Fastest available file system, only for large parallel applications running with millions of small I/O operations |
| `ext4`      | `/tmp`            | 95 GB    | local        | No     | is cleaned up after the job automatically  |

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
