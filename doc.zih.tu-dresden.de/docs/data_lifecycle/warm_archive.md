# Warm Archive

The warm archive is intended as a storage space for the duration of a running HPC project.
It does **not** substitute a long-term archive, though.

This storage is best suited for large files (like `tgz`s of input data data or intermediate results).

The hardware consists of 20 storage nodes with a net capacity of 10 PiB on spinning disks.
We have seen an total data rate of 50 GiB/s under benchmark conditions.

A project can apply for storage space in the warm archive.
This is limited in capacity and
duration.

## Access

### As Filesystem

On ZIH systems, users can access the warm archive via [workspaces](workspaces.md)).
Although the lifetime is considerable long, please be aware that the data will be
deleted as soon as the user's login expires.

!!! attention

    These workspaces can **only** be written to from the login or export nodes.
    On all compute nodes, the warm archive is mounted read-only.

### S3

A limited S3 functionality is available.
