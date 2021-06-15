# SGI Altix

**`%RED%This page is deprecated! The SGI Atlix is a former system! [[Compendium.Hardware][(Current hardware)]]%ENDCOLOR%`**

The SGI Altix is shared memory system for large parallel jobs using up
to 2000 cores in parallel ( [information on the
hardware](HardwareAltix)). It's partitions are Mars (login), Jupiter,
Saturn, Uranus, and Neptun (interactive).

## Compiling Parallel Applications

This installation of the Message Passing Interface supports the MPI 1.2
standard with a few MPI-2 features (see `man mpi` ). There is no command
like `mpicc`, instead you just have to use the normal compiler (e.g.
`icc`, `icpc`, or `ifort`) and append `-lmpi` to the linker command
line. Since the include files as well as the library are in standard
directories there is no need to append additional library- or
include-paths.

-   Note for C++ programmers: You need to link with
    `-lmpi++abi1002 -lmpi` instead of `-lmpi`.
-   Note for Fortran programmers: The MPI module is only provided for
    the Intel compiler and does not work with gfortran.

Please follow these following guidelines to run your parallel program
using the batch system on Mars.

## Batch system

Applications on an HPC system can not be run on the login node. They
have to be submitted to compute nodes with dedicated resources for the
user's job. Normally a job can be submitted with these data:

-   number of CPU cores,
-   requested CPU cores have to belong on one node (OpenMP programs) or
    can distributed (MPI),
-   memory per process,
-   maximum wall clock time (after reaching this limit the process is
    killed automatically),
-   files for redirection of output and error messages,
-   executable and command line parameters.

### LSF

The batch sytem on Atlas is LSF. For general information on LSF, please
follow [this link](PlatformLSF).

### Submission of Parallel Jobs

The MPI library running on the Altix is provided by SGI and highly
optimized for the ccNUMA architecture of this machine. However,
communication within a partition is faster than across partitions. Take
this into consideration when you submit your job.

Single-partition jobs can be started like this:

    <span class='WYSIWYG_HIDDENWHITESPACE'>&nbsp;</span>bsub -R "span[hosts=1]" -n 16 mpirun -np 16 a.out<span class='WYSIWYG_HIDDENWHITESPACE'>&nbsp;</span>

Really large jobs with over 256 CPUs might run over multiple partitions.
Cross-partition jobs can be submitted via PAM like this

    <span class='WYSIWYG_HIDDENWHITESPACE'>&nbsp;</span>bsub -n 1024 pamrun a.out<span class='WYSIWYG_HIDDENWHITESPACE'>&nbsp;</span>

### Batch Queues

| Batch Queue    | Admitted Users   | Available CPUs      | Default Runtime | Max. Runtime |
|:---------------|:-----------------|:--------------------|:----------------|:-------------|
| `interactive`  | `all`            | `min. 1, max. 32`   | `12h`           | `12h`        |
| `small`        | `all`            | `min. 1, max. 63`   | `12h`           | `120h`       |
| `intermediate` | `all`            | `min. 64, max. 255` | `12h`           | `120h`       |
| `large`        | `all`            | `min.256, max.1866` | `12h`           | `24h`        |
| `ilr`          | `selected users` | `min. 1, max. 768`  | `12h`           | `24h`        |

-- Main.UlfMarkwardt - 2013-02-27
