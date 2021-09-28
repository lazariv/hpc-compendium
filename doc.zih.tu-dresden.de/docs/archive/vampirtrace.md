# VampirTrace

!!! warning

    As of 2014 VampirTrace is discontinued. This site only serves an archival purpose. The official
    successor is the new Scalable Performance Measurement Infrastructure
    [Score-P](../software/scorep.md).

VampirTrace is a performance monitoring tool, that produces tracefiles during a program run. These
tracefiles can be analyzed and visualized by the tool [Vampir](../software/vampir.md). VampirTrace
supports lots of features e.g.

- MPI, OpenMP, Pthreads, and hybrid programs
- Manual source code instrumentation
- Recording hardware counter by using PAPI library
- Memory allocation tracing
- I/O tracing
- Function filtering and grouping

Only the basic usage is shown in this Wiki. For a comprehensive
VampirTrace user manual refer to the
[VampirTrace Website](http://www.tu-dresden.de/zih/vampirtrace).

Before using VampirTrace, set up the correct environment with

```console
module load vampirtrace
```

To make measurements with VampirTrace, the user's application program needs to be instrumented,
i.e., at specific important points (*events*) VampirTrace measurement calls have to be activated. By
default, VampirTrace handles this automatically. In order to enable instrumentation of function
calls, MPI as well as OpenMP events, the user only needs to replace the compiler and linker commands
with VampirTrace's wrappers. Following wrappers exist:

| Programming Language | VampirTrace Wrapper Command |
|----------------------|-----------------------------|
| C                    | `vtcc`                      |
| C++                  | `vtcxx`                     |
| Fortran 77           | `vtf77`                     |
| Fortran 90           | `vtf90`                     |

The following sections show some examples depending on the parallelization type of the program.

## Serial Programs

Compiling serial code is the default behavior of the wrappers. Simply replace the compiler by
VampirTrace's wrapper:

|                      |                               |
|----------------------|-------------------------------|
| original             | `ifort a.f90 b.f90 -o myprog` |
| with instrumentation | `vtf90 a.f90 b.f90 -o myprog` |

This will instrument user functions (if supported by compiler) and link the VampirTrace library.

## MPI Parallel Programs

If your MPI implementation uses MPI compilers (this is the case on [Deimos](system_deimos.md)), you
need to tell VampirTrace's wrapper to use this compiler instead of the serial one:

|                      |                                      |
|----------------------|--------------------------------------|
| original             | `mpicc hello.c -o hello`             |
| with instrumentation | `vtcc -vt:cc mpicc hello.c -o hello` |

MPI implementations without own compilers (as on the [Altix](system_altix.md) require the user to
link the MPI library manually. In this case, you simply replace the compiler by VampirTrace's
compiler wrapper:

|                      |                               |
|----------------------|-------------------------------|
| original             | `icc hello.c -o hello -lmpi`  |
| with instrumentation | `vtcc hello.c -o hello -lmpi` |

If you want to instrument MPI events only (creates smaller trace files and less overhead) use the
option `-vt:inst manual` to disable automatic instrumentation of user functions.

## OpenMP Parallel Programs

When VampirTrace detects OpenMP flags on the command line, OPARI is invoked for automatic source
code instrumentation of OpenMP events:

|                      |                            |
|----------------------|----------------------------|
| original             | `ifort -openmp pi.f -o pi` |
| with instrumentation | `vtf77 -openmp pi.f -o pi` |

## Hybrid MPI/OpenMP Parallel Programs

With a combination of the above mentioned approaches, hybrid applications can be instrumented:

|                      |                                                     |
|----------------------|-----------------------------------------------------|
| original             | `mpif90 -openmp hybrid.F90 -o hybrid`               |
| with instrumentation | `vtf90 -vt:f90 mpif90 -openmp hybrid.F90 -o hybrid` |

By default, running a VampirTrace instrumented application should result in a tracefile in the
current working directory where the application was executed.
