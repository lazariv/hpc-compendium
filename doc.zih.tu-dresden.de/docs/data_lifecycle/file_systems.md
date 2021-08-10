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

``` console
marie@login$ df
```

Alternativly you can use the "findmnt"-command, which is also able to perform an `df` by adding the
"-D"-parameter:

``` console
marie@login$ findmnt -D
```

Optional you can use the `-t`-parameter to specify the fs-type or the `-o`-parameter to alter the
output.

We do **not recommend** the usage of the "du"-command for this purpose.  It is able to cause issues
for other users, while reading data from the filesystem.
