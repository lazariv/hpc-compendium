# SGI UV2000 / Venus

!!! warning

    **This page is deprecated! The SGI UV2000 (Venus) is a former system!**

## System

The SGI UV2000 is a shared memory system based on Intel Sandy Bridge processors. It is operated by
the Linux operating system SLES 11 SP 3 with a kernel version 3.x.

| Component                  | Count |
|----------------------------|-------|
| Number of CPU sockets      | 64    |
| Physical cores per sockets | 8     |
| Total number of cores      | 512   |
| Total memory               | 8 TiB |

From our experience, most parallel applications benefit from using the additional hardware
hyperthreads.

### Filesystems

Venus uses the same `home` filesystem as all our other HPC installations.
For computations, please use `/scratch`.

## Usage

### Login to the System

Login to the system is available via ssh at `venus.hrsk.tu-dresden.de`.

The RSA fingerprints of the Phase 2 Login nodes are:

```Bash
MD5:63:65:c6:d6:4e:5e:03:9e:07:9e:70:d1:bc:b4:94:64
```

and

```Bash
SHA256:Qq1OrgSCTzgziKoop3a/pyVcypxRfPcZT7oUQ3V7E0E
```

### MPI

The installation of the Message Passing Interface on Venus (SGI MPT) supports the MPI 2.2 standard
(see `man mpi` ). There is no command like `mpicc`, instead you just have to use the "serial"
compiler (e.g. `icc`, `icpc`, or `ifort`) and append `-lmpi` to the linker command line.

Example:

```console
% icc -o myprog -g -O2 -xHost myprog.c -lmpi
```

Notes:

- C++ programmers: You need to link with both libraries:
  `-lmpi++ -lmpi`.
- Fortran programmers: The MPI module is only provided for the Intel
  compiler and does not work with `gfortran`.

Please follow the following guidelines to run your parallel program using the batch system on Venus.

### Batch System

Applications on an HPC system can not be run on the login node. They have to be submitted to compute
nodes with dedicated resources for the user's job. Normally a job can be submitted with these data:

- number of CPU cores,
- requested CPU cores have to belong on one node (OpenMP programs) or
  can distributed (MPI),
- memory per process,
- maximum wall clock time (after reaching this limit the process is
  killed automatically),
- files for redirection of output and error messages,
- executable and command line parameters.

The batch system on Venus is Slurm. Please see
[general information on Slurm](../jobs_and_resources/slurm.md).

#### Submission of Parallel Jobs

The MPI library running on the UV is provided by SGI and highly optimized for the ccNUMA
architecture of this machine.

On Venus, you can only submit jobs with a core number which is a multiple of 8 (a whole CPU chip and
128 GB RAM). Parallel jobs can be started like this:

```Bash
srun -n 16 a.out
```

**Please note:** There are different MPI libraries on Venus than on other ZIH systems,
so you have to compile the binaries specifically for their target.

#### Filesystems

- The large main memory on the system allows users to create RAM disks
  within their own jobs.
