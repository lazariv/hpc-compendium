

# HPC Component SGI Altix

The SGI Altix 4700 is a shared memory system with dual core Intel
Itanium 2 CPUs (Montecito) operated by the Linux operating system SuSE
SLES 10 with a 2.6 kernel. Currently, the following Altix partitions are
installed at ZIH:

\|\*Name \*\|\*Total Cores \*\|**Compute Cores**\|**Memory per Core**\|
\| Mars \|384 \|348 \|1 GB\| \|Jupiter \|512 \|506 \|4 GB\| \|Saturn
\|512 \|506 \|4 GB\| \|Uranus \|512 \|506 \|4 GB\| \|Neptun \|128 \|128
\|1 GB\|

\<P> The jobs for these partitions (except \<TT>Neptun\</TT>) are
scheduled by the [Platform LSF](Platform LSF) batch system running on
`mars.hrsk.tu-dresden.de`. The actual placement of a submitted job may
depend on factors like memory size, number of processors, time limit.

## Filesystems All partitions share the same CXFS filesystems `/work` and `/fastfs`. ... [more information](FileSystems)

## ccNuma Architecture

The SGI Altix has a ccNUMA architecture, which stands for Cache Coherent
Non-Uniform Memory Access. It can be considered as a SM-MIMD (*shared
memory - multiple instruction multiple data*) machine. The SGI ccNuma
system has the following properties:

-   Memory is physically distributed but logically shared
-   Memory is kept coherent automatically by hardware.
-   Coherent memory: memory is always valid (caches hold copies)
-   Granularity is L3 cacheline (128 B)
-   Bandwidth of NumaLink4 is 6.4 GB/s

The ccNuma is a compromise between a distributed memory system and a
flat symmetric multi processing machine (SMP). Altough the memory is
shared, the access properties are not the same.

## Compute Module

The basic compute module of an Altix system is shown below.

|                                                                                                                                                               |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| \<img src="%ATTACHURLPATH%/altix_brick_web.png" alt="altix_brick_web.png" width='312' height='192' />\<CAPTION ALIGN="BOTTOM">Altix compute blade \</CAPTION> |

It consists of one dual core Intel Itanium 2 "Montecito" processor, the
local memory of 4 GB (2 GB on `Mars`), and the communication component,
the so-called SHUB. All resources are shared by both cores. They have a
common front side bus, so that accumulated memory bandwidth for both is
not higher than for just one core.

The SHUB connects local and remote ressources. Via the SHUB and NUMAlink
all CPUs can access remote memory in the whole system. Naturally, the
fastest access provides local memory. There are some hints and commands
that may help you to get optimal memory allocation and process placement
). Four of these blades are grouped together with a NUMA router in a
compute brick. All bricks are connected with NUMAlink4 in a
"fat-tree"-topology.

|                                                                                                                                                                              |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| \<img src="%ATTACHURLPATH%/memory_access_web.png" alt="memory_access_web.png" width='450' />\<CAPTION align="bottom">Remote memory access via SHUBs and NUMAlink \</CAPTION> |

## CPU

The current SGI Altix is based on the dual core Intel Itanium 2
processor (codename "Montecito"). One core has the following basic
properties:

|                                     |                            |
|-------------------------------------|----------------------------|
| clock rate                          | 1.6 GHz                    |
| integer units                       | 6                          |
| floating point units (multiply-add) | 2                          |
| peak performance                    | 6.4 GFLOPS                 |
| L1 cache                            | 2 x 16 kB, 1 clock latency |
| L2 cache                            | 256 kB, 5 clock latency    |
| L3 cache                            | 9 MB, 12 clock latency     |
| front side bus                      | 128 bit x 200 MHz          |

The theoretical peak performance of all Altix partitions is hence about
13.1 TFLOPS.

The processor has hardware support for efficient software pipelining.
For many scientific applications it provides a high sustained
performance exceeding the performance of RISC CPUs with similar peak
performance. On the down side is the fact that the compiler has to
explicitely discover and exploit the parallelism in the application.

<span class="twiki-macro COMMENT"></span>
