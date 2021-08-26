# Overview

As soon as you have access to ZIH systems, you have to manage your data. Several filesystems are
available. Each filesystem serves for special purpose according to their respective capacity,
performance and permanence.

## Work Directories

| Filesystem  | Usable directory  | Capacity | Availability | Backup | Remarks                                                                                                                                                         |
|:------------|:------------------|:---------|:-------------|:-------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Lustre`    | `/scratch/`       | 4 PB     | global       | No     | Only accessible via [Workspaces](workspaces.md). Not made for billions of files!                                                                                   |
| `Lustre`    | `/lustre/ssd`     | 40 TB    | global       | No     | Only accessible via [Workspaces](workspaces.md). For small I/O operations                                                                                          |
| `BeeGFS`    | `/beegfs/global0` | 232 TB   | global       | No     | Only accessible via [Workspaces](workspaces.md). Fastest available file system, only for large parallel applications running with millions of small I/O operations |
| `ext4`      | `/tmp`            | 95 GB    | local        | No     | is cleaned up after the job automatically  |

## Recommendations for Filesystem Usage

To work as efficient as possible, consider the following points

- Save source code etc. in `/home` or `/projects/...`
- Store checkpoints and other temporary data in `/scratch/ws/...`
- Compilation in `/dev/shm` or `/tmp`

Getting high I/O-bandwidth

- Use many clients
- Use many processes (writing in the same file at the same time is possible)
- Use large I/O transfer blocks

## Cheat Sheet for Debugging Filesystem Issues

Users can select from the following commands to get some idea about
their data.

### General

For the first view, you can use the command `df`.

``` console
marie@login$ df
```

Alternatively, you can use the command `findmnt`, which is also able to report space usage
by adding the parameter `-D`:

``` console
marie@login$ findmnt -D
```

Optionally, you can use the parameter `-t` to specify the filesystem type or the parameter `-o` to
alter the output.

!!! important

    **Don't use** the `du`-command for this purpose. It is able to cause issues
    for other users, while reading data from the filesystem.
