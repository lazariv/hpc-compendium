# Migration to Atlas

 Atlas is a different machine than
Deimos, please have a look at the table:

|                                                   |            |           |
|---------------------------------------------------|------------|-----------|
|                                                   | **Deimos** | **Atlas** |
| **number of hosts**                               | 584        | 92        |
| **cores per host**                                | 2...8      | 64        |
| **memory \[GB\] per host**                        | 8...64     | 64..512   |
| **example benchmark: SciMark (higher is better)** | 655        | 584       |

A single thread on Atlas runs with a very poor performance in comparison
with the 6 year old Deimos. The reason for this is that the AMD CPU
codenamed "Bulldozer" is designed for multi-threaded use.

## Modules

We have grouped the module definitions for a better overview. This is
only for displaying the available modules, not for loading a module. All
available modules can be made visible with `module load ALL; module av`
. For more details, please see [module
groups.](RuntimeEnvironment#Module_Groups)

#BatchSystem

## Batch System

Although we are running LSF as batch system there are certain
differences to the older versions known from Deimos and Mars.

The most important changes are:

-   Specify maximum runtime instead of a queue (`-W <hh:mm>`).
-   Specify needed memory (per process in MByte) with
    `-M <memory per process in MByte>`, the default is 300 MB, e.g.
    `-M 2000`.

|                       |        |                                                      |
|-----------------------|--------|------------------------------------------------------|
| Hosts on Atlas        | number | per process/core user memory limit in MB (-M option) |
| nodes with 64 GB RAM  | 48     | 940                                                  |
| nodes with 128 GB RAM | 24     | 1950                                                 |
| nodes with 256 GB RAM | 12     | 4000                                                 |
| nodes with 512 GB RAM | 8      | 8050                                                 |

-   Jobs with a job runtime greater than 72 hours (jobs that will run in
    the queue `long`) will be collected over the day and scheduled in a
    time window in accordance with their priority.
-   Interactive Jobs with X11 tunneling need an additional option `-XF`
    to work (`bsub -Is -XF -n <N> -W <hh:mm> -M <MEM> bash`).
-   The load of the system can be seen with `lsfview` and `lsfnodestat`.

Atlas is designed as a high-throughput machine. With the large compute
nodes you have to be more precise in your resource requests.

-   In ninety nine percent of the cases it is enough when you specify
    your processor requirements with `-n <n>` and your memory
    requirements with `-M <memory per process in MByte>`.
-   Please use \<span class="WYSIWYG_TT">-x\</span>("exclusive use of a
    hosts") only with care and when you really need it.
    -   The option `-x` in combination with `-n 1` leads to an
        "efficiency" of only 1.5% - in contrast with 50% on the single
        socket nodes at Deimos.
    -   You will be charged for the whole blocked host(s) within your
        CPU hours budget.
    -   Don't use `-x` for memory reasons, please use `-M` instead.
-   Please use `-M <memory per process in MByte>` to specify your memory
    requirements per process.
-   Please don't use `-R "span[hosts=1]"` or `-R "span[ptile=<n>]"` or
    any other \<span class="WYSIWYG_TT">-R "..."\</span>option, the
    batch system is smart enough to select the best hosts in accordance
    with your processor and memory requirements.
    -   Jobs with a processor requirement ≤ 64 will always be scheduled
        on one node.
    -   Larger jobs will use just as many hosts as needed, e.g. 160
        processes will be scheduled on three hosts.

For more details, please see the pages on [LSF](PlatformLSF).

## Software

Depending on the applications we have seen a broad variety of different
performances running binaries from Deimos on Atlas. Some can run without
touching, with others we have seen significant degradations so that a
re-compile made sense.

### Applications

As a default, all applications provided by ZIH should run an atlas
without problems. Please [tell us](mailto:hpcsupport@zih.tu-dresden.de)
if you are missing your application or experience severe performance
degradation. Please include "Atlas" in your subject.

### Development

From the benchmarking point of view, the best compiler for the AMD
Bulldozer processor, the best compiler comes from the Open64 suite. For
convenience, other compilers are installed, Intel 12.1 shows good
results as well. Please check the best compiler flags at [this
overview](http://developer.amd.com/Assets/CompilerOptQuickRef-62004200.pdf).
For best performance, please use [ACML](Libraries#ACML) as BLAS/LAPACK
library.

### MPI parallel applications

Please note the more convenient syntax on Atlas. Therefore, please use a
command like

    bsub -W 2:00 -M 200 -n 8 mpirun a.out

to submit your MPI parallel applications.

-   Set DENYTOPICVIEW = WikiGuest
