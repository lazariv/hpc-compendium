# Slurm

The HRSK-II systems are operated with the batch system Slurm. Just specify the resources you need
in terms of cores, memory, and time and your job will be placed on the system.

## Job Submission

Job submission can be done with the command: `srun [options] <command>`

However, using srun directly on the shell will be blocking and launch an interactive job. Apart from
short test runs, it is recommended to launch your jobs into the background by using batch jobs. For
that, you can conveniently put the parameters directly in a job file which you can submit using
`sbatch [options] <job file>`

Some options of `srun/sbatch` are:

| slurm option                           | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                |
|:---------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| -n \<N> or --ntasks \<N>               | set a number of tasks to N(default=1). This determines how many processes will be spawned by srun (for MPI jobs).                                                                                                                                                                                                                                                                                                                                          |
| -N \<N> or --nodes \<N>                | set number of nodes that will be part of a job, on each node there will be --ntasks-per-node processes started, if the option --ntasks-per-node is not given, 1 process per node will be started                                                                                                                                                                                                                                                           |
| --ntasks-per-node \<N>                 | how many tasks per allocated node to start, as stated in the line before                                                                                                                                                                                                                                                                                                                                                                                   |
| -c \<N> or --cpus-per-task \<N>        | this option is needed for multithreaded (e.g. OpenMP) jobs, it tells SLURM to allocate N cores per task allocated; typically N should be equal to the number of threads you program spawns, e.g. it should be set to the same number as OMP_NUM_THREADS                                                                                                                                                                                                    |
| -p \<name> or --partition \<name>      | select the type of nodes where you want to execute your job, on Taurus we currently have haswell, `smp`, `sandy`, `west`, ml and `gpu` available                                                                                                                                                                                                                                                                                                           |
| --mem-per-cpu \<name>                  | specify the memory need per allocated CPU in MB                                                                                                                                                                                                                                                                                                                                                                                                            |
| --time \<HH:MM:SS>                     | specify the maximum runtime of your job, if you just put a single number in, it will be interpreted as minutes                                                                                                                                                                                                                                                                                                                                             |
| --mail-user \<your email>              | tell the batch system your email address to get updates about the status of the jobs                                                                                                                                                                                                                                                                                                                                                                       |
| --mail-type ALL                        | specify for what type of events you want to get a mail; valid options beside ALL are: BEGIN, END, FAIL, REQUEUE                                                                                                                                                                                                                                                                                                                                            |
| -J \<name> or --job-name \<name>       | give your job a name which is shown in the queue, the name will also be included in job emails (but cut after 24 chars within emails)                                                                                                                                                                                                                                                                                                                      |
| --no-requeue                           | At node failure, jobs are requeued automatically per default. Use this flag to disable requeueing.                                                                                                                                                                                                                                                                                                                                                         |
| --exclusive                            | tell SLURM that only your job is allowed on the nodes allocated to this job; please be aware that you will be charged for all CPUs/cores on the node                                                                                                                                                                                                                                                                                                       |
| -A \<project>                          | Charge resources used by this job to the specified project, useful if a user belongs to multiple projects.                                                                                                                                                                                                                                                                                                                                                 |
| -o \<filename> or --output \<filename> | \<p>specify a file name that will be used to store all normal output (stdout), you can use %j (job id) and %N (name of first node) to automatically adopt the file name to the job, per default stdout goes to "slurm-%j.out"\</p> \<p>%RED%NOTE:<span class="twiki-macro ENDCOLOR"></span> the target path of this parameter must be writeable on the compute nodes, i.e. it may not point to a read-only mounted file system like /projects.\</p>        |
| -e \<filename> or --error \<filename>  | \<p>specify a file name that will be used to store all error output (stderr), you can use %j (job id) and %N (name of first node) to automatically adopt the file name to the job, per default stderr goes to "slurm-%j.out" as well\</p> \<p>%RED%NOTE:<span class="twiki-macro ENDCOLOR"></span> the target path of this parameter must be writeable on the compute nodes, i.e. it may not point to a read-only mounted file system like /projects.\</p> |
| -a or --array                          | submit an array job, see the extra section below                                                                                                                                                                                                                                                                                                                                                                                                           |
| -w \<node1>,\<node2>,...               | restrict job to run on specific nodes only                                                                                                                                                                                                                                                                                                                                                                                                                 |
| -x \<node1>,\<node2>,...               | exclude specific nodes from job                                                                                                                                                                                                                                                                                                                                                                                                                            |

The following example job file shows how you can make use of sbatch

```Bash
#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --output=simulation-m-%j.out
#SBATCH --error=simulation-m-%j.err
#SBATCH --ntasks=512
#SBATCH -A myproject

echo Starting Program
```

During runtime, the environment variable SLURM_JOB_ID will be set to the id of your job.

You can also use our [Slurm Batch File Generator]**todo** Slurmgenerator, which could help you create
basic SLURM job scripts.

Detailed information on [memory limits on Taurus]**todo**

### Interactive Jobs

Interactive activities like editing, compiling etc. are normally limited to the login nodes. For
longer interactive sessions you can allocate cores on the compute node with the command "salloc". It
takes the same options like `sbatch` to specify the required resources.

The difference to LSF is, that `salloc` returns a new shell on the node, where you submitted the
job. You need to use the command `srun` in front of the following commands to have these commands
executed on the allocated resources. If you allocate more than one task, please be aware that srun
will run the command on each allocated task!

An example of an interactive session looks like:

```Shell Session
tauruslogin3 /home/mark; srun --pty -n 1 -c 4 --time=1:00:00 --mem-per-cpu=1700 bash<br />srun: job 13598400 queued and waiting for resources<br />srun: job 13598400 has been allocated resources
taurusi1262 /home/mark;   # start interactive work with e.g. 4 cores.
```

**Note:** A dedicated partition `interactive` is reserved for short jobs (< 8h) with not more than
one job per user. Please check the availability of nodes there with `sinfo -p interactive` .

### Interactive X11/GUI Jobs

SLURM will forward your X11 credentials to the first (or even all) node
for a job with the (undocumented) --x11 option. For example, an
interactive session for 1 hour with Matlab using eigth cores can be
started with:

```Shell Session
module load matlab
srun --ntasks=1 --cpus-per-task=8 --time=1:00:00 --pty --x11=first matlab
```

**Note:** If you are getting the error:

```Bash
srun: error: x11: unable to connect node taurusiXXXX
```

that probably means you still have an old host key for the target node in your `\~/.ssh/known_hosts`
file (e.g. from pre-SCS5). This can be solved either by removing the entry from your known_hosts or
by simply deleting the known_hosts file altogether if you don't have important other entries in it.

### Requesting an Nvidia K20X / K80 / A100

SLURM will allocate one or many GPUs for your job if requested. Please note that GPUs are only
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
partition `gpu-interactive`. SLURM will automatically select the right partition if the partition
parameter (-p) is omitted.

**Note:** Due to an unresolved issue concering the SLURM job scheduling behavior, it is currently
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
taurus (smp island). Using --cpus-per-task N SLURM will start one task and you will have N CPUs
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

#### Multiple Programms Running Simultaneously in a Job

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
case it can be turned off by specifying the SLURM parameter: `--exclusive` .

Setting `--exclusive` **only** makes sure that there will be **no other jobs running on your nodes**.
It does not, however, mean that you automatically get access to all the resources which the node
might provide without explicitly requesting them, e.g. you still have to request a GPU via the
generic resources parameter (gres) to run on the GPU partitions, or you still have to request all
cores of a node if you need them. CPU cores can either to be used for a task (`--ntasks`) or for
multi-threading within the same task (--cpus-per-task). Since those two options are semantically
different (e.g., the former will influence how many MPI processes will be spawned by 'srun' whereas
the latter does not), SLURM cannot determine automatically which of the two you might want to use.
Since we use cgroups for separation of jobs, your job is not allowed to use more resources than
requested.*

If you just want to use all available cores in a node, you have to
specify how Slurm should organize them, like with \<span>"-p haswell -c
24\</span>" or "\<span>-p haswell --ntasks-per-node=24". \</span>

Here is a short example to ensure that a benchmark is not spoiled by
other jobs, even if it doesn't use up all resources in the nodes:

```Bash
#!/bin/bash
#SBATCH -J Benchmark<br />#SBATCH -p haswell<br />#SBATCH --nodes=2<br />#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=8<br />#SBATCH --exclusive    # ensure that nobody spoils my measurement on 2 x 2 x 8 cores<br />#SBATCH --mail-user=your.name@tu-dresden.de
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
batch queues is not sufficient for your job. SLURM has an option `-d` or "--dependency" that allows
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

### Binding and Distribution of Tasks

The SLURM provides several binding strategies to place and bind the tasks and/or threads of your job
to cores, sockets and nodes. Note: Keep in mind that the distribution method has a direct impact on
the execution time of your application. The manipulation of the distribution can either speed up or
slow down your application. More detailed information about the binding can be found
[here](BindingAndDistributionOfTasks.md).

The default allocation of the tasks/threads for OpenMP, MPI and Hybrid (MPI and OpenMP) are as
follows.

#### OpenMP

The illustration below shows the default binding of a pure OpenMP-job on 1 node with 16 cpus on
which 16 threads are allocated.

```Bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=16

export OMP_NUM_THREADS=16

srun --ntasks 1 --cpus-per-task $OMP_NUM_THREADS ./application
```

\<img alt=""
src="data:;base64,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"
/>

#### MPI

The illustration below shows the default binding of a pure MPI-job. In
which 32 global ranks are distributed onto 2 nodes with 16 cores each.
Each rank has 1 core assigned to it.

```Bash
#!/bin/bash
#SBATCH --nodes=2
#SBATCH --tasks-per-node=16
#SBATCH --cpus-per-task=1

srun --ntasks 32 ./application
```

\<img alt=""
src="data:;base64,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v++++77//nv52DVr1hhclJaWyscajUbX2MjIyI6ODsnYy5cv5+XlxcfHT5gw4fe//73XQFF+ZPIm2kcmb6JYPXkLZh7y6bUOiGJl6oBoncqsfVGszNr3vI/nte8h1muuRLEyuRLNWz1/v8gQ3V+ZOiCKlakDolzJrH1RrMzaF8XKrH1RrEyuRLEyuRJdl56/X7xQdRAdoaioKDMzs7Ky0mKxzJ8/f8WKFfKxa9euPXbsWGNj44kTJyZPnrx582b5WM327dsXLVqkKEptba18bFlZmdFo/Otf/1pXV1dTU3Ps2DH52AceeOAXv/jFjz/+aLfbV69efeONN3qO/eijj959990dO3YkJSW57iPKm0ysKG8ysRr3vOmZIaJYz2PwHPv5559XVlY2NzdXVVXdf//9OTk58rGrV68uLCxs+Z+uri75WLvd7gzMzc1dvny5fOxtt9324IMP2my2q1evzp0798knn/QcK8qPaLtMrChvMrGivOmvHoEnc72iOiATK6oDrrGidSqz9kWxMmvfc131vPZFsTK5EsXK5Eo0b2Vy5SuZ+yuqAzKxojogkyuZtS+KlVn7oliZtS+KlcmVKFYmV6LrksmVfwalVUpMTHzrrbe0P5eXl4eHh1+7dk0y1tWWLVsWLFggf15VVb/55puMjIwvvvhC8bFVysnJeeaZZzyPRxSbkZGxd+9e7c/l5eVhYWHd3d1eY0tKSvrcTlHeZGJdueZNMrbfvA1U6XHnefxez9vZ2Zmfn3/PPffIx65evdrv++vU0NAQGRl5+PBhydgrV64oilJRUaH9ePDgQaPR2NHR4TVWlB/37T7NjT55k4kV5U1/6Qk8mesV1QGZWFEdEOXKdZ3Kr333WNF2yVif1r5rrHyu3GN9ylWfeetrrmT4tI761AGvsR7qgPz9lVn7olhVYu27x/q69vs9r9dc9Yn1NVf9/l0gnyt5A/8GXF1dXX19/cyZM7UfZ82a1d3d/e233/pxqOPHj8+aNUt+/56ent/97nevvfZadHS0TydyOByff/55T0/PddddFxcXt2jRoq+++ko+PC8vr6SkpL6+vrm5+c033/zNb34zatQonwaghGbeAq+4uDg5OTk6Ovrrr7/++9//7mvs5MmTb7311h07dnR1dflx9rfffjstLe3nP/+55P7OJepkt9t9et9woAxt3kJFgOuAc536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"
/>

#### Hybrid (MPI and OpenMP)

In the illustration below the default binding of a Hybrid-job is shown.
In which 8 global ranks are distributed onto 2 nodes with 16 cores each.
Each rank has 4 cores assigned to it.

```Bash
#!/bin/bash
#SBATCH --nodes=2
#SBATCH --tasks-per-node=4
#SBATCH --cpus-per-task=4

export OMP_NUM_THREADS=4

srun --ntasks 8 --cpus-per-task $OMP_NUM_THREADS ./application
```

\<img alt=""
src="data:;base64,iVBORw0KGgoAAAANSUhEUgAAAvoAAADyCAIAAACzsfbGAAAABmJLR0QA/wD/AP+gvaeTAAAgAElEQVR4nO3de1iUdf7/8XsQA+SoDgdhZHA4CaUlpijmYdXooJvrsbxqzXa1dCsPbFlt5qF2O2xbXV52bdtlV25c7iVrhrVXWVaEupJ2gjxUYAIDgjgcZJCDIIf7+8f9a36zjCAwM/eMn3k+/oJ77rnf9z3z5u1r7hnn1siyLAEAAIjLy9U7AAAA4FzEHQAAIDjiDgAAEBxxBwAACI64AwAABEfcAQAAgiPuAAAAwRF3AACA4Ig7AABAcMQdAAAgOOIOAAAQHHEHAAAIjrgDAAAER9wBAACCI+4AAADBEXcAAIDgiDsAAEBwxB0AACA44g4AABCctz131mg0jtoPANccWZZVrsjMATyZPTOHszsAAEBwdp3dUaj/Cg+Aa7n2LAszB/A09s8czu4AAADBEXcAAIDgiDsAAEBwxB0AACA44g4AABAccQcAAAiOuAMAAARH3AEAAIIj7gAAAMERdwAAgOCIOwAAQHDEHQAAIDjiDgAAEBxxBwAACI64AwAABEfcAQAAgiPuAAAAwRF3AACA4Ig7AABAcMQdAAAgOOIOAAAQHHEHAAAIjrgDAAAER9zxXDNmzNBoNF9++aVlSURExPvvv9/3LXz//fcBAQF9Xz8zMzMtLc3f3z8iIqIfOwpACOrPnPXr1ycnJw8ZMiQ6OnrDhg2XL1/ux+5CLMQdjzZ8+PDHH39ctXJarXbdunVbtmxRrSIAt6LyzGlqanrzzTfPnj2blZWVlZW1efNm1UrD3RB3PNqKFSuKi4vfe+8925uqqqoWL14cFham0+keeeSRlpYWZfnZs2dvu+22kJCQG264IS8vz7L+xYsXV69ePXLkyNDQ0Hvuuae2ttZ2m3feeeeSJUtGjhzppMMB4OZUnjk7duyYOnXq8OHD09LSHnjgAeu7w9MQdzxaQEDAli1bnnrqqfb29m43LVy4cPDgwcXFxd9++21+fn5GRoayfPHixTqd7vz58/v37//HP/5hWf/ee+81mUwFBQXl5eXBwcHLly9X7SgAXCtcOHOOHDkyfvx4hx4NrimyHezfAlxo+vTpzz33XHt7++jRo7dv3y7Lcnh4+L59+2RZLiwslCSpurpaWTMnJ8fX17ezs7OwsFCj0Vy4cEFZnpmZ6e/vL8tySUmJRqOxrN/Q0KDRaMxm8xXr7t69Ozw83NlHB6dy1d8+M+ea5qqZI8vypk2bRo0aVVtb69QDhPPY/7fvrXa8gpvx9vZ+8cUXV65cuWzZMsvCiooKf3//0NBQ5VeDwdDa2lpbW1tRUTF8+PChQ4cqy+Pj45UfjEajRqOZMGGCZQvBwcGVlZXBwcFqHQeAa4P6M+fZZ5/dtWtXbm7u8OHDnXVUcHvEHUjz5s175ZVXXnzxRcsSnU7X3NxcU1OjTB+j0ejj46PVaqOiosxmc1tbm4+PjyRJ58+fV9aPjo7WaDTHjx8n3wC4KjVnzpNPPpmdnX3o0CGdTue0A8I1gM/uQJIk6eWXX962bVtjY6Pya0JCwqRJkzIyMpqamkwm08aNG++//34vL6/Ro0ePGzfutddekySpra1t27ZtyvqxsbHp6ekrVqyoqqqSJKmmpmbv3r22VTo7O1tbW5X37FtbW9va2lQ6PABuRp2Zs2bNmuzs7AMHDmi12tbWVv4juicj7kCSJCk1NXXOnDmW/wqh0Wj27t3b0tIyatSocePGjR079tVXX1Vuevfdd3NyclJSUmbOnDlz5kzLFnbv3h0ZGZmWlhYYGDhp0qQjR47YVtmxY4efn9+yZctMJpOfnx8nlgGPpcLMMZvN27dv//nnnw0Gg5+fn5+fX3JysjpHBzeksXwCaCB31mgkSbJnCwCuRa7622fmAJ7J/r99zu4AAADBEXcAAIDgiDsAAEBwxB0AACA44g4AABAccQcAAAiOuAMAAARH3AEAAIIj7gAAAMERdwAAgOCIOwAAQHDEHQAAIDjiDgAAEBxxBwAACI64AwAABEfcAQAAgiPuAAAAwRF3AACA4Ig7AABAcMQdAAAgOOIOAAAQHHEHAAAIjrgDAAAER9wBAACCI+4AAADBedu/CY1GY/9GAKCPmDkA+ouzOwAAQHAaWZZdvQ8AAABOxNkdAAAgOOIOAAAQHHEHAAAIjrgDAAAER9wBAACCI+4AAADB2fU1g3zZlycY2FcV0BueQP2vsaCvPAEzBz2xZ+ZwdgcAAAjOAReR4IsKRWX/qyV6Q1SufSVNX4mKmYOe2N8bnN0BAACCI+4AAADBEXcAAIDgiDsAAEBwxB0AACA44g4AABAccQcAAAiOuAMAAARH3AEAAIIj7gAAAMERdwAAgOCIOwAAQHDEHQAAIDjx486PP/7461//WqvVDhkyZPTo0U888cQANjJ69Oj333+/jyvfdNNNWVlZV7wpMzMzLS3N398/IiJiALsBx3Kr3li/fn1ycvKQIUOio6M3bNhw+fLlAewM3IFb9RUzx624VW942swRPO50dXXdfvvtkZGRJ0+erK2tzcrKMhgMLtwfrVa7bt26LVu2uHAfoHC33mhqanrzzTfPnj2blZWVlZW1efNmF+4MBszd+oqZ4z7crTc8bubIdrB/C8529uxZSZJ+/PFH25vOnTu3aNGi0NDQqKiohx9+uLm5WVleX1+/evXq6OjowMDAcePGFRYWyrKcmJi4b98+5dbp06cvW7bs8uXLDQ0Nq1at0ul0Wq327rvvrqmpkWX5kUceGTx4sFar1ev1y5Ytu+Je7d69Ozw83FnH7Dj2PL/0xsB6Q7Fp06apU6c6/pgdx1XPL33FzHHGfdXhnr2h8ISZI/jZncjIyISEhFWrVv373/8uLy+3vmnhwoWDBw8uLi7+9ttv8/PzMzIylOVLly4tKys7evSo2Wx+5513AgMDLXcpKyubMmXKLbfc8s477wwePPjee+81mUwFBQXl5eXBwcHLly+XJGn79u3Jycnbt283Go3vvPOOiseK/nHn3jhy5Mj48eMdf8xwPnfuK7iWO/eGR8wc16YtFZhMpieffDIlJcXb2zsuLm737t2yLBcWFkqSVF1drayTk5Pj6+vb2dlZXFwsSVJlZWW3jSQmJj7zzDM6ne7NN99UlpSUlGg0GssWGhoaNBqN2WyWZfnGG29UqvSEV1puwg17Q5blTZs2jRo1qra21oFH6nCuen7pK2aOM+6rGjfsDdljZo74cceisbHxlVde8fLyOnHixOeff+7v72+5qbS0VJIkk8mUk5MzZMgQ2/smJiaGh4enpqa2trYqS7744gsvLy+9lZCQkB9++EFm9Nh9X/W5T29s3brVYDAYjUaHHp/jEXf6wn36ipnjbtynNzxn5gj+Zpa1gICAjIwMX1/fEydO6HS65ubmmpoa5Saj0ejj46O8wdnS0lJVVWV7923btoWGht51110tLS2SJEVHR2s0muPHjxt/UV9fn5ycLEmSl5cHPapicJPeePLJJ3ft2nXo0CG9Xu+Eo4Ta3KSv4IbcpDc8auYI/kdy/vz5xx9/vKCgoLm5+cKFCy+88EJ7e/uECRMSEhImTZqUkZHR1NRkMpk2btx4//33e3l5xcbGpqenP/jgg1VVVbIsnzp1ytJqPj4+2dnZQUFBd9xxR2Njo7LmihUrlBVqamr27t2rrBkREVFUVHTF/ens7GxtbW1vb5ckqbW1ta2tTZWHAVfgbr2xZs2a7OzsAwcOaLXa1tZW4f9TqKjcra+YOe7D3XrD42aOa08uOVtDQ8PKlSvj4+P9/PxCQkKmTJny0UcfKTdVVFQsWLBAq9WOGDFi9erVTU1NyvILFy6sXLkyKioqMDAwJSWlqKhItvokfEdHx29/+9uJEydeuHDBbDavWbMmJiYmICDAYDCsXbtW2cLBgwfj4+NDQkIWLlzYbX/eeOMN6wff+gSmG7Ln+aU3+tUb9fX13f4wY2Nj1Xss+s9Vzy99xcxxxn3V4Va94YEzR2PZygBoNBql/IC3AHdmz/NLb4jNVc8vfSU2Zg56Yv/zK/ibWQAAAMQdAAAgOOIOAAAQHHEHAAAIjrgDAAAER9wBAACCI+4AAADBEXcAAIDgiDsAAEBwxB0AACA44g4AABAccQcAAAiOuAMAAARH3AEAAILztn8TymXZAVv0BpyBvkJP6A30hLM7AABAcBpZll29DwAAAE7E2R0AACA44g4AABAccQcAAAiOuAMAAARH3AEAAIIj7gAAAMERdwAAgODs+lZlvr/SEwzsm5noDU+g/rd20VeegJmDntgzczi7AwAABOeAa2bxvcyisv/VEr0hKte+kqavRMXMQU/s7w3O7gAAAMERdwAAgOCIOwAAQHDEHQAAIDjiDgAAEBxxBwAACI64AwAABEfcAQAAghM27uTl5c2ZM2fYsGH+/v5jxozZuHFjc3OzCnU7OjrWrFkzbNiwoKCge++99+LFi1dcLSAgQGPFx8enra1Nhd3zWK7qB5PJtGTJEq1WGxIScttttxUVFV1xtczMzLS0NH9//4iICOvly5cvt+6TrKwsFfYZA8PMgTVmjrsRM+785z//mTVr1o033nj06NHq6updu3ZVV1cfP368L/eVZbm9vX3Apbdu3XrgwIFvv/32zJkzZWVlq1atuuJqJpOp8RcLFiyYP3++j4/PgIuidy7sh9WrV5vN5tOnT1dWVo4YMWLx4sVXXE2r1a5bt27Lli22N2VkZFhaZdGiRQPeEzgVMwfWmDnuSLaD/Vtwhs7OTp1Ol5GR0W15V1eXLMvnzp1btGhRaGhoVFTUww8/3NzcrNyamJi4cePGW265JSEhITc3t6GhYdWqVTqdTqvV3n333TU1Ncpqr776ql6vDw4OHjFixHPPPWdbPSws7O2331Z+zs3N9fb2rq+v72Vva2pqfHx8vvjiCzuP2hnseX7dpzdc2w+xsbFvvfWW8nNubq6Xl1dHR0dPu7p79+7w8HDrJffff/8TTzwx0EN3Ilc9v+7TV9aYOY7CzGHm9MQBicW15Z1BSdAFBQVXvHXy5MlLly69ePFiVVXV5MmTH3roIWV5YmLiDTfcUFtbq/w6d+7c+fPn19TUtLS0PPjgg3PmzJFluaioKCAg4Oeff5Zl2Ww2f/fdd902XlVVZV1aOaucl5fXy96+/PLL8fHxdhyuE4kxelzYD7Isb9iwYdasWSaTqaGh4b777luwYEEvu3rF0TNixAidTjd+/PiXXnrp8uXL/X8AnIK4Y42Z4yjMHGZOT4g7V/D5559LklRdXW17U2FhofVNOTk5vr6+nZ2dsiwnJia+/vrryvKSkhKNRmNZraGhQaPRmM3m4uJiPz+/PXv2XLx48YqlT58+LUlSSUmJZYmXl9fHH3/cy94mJCS8/PLL/T9KNYgxelzYD8rK06dPVx6NpKSk8vLyXnbVdvQcOHDgyy+//Pnnn/fu3RsVFWX7etFViDvWmDmOwsxRljNzbNn//Ar42Z3Q0FBJkiorK21vqqio8Pf3V1aQJMlgMLS2ttbW1iq/RkZGKj8YjUaNRjNhwoSYmJiYmJixY8cGBwdXVlYaDIbMzMy///3vERER06ZNO3ToULftBwYGSpLU0NCg/NrY2NjV1RUUFPTPf/7T8skv6/Vzc3ONRuPy5csddeyw5cJ+kGV59uzZBoPhwoULTU1NS5YsueWWW5qbm3vqB1vp6emTJ0+Oi4tbuHDhSy+9tGvXLnseCjgJMwfWmDluyrVpyxmU903/+Mc/dlve1dXVLVnn5ub6+PhYkvW+ffuU5WfOnBk0aJDZbO6pREtLy/PPPz906FDlvVhrYWFhO3fuVH4+ePBg7++j33333ffcc0//Dk9F9jy/7tMbLuyHmpoayeaNhmPHjvW0HdtXWtb27NkzbNiw3g5VRa56ft2nr6wxcxyFmaMsZ+bYckBicW15J/nggw98fX2feeaZ4uLi1tbWU6dOrV69Oi8vr6ura9KkSffdd19jY+P58+enTJny4IMPKnexbjVZlu+4445FixadO3dOluXq6up3331XluWffvopJyentbVVluUdO3aEhYXZjp6NGzcmJiaWlJSYTKapU6cuXbq0p52srq6+7rrr3PMDgwoxRo/s0n7Q6/UrV65saGi4dOnSs88+GxAQcOHCBds97OjouHTpUmZmZnh4+KVLl5RtdnZ2vvXWW0aj0Ww2Hzx4MDY21vI2v8sRd7ph5jgEM8eyBWZON8SdHh05cuSOO+4ICQkZMmTImDFjXnjhBeUD8BUVFQsWLNBqtSNGjFi9enVTU5OyfrdWM5vNa9asiYmJCQgIMBgMa9eulWU5Pz9/4sSJQUFBQ4cOTU1NPXz4sG3dy5cvP/rooyEhIQEBAUuXLm1oaOhpD//617+67QcGFcKMHtl1/XD8+PH09PShQ4cGBQVNnjy5p39p3njjDetzrv7+/rIsd3Z2zp49e/jw4dddd53BYHjqqadaWloc/sgMDHHHFjPHfswcy92ZOd3Y//xqLFsZAOVdQHu2AHdmz/NLb4jNVc8vfSU2Zg56Yv/zK+BHlQEAAKwRdwAAgOCIOwAAQHDEHQAAIDjiDgAAEBxxBwAACI64AwAABEfcAQAAgiPuAAAAwXnbv4mrXmEVHovegDPQV+gJvYGecHYHAAAIzq5rZgEAALg/zu4AAADBEXcAAIDgiDsAAEBwxB0AACA44g4AABAccQcAAAiOuAMAAARn17cq8/2VnmBg38xEb3gC9b+1i77yBMwc9MSemcPZHQAAIDgHXDPLVa/wqKtOXXt42mPlaXVdxdMeZ0+raw9Pe6w8ra49OLsDAAAER9wBAACCI+4AAADBEXcAAIDgiDsAAEBwxB0AACA44g4AABCcw+KO2Wz29vaOiYnR6/V/+MMf+v6f8o1G4+zZs3u69cMPPzQYDDExMZmZmWrWnT9/fkhIyKJFi3pawRl1S0tLZ86cGRUVlZSU9Mknn6hWt6WlJSUlRafT6fX6bdu29XGDfUdv2F9X1N6wh5OeX0mSWlpa9Hr9unXr1Kzr7++v0+l0Ot3ixYvVrHv27NmZM2eGhYUlJSW1traqU7egoED3C29v77y8vD5us4/oDYfUFa03ZDtYb6G+vj4qKkqW5dbW1gkTJnz88cd93EhpaemsWbOueFN7e7vBYDAajTU1NdHR0Q0NDerUlWU5Nzc3Ozt74cKF1gudXbe4uPjo0aOyLJ86dSo8PLyzs1Oduh0dHefPn5dlua6uLjIyUvm5W93+ojccW1ek3rCHCs+vLMsbN25cvHjx2rVr1ayr1+ttF6pQd/bs2Tt27JBluby8vL29XbW6ipqamhEjRnR0dNjW7S96w+F1hekNhePfzPLx8Zk4ceKZM2ckSWpra5s1a1ZKSsq4ceMOHTokSZLRaExNTX3ooYduvfXWRx991PqOeXl5kydPrqmpsSz5+uuvExIS9Hq9VqudMWNGTk6OOnUlSZoxY0ZgYKDKx2swGCZNmiRJ0vXXXy9JUnNzszp1Bw0aFB4eLklSR0dHQECAn59fXw58AOgNesMZHPv8lpSU/Pjjj3feeafKdV1yvKWlpUajccWKFZIkjRw50tu7t+/Zd8bxvvfee3fdddegQYMG9lBcFb1Bb/x/9mQl6y1YUt7FixfHjh2bm5sry3JnZ2d9fb0sy1VVVWlpabIsl5aWBgcH19TUyLI8bdq0kpISJeXl5eWlpqaaTCbr7b/77ru///3vlZ//9Kc/bd++XZ26is8++6wvr+AdXleW5U8//XTKlClq1m1oaIiOjh40aNAbb7xxxbr9RW84o64sRG/YQ4XjXbhwYWFh4c6dO6/6Ct6xdQMCAgwGw/jx4z/55BPV6n766aczZsyYP3/+TTfdtHnzZjWPVzFz5sycnJwr1u0vesOxdUXqjf+3Bbvu/L+HPWjQIL1ef9111y1btkxZ2NXV9fTTT6elpU2fPj04OFiW5dLS0mnTpim3rly5Mjc3t7S0VK/XjxkzxnKe3KKP/6Q5vK7iqv+kOaluWVlZUlLSTz/9pHJd5V6jRo0qLy+3rdtf9Aa94QzOPt5PPvlk/fr1siz3/k+aMx5no9Eoy3J+fn5kZGRdXZ06dT/++GNfX9/CwsJLly5NnTrV8maEOn1lMpkiIyMt71bI7j1z6A3Vjld2dG8oHPlmVkREhNFoLCsr++qrr3744QdJkvbv319cXHzo0KGDBw/6+voqqw0ePFj5wcvLq6OjQ5KksLAwPz+/EydOdNtgZGTkuXPnlJ8rKysjIyPVqeuq45UkyWw233XXXdu3bx89erSadRUxMTGpqamnTp3q/4NxFfQGveEMDj/eY8eO7dmzJyYm5rHHHnv77befffZZdepKkqTX6yVJGjduXHJy8unTp9WpGxUVlZiYmJiY6Ovre+utt548eVK145Uk6b333ps3b56T3smiN+iNbhz/2Z2IiIgtW7Zs3bpVkqT6+nqDweDt7f3111+bTKae7hIUFPTBBx889thj33zzjfXyiRMnFhUVlZeX19XV5ebm9v6BeQfW7RcH1r18+fKCBQvWr18/a9YsNetWVVUp0aGiouLYsWPJyclXrT4w9Aa94QwOPN7NmzdXVFQYjca//e1vv/vd7zZt2qRO3bq6ugsXLkiSVFRUdOrUqdjYWHXq3nDDDV1dXRUVFZ2dnf/973+TkpLUqavYs2fPkiVLeqloP3qD3rBwyvfuLF68+MSJE4WFhfPmzfv666+XLl36r3/9Kzo6upe7REREZGdnP/DAA0VFRZaF3t7er7322owZM1JSUrZu3RoUFKROXUmSbrvttqVLl+7fv1+n0xUUFKhT9/PPPz98+PDTTz+t/B88o9GoTt26urrZs2dHRUXNmjXrz3/+s/JKwknoDXrDGRz4/Lqk7tmzZ1NTU6Oion7zm9+8/vrroaGh6tTVaDTbtm1LT09PSkq6/vrr586dq05dSZJMJtPp06enTZvWe0X70Rv0hkJjeUtsIHfWaCRJsmcL1BW17rW4z9SlLnWv3brX4j5TV826fKsyAAAQHHEHAAAIjrgDAAAEp17c6eUKR1e9CNGAlfZ8pSEVLgbU09VVrnoBFHv0dJUTZ1+kxh5/+ctf4uPj4+Li1q9fb3tTQkJCQkLCvn377Kxi22b96skBd2m3O/bSk7Yr29OlV9zhnnrSdmWndqk6mDkWzJxumDk9rSzyzLHnS3v6vgXbKxw1NDR0dXUpt17xIkQOqWt7pSFL3Z4uBuSQugrrq6tYH+8VL4DiqLrdrnJiXVfR7UIkjqo74PuePXtWr9e3tLS0t7enpKR88803ln3+7rvvbrrppkuXLtXV1SmT1J663dqsvz3Ze5f2vW4vPWm78lW7tO91FT31pO3KvXep/dNjYJg5vWPm9GVNZo5nzhyVzu7YXuFo7NixlZWVyq19vwhRf9leachS19kXA+p2dRXr43WeUpurnNjWdfZFavorICDA19e3ra1NuQTd8OHDLftcWFiYmprq6+s7bNiwkSNHHj582J5C3dqsvz054C7tdsdeetJ2ZXu61HaHe+lJ5/0Nugozh5nTE2aOZ84cleLOuXPnoqKilJ91Ol1lZWVWVtZVvz/AgT777LO4uLjAwEDruhcvXtTr9ZGRkevXr7/qF7f014YNG55//nnLr9Z16+rqYmNjb7755gMHDji26JkzZ3Q63YIFC8aNG7dly5ZudRUqfLVXv4SEhGRkZERHR0dGRs6bN2/UqFGWfR4zZsyRI0caGxvPnz+fn5/v2Nntnj1py4Fd2ktP2nJel6rDPZ9fZo47YOZ45szp7RqnTqWETXWUl5evXbs2Ozu7W92goKCysjKj0Thz5sw5c+aMHDnSURUPHDgQHR2dmJh49OhRZYl13VOnTun1+oKCgrlz5548eXLYsGGOqtvZ2Xns2LHvv/9er9enp6dPmjTp9ttvt16hurq6sLBw+vTpjqpov/Ly8ldffbWkpMTX1/dXv/rV3LlzLY/VmDFjVq1aNX369IiIiLS0tN4vyWs/d+hJW47q0t570pbzutRV3OH5Zea4A2aOZ84clc7u9PEKR85w1SsNOeNiQL1fXaUvF0AZmKte5cSpF6kZmIKCgptvvlmr1QYEBMycOfOrr76yvvWRRx7Jz8/fv39/fX19XFycA+u6c0/asr9L+3jFHwvndak63Pn5Zea4FjOnL8SbOSrFHdsrHG3evNlsNju7ru2Vhix1nXoxINurq1jq9usCKP1le5WTbo+zu51VliQpPj7+m2++aWpqamtrO3z4cEJCgvU+l5WVSZL04Ycfms3m1NRUB9Z1w5605cAu7aUnbTm1S9Xhhs8vM8dNMHM8dObY8znnfm3hgw8+GDVqVHR09M6dO2VZHjlyZGNjo3JTenq6Vqv18/OLiorKz893YN2PPvpo0KBBUb8oLS211D158mRSUlJkZGRCQsKuXbv6srUBPGI7d+5UPpFuqVtQUBAXFxcZGTl69Oi9e/c6vO4XX3yRlJQUHx+/bt06+X8f5/Pnz0dGRnZ2dvZxU/Z0SL/u+/zzz8fFxcXGxmZkZMj/u88TJ04MCwu7+eabT506ZWdd2zbrV0/23qV9r9tLT9qufNUu7dfxKmx70nblq3ap/dNjYJg5V8XM6QtmjgfOHPXijrWioqJHH32UuqLWtee+nvZYeVpdO11zx0tdderac19Pe6w8ra4FlwilrlPqXov7TF3qUvfarXst7jN11azLRSQAAIDgiDsAAEBwxB0AACA44g4AABAccQcAAAiOuAMAAARH3AEAAIIj7gAAAME54GsGITZ7vvILYnPVV41BbMwc9ISvGQQAAOiRXWd3AAAA3B9ndwAAgOCIOwAAQHDEHQAAIDjiDgAAEBxxBwAACI64AwAABEfcAQAAgiPuAAAAwRF3AACA4Ig7AABAcMQdAAAgOOIOAAAQHHEHAAAIjrgDAAAER9wBAACCI+4AAADBEXcAAIDgiDsAAEBwxB0AACC4/wNeW27o5DoAAAACSURBVCEI/r8gawAAAABJRU5ErkJggg=="
/>

## Editing Jobs

Jobs that have not yet started can be altered. Using `scontrol update timelimit=4:00:00
jobid=<jobid>` is is for example possible to modify the maximum runtime. scontrol understands many
different options, please take a look at the man page for more details.

## Job and SLURM Monitoring

On the command line, use `squeue` to watch the scheduling queue. This command will tell the reason,
why a job is not running (job status in the last column of the output). More information about job
parameters can also be determined with `scontrol -d show job <jobid>` Here are detailed descriptions
of the possible job status:

| Reason             | Long description                                                                                                                                 |
|:-------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------|
| Dependency         | This job is waiting for a dependent job to complete.                                                                                             |
| None               | No reason is set for this job.                                                                                                                   |
| PartitionDown      | The partition required by this job is in a DOWN state.                                                                                           |
| PartitionNodeLimit | The number of nodes required by this job is outside of its partitions current limits. Can also indicate that required nodes are DOWN or DRAINED. |
| PartitionTimeLimit | The jobs time limit exceeds its partitions current time limit.                                                                                   |
| Priority           | One or higher priority jobs exist for this partition.                                                                                            |
| Resources          | The job is waiting for resources to become available.                                                                                            |
| NodeDown           | A node required by the job is down.                                                                                                              |
| BadConstraints     | The jobs constraints can not be satisfied.                                                                                                       |
| SystemFailure      | Failure of the SLURM system, a file system, the network, etc.                                                                                    |
| JobLaunchFailure   | The job could not be launched. This may be due to a file system problem, invalid program name, etc.                                              |
| NonZeroExitCode    | The job terminated with a non-zero exit code.                                                                                                    |
| TimeLimit          | The job exhausted its time limit.                                                                                                                |
| InactiveLimit      | The job reached the system InactiveLimit.                                                                                                        |

In addition, the `sinfo` command gives you a quick status overview.

For detailed information on why your submitted job has not started yet, you can use: `whypending
<jobid>`.

## Accounting

The SLRUM command `sacct` provides job statistics like memory usage, CPU
time, energy usage etc. Examples:

```Shell Session
# show all own jobs contained in the accounting database
sacct
# show specific job
sacct -j &lt;JOBID&gt;
# specify fields
sacct -j &lt;JOBID&gt; -o JobName,MaxRSS,MaxVMSize,CPUTime,ConsumedEnergy
# show all fields
sacct -j &lt;JOBID&gt; -o ALL
```

Read the manpage (`man sacct`) for information on the provided fields.

Note that sacct by default only shows data of the last day. If you want
to look further into the past without specifying an explicit job id, you
need to provide a startdate via the **-S** or **--starttime** parameter,
e.g

```Shell Session
# show all jobs since the beginning of year 2020:
sacct -S 2020-01-01
```

## Killing jobs

The command `scancel <jobid>` kills a single job and removes it from the queue. By using `scancel -u
<username>` you are able to kill all of your jobs at once.

## Host List

If you want to place your job onto specific nodes, there are two options for doing this. Either use
`-p` to specify a host group that fits your needs. Or, use `-w` or (`--nodelist`) with a name node
nodes that will work for you.

## Job Profiling

\<a href="%ATTACHURL%/hdfview_memory.png"> \<img alt="" height="272"
src="%ATTACHURL%/hdfview_memory.png" style="float: right; margin-left:
10px;" title="hdfview" width="324" /> \</a>

SLURM offers the option to gather profiling data from every task/node of the job. Following data can
be gathered:

- Task data, such as CPU frequency, CPU utilization, memory
  consumption (RSS and VMSize), I/O
- Energy consumption of the nodes
- Infiniband data (currently deactivated)
- Lustre filesystem data (currently deactivated)

The data is sampled at a fixed rate (i.e. every 5 seconds) and is stored in a HDF5 file.

**CAUTION**: Please be aware that the profiling data may be quiet large, depending on job size,
runtime, and sampling rate. Always remove the local profiles from
`/lustre/scratch2/profiling/${USER}`, either by running sh5util as shown above or by simply removing
those files.

Usage examples:

```Shell Session
# create energy and task profiling data (--acctg-freq is the sampling rate in seconds)
srun --profile=All --acctg-freq=5,energy=5 -n 32 ./a.out
# create task profiling data only
srun --profile=All --acctg-freq=5 -n 32 ./a.out

# merge the node local files in /lustre/scratch2/profiling/${USER} to single file
# (without -o option output file defaults to job_&lt;JOBID&gt;.h5)
sh5util -j &lt;JOBID&gt; -o profile.h5
# in jobscripts or in interactive sessions (via salloc):
sh5util -j ${SLURM_JOBID} -o profile.h5

# view data:
module load HDFView
hdfview.sh profile.h5
```

More information about profiling with SLURM:

- [Slurm Profiling](http://slurm.schedmd.com/hdf5_profile_user_guide.html)
- [sh5util](http://slurm.schedmd.com/sh5util.html)

## Reservations

If you want to run jobs, which specifications are out of our job limitations, you could
[ask for a reservation](mailto:hpcsupport@zih.tu-dresden.de). Please add the following information
to your request mail:

- start time (please note, that the start time have to be later than
  the day of the request plus 7 days, better more, because the longest
  jobs run 7 days)
- duration or end time
- account
- node count or cpu count
- partition

After we agreed with your requirements, we will send you an e-mail with your reservation name. Then
you could see more information about your reservation with the following command:

```Shell Session
scontrol show res=<reservation name>
# e.g. scontrol show res=hpcsupport_123
```

If you want to use your reservation, you have to add the parameter `--reservation=<reservation
name>` either in your sbatch script or to your `srun` or `salloc` command.

## Slurm External Links

- Manpages, tutorials, examples, etc: (http://slurm.schedmd.com/)
- Comparison with other batch systems: (http://www.schedmd.com/slurmdocs/rosetta.html)
