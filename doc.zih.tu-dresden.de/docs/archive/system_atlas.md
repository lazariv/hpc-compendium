# Atlas

**This page is deprecated! Atlas is a former system!**

Atlas is a general purpose HPC cluster for jobs using 1 to 128 cores in parallel
([Information on the hardware](hardware_atlas.md)).

## Compiling Parallel Applications

When loading a compiler module on Atlas, the module for the MPI implementation OpenMPI is also
loaded in most cases. If not, you should explicitly load the OpenMPI module with `module load
openmpi`. This also applies when you use the system's (old) GNU compiler.

Use the wrapper commands `mpicc` , `mpiCC` , `mpif77` , or `mpif90` to compile MPI source code. They
use the currently loaded compiler. To reveal the command lines behind the wrappers, use the option
`-show`.

For running your code, you have to load the same compiler and MPI module as for compiling the
program. Please follow te following guiedlines to run your parallel program using the batch system.

## Batch System

Applications on an HPC system can not be run on the login node. They
have to be submitted to compute nodes with dedicated resources for the
user's job. Normally a job can be submitted with these data:

- number of CPU cores,
- requested CPU cores have to belong on one node (OpenMP programs) or
  can distributed (MPI),
- memory per process,
- maximum wall clock time (after reaching this limit the process is
  killed automatically),
- files for redirection of output and error messages,
- executable and command line parameters.

### LSF

The batch sytem on Atlas is LSF. For general information on LSF, please follow
[this link](platform_lsf.md).

### Submission of Parallel Jobs

To run MPI jobs ensure that the same MPI module is loaded as during compile-time. In doubt, check
you loaded modules with `module list`. If you code has been compiled with the standard OpenMPI
installation, you can load the OpenMPI module via `module load openmpi`.

Please pay attention to the messages you get loading the module. They are more up-to-date than this
manual. To submit a job the user has to use a script or a command-line like this:

```Bash
bsub -n <N> mpirun <program name>
```

### Memory Limits

**Memory limits are enforced.** This means that jobs which exceed their per-node memory limit **may
be killed** automatically by the batch system.

The **default limit** is **300 MB** *per job slot* (`bsub -n`).

Atlas has sets of nodes with different amount of installed memory which affect where your job may be
run. To achieve the shortest possible waiting time for your jobs, you should be aware of the limits
shown in the following table and read through the explanation below.

| Nodes        | No. of Cores | Avail. Memory per Job Slot | Max. Memory per Job Slot for Oversubscription |
|:-------------|:-------------|:---------------------------|:----------------------------------------------|
| `n[001-047]` | `3008`       | `940 MB`                   | `1880 MB`                                     |
| `n[049-072]` | `1536`       | `1950 MB`                  | `3900 MB`                                     |
| `n[085-092]` | `512`        | `8050 MB`                  | `16100 MB`                                    |

#### Explanation

The amount of memory that you request for your job (-M ) restricts to which nodes it will be
scheduled. Usually, the column **Avail. Memory per Job Slot** shows the maximum that will be
allowed on the respective nodes.

However, we allow for **oversubscribing of job slot memory**. This means that jobs which use **-n32
or less** may be scheduled to smaller memory nodes.

Have a look at the **examples below**.

#### Monitoring memory usage

At the end of the job completion mail there will be a link to a website
which shows the memory usage over time per node. This will only be
available for longer running jobs (>10 min).

#### Examples

| Job Spec.                                                                             | Nodes Allowed                                                                                     | Remark                                                                                                          |
|:--------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------|
| `bsub -n 1 -M 500`     | All nodes      | <= 940 Fits everywhere                                                                                          |
| `bsub -n 64 -M 700`    | All nodes      | <= 940 Fits everywhere                                                                                          |
| `bsub -n 4 -M 1800`    | All nodes      | Is allowed to oversubscribe on small nodes n\[001-047\]                                                         |
| `bsub -n 64 -M 1800`   | `n[049-092]`   | 64\*1800 will not fit onto a single small node and is therefore restricted to running on medium and large nodes |
| `bsub -n 4 -M 2000`    | `-n[049-092]`  | Over limit for oversubscribing on small nodes `n[001-047]`, but may still go to medium nodes                    |
| `bsub -n 32 -M 2000`   | `-n[049-092]`  | Same as above                                                                                     |              
| `bsub -n 32 -M 1880`   | All nodes      | Using max. 1880 MB, the job is eligible for running on any node                                   |
| `bsub -n 64 -M 2000`   | `-n[085-092]`  | Maximum for medium nodes is 1950 per slot - does the job **really** need **2000 MB** per process? |
| `bsub -n 64 -M 1950`   | `n[049-092]`   | When using 1950 as maximum, it will fit to the medium nodes                                       |
| `bsub -n 32 -M 16000`  | `n[085-092]`   | Wait time might be **very long**                                                                  |
| `bsub -n 64 -M 16000`  | `n[085-092]`   | Memory request cannot be satisfied (64\*16 MB = 1024 GB), **cannot schedule job**                 |

### Batch Queues

*Batch queues are subject to (mostly minor) changes anytime*. The
scheduling policy prefers short running jobs over long running ones.
This means that **short jobs get higher priorities** and are usually
started earlier than long running jobs.

| Batch Queue   | Admitted Users | Max. Cores                        | Default Runtime    | Max. Runtime |
|:--------------|:---------------|:----------------------------------|:-------------------|:-------------|
| `interactive` | `all`          | n/a   | 12h 00min | 12h 00min    |
| `short`       | `all`          | 1024  | 1h 00min  | 24h 00min    |
| `medium`      | `all`          | 1024  | 24h 01min | 72h 00min    |
| `long`        | `all`          | 1024  | 72h 01min | 120h 00min   |
| `rtc`         | `on request`   | 4     | 12h 00min | 300h 00min   |