# SGI UV2000 (venus)

The SGI UV2000 is a shared memory system based on Intel Sandy Bridge
processors. It is operated by the Linux operating system SLES 11 SP 3
with a kernel version 3.x.

|                            |       |
|----------------------------|-------|
| Number of CPU sockets      | 64    |
| Physical cores per sockets | 8     |
| Total number of cores      | 512   |
| Total memory               | 8 TiB |

From our experience, most parallel applications benefit from using the
additional hardware hyperthreads.

## Filesystems

Venus uses the same HOME file system as all our other HPC installations.
For computations, please use `/scratch`.

... [More information on file systems](FileSystems)
