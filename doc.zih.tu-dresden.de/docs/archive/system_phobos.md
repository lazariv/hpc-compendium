# Linux Networx PC-Cluster Phobos

!!! warning

    **This page is deprecated! Phobos is a former system which was shut down on 1 November 2010.**

`Phobos` is a cluster based on AMD Opteron CPUs. The nodes are operated
by the Linux operating system SuSE SLES 9 with a 2.6 kernel. Currently,
the following hardware is installed:

| Component | Count |
|-----------|-------|
|CPUs |AMD Opteron 248 (single core) |
|total peak performance |563.2 GFLOPS |
|Number of nodes |64 compute + 1 master |
|CPUs per node |2 |
|RAM per node |4 GB |

All nodes share a 4.4 TB SAN. Each node has additional local disk space mounted on `/scratch`. The
jobs for the compute nodes are scheduled by a [Platform LSF](platform_lsf.md) batch system running on
the login node `phobos.hrsk.tu-dresden.de`.

Two separate Infiniband networks (10 Gb/s) with low cascading switches provide the infrastructure
for low latency / high throughput data traffic. An additional GB/Ethernetwork is used for control
and service purposes.

## CPU

`Phobos` is based on single-core AMD Opteron 248 processor. It has the
following basic properties:

| Component | Count |
|-----------|-------|
|clock rate |2.2 GHz |
|floating point units |2 |
|peak performance |4.4 GFLOPS |
|L1 cache |2x64 kB |
|L2 cache |1 MB |
|memory bus |128 bit x 200 MHz |

The CPU belongs to the x86_64 family. Although it is fully capable of running x86-code, one should
always try to use 64-bit programs due to their potentially higher performance.
