# Batch System Slurm

When logging in to ZIH systems, you are placed on a login node. There, you can manage your
[data life cycle](../data_lifecycle/overview.md),
[setup experiments](../data_lifecycle/experiments.md), and
edit and prepare jobs. The login nodes are not suited for computational work! From the login nodes,
you can interact with the batch system, e.g., submit and monitor your jobs.

??? note "Batch System"

    The batch system is the central organ of every HPC system users interact with its compute
    resources. The batch system finds an adequate compute system (partition) for your compute jobs.
    It organizes the queueing and messaging, if all resources are in use. If resources are available
    for your job, the batch system allocates and connects to these resources, transfers runtime
    environment, and starts the job.

??? note "Batch Job"

    At HPC systems, computational work and resource requirements are encapsulated into so-called
    jobs. In order to allow the batch system an efficient job placement it needs these
    specifications:

    * requirements: number of nodes and cores, memory per core, additional resources (GPU)
    * maximum run-time
    * HPC project for accounting
    * who gets an email on which occasion

    Moreover, the [runtime environment](../software/overview.md) as well as the executable and
    certain command-line arguments have to be specified to run the computational work.

ZIH uses the batch system Slurm for resource management and job scheduling.
Just specify the resources you need in terms
of cores, memory, and time and your Slurm will place your job on the system.

This page provides a brief overview on

* [Slurm options](#options) to specify resource requirements,
* how to submit [interactive](#interactive-jobs) and [batch jobs](#batch-jobs),
* how to [write job files](#job-files),
* how to [manage and control your jobs](#manage-and-control-jobs).

If you are are already familiar with Slurm, you might be more interested in our collection of
[job examples](slurm_examples.md).
There is also a ton of external resources regarding Slurm. We recommend these links for detailed
information:

- [slurm.schedmd.com](https://slurm.schedmd.com/) provides the official documentation comprising
   manual pages, tutorials, examples, etc.
- [Comparison with other batch systems](https://www.schedmd.com/slurmdocs/rosetta.html)

## Job Submission

There are three basic Slurm commands for job submission and execution:

1. `srun`: Submit a job for execution or initiate job steps in real time.
1. `sbatch`: Submit a batch script to Slurm for later execution.
1. `salloc`: Obtain a Slurm job allocation (a set of nodes), execute a command, and then release the
   allocation when the command is finished.

Using `srun` directly on the shell will be blocking and launch an
[interactive job](#interactive-jobs). Apart from short test runs, it is recommended to submit your
jobs to Slurm for later execution by using [batch jobs](#batch-jobs). For that, you can conveniently
put the parameters directly in a [job file](#job-files), which you can submit using `sbatch
[options] <job file>`.

At runtime, the environment variable `SLURM_JOB_ID` is set to the id of your job. The job
id is unique. The id allows you to [manage and control](#manage-and-control-jobs) your jobs.

## Options

The following table contains the most important options for `srun/sbatch/salloc` to specify resource
requirements and control communication.

??? tip "Options Table"

    | Slurm Option               | Description |
    |:---------------------------|:------------|
    | `-n, --ntasks=<N>`         | Number of (MPI) tasks (default: 1) |
    | `-N, --nodes=<N>`          | Number of nodes; there will be `--ntasks-per-node` processes started on each node |
    | `--ntasks-per-node=<N>`    | Number of tasks per allocated node to start (default: 1) |
    | `-c, --cpus-per-task=<N>`  | Number of CPUs per task; needed for multithreaded (e.g. OpenMP) jobs; typically `N` should be equal to `OMP_NUM_THREADS` |
    | `-p, --partition=<name>`   | Type of nodes where you want to execute your job (refer to [partitions](partitions_and_limits.md)) |
    | `--mem-per-cpu=<size>`     | Memory need per allocated CPU in MB |
    | `-t, --time=<HH:MM:SS>`    | Maximum runtime of the job |
    | `--mail-user=<your email>` | Get updates about the status of the jobs |
    | `--mail-type=ALL`          | For what type of events you want to get a mail; valid options: `ALL`, `BEGIN`, `END`, `FAIL`, `REQUEUE` |
    | `-J, --job-name=<name>`    | Name of the job shown in the queue and in mails (cut after 24 chars) |
    | `--no-requeue`             | Disable requeueing of the job in case of node failure (default: enabled) |
    | `--exclusive`              | Exclusive usage of compute nodes; you will be charged for all CPUs/cores on the node |
    | `-A, --account=<project>`  | Charge resources used by this job to the specified project |
    | `-o, --output=<filename>`  | File to save all normal output (stdout) (default: `slurm-%j.out`) |
    | `-e, --error=<filename>`   | File to save all error output (stderr)  (default: `slurm-%j.out`) |
    | `-a, --array=<arg>`        | Submit an array job ([examples](slurm_examples.md#array-jobs)) |
    | `-w <node1>,<node2>,...`   | Restrict job to run on specific nodes only |
    | `-x <node1>,<node2>,...`   | Exclude specific nodes from job |

!!! note "Output and Error Files"

    When redirecting stderr and stderr into a file using `--output=<filename>` and
    `--stderr=<filename>`, make sure the target path is writeable on the
    compute nodes, i.e., it may not point to a read-only mounted
    [filesystem](../data_lifecycle/overview.md) like `/projects.`

!!! note "No free lunch"

    Runtime and memory limits are enforced. Please refer to the section on [partitions and
    limits](partitions_and_limits.md) for a detailed overview.

### Host List

If you want to place your job onto specific nodes, there are two options for doing this. Either use
`-p, --partition=<name>` to specify a host group aka. [partition](partitions_and_limits.md) that fits
your needs. Or, use `-w, --nodelist=<host1,host2,..>` with a list of hosts that will work for you.

## Interactive Jobs

Interactive activities like editing, compiling, preparing experiments etc. are normally limited to
the login nodes. For longer interactive sessions, you can allocate cores on the compute node with
the command `salloc`. It takes the same options as `sbatch` to specify the required resources.

`salloc` returns a new shell on the node, where you submitted the job. You need to use the command
`srun` in front of the following commands to have these commands executed on the allocated
resources. If you allocate more than one task, please be aware that `srun` will run the command on
each allocated task by default!

The syntax for submitting a job is

```
marie@login$ srun [options] <command>
```

An example of an interactive session looks like:

```console
marie@login$ srun --pty --ntasks=1 --cpus-per-task=4 --time=1:00:00 --mem-per-cpu=1700 bash -l
srun: job 13598400 queued and waiting for resources
srun: job 13598400 has been allocated resources
marie@compute$ # Now, you can start interactive work with e.g. 4 cores
```

!!! note "Using `module` commands"

    The [module commands](../software/modules.md) are made available by sourcing the files
    `/etc/profile` and `~/.bashrc`. This is done automatically by passing the parameter `-l` to your
    shell, as shown in the example above. If you missed adding `-l` at submitting the interactive
    session, no worry, you can source this files also later on manually.

!!! note "Partition `interactive`"

    A dedicated partition `interactive` is reserved for short jobs (< 8h) with not more than one job
    per user. Please check the availability of nodes there with `sinfo --partition=interactive`.

### Interactive X11/GUI Jobs

Slurm will forward your X11 credentials to the first (or even all) node for a job with the
(undocumented) `--x11` option. For example, an interactive session for one hour with Matlab using
eight cores can be started with:

```console
marie@login$ module load matlab
marie@login$ srun --ntasks=1 --cpus-per-task=8 --time=1:00:00 --pty --x11=first matlab
```

!!! hint "X11 error"

    If you are getting the error:

    ```Bash
    srun: error: x11: unable to connect node taurusiXXXX
    ```

    that probably means you still have an old host key for the target node in your
    `~.ssh/known_hosts` file (e.g. from pre-SCS5). This can be solved either by removing the entry
    from your known_hosts or by simply deleting the `known_hosts` file altogether if you don't have
    important other entries in it.

## Batch Jobs

Working interactively using `srun` and `salloc` is a good starting point for testing and compiling.
But, as soon as you leave the testing stage, we highly recommend you to use batch jobs.
Batch jobs are encapsulated within [job files](#job-files) and submitted to the batch system using
`sbatch` for later execution. A job file is basically a script holding the resource requirements,
environment settings and the commands for executing the application. Using batch jobs and job files
has multiple advantages:

* You can reproduce your experiments and work, because all steps are saved in a file.
* You can easily share your settings and experimental setup with colleagues.
* You can submit your job file to the scheduling system for later execution. In the meanwhile, you can
  grab a coffee and proceed with other work (e.g., start writing a paper).

!!! hint "The syntax for submitting a job file to Slurm is"

    ```console
    marie@login$ sbatch [options] <job_file>
    ```

### Job Files

Job files have to be written with the following structure.

```bash
#!/bin/bash                           # Batch script starts with shebang line

#SBATCH --ntasks=24                   # All #SBATCH lines have to follow uninterrupted
#SBATCH --time=01:00:00               # after the shebang line
#SBATCH --account=<KTR>               # Comments start with # and do not count as interruptions
#SBATCH --job-name=fancyExp
#SBATCH --output=simulation-%j.out
#SBATCH --error=simulation-%j.err

module purge                          # Set up environment, e.g., clean modules environment
module load <modules>                 # and load necessary modules

srun ./application [options]          # Execute parallel application with srun
```

The following two examples show the basic resource specifications for a pure OpenMP application and
a pure MPI application, respectively. Within the section [Job Examples](slurm_examples.md), we
provide a comprehensive collection of job examples.

??? example "Job file OpenMP"

    ```bash
    #!/bin/bash

    #SBATCH --nodes=1
    #SBATCH --tasks-per-node=1
    #SBATCH --cpus-per-task=64
    #SBATCH --time=01:00:00
    #SBATCH --account=<account>

    module purge
    module load <modules>

    export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
    srun ./path/to/openmpi_application
    ```

    * Submisson: `marie@login$ sbatch batch_script.sh`
    * Run with fewer CPUs: `marie@login$ sbatch --cpus-per-task=14 batch_script.sh`

??? example "Job file MPI"

    ```bash
    #!/bin/bash

    #SBATCH --ntasks=64
    #SBATCH --time=01:00:00
    #SBATCH --account=<account>

    module purge
    module load <modules>

    srun ./path/to/mpi_application
    ```

    * Submisson: `marie@login$ sbatch batch_script.sh`
    * Run with fewer MPI tasks: `marie@login$ sbatch --ntasks=14 batch_script.sh`

## Manage and Control Jobs

### Job and Slurm Monitoring

On the command line, use `squeue` to watch the scheduling queue. This command will tell the reason,
why a job is not running (job status in the last column of the output). More information about job
parameters can also be determined with `scontrol -d show job <jobid>`. The following table holds
detailed descriptions of the possible job states:

??? tip "Reason Table"

    | Reason             | Long Description  |
    |:-------------------|:------------------|
    | `Dependency`         | This job is waiting for a dependent job to complete. |
    | `None`               | No reason is set for this job. |
    | `PartitionDown`      | The partition required by this job is in a down state. |
    | `PartitionNodeLimit` | The number of nodes required by this job is outside of its partitions current limits. Can also indicate that required nodes are down or drained. |
    | `PartitionTimeLimit` | The jobs time limit exceeds its partitions current time limit. |
    | `Priority`           | One or higher priority jobs exist for this partition. |
    | `Resources`          | The job is waiting for resources to become available. |
    | `NodeDown`           | A node required by the job is down. |
    | `BadConstraints`     | The jobs constraints can not be satisfied. |
    | `SystemFailure`      | Failure of the Slurm system, a filesystem, the network, etc. |
    | `JobLaunchFailure`   | The job could not be launched. This may be due to a filesystem problem, invalid program name, etc. |
    | `NonZeroExitCode`    | The job terminated with a non-zero exit code. |
    | `TimeLimit`          | The job exhausted its time limit. |
    | `InactiveLimit`      | The job reached the system inactive limit. |

In addition, the `sinfo` command gives you a quick status overview.

For detailed information on why your submitted job has not started yet, you can use the command

```console
marie@login$ whypending <jobid>
```

### Editing Jobs

Jobs that have not yet started can be altered. Using `scontrol update timelimit=4:00:00
jobid=<jobid>`, it is for example possible to modify the maximum runtime. `scontrol` understands
many different options, please take a look at the
[scontrol documentation](https://slurm.schedmd.com/scontrol.html) for more details.

### Canceling Jobs

The command `scancel <jobid>` kills a single job and removes it from the queue. By using `scancel -u
<username>`, you can send a canceling signal to all of your jobs at once.

### Accounting

The Slurm command `sacct` provides job statistics like memory usage, CPU time, energy usage etc.

!!! hint "Learn from old jobs"

    We highly encourage you to use `sacct` to learn from you previous jobs in order to better
    estimate the requirements, e.g., runtime, for future jobs.

`sacct` outputs the following fields by default.

```console
# show all own jobs contained in the accounting database
marie@login$ sacct
       JobID    JobName  Partition    Account  AllocCPUS      State ExitCode
------------ ---------- ---------- ---------- ---------- ---------- --------
[...]
```

We'd like to point your attention to the following options to gain insight in your jobs.

??? example "Show specific job"

    ```console
    marie@login$ sacct --jobs=<JOBID>
    ```

??? example "Show all fields for a specific job"

    ```console
    marie@login$ sacct --jobs=<JOBID> --format=All
    ```

??? example "Show specific fields"

    ```console
    marie@login$ sacct --jobs=<JOBID> --format=JobName,MaxRSS,MaxVMSize,CPUTime,ConsumedEnergy
    ```

The manual page (`man sacct`) and the [sacct online reference](https://slurm.schedmd.com/sacct.html)
provide a comprehensive documentation regarding available fields and formats.

!!! hint "Time span"

    By default, `sacct` only shows data of the last day. If you want to look further into the past
    without specifying an explicit job id, you need to provide a start date via the option
    `--starttime` (or short: `-S`). A certain end date is also possible via `--endtime` (or `-E`).

??? example "Show all jobs since the beginning of year 2021"

    ```console
    marie@login$ sacct -S 2021-01-01 [-E now]
    ```

## Jobs at Reservations

How to ask for a reservation is described in the section
[reservations](overview.md#exclusive-reservation-of-hardware).
After we agreed with your requirements, we will send you an e-mail with your reservation name. Then,
you could see more information about your reservation with the following command:

```console
marie@login$ scontrol show res=<reservation name>
# e.g. scontrol show res=hpcsupport_123
```

If you want to use your reservation, you have to add the parameter
`--reservation=<reservation name>` either in your sbatch script or to your `srun` or `salloc` command.

## Node Features for Selective Job Submission

The nodes in our HPC system are becoming more diverse in multiple aspects: hardware, mounted
storage, software. The system administrators can describe the set of properties and it is up to the
user to specify her/his requirements. These features should be thought of as changing over time
(e.g., a filesystem get stuck on a certain node).

A feature can be used with the Slurm option `--constrain` or `-C` like
`srun -C fs_lustre_scratch2 ...` with `srun` or `sbatch`. Combinations like
`--constraint="fs_beegfs_global0`are allowed. For a detailed description of the possible
constraints, please refer to the [Slurm documentation](https://slurm.schedmd.com/srun.html).

!!! hint

      A feature is checked only for scheduling. Running jobs are not affected by changing features.

### Available Features

| Feature | Description                                                              |
|:--------|:-------------------------------------------------------------------------|
| DA      | Subset of Haswell nodes with a high bandwidth to NVMe storage (island 6) |

#### Filesystem Features

A feature `fs_*` is active if a certain filesystem is mounted and available on a node. Access to
these filesystems are tested every few minutes on each node and the Slurm features set accordingly.

| Feature            | Description                                                          |
|:-------------------|:---------------------------------------------------------------------|
| `fs_lustre_scratch2` | `/scratch` mounted read-write (mount point is `/lustre/scratch2`)  |
| `fs_lustre_ssd`      | `/ssd` mounted read-write (mount point is `/lustre/ssd`)           |
| `fs_warm_archive_ws` | `/warm_archive/ws` mounted read-only                               |
| `fs_beegfs_global0`  | `/beegfs/global0` mounted read-write                               |
| `fs_beegfs`          | `/beegfs` mounted read-write                                       |

For certain projects, specific filesystems are provided. For those,
additional features are available, like `fs_beegfs_<projectname>`.
