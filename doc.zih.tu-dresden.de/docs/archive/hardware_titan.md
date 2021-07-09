# Windows HPC Server 2008 - Cluster Titan

The Dell Blade Server `Titan` is a homogenous cluster based on quad core
Intel Xeon CPUs. The cluster consists of one management and 8 compute
nodes, which are connected via a gigabit Ethernet network. The
connection to the cluster is only available over a terminal server
(titants1.hpcms.zih.tu-dresden.de, 141.30.63.227) via the remote desktop
protocol.

The nodes are operated by the Windows operating system Microsoft HPC
Server 2008. Currently, the following hardware is installed:

\* Compute Node: \|CPUs \|Intel Xeon E5440 Quad-Core \| \|RAM per core
\|2 GB \| \|Number of cores \|64 \| \|total peak performance \|724,48
GFLOPS \|

\* Management Node:

\|CPUs \|Intel Xeon E5410 Quad-Core \| \|RAM per core \|2 GB \| \|Number
of cores \|8 \|

\<P> The management node shares 1.2 TB disk space via NTFS over all
nodes. Each node has a local disk of 120 GB. The jobs for the compute
nodes are scheduled by the Microsoft scheduler, which is a part of the
Microsoft HPC Pack, from the management node. The job submission can be
done via the graphical user interface Microsoft HPC Job Manager.

Two separate gigabit Ethernet networks are available for communication
and I/O infrastructure.

## CPU

The cluster is based on quad core Intel Xeon E5440 processor. One core
has the following basic properties:

\|clock rate \|2.83 GHz \| \|floating point units \|2 \| \|peak
performance \|11.26 GFLOPS \| \|L1 cache \|32 KB I + 32KB on chip per
core \| \|L2 cache \|12 MB I+D on chip per chip, 6MB shared/ 2 cores \|
\|FSB \|1333 MHz \|

The management node is based on a quad core Intel Xeon E5410 processor.
One core has the following basic properties:

\|clock rate \|2.33 GHz \| \|floating point units \|2 \| \|peak
performance \|9.32 GFLOPS \| \|L1 cache \|32 KB I + 32KB on chip per
core \| \|L2 cache \|12 MB I+D on chip per chip, 6MB shared/ 2 cores \|
\|FSB \|1333 MHz \|

The CPU belongs to the x86_64 family. Since it is fully capable of
running x86-code, one should compare the performances of the 32 and 64
bit versions of the same code.
