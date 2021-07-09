# Debuggers

This section describes how to start the debuggers on the HPC systems of
ZIH.

Detailed i nformation about how to use the debuggers can be found on the
website of the debuggers (see below).

## Overview of available Debuggers

|--------------------|-----------------------------------|--|
|                    | **GNU Debugger** | **DDT**  |
| Interface          | command line   | graphical user interface |
| Languages          | C, C++, Fortran| C, C++, Fortran, F95 |
| Parallel Debugging | Threads        | Threads, MPI, hybrid |
| Debugger Backend   | GDB            | |
| Licenses at ZIH    | free           | 1024 |

## General Advices

-   You need to compile your code with the flag `-g` to enable
    debugging. This tells the compiler to include information about
    variable and function names, source code lines etc. into the
    executable.
-   It is also recommendable to reduce or even disable optimizations
    (`-O0`). At least inlining should be disabled (usually
    `-fno-inline`)
-   For parallel applications: try to reconstruct the problem with less
    processes before using a parallel debugger.
-   The flag `-traceback` of the Intel Fortran compiler causes to print
    stack trace and source code location when the program terminates
    abnormally.
-   If your program crashes and you get an address of the failing
    instruction, you can get the source code line with the command
    `addr2line -e <executable> <address>`
-   Use the compiler's check capabilites to find typical problems at
    compile time or run time
    -   Read manual (`man gcc`, `man ifort`, etc.)
    -   Intel C compile time checks:
        `-Wall -Wp64 -Wuninitialized -strict-ansi`
    -   Intel Fortran compile time checks: `-warn all -std95`
    -   Intel Fortran run time checks: `-C -fpe0 -traceback`
-   Use **TODO: memory debuggers - Compendium.Debuggers, Memory_Debugging** to
    verify the proper usage of memory.
-   Core dumps are useful when your program crashes after a long
    runtime.
-   More hints: **TODO: Slides about typical Bugs in parallel
    Programs - typical_bugs.pdf**

## GNU Debugger

The GNU Debugger (GDB) offers only limited to no support for parallel
applications and Fortran 90. However, it might be the debugger you are
most used to. GDB works best for serial programs. You can start GDB in
several ways:

|                               |                                |
|-------------------------------|--------------------------------|
|                               | Command                        |
| Run program under GDB         | `gdb <executable>`             |
| Attach running program to GDB | `gdb --pid <process ID>`       |
| Open a core dump              | `gdb <executable> <core file>` |

This [GDB Reference
Sheet](http://users.ece.utexas.edu/~adnan/gdb-refcard.pdf) makes life
easier when you often use GDB.

Fortran 90 programmers which like to use the GDB should issue an
`module load ddt` before their debug session. This makes the GDB
modified by DDT available, which has better support for Fortran 90 (e.g.
derived types).

## DDT

noch **TODO: ddt.png title=DDT Main Window**

-   Commercial tool of Arm shipped as "Forge" together with MAP profiler
-   Intuitive graphical user interface
-   Great support for parallel applications
-   We have 1024 licences, so many user can use this tool for parallel
    debugging
-   Don't expect that debugging an MPI program with 100ths of process
    will work without problems
    -   The more processes and nodes involved, the higher is the
        probability for timeouts or other problems
    -   Debug with as few processes as required to reproduce the bug you
        want to find
-   Module to load before using: `module load ddt`
-   Start: `ddt <executable>`
-   If you experience problems in DDTs configuration when changing the
    HPC system, you should issue `rm -r ~/.ddt.`
-   More Info
    -   **TODO** Slides about basic DDT usage: parallel_debugging_ddt.pdf
    -   [Official Userguide](https://developer.arm.com/docs/101136/latest/ddt)

### Serial Program Example (Taurus, Venus)

```Bash
    % module load ddt
    % salloc --x11 -n 1 --time=2:00:00
    salloc: Granted job allocation 123456
    % ddt ./myprog
```

-   uncheck MPI, uncheck OpenMP
-   hit *Run*.

### Multithreaded Program Example (Taurus, Venus)

```Bash
    % module load ddt
    % salloc --x11 -n 1 --cpus-per-task=<number of threads> --time=2:00:00
    salloc: Granted job allocation 123456
    % srun --x11=first ddt ./myprog
```

-   uncheck MPI
-   select OpenMP, set number of threads (if OpenMP)
-   hit *Run*

### MPI-Parallel Program Example (Taurus, Venus)

```Bash
    % module load ddt
    % module load bullxmpi  # Taurus only
    % salloc --x11 -n <number of processes> --time=2:00:00
    salloc: Granted job allocation 123456
    % ddt -np <number of processes> ./myprog
```

-   select MPI
-   set the MPI implementation to "SLURM (generic)"
-   set number of processes
-   hit *Run*

## Memory Debugging

-   Memory debuggers find memory management bugs, e.g.
    -   Use of non-initialized memory
    -   Access memory out of allocated bounds
-   Very valuable tools to find bugs
-   DDT and Totalview have memory debugging included (needs to be
    enabled before run)

### Valgrind

-   <http://www.valgrind.org>
-   Simulation of the program run in a virtual machine which accurately
    observes memory operations
-   Extreme run time slow-down
    -   Use small program runs
-   Sees more memory errors than the other debuggers
-   Not available on mars

<!-- -->

-   for serial programs:

```Bash
    % module load Valgrind
    % valgrind ./myprog
``` 

-   for MPI parallel programs (every rank writes own valgrind logfile):

```Bash
    % module load Valgrind
    % mpirun -np 4 valgrind --log-file=valgrind.%p.out ./myprog
```
