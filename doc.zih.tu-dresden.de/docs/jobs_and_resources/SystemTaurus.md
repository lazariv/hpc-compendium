# Taurus

## Information about the Hardware

Detailed information on the current HPC hardware can be found
[here.](../use_of_hardware/HardwareTaurus.md)

## Applying for Access to the System

Project and login application forms for taurus are available
[here](../access.md).

## Login to the System

Login to the system is available via ssh at taurus.hrsk.tu-dresden.de.
There are several login nodes (internally called tauruslogin3 to
tauruslogin6). Currently, if you use taurus.hrsk.tu-dresden.de, you will
be placed on tauruslogin5. It might be a good idea to give the other
login nodes a try if the load on tauruslogin5 is rather high (there will
once again be load balancer soon, but at the moment, there is none).

Please note that if you store data on the local disk (e.g. under /tmp),
it will be on only one of the three nodes. If you relogin and the data
is not there, you are probably on another node.

You can find an list of fingerprints [here](../access/Login.md#SSH_access).

## Transferring Data from/to Taurus

taurus has two specialized data transfer nodes. Both nodes are
accessible via `taurusexport.hrsk.tu-dresden.de`. Currently, only rsync,
scp and sftp to these nodes will work. A login via SSH is not possible
as these nodes are dedicated to data transfers.

These nodes are located behind a firewall. By default, they are only
accessible from IP addresses from with the Campus of the TU Dresden.
External IP addresses can be enabled upon request. These requests should
be send via eMail to `servicedesk@tu-dresden.de` and mention the IP
address range (or node names), the desired protocol and the time frame
that the firewall needs to be open.

We are open to discuss options to export the data in the scratch file
system via CIFS or other protocols. If you have a need for this, please
contact the Service Desk as well.

**Phase 2:** The nodes taurusexport\[3,4\] provide access to the
`/scratch` file system of the second phase.

You can find an list of fingerprints [here](../access/Login.md#SSH_access).

## Compiling Parallel Applications

You have to explicitly load a compiler module and an MPI module on
Taurus. Eg. with `module load GCC OpenMPI`. ( [read more about
Modules](../software/RuntimeEnvironment.md), **todo link** (read more about
Compilers)(Compendium.Compilers))

Use the wrapper commands like e.g. `mpicc` (`mpiicc` for intel),
`mpicxx` (`mpiicpc`) or `mpif90` (`mpiifort`) to compile MPI source
code. To reveal the command lines behind the wrappers, use the option
`-show`.

For running your code, you have to load the same compiler and MPI module
as for compiling the program. Please follow the following guiedlines to
run your parallel program using the batch system.

## Batch System

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

The batch system on Taurus is Slurm. If you are migrating from LSF
(deimos, mars, atlas), the biggest difference is that Slurm has no
notion of batch queues any more.

-   [General information on the Slurm batch system](Slurm.md)
-   Slurm also provides process-level and node-level [profiling of
    jobs](Slurm.md#Job_Profiling)

### Partitions

Please note that the islands are also present as partitions for the
batch systems. They are called

-   romeo (Island 7 - AMD Rome CPUs)
-   julia (large SMP machine)
-   haswell (Islands 4 to 6 - Haswell CPUs)
-   gpu (Island 2 - GPUs)
    -   gpu2 (K80X)
-   smp2 (SMP Nodes)

**Note:** usually you don't have to specify a partition explicitly with
the parameter -p, because SLURM will automatically select a suitable
partition depending on your memory and gres requirements.

### Run-time Limits

**Run-time limits are enforced**. This means, a job will be canceled as
soon as it exceeds its requested limit. At Taurus, the maximum run time
is 7 days.

Shorter jobs come with multiple advantages:\<img alt="part.png"
height="117" src="%ATTACHURL%/part.png" style="float: right;"
title="part.png" width="284" />

-   lower risk of loss of computing time,
-   shorter waiting time for reservations,
-   higher job fluctuation; thus, jobs with high priorities may start
    faster.

To bring down the percentage of long running jobs we restrict the number
of cores with jobs longer than 2 days to approximately 50% and with jobs
longer than 24 to 75% of the total number of cores. (These numbers are
subject to changes.) As best practice we advise a run time of about 8h.

Please always try to make a good estimation of your needed time limit.
For this, you can use a command line like this to compare the requested
timelimit with the elapsed time for your completed jobs that started
after a given date:

    sacct -X -S 2021-01-01 -E now --format=start,JobID,jobname,elapsed,timelimit -s COMPLETED

Instead of running one long job, you should split it up into a chain
job. Even applications that are not capable of chreckpoint/restart can
be adapted. The HOWTO can be found [here](../use_of_hardware/CheckpointRestart.md),

### Memory Limits

**Memory limits are enforced.** This means that jobs which exceed their
per-node memory limit will be killed automatically by the batch system.
Memory requirements for your job can be specified via the *sbatch/srun*
parameters: **--mem-per-cpu=\<MB>** or **--mem=\<MB>** (which is "memory
per node"). The **default limit** is **300 MB** per cpu.

Taurus has sets of nodes with a different amount of installed memory
which affect where your job may be run. To achieve the shortest possible
waiting time for your jobs, you should be aware of the limits shown in
the following table.

| Partition          | Nodes                                    | # Nodes | Cores per Node  | Avail. Memory per Core | Avail. Memory per Node | GPUs per node     |
|:-------------------|:-----------------------------------------|:--------|:----------------|:-----------------------|:-----------------------|:------------------|
| `haswell64`        | `taurusi[4001-4104,5001-5612,6001-6612]` | `1328`  | `24`            | `2541 MB`              | `61000 MB`             | `-`               |
| `haswell128`       | `taurusi[4105-4188]`                     | `84`    | `24`            | `5250 MB`              | `126000 MB`            | `-`               |
| `haswell256`       | `taurusi[4189-4232]`                     | `44`    | `24`            | `10583 MB`             | `254000 MB`            | `-`               |
| `broadwell`        | `taurusi[4233-4264]`                     | `32`    | `28`            | `2214 MB`              | `62000 MB`             | `-`               |
| `smp2`             | `taurussmp[3-7]`                         | `5`     | `56`            | `36500 MB`             | `2044000 MB`           | `-`               |
| `gpu2`             | `taurusi[2045-2106]`                     | `62`    | `24`            | `2583 MB`              | `62000 MB`             | `4 (2 dual GPUs)` |
| `gpu2-interactive` | `taurusi[2045-2108]`                     | `64`    | `24`            | `2583 MB`              | `62000 MB`             | `4 (2 dual GPUs)` |
| `hpdlf`            | `taurusa[3-16]`                          | `14`    | `12`            | `7916 MB`              | `95000 MB`             | `3`               |
| `ml`               | `taurusml[1-32]`                         | `32`    | `44 (HT: 176)`  | `1443 MB*`             | `254000 MB`            | `6`               |
| `romeo`            | `taurusi[7001-7192]`                     | `192`   | `128 (HT: 256)` | `1972 MB*`             | `505000 MB`            | `-`               |
| `julia`            | `taurussmp8`                             | `1`     | `896`           | `27343 MB*`            | `49000000 MB`          | `-`               |

\* note that the ML nodes have 4way-SMT, so for every physical core
allocated (e.g., with SLURM_HINT=nomultithread), you will always get
4\*1443MB because the memory of the other threads is allocated
implicitly, too.

### Submission of Parallel Jobs

To run MPI jobs ensure that the same MPI module is loaded as during
compile-time. In doubt, check you loaded modules with `module list`. If
your code has been compiled with the standard `bullxmpi` installation,
you can load the module via `module load bullxmpi`. Alternative MPI
libraries (`intelmpi`, `openmpi`) are also available.

Please pay attention to the messages you get loading the module. They
are more up-to-date than this manual.

## GPUs

Island 2 of taurus contains a total of 128 NVIDIA Tesla K80 (dual) GPUs
in 64 nodes.

More information on how to program applications for GPUs can be found
[GPU Programming](GPU Programming).

The following software modules on taurus offer GPU support:

-   `CUDA` : The NVIDIA CUDA compilers
-   `PGI` : The PGI compilers with OpenACC support

## Hardware for Deep Learning (HPDLF)

The partition hpdlf contains 14 servers. Each of them has:

-   2 sockets CPU E5-2603 v4 (1.70GHz) with 6 cores each,
-   3 consumer GPU cards NVIDIA GTX1080,
-   96 GB RAM.

## Energy Measurement

Taurus contains sophisticated energy measurement instrumentation.
Especially HDEEM is available on the haswell nodes of Phase II. More
detailed information can be found at
**todo link** (EnergyMeasurement)(EnergyMeasurement).

## Low level optimizations

x86 processsors provide registers that can be used for optimizations and
performance monitoring. Taurus provides you access to such features via
the **todo link** (X86Adapt)(X86Adapt) software infrastructure.
