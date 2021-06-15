

# MEGWARE PC-Farm Atlas

The PC farm `Atlas` is a heterogenous cluster based on multicore chips
AMD Opteron 6274 ("Bulldozer"). The nodes are operated by the Linux
operating system SuSE SLES 11 with a 2.6 kernel. Currently, the
following hardware is installed:

\|CPUs \|AMD Opteron 6274 \| \|number of cores \|5120 \| \|th. peak
performance\| 45 TFlops\| \|compute nodes \| 4-way nodes *Saxonid* with
64 cores\| \|nodes with 64 GB RAM \| 48 \| \|nodes with 128 GB RAM \| 12
\| \|nodes with 512 GB RAM \| 8 \|

\<P>

Mars and Deimos users: Please read the [migration
hints](MigrateToAtlas).

All nodes share the HOME and `/fastfs/` [file system](FileSystems) with
our other HPC systems. Each node has 180 GB local disk space for scratch
mounted on `/tmp` . The jobs for the compute nodes are scheduled by the
[Platform LSF](Platform LSF) batch system from the login nodes
`atlas.hrsk.tu-dresden.de` .

A QDR Infiniband interconnect provides the communication and I/O
infrastructure for low latency / high throughput data traffic.

Users with a login on the [SGI Altix](HardwareAltix) can access their
home directory via NFS below the mount point `/hpc_work`.

## CPU AMD Opteron 6274

\| Clock rate \| 2.2 GHz\| \| cores \| 16 \| \| L1 data cache \| 16 KB
per core \| \| L1 instruction cache \| 64 KB shared in a *module* (i.e.
2 cores) \| \| L2 cache \| 2 MB per module\| \| L3 cache \| 12 MB total,
6 MB shared between 4 modules = 8 cores\| \| FP units \| 1 per module
(supports fused multiply-add)\| \| th. peak performance\| 8.8 GFlops per
core (w/o turbo) \|

The CPU belongs to the x86_64 family. Since it is fully capable of
running x86-code, one should compare the performances of the 32 and 64
bit versions of the same code.

For more architectural details, see the [AMD Bulldozer block
diagram](http://upload.wikimedia.org/wikipedia/commons/e/ec/AMD_Bulldozer_block_diagram_%288_core_CPU%29.PNG)
and [topology of Atlas compute nodes](%ATTACHURL%/Atlas_Knoten.pdf).
