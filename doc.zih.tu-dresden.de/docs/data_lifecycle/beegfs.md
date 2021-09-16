# BeeGFS

Commands to work with the BeeGFS filesystem.

## Capacity and Filesystem Health

View storage and inode capacity and utilization for metadata and storage targets.

```console
marie@login$ beegfs-df -p /beegfs/global0
```

The `-p` parameter needs to be the mountpoint of the filesystem and is mandatory.

List storage and inode capacity, reachability and consistency information of each storage target.

```console
marie@login$ beegfs-ctl --listtargets --nodetype=storage --spaceinfo --longnodes --state --mount=/beegfs/global0
```

To check the capacity of the metadata server, just toggle the `--nodetype` argument.

```console
marie@login$ beegfs-ctl --listtargets --nodetype=meta --spaceinfo --longnodes --state --mount=/beegfs/global0
```

## Striping

Show the stripe information of a given file on the filesystem and on which storage target the
file is stored.

```console
marie@login$ beegfs-ctl --getentryinfo /beegfs/global0/my-workspace/myfile --mount=/beegfs/global0
```

Set the stripe pattern for a directory. In BeeGFS, the stripe pattern will be inherited from a
directory to its children.

```console
marie@login$ beegfs-ctl --setpattern --chunksize=1m --numtargets=16 /beegfs/global0/my-workspace/ --mount=/beegfs/global0
```

This will set the stripe pattern for `/beegfs/global0/path/to/mydir/` to a chunk size of 1 MiB
distributed over 16 storage targets.

Find files located on certain server or targets. The following command searches all files that are
stored on the storage targets with id 4 or 30 and my-workspace directory.

```console
marie@login$ beegfs-ctl --find /beegfs/global0/my-workspace/ --targetid=4 --targetid=30 --mount=/beegfs/global0
```

## Network

View the network addresses of the filesystem servers.

```console
marie@login$ beegfs-ctl --listnodes --nodetype=meta --nicdetails --mount=/beegfs/global0
marie@login$ beegfs-ctl --listnodes --nodetype=storage --nicdetails --mount=/beegfs/global0
marie@login$ beegfs-ctl --listnodes --nodetype=client --nicdetails --mount=/beegfs/global0
```

Display connections the client is actually using

```console
marie@login$ beegfs-net
```

Display possible connectivity of the services

```console
marie@login$ beegfs-check-servers -p /beegfs/global0
```
