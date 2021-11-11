# Score-P

The Score-P measurement infrastructure is a highly scalable and easy-to-use tool suite for
profiling, event tracing, and online analysis of HPC applications. Currently, it works with the
analysis tools Vampir, Scalasca, and Tau. Score-P supports lots of features e.g.

* MPI, SHMEM, OpenMP, Pthreads, and hybrid programs
* Manual source code instrumentation
* Monitoring of CUDA, OpenCL, and OpenACC applications
* Recording hardware counter by using PAPI library
* Function filtering and grouping

Only the basic usage is shown in this Wiki. For a comprehensive Score-P user manual refer to the
[Score-P website](https://score-p.org/).

Before using Score-P, set up the correct environment with

```console
marie@login$ module load Score-P
```

To make measurements with Score-P, the user's application program needs to be instrumented, i.e., at
specific important points ("events") Score-P measurement calls have to be activated. By default,
Score-P handles this automatically. In order to enable instrumentation of function calls, MPI as
well as OpenMP events, the user only needs to prepend the Score-P wrapper to the usual compile and
link commands. The following sections show some examples depending on the parallelization type of
the program.

## Serial Programs

Original:

```console
marie@login$ ifort a.f90 b.f90 -o myprog
```

With instrumentation:

```console
marie@login$ scorep ifort a.f90 b.f90 -o myprog
```

This will instrument user functions (if supported by the compiler) and link the Score-P library.

## MPI Parallel Programs

If your MPI implementation uses MPI compilers, Score-P will detect MPI parallelization
automatically:

Original:

```console
marie@login$ mpicc hello.c -o hello
```

With instrumentation:

```console
marie@login$ scorep mpicc hello.c -o hello
```

MPI implementations without own compilers require the user to link the MPI library
manually. Even in this case, Score-P will detect MPI parallelization automatically:

Original:

```console
marie@login$ icc hello.c -o hello -lmpi
```

With instrumentation:

```console
marie@login$ scorep icc hello.c -o hello -lmpi
```

However, if Score-P fails to detect MPI parallelization automatically you can manually select MPI
instrumentation:

Original:

```console
marie@login$ icc hello.c -o hello -lmpi
```

With instrumentation:

```console
marie@login$ scorep --mpp=mpi icc hello.c -o hello -lmpi
```

If you want to instrument MPI events only (creates less overhead and smaller trace files) use the
option `--nocompiler` to disable automatic instrumentation of user functions.

## OpenMP Parallel Programs

When Score-P detects OpenMP flags on the command line, OPARI2 is invoked for automatic source code
instrumentation of OpenMP events:

Original:

```console
marie@login$ ifort -openmp pi.f -o pi
```

With instrumentation:

```console
marie@login$ scorep ifort -openmp pi.f -o pi
```

## Hybrid MPI/OpenMP Parallel Programs

With a combination of the above mentioned approaches, hybrid applications can be instrumented:

Original:

```console
marie@login$ mpif90 -openmp hybrid.F90 -o hybrid
```

With instrumentation:

```console
marie@login$ scorep mpif90 -openmp hybrid.F90 -o hybrid
```

## Score-P Instrumenter Option Overview

| Type of instrumentation | Instrumenter switch | Default value | Runtime measurement control |
| --- | --- | --- | --- |
| MPI | `--mpp=mpi` | (auto) | (see Sec. Selection of MPI Groups ) |
| SHMEM | `--mpp=shmem` | (auto) | - |
| OpenMP | `--thread=omp` | (auto) | - |
| Pthread | `--thread=pthread` | (auto) | - |
| Compiler (see Sec. Automatic Compiler Instrumentation ) | `--compiler/--nocompiler` | enabled | Filtering (see Sec. Filtering ) |
| PDT instrumentation (see Sec. Source-Code Instrumentation Using PDT ) | `--pdt/--nopdt` | disabled | Filtering (see Sec. Filtering)|
| POMP2 user regions (see Sec. Semi-Automatic Instrumentation of POMP2 User Regions ) | `--pomp/--nopomp` | depends on OpenMP usage | Filtering (see Sec. Filtering ) |
| Manual (see Sec. Manual Region Instrumentation ) | `--user/--nouser` | disabled | Filtering (see Sec. Filtering ) and selective recording (see Sec. Selective Recording ) |

## Application Measurement

After the application run, you will find an experiment directory in your current working directory,
which contains all recorded data.  In general, you can record a profile and/or a event trace.
Whether a profile and/or a trace is recorded, is specified by the environment variables
`SCOREP_ENABLE_PROFILING` and `SCOREP_ENABLE_TRACING` (see
[official Score-P documentation](https://perftools.pages.jsc.fz-juelich.de/cicd/scorep/tags/latest/html/measurement.html)).
If the value of this variables is zero or false, profiling/tracing is disabled. Otherwise Score-P
will record a profile and/or trace. By default, profiling is enabled and tracing is disabled. For
more information please see the list of Score-P measurement
[configuration variables](https://perftools.pages.jsc.fz-juelich.de/cicd/scorep/tags/latest/html/scorepmeasurementconfig.html).

You may start with a profiling run, because of its lower space requirements. According to profiling
results, you may configure the trace buffer limits, filtering or selective recording for recording
traces.  Score-P allows to configure several parameters via environment variables. After the
measurement run you can find a `scorep.cfg` file in your experiment directory which contains the
configuration of the measurement run. If you had not set configuration values explicitly, the file
will contain the default values.
