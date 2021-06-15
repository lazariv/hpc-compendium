# Score-P

The Score-P measurement infrastructure is a highly scalable and
easy-to-use tool suite for profiling, event tracing, and online analysis
of HPC applications.\<br />Currently, it works with the analysis tools
[Vampir](Vampir), Scalasca, Periscope, and Tau.\<br />Score-P supports
lots of features e.g.

-   MPI, SHMEM, OpenMP, pthreads, and hybrid programs
-   Manual source code instrumentation
-   Monitoring of CUDA applications
-   Recording hardware counter by using PAPI library
-   Function filtering and grouping

Only the basic usage is shown in this Wiki. For a comprehensive Score-P
user manual refer to the [Score-P website](http://www.score-p.org).

Before using Score-P, set up the correct environment with

    module load scorep

To make measurements with Score-P, the user's application program needs
to be instrumented, i.e., at specific important points (\`\`events'')
Score-P measurement calls have to be activated. By default, Score-P
handles this automatically. In order to enable instrumentation of
function calls, MPI as well as OpenMP events, the user only needs to
prepend the Score-P wrapper to the usual compiler and linker commands.
Following wrappers exist:

The following sections show some examples depending on the
parallelization type of the program.

## Serial programs

|                      |                                    |
|----------------------|------------------------------------|
| original             | ifort a.f90 b.f90 -o myprog        |
| with instrumentation | scorep ifort a.f90 b.f90 -o myprog |

This will instrument user functions (if supported by the compiler) and
link the Score-P library.

## MPI parallel programs

If your MPI implementation uses MPI compilers, Score-P will detect MPI
parallelization automatically:

|                      |                               |
|----------------------|-------------------------------|
| original             | mpicc hello.c -o hello        |
| with instrumentation | scorep mpicc hello.c -o hello |

MPI implementations without own compilers (as on the Altix) require the
user to link the MPI library manually. Even in this case, Score-P will
detect MPI parallelization automatically:

|                      |                                   |
|----------------------|-----------------------------------|
| original             | icc hello.c -o hello -lmpi        |
| with instrumentation | scorep icc hello.c -o hello -lmpi |

However, if Score-P falis to detect MPI parallelization automatically
you can manually select MPI instrumentation:

|                      |                                             |
|----------------------|---------------------------------------------|
| original             | icc hello.c -o hello -lmpi                  |
| with instrumentation | scorep --mpp=mpi icc hello.c -o hello -lmpi |

If you want to instrument MPI events only (creates less overhead and
smaller trace files) use the option --nocompiler to disable automatic
instrumentation of user functions.

## OpenMP parallel programs

When Score-P detects OpenMP flags on the command line, OPARI2 is invoked
for automatic source code instrumentation of OpenMP events:

|                      |                                 |
|----------------------|---------------------------------|
| original             | ifort -openmp pi.f -o pi        |
| with instrumentation | scorep ifort -openmp pi.f -o pi |

## Hybrid MPI/OpenMP parallel programs

With a combination of the above mentioned approaches, hybrid
applications can be instrumented:

|                      |                                            |
|----------------------|--------------------------------------------|
| original             | mpif90 -openmp hybrid.F90 -o hybrid        |
| with instrumentation | scorep mpif90 -openmp hybrid.F90 -o hybrid |

## Score-P instrumenter option overview

|                                                                               Type of instrumentation                                                                               |   Instrumenter switch   |      Default value      |                                                                                                                            Runtime measurement control                                                                                                                            |
|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:-----------------------:|:-----------------------:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
|                                                                                         MPI                                                                                         |        --mpp=mpi        |         (auto)          |                                                                               (see Sec. [Selection of MPI Groups](https://silc.zih.tu-dresden.de/scorep-current/html/measurement.html#mpi_groups) )                                                                               |
|                                                                                        SHMEM                                                                                        |       --mpp=shmem       |         (auto)          |                                                                                                                                                                                                                                                                                   |
|                                                                                       OpenMP                                                                                        |      --thread=omp       |         (auto)          |                                                                                                                                                                                                                                                                                   |
|                                                                                       Pthread                                                                                       |    --thread=pthread     |         (auto)          |                                                                                                                                                                                                                                                                                   |
|             Compiler (see Sec. [Automatic Compiler Instrumentation](https://silc.zih.tu-dresden.de/scorep-current/html/instrumentation.html#compiler_instrumentation) )             | --compiler/--nocompiler |         enabled         |                                                                                 Filtering (see Sec. [Filtering](https://silc.zih.tu-dresden.de/scorep-current/html/measurement.html#filtering) )                                                                                  |
|        PDT instrumentation (see Sec. [Source-Code Instrumentation Using PDT](https://silc.zih.tu-dresden.de/scorep-current/html/instrumentation.html#tau_instrumentation) )         |      --pdt/--nopdt      |        disabled         |                                                                                 Filtering (see Sec. [Filtering](https://silc.zih.tu-dresden.de/scorep-current/html/measurement.html#filtering) )                                                                                  |
| POMP2 user regions (see Sec. [Semi-Automatic Instrumentation of POMP2 User Regions](https://silc.zih.tu-dresden.de/scorep-current/html/instrumentation.html#pomp_instrumentation) ) |     --pomp/--nopomp     | depends on OpenMP usage |                                                                                 Filtering (see Sec. [Filtering](https://silc.zih.tu-dresden.de/scorep-current/html/measurement.html#filtering) )                                                                                  |
|                 Manual (see Sec. [Manual Region Instrumentation](https://silc.zih.tu-dresden.de/scorep-current/html/instrumentation.html#manual_instrumentation) )                  |     --user/--nouser     |        disabled         | Filtering (see Sec. [Filtering](https://silc.zih.tu-dresden.de/scorep-current/html/measurement.html#filtering) )\<br /> and\<br /> selective recording (see Sec. [Selective Recording](https://silc.zih.tu-dresden.de/scorep-current/html/measurement.html#selective_recording) ) |

## Application Measurement

After the application run, you will find an experiment directory in your
current working directory, which contains all recorded data.

In general, you can record a profile and/or a event trace. Whether a
profile and/or a trace is recorded, is specified by the environment
variables \<span>
`[[https://silc.zih.tu-dresden.de/scorep-current/html/scorepmeasurementconfig.html#SCOREP_ENABLE_PROFILING][SCOREP_ENABLE_PROFILING]]`
\</span> and \<span>
`[[https://silc.zih.tu-dresden.de/scorep-current/html/scorepmeasurementconfig.html#SCOREP_ENABLE_TRACING][SCOREP_ENABLE_TRACING]]`
\</span>. If the value of this variables is zero or false,
profiling/tracing is disabled. Otherwise Score-P will record a profile
and/or trace. By default, profiling is enabled and tracing is disabled.
For more information please see [the list of Score-P measurement
configuration
variables](https://silc.zih.tu-dresden.de/scorep-current/html/scorepmeasurementconfig.html).

You may start with a profiling run, because of its lower space
requirements. According to profiling results, you may configure the
trace buffer limits, filtering or selective recording for recording
traces.

Score-P allows to configure several parameters via environment
variables. After the measurement run you can find a \<span>scorep.cfg
\</span>file in your experiment directory which contains the
configuration of the measurement run. If you had not set configuration
values explicitly, the file will contain the default values.

-- Main.RonnyTschueter - 2014-09-11
