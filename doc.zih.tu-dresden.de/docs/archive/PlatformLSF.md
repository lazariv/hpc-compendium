# Platform LSF

**`%RED%This Page is deprecated! The current bachsystem on Taurus and Venus is [[Compendium.Slurm][Slurm]]!%ENDCOLOR%`**

 The HRSK-I systems are operated
with the batch system LSF running on *Mars*, *Atlas* resp..

## Job Submission

The job submission can be done with the command:
`bsub [bsub_options] <job>`

Some options of `bsub` are shown in the following table:

| bsub option        | Description                                                                                                                                                                |
|:-------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| -n \<N>            | set number of processors (cores) to N(default=1)                                                                                                                           |
| -W \<hh:mm>        | set maximum wall clock time to \<hh:mm>                                                                                                                                    |
| -J \<name>         | assigns the specified name to the job                                                                                                                                      |
| -eo \<errfile>     | writes the standard error output of the job to the specified file (overwriting)                                                                                            |
| -o \<outfile>      | appends the standard output of the job to the specified file                                                                                                               |
| -R span\[hosts=1\] | use only one SMP node (automatically set by the batch system)                                                                                                              |
| -R span\[ptile=2\] | run 2 tasks per node                                                                                                                                                       |
| -x                 | disable other jobs to share the node ( Atlas ).                                                                                                                            |
| -m                 | specify hosts to run on ( [see below](#HostList))                                                                                                                          |
| -M \<M>            | specify per-process (per-core) memory limit (in MB), the job's memory limit is derived from that number (N proc \* M MB); see examples and [Attn. #2](#AttentionNo2) below |
| -P \<project>      | specifiy project                                                                                                                                                           |

You can use the `%J` -macro to merge the job ID into names.

It might be more convenient to put the options directly in a job file
which you can submit using

    bsub  &lt; my_jobfile

The following example job file shows how you can make use of it:

    #!/bin/bash
    #BSUB -J my_job                     # the job's name
    #BSUB -W 4:00                       # max. wall clock time 4h
    #BSUB -R "span[hosts=1]"            # run on a single node
    #BSUB -n 4                          # number of processors
    #BSUB -M 500                        # 500MB per core memory limit
    #BSUB -o out.%J                     # output file
    #BSUB -u name@tu-dresden.de         # email address; works ONLY with @tu-dresden.de 

    echo Starting Program
    cd $HOME/work
    a.out                               # e.g. an OpenMP program
    echo Finished Program

**Understanding memory limits** The option -M to bsub defines how much
memory may be consumed by a single process of the job. The job memory
limit is computed taking this value times the number of processes
requested (-n). Therefore, having -M 600 and -n 4 results in a job
memory limit of 2400 MB. If any one of your processes consumes more than
600 MB memory OR if all processes belonging to this job consume more
than 2400 MB of memory in sum, then the job will be killed by LSF.

-   For serial programs, the given limit is the same for the process and
    the whole job, e.g. 500 MB

<!-- -->

    bsub -W 1:00 -n 1 -M 500 myprog

-   For MPI-parallel programs, the job memory limit is N processes \*
    memory limit, e.g. 32\*800 MB = 25600 MB

<!-- -->

    bsub -W 8:00 -n 32 -M 800 mympiprog

-   For OpenMP-parallel programs, the same applies as with MPI-parallel
    programs, e.g. 8\*2000 MB = 16000 MB

<!-- -->

    bsub -W 4:00 -n 8 -M 2000 myompprog

LSF sets the user environment according to the environment at the time
of submission.

Based on the given information the job scheduler puts your job into the
appropriate queue. These queues are subject to permanent changes. You
can check the current situation using the command `bqueues -l` . There
are a couple of rules and restrictions to balance the system loads. One
idea behind them is to prevent users from occupying the machines
unfairly. An indicator for the priority of a job placement in a queue is
therefore the ratio between used and granted CPU time for a certain
period.

`Attention`: If you do not give the maximum runtime of your program, the
default runtime for the specified queue is taken. This is way below the
maximal possible runtime (see table [below](#JobQueues)).

#AttentionNo2 `Attention #2`: Some systems enforce a limit on how much
memory each process and your job as a whole may allocate. If your job or
any of its processes exceed this limit (N proc.\*limit for the job),
your job will be killed. If memory limiting is in place, there also
exists a default limit which will be applied to your job if you do not
specify one. Please find the limits along with the description of the
machines' [queues](#JobQueues) below.

#InteractiveJobs

### Interactive Jobs

Interactive activities like editing, compiling etc. are normally limited
to the boot CPU set ( *Mars* ) or to the master nodes ( *Atlas* ). For
the development and testing sometimes a larger number of CPUs and more
CPU time may be needed. Please do not use the interactive queue for
extensive production runs!

Use the bsub options `-Is` for an interactive and, additionally on
*Atlas*, `-XF` for an X11 job like:

    bsub -Is -XF matlab

or for an interactive job with a bash use

    bsub -Is -n 2 -W &lt;hh:mm&gt; -P &lt;project&gt; bash

You can check the current usage of the system with the command `bhosts`
to estimate the time to schedule.

#ParallelJobs

### Parallel Jobs

For submitting parallel jobs, a few rules have to be understood and
followed. In general they depend on the type of parallelization and the
architecture.

#OpenMPJobs

#### OpenMP Jobs

An SMP-parallel job can only run within a node (or a partition), so it
is necessary to include the option `-R "span[hosts=1]"` . The maximum
number of processors for an SMP-parallel program is 506 on a large Altix
partition, and 64 on \<tt>*Atlas*\</tt> . A simple example of a job file
for an OpenMP job can be found above (section [3.4](#LSF-OpenMP)).

[Further information on pinning
threads.](RuntimeEnvironment#Placing_Threads_or_Processes_on)

#MpiJobs

#### MPI Jobs

There are major differences for submitting MPI-parallel jobs on the
systems at ZIH. Please refer to the HPC systems's section. It is
essential to use the same modules at compile- and run-time.

### Array Jobs

Array jobs can be used to create a sequence of jobs that share the same
executable and resource requirements, but have different input files, to
be submitted, controlled, and monitored as a single unit.

After the job array is submitted, LSF independently schedules and
dispatches the individual jobs. Each job submitted from a job array
shares the same job ID as the job array and are uniquely referenced
using an array index. The dimension and structure of a job array is
defined when the job array is created.

Here is an example how an array job can looks like:

    #!/bin/bash

    #BSUB -W 00:10
    #BSUB -n 1           
    #BSUB -J "myTask[1-100:2]" # create job array with 50 tasks
    #BSUB -o logs/out.%J.%I    # appends the standard output of the job to the specified file that
                               # contains the job information (%J) and the task information (%I)
    #BSUB -e logs/err.%J.%I    # appends the error output of the job to the specified file that 
                               # contains the job information (%J) and the task information (%I)

    echo "Hello Job $LSB_JOBID Task $LSB_JOBINDEX"

Alternatively, you can use the following single command line to submit
an array job:

    bsub -n 1 -W 00:10 -J "myTask[1-100:2]" -o "logs/out.%J.%I" -e "logs/err.%J.%I" "echo Hello Job \$LSB_JOBID Task \$LSB_JOBINDEX"

For further details please read the LSF manual.

### Chain Jobs

You can use chain jobs to create dependencies between jobs. This is
often the case if a job relies on the result of one or more preceding
jobs. Chain jobs can also be used if the runtime limit of the batch
queues is not sufficient for your job.

To create dependencies between jobs you have to use the option `-w`.
Since `-w` relies on the job id or the job name it is advisable to use
the option `-J` to create a user specified name for a single job. For
detailed information see the man pages of bsub with `man bsub`.

Here is an example how a chain job can looks like:

    #!/bin/bash

    #job parameters
    time="4:00"
    mem="rusage[mem=2000] span[host=1]"
    n="8"

    #iteration parameters
    start=1
    end=10
    i=$start

    #create chain job with 10 jobs
    while [ "$i" -lt "`expr $end + 1`" ]
    do
       if [ "$i" -eq "$start" ];then
          #create jobname
          JOBNAME="${USER}_job_$i"
          bsub -n "$n" -W "$time" -R "$mem" -J "$JOBNAME" &lt;job&gt;
       else
          #create jobname
          OJOBNAME=$JOBNAME
          JOBNAME="${USER}_job_$i"
          #only start a job if the preceding job has the status done
          bsub -n "$n" -W "$time" -R "$mem" -J "$JOBNAME" -w "done($OJOBNAME)" &lt;job&gt;
       fi
       i=`expr $i + 1`
    done

#JobQueues

## Job Queues

With the command `bqueues [-l <queue name>]` you can get information
about available queues. With `bqueues -l` you get a detailed listing of
the queue properties.

`Attention`: The queue `interactive` is the only one to accept
interactive jobs!

## Job Monitoring

You can check the current usage of the system with the command `bhosts`
to estimate the time to schedule. Or to get an overview on *Atlas*,
lsfview shows the current usage of the system.

The command `bhosts` shows the load on the hosts.

For a more convenient overview the command `lsfshowjobs` displays
information on the LSF status like this:

    You have 1 running job using 64 cores
    You have 1 pending job

and the command `lsfnodestat` displays the node and core status of
machine like this:

# -------------------------------------------

nodes available: 714/714 nodes damaged: 0

# -------------------------------------------

jobs running: 1797 \| cores closed (exclusive jobs): 94 jobs wait: 3361
\| cores closed by ADMIN: 129 jobs suspend: 0 \| cores working: 2068
jobs damaged: 0 \|

# -------------------------------------------

normal working cores: 2556 cores free for jobs: 265 \</pre>

The command `bjobs` allows to monitor your running jobs. It has the
following options:

| bjobs option  | Description                                                                                                                       |
|:--------------|:----------------------------------------------------------------------------------------------------------------------------------|
| `-r`          | Displays running jobs.                                                                                                            |
| `-s`          | Displays suspended jobs, together with the suspending reason that caused each job to become suspended.                            |
| `-p`          | Displays pending jobs, together with the pending reasons that caused each job not to be dispatched during the last dispatch turn. |
| `-a`          | Displays information on jobs in all states, including finished jobs that finished recently.                                       |
| `-l [job_id]` | Displays detailed information for each job or for a particular job.                                                               |

## Checking the progress of your jobs

If you run code that regularily emits status or progress messages, using
the command

`watch -n10 tail -n2 '*out'`

in your `$HOME/.lsbatch` directory is a very handy way to keep yourself
informed. Note that this only works if you did not use the `-o` option
of `bsub`, If you used `-o`, replace `*out` with the list of file names
you passed to this very option.

#HostList

## Host List

The `bsub` option `-m` can be used to specify a list of hosts for
execution. This is especially useful for memory intensive computations.

### Altix

Jupiter, saturn, and uranus have 4 GB RAM per core, mars only 1GB. So it
makes sense to specify '-m "jupiter saturn uranus".

\</noautolink>
