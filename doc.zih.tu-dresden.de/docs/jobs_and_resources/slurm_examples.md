# Job Examples

## Requesting an Nvidia K20X / K80 / A100

Slurm will allocate one or many GPUs for your job if requested. Please note that GPUs are only
available in certain partitions, like `gpu2`, `gpu3` or `gpu2-interactive`. The option
for sbatch/srun in this case is `--gres=gpu:[NUM_PER_NODE]` (where `NUM_PER_NODE` can be `1`, 2 or
4, meaning that one, two or four of the GPUs per node will be used for the job). A sample job file
could look like this

```Bash
#!/bin/bash
#SBATCH -A Project1            # account CPU time to Project1
#SBATCH --nodes=2              # request 2 nodes<br />#SBATCH --mincpus=1            # allocate one task per node...<br />#SBATCH --ntasks=2             # ...which means 2 tasks in total (see note below)
#SBATCH --cpus-per-task=6      # use 6 threads per task
#SBATCH --gres=gpu:1           # use 1 GPU per node (i.e. use one GPU per task)
#SBATCH --time=01:00:00        # run for 1 hour
srun ./your/cuda/application   # start you application (probably requires MPI to use both nodes)
```

Please be aware that the partitions `gpu`, `gpu1` and `gpu2` can only be used for non-interactive
jobs which are submitted by `sbatch`.  Interactive jobs (`salloc`, `srun`) will have to use the
partition `gpu-interactive`. Slurm will automatically select the right partition if the partition
parameter (-p) is omitted.

**Note:** Due to an unresolved issue concerning the Slurm job scheduling behavior, it is currently
not practical to use `--ntasks-per-node` together with GPU jobs.  If you want to use multiple nodes,
please use the parameters `--ntasks` and `--mincpus` instead. The values of mincpus \* nodes has to
equal ntasks in this case.

### Limitations of GPU job allocations

The number of cores per node that are currently allowed to be allocated for GPU jobs is limited
depending on how many GPUs are being requested.  On the K80 nodes, you may only request up to 6
cores per requested GPU (8 per on the K20 nodes). This is because we do not wish that GPUs remain
unusable due to all cores on a node being used by a single job which does not, at the same time,
request all GPUs.

E.g., if you specify `--gres=gpu:2`, your total number of cores per node (meaning: ntasks \*
cpus-per-task) may not exceed 12 (on the K80 nodes)

Note that this also has implications for the use of the --exclusive parameter. Since this sets the
number of allocated cores to 24 (or 16 on the K20X nodes), you also **must** request all four GPUs
by specifying --gres=gpu:4, otherwise your job will not start. In the case of --exclusive, it won't
be denied on submission, because this is evaluated in a later scheduling step. Jobs that directly
request too many cores per GPU will be denied with the error message:

```Shell Session
Batch job submission failed: Requested node configuration is not available
```

### Parallel Jobs

For submitting parallel jobs, a few rules have to be understood and followed. In general, they
depend on the type of parallelization and architecture.

#### OpenMP Jobs

An SMP-parallel job can only run within a node, so it is necessary to include the options `-N 1` and
`-n 1`. The maximum number of processors for an SMP-parallel program is 488 on Venus and 56 on
taurus (smp island). Using --cpus-per-task N Slurm will start one task and you will have N CPUs
available for your job. An example job file would look like:

```Bash
#!/bin/bash
#SBATCH -J Science1
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mail-type=end
#SBATCH --mail-user=your.name@tu-dresden.de
#SBATCH --time=08:00:00

export OMP_NUM_THREADS=8
./path/to/binary
```

#### MPI Jobs

For MPI jobs one typically allocates one core per task that has to be started. **Please note:**
There are different MPI libraries on Taurus and Venus, so you have to compile the binaries
specifically for their target.

```Bash
#!/bin/bash
#SBATCH -J Science1
#SBATCH --ntasks=864
#SBATCH --mail-type=end
#SBATCH --mail-user=your.name@tu-dresden.de
#SBATCH --time=08:00:00

srun ./path/to/binary
```

#### Multiple Programs Running Simultaneously in a Job

In this short example, our goal is to run four instances of a program concurrently in a **single**
batch script. Of course we could also start a batch script four times with sbatch but this is not
what we want to do here. Please have a look at [Running Multiple GPU Applications Simultaneously in
a Batch Job] todo Compendium.RunningNxGpuAppsInOneJob in case you intend to run GPU programs
simultaneously in a **single** job.

```Bash
#!/bin/bash
#SBATCH -J PseudoParallelJobs
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=end
#SBATCH --mail-user=your.name@tu-dresden.de
#SBATCH --time=01:00:00

# The following sleep command was reported to fix warnings/errors with srun by users (feel free to uncomment).
#sleep 5
srun --exclusive --ntasks=1 ./path/to/binary &

#sleep 5
srun --exclusive --ntasks=1 ./path/to/binary &

#sleep 5
srun --exclusive --ntasks=1 ./path/to/binary &

#sleep 5
srun --exclusive --ntasks=1 ./path/to/binary &

echo "Waiting for parallel job steps to complete..."
wait
echo "All parallel job steps completed!"
```

### Exclusive Jobs for Benchmarking

Jobs on taurus run, by default, in shared-mode, meaning that multiple jobs can run on the same
compute nodes. Sometimes, this behaviour is not desired (e.g. for benchmarking purposes), in which
case it can be turned off by specifying the Slurm parameter: `--exclusive` .

Setting `--exclusive` **only** makes sure that there will be **no other jobs running on your nodes**.
It does not, however, mean that you automatically get access to all the resources which the node
might provide without explicitly requesting them, e.g. you still have to request a GPU via the
generic resources parameter (gres) to run on the GPU partitions, or you still have to request all
cores of a node if you need them. CPU cores can either to be used for a task (`--ntasks`) or for
multi-threading within the same task (--cpus-per-task). Since those two options are semantically
different (e.g., the former will influence how many MPI processes will be spawned by 'srun' whereas
the latter does not), Slurm cannot determine automatically which of the two you might want to use.
Since we use cgroups for separation of jobs, your job is not allowed to use more resources than
requested.*

If you just want to use all available cores in a node, you have to
specify how Slurm should organize them, like with \<span>"-p haswell -c
24\</span>" or "\<span>-p haswell --ntasks-per-node=24". \</span>

Here is a short example to ensure that a benchmark is not spoiled by
other jobs, even if it doesn't use up all resources in the nodes:

```Bash
#!/bin/bash
#SBATCH -J Benchmark
#SBATCH -p haswell
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=8
#SBATCH --exclusive    # ensure that nobody spoils my measurement on 2 x 2 x 8 cores
#SBATCH --mail-user=your.name@tu-dresden.de
#SBATCH --time=00:10:00

srun ./my_benchmark
```

### Array Jobs

Array jobs can be used to create a sequence of jobs that share the same executable and resource
requirements, but have different input files, to be submitted, controlled, and monitored as a single
unit. The arguments `-a` or `--array` take an additional parameter that specify the array indices.
Within the job you can read the environment variables `SLURM_ARRAY_JOB_ID`, which will be set to the
first job ID of the array, and `SLURM_ARRAY_TASK_ID`, which will be set individually for each step.

Within an array job, you can use %a and %A in addition to %j and %N
(described above) to make the output file name specific to the job. %A
will be replaced by the value of SLURM_ARRAY_JOB_ID and %a will be
replaced by the value of SLURM_ARRAY_TASK_ID.

Here is an example of how an array job can look like:

```Bash
#!/bin/bash
#SBATCH -J Science1
#SBATCH --array 0-9
#SBATCH -o arraytest-%A_%a.out
#SBATCH -e arraytest-%A_%a.err
#SBATCH --ntasks=864
#SBATCH --mail-type=end
#SBATCH --mail-user=your.name@tu-dresden.de
#SBATCH --time=08:00:00

echo "Hi, I am step $SLURM_ARRAY_TASK_ID in this array job $SLURM_ARRAY_JOB_ID"
```

**Note:** If you submit a large number of jobs doing heavy I/O in the Lustre file systems you should
limit the number of your simultaneously running job with a second parameter like:

```Bash
#SBATCH --array=1-100000%100
```

For further details please read the Slurm documentation at
(https://slurm.schedmd.com/sbatch.html)

### Chain Jobs

You can use chain jobs to create dependencies between jobs. This is often the case if a job relies
on the result of one or more preceding jobs. Chain jobs can also be used if the runtime limit of the
batch queues is not sufficient for your job. Slurm has an option `-d` or "--dependency" that allows
to specify that a job is only allowed to start if another job finished.

Here is an example of how a chain job can look like, the example submits 4 jobs (described in a job
file) that will be executed one after each other with different CPU numbers:

```Bash
#!/bin/bash
TASK_NUMBERS="1 2 4 8"
DEPENDENCY=""
JOB_FILE="myjob.slurm"

for TASKS in $TASK_NUMBERS ; do
    JOB_CMD="sbatch --ntasks=$TASKS"
    if [ -n "$DEPENDENCY" ] ; then
        JOB_CMD="$JOB_CMD --dependency afterany:$DEPENDENCY"
    fi
    JOB_CMD="$JOB_CMD $JOB_FILE"
    echo -n "Running command: $JOB_CMD  "
    OUT=`$JOB_CMD`
    echo "Result: $OUT"
    DEPENDENCY=`echo $OUT | awk '{print $4}'`
done
```



## Array-Job with Afterok-Dependency and DataMover Usage

TODO
