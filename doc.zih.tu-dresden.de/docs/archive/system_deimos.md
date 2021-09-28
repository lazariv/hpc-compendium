# Linux Networx PC-Farm Deimos

!!! warning

    **This page is deprecated! Deimos is a former system!**

The PC farm `Deimos` is a heterogeneous cluster based on dual core AMD Opteron CPUs. The nodes are
operated by the Linux operating system SuSE SLES 10 with a 2.6 kernel. Currently, the following
hardware is installed:

| Component | Count |
|-----------|-------|
|CPUs |AMD Opteron X85 dual core |
|RAM per core |2 GB |
|Number of cores |2584 |
|total peak performance |13.4 TFLOPS |
|single chip nodes |384 |
|dual nodes |230 |
|quad nodes |88 |
|quad nodes (32 GB RAM) |24 |

All nodes share a 68 TB on DDN hardware. Each node has per core 40 GB local disk space for scratch
mounted on `/tmp`. The jobs for the compute nodes are scheduled by the
[Platform LSF](platform_lsf.md)
batch system from the login nodes `deimos.hrsk.tu-dresden.de` .

Two separate Infiniband networks (10 Gb/s) with low cascading switches provide the communication and
I/O infrastructure for low latency / high throughput data traffic. An additional gigabit Ethernet
network is used for control and service purposes.

Users with a login on the [SGI Altix](system_altix.md) can access their home directory via NFS
below the mount point `/hpc_work`.

## CPU

The cluster is based on dual-core AMD Opteron X85 processor. One core has the following basic
properties:

| Component | Count |
|-----------|-------|
|clock rate |2.6 GHz |
|floating point units |2 |
|peak performance |5.2 GFLOPS |
|L1 cache |2x64 kB |
|L2 cache |1 MB |
|memory bus |128 bit x 200 MHz |

The CPU belongs to the x86_64 family. Since it is fully capable of running x86-code, one should
compare the performances of the 32 and 64 bit versions of the same code.
