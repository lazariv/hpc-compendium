# Job Examples

## Parallel Jobs

For submitting parallel jobs, a few rules have to be understood and followed. In general, they
depend on the type of parallelization and architecture.

### OpenMP Jobs

An SMP-parallel job can only run within a node, so it is necessary to include the options `-N 1` and
`-n 1`. The maximum number of processors for an SMP-parallel program is 896 and 56 on partition
`taurussmp8` and  `smp2`, respectively.  Please refer to the
[partitions section](partitions_and_limits.md#memory-limits) for up-to-date information. Using the
option `--cpus-per-task=<N>` Slurm will start one task and you will have `N` CPUs available for your
job.  An example job file would look like:

!!! example "Job file for OpenMP application"

    ```Bash
    #!/bin/bash
    #SBATCH --nodes=1
    #SBATCH --tasks-per-node=1
    #SBATCH --cpus-per-task=8
    #SBATCH --time=08:00:00
    #SBATCH -J Science1
    #SBATCH --mail-type=end
    #SBATCH --mail-user=your.name@tu-dresden.de

    export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
    ./path/to/binary
    ```

### MPI Jobs

For MPI-parallel jobs one typically allocates one core per task that has to be started.

!!! warning "MPI libraries"

    There are different MPI libraries on ZIH systems for the different micro archtitectures. Thus,
    you have to compile the binaries specifically for the target architecture and partition. Please
    refer to the sections [building software](../software/building_software.md) and
    [module environments](../software/modules.md#module-environments) for detailed
    information.

!!! example "Job file for MPI application"

    ```Bash
    #!/bin/bash
    #SBATCH --ntasks=864
    #SBATCH --time=08:00:00
    #SBATCH -J Science1
    #SBATCH --mail-type=end
    #SBATCH --mail-user=your.name@tu-dresden.de

    srun ./path/to/binary
    ```

### Multiple Programs Running Simultaneously in a Job

In this short example, our goal is to run four instances of a program concurrently in a **single**
batch script. Of course, we could also start a batch script four times with `sbatch` but this is not
what we want to do here. However, you can also find an example about
[how to run GPU programs simultaneously in a single job](#running-multiple-gpu-applications-simultaneously-in-a-batch-job)
below.

!!! example " "

    ```Bash
    #!/bin/bash
    #SBATCH --ntasks=4
    #SBATCH --cpus-per-task=1
    #SBATCH --time=01:00:00
    #SBATCH -J PseudoParallelJobs
    #SBATCH --mail-type=end
    #SBATCH --mail-user=your.name@tu-dresden.de

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

## Requesting GPUs

Slurm will allocate one or many GPUs for your job if requested. Please note that GPUs are only
available in certain partitions, like `gpu2`, `gpu3` or `gpu2-interactive`. The option
for `sbatch/srun` in this case is `--gres=gpu:[NUM_PER_NODE]` (where `NUM_PER_NODE` can be `1`, `2` or
`4`, meaning that one, two or four of the GPUs per node will be used for the job).

!!! example "Job file to request a GPU"

    ```Bash
    #!/bin/bash
    #SBATCH --nodes=2              # request 2 nodes
    #SBATCH --mincpus=1            # allocate one task per node...
    #SBATCH --ntasks=2             # ...which means 2 tasks in total (see note below)
    #SBATCH --cpus-per-task=6      # use 6 threads per task
    #SBATCH --gres=gpu:1           # use 1 GPU per node (i.e. use one GPU per task)
    #SBATCH --time=01:00:00        # run for 1 hour
    #SBATCH -A Project1            # account CPU time to Project1

    srun ./your/cuda/application   # start you application (probably requires MPI to use both nodes)
    ```

Please be aware that the partitions `gpu`, `gpu1` and `gpu2` can only be used for non-interactive
jobs which are submitted by `sbatch`.  Interactive jobs (`salloc`, `srun`) will have to use the
partition `gpu-interactive`. Slurm will automatically select the right partition if the partition
parameter `-p, --partition` is omitted.

!!! note

    Due to an unresolved issue concerning the Slurm job scheduling behavior, it is currently not
    practical to use `--ntasks-per-node` together with GPU jobs. If you want to use multiple nodes,
    please use the parameters `--ntasks` and `--mincpus` instead. The values of `mincpus`*`nodes`
    has to equal `ntasks` in this case.

### Limitations of GPU Job Allocations

The number of cores per node that are currently allowed to be allocated for GPU jobs is limited
depending on how many GPUs are being requested. On the K80 nodes, you may only request up to 6
cores per requested GPU (8 per on the K20 nodes). This is because we do not wish that GPUs remain
unusable due to all cores on a node being used by a single job which does not, at the same time,
request all GPUs.

E.g., if you specify `--gres=gpu:2`, your total number of cores per node (meaning:
`ntasks`*`cpus-per-task`) may not exceed 12 (on the K80 nodes)

Note that this also has implications for the use of the `--exclusive` parameter. Since this sets the
number of allocated cores to 24 (or 16 on the K20X nodes), you also **must** request all four GPUs
by specifying `--gres=gpu:4`, otherwise your job will not start. In the case of `--exclusive`, it won't
be denied on submission, because this is evaluated in a later scheduling step. Jobs that directly
request too many cores per GPU will be denied with the error message:

```console
Batch job submission failed: Requested node configuration is not available
```

### Running Multiple GPU Applications Simultaneously in a Batch Job

Our starting point is a (serial) program that needs a single GPU and four CPU cores to perform its
task (e.g. TensorFlow). The following batch script shows how to run such a job on the partition `ml`.

!!! example

    ```bash
    #!/bin/bash
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=4
    #SBATCH --gres=gpu:1
    #SBATCH --gpus-per-task=1
    #SBATCH --time=01:00:00
    #SBATCH --mem-per-cpu=1443
    #SBATCH --partition=ml

    srun some-gpu-application
    ```

When `srun` is used within a submission script, it inherits parameters from `sbatch`, including
`--ntasks=1`, `--cpus-per-task=4`, etc. So we actually implicitly run the following

```bash
srun --ntasks=1 --cpus-per-task=4 ... --partition=ml some-gpu-application
```

Now, our goal is to run four instances of this program concurrently in a single batch script. Of
course we could also start the above script multiple times with `sbatch`, but this is not what we want
to do here.

#### Solution

In order to run multiple programs concurrently in a single batch script/allocation we have to do
three things:

1. Allocate enough resources to accommodate multiple instances of our program. This can be achieved
   with an appropriate batch script header (see below).
1. Start job steps with srun as background processes. This is achieved by adding an ampersand at the
   end of the `srun` command
1. Make sure that each background process gets its private resources. We need to set the resource
   fraction needed for a single run in the corresponding srun command. The total aggregated
   resources of all job steps must fit in the allocation specified in the batch script header.
   Additionally, the option `--exclusive` is needed to make sure that each job step is provided with
   its private set of CPU and GPU resources.  The following example shows how four independent
   instances of the same program can be run concurrently from a single batch script. Each instance
   (task) is equipped with 4 CPUs (cores) and one GPU.

!!! example "Job file simultaneously executing four independent instances of the same program"

    ```Bash
    #!/bin/bash
    #SBATCH --ntasks=4
    #SBATCH --cpus-per-task=4
    #SBATCH --gres=gpu:4
    #SBATCH --gpus-per-task=1
    #SBATCH --time=01:00:00
    #SBATCH --mem-per-cpu=1443
    #SBATCH --partition=ml

    srun --exclusive --gres=gpu:1 --ntasks=1 --cpus-per-task=4 --gpus-per-task=1 --mem-per-cpu=1443 some-gpu-application &
    srun --exclusive --gres=gpu:1 --ntasks=1 --cpus-per-task=4 --gpus-per-task=1 --mem-per-cpu=1443 some-gpu-application &
    srun --exclusive --gres=gpu:1 --ntasks=1 --cpus-per-task=4 --gpus-per-task=1 --mem-per-cpu=1443 some-gpu-application &
    srun --exclusive --gres=gpu:1 --ntasks=1 --cpus-per-task=4 --gpus-per-task=1 --mem-per-cpu=1443 some-gpu-application &

    echo "Waiting for all job steps to complete..."
    wait
    echo "All jobs completed!"
    ```

In practice it is possible to leave out resource options in `srun` that do not differ from the ones
inherited from the surrounding `sbatch` context. The following line would be sufficient to do the
job in this example:

```bash
srun --exclusive --gres=gpu:1 --ntasks=1 some-gpu-application &
```

Yet, it adds some extra safety to leave them in, enabling the Slurm batch system to complain if not
enough resources in total were specified in the header of the batch script.

## Exclusive Jobs for Benchmarking

Jobs ZIH systems run, by default, in shared-mode, meaning that multiple jobs (from different users)
can run at the same time on the same compute node. Sometimes, this behavior is not desired (e.g.
for benchmarking purposes). Thus, the Slurm parameter `--exclusive` request for exclusive usage of
resources.

Setting `--exclusive` **only** makes sure that there will be **no other jobs running on your nodes**.
It does not, however, mean that you automatically get access to all the resources which the node
might provide without explicitly requesting them, e.g. you still have to request a GPU via the
generic resources parameter (`gres`) to run on the partitions with GPU, or you still have to
request all cores of a node if you need them. CPU cores can either to be used for a task
(`--ntasks`) or for multi-threading within the same task (`--cpus-per-task`). Since those two
options are semantically different (e.g., the former will influence how many MPI processes will be
spawned by `srun` whereas the latter does not), Slurm cannot determine automatically which of the
two you might want to use. Since we use cgroups for separation of jobs, your job is not allowed to
use more resources than requested.*

If you just want to use all available cores in a node, you have to specify how Slurm should organize
them, like with `-p haswell -c 24` or `-p haswell --ntasks-per-node=24`.

Here is a short example to ensure that a benchmark is not spoiled by other jobs, even if it doesn't
use up all resources in the nodes:

!!! example "Exclusive resources"

    ```Bash
    #!/bin/bash
    #SBATCH -p haswell
    #SBATCH --nodes=2
    #SBATCH --ntasks-per-node=2
    #SBATCH --cpus-per-task=8
    #SBATCH --exclusive    # ensure that nobody spoils my measurement on 2 x 2 x 8 cores
    #SBATCH --time=00:10:00
    #SBATCH -J Benchmark
    #SBATCH --mail-user=your.name@tu-dresden.de

    srun ./my_benchmark
    ```

## Array Jobs

Array jobs can be used to create a sequence of jobs that share the same executable and resource
requirements, but have different input files, to be submitted, controlled, and monitored as a single
unit. The option is `-a, --array=<indexes>` where the parameter `indexes` specifies the array
indices. The following specifications are possible

* comma separated list, e.g., `--array=0,1,2,17`,
* range based, e.g., `--array=0-42`,
* step based, e.g., `--array=0-15:4`,
* mix of comma separated and range base, e.g., `--array=0,1,2,16-42`.

A maximum number of simultaneously running tasks from the job array may be specified using the `%`
separator. The specification `--array=0-23%8` limits the number of simultaneously running tasks from
this job array to 8.

Within the job you can read the environment variables `SLURM_ARRAY_JOB_ID` and
`SLURM_ARRAY_TASK_ID` which is set to the first job ID of the array and set individually for each
step, respectively.

Within an array job, you can use `%a` and `%A` in addition to `%j` and `%N` to make the output file
name specific to the job:

* `%A` will be replaced by the value of `SLURM_ARRAY_JOB_ID`
* `%a` will be replaced by the value of `SLURM_ARRAY_TASK_ID`

!!! example "Job file using job arrays"

    ```Bash
    #!/bin/bash
    #SBATCH --array 0-9
    #SBATCH -o arraytest-%A_%a.out
    #SBATCH -e arraytest-%A_%a.err
    #SBATCH --ntasks=864
    #SBATCH --time=08:00:00
    #SBATCH -J Science1
    #SBATCH --mail-type=end
    #SBATCH --mail-user=your.name@tu-dresden.de

    echo "Hi, I am step $SLURM_ARRAY_TASK_ID in this array job $SLURM_ARRAY_JOB_ID"
    ```

!!! note

    If you submit a large number of jobs doing heavy I/O in the Lustre filesystems you should limit
    the number of your simultaneously running job with a second parameter like:

    ```Bash
    #SBATCH --array=1-100000%100
    ```

Please read the Slurm documentation at https://slurm.schedmd.com/sbatch.html for further details.

## Chain Jobs

You can use chain jobs to create dependencies between jobs. This is often the case if a job relies
on the result of one or more preceding jobs. Chain jobs can also be used if the runtime limit of the
batch queues is not sufficient for your job. Slurm has an option
`-d, --dependency=<dependency_list>` that allows to specify that a job is only allowed to start if
another job finished.

Here is an example of how a chain job can look like, the example submits 4 jobs (described in a job
file) that will be executed one after each other with different CPU numbers:

!!! example "Script to submit jobs with dependencies"

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

## Array-Job with Afterok-Dependency and Datamover Usage

This part is under construction.
