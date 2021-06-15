# LoadLeveler - IBM Tivoli Workload Scheduler



## Job Submission

First of all, to submit a job to LoadLeveler a job file needs to be
created. This job file can be passed to the command:
`llsubmit [llsubmit_options] <job_file>`

### Job File Examples

#### Serial Batch Jobs

An example job file may look like this:

    #@ job_name = my_job
    #@ output = $(job_name).$(jobid).out
    #@ error  = $(job_name).$(jobid).err
    #@ class = short
    #@ group = triton-ww | triton-ipf | triton-ism | triton-et
    #@ wall_clock_limit = 00:30:00
    #@ resources = ConsumableMemory(1 gb)
    #@ environment = COPY_ALL
    #@ notification = complete
    #@ notify_user = your_email@adress
    #@ queue

    ./my_serial_program

This example requests a serial job with a runtime of 30 minutes and a
overall memory requirement of 1GByte. There are four groups available,
don't forget to choose the one and only matching group. When the job
completes, a mail will be sent which includes details about resource
usage.

#### MPI Parallel Batch Jobs

An example job file may look like this:

    #@ job_name = my_job
    #@ output = $(job_name).$(jobid).out
    #@ error  = $(job_name).$(jobid).err
    #@ job_type = parallel
    #@ node = 2
    #@ tasks_per_node = 8
    #@ class = short
    #@ group = triton-ww | triton-ipf | triton-ism | triton-et
    #@ wall_clock_limit = 00:30:00
    #@ resources = ConsumableMemory(1 gb)
    #@ environment = COPY_ALL
    #@ notification = complete
    #@ notify_user = your_email@adress
    #@ queue

    mpirun -x OMP_NUM_THREADS=1 -x LD_LIBRARY_PATH -np 16 ./my_mpi_program

This example requests a parallel job with 16 processes (2 nodes, 8 tasks
per node), a runtime of 30 minutes, 1GByte memory requirement per task
and therefore a overall memory requirement of 8GByte per node. Please
keep in mind that each node on Triton only provides 45GByte. The choice
of the correct group is also important and necessary. The `-x` option of
`mpirun` exports the specified environment variables to all MPI
processes.

-   `OMP_NUM_THREADS=1`: If you are using libraries like MKL, which are
    multithreaded, you always should set the number of threads
    explicitly so that the nodes are not overloaded. Otherwise you will
    experience heavy performance problems.
-   `LD_LIBRARY_PATH`: If your program is linked with shared libraries
    (like MKL) which are not standard system libraries, you must export
    this variable to the MPI processes.

When the job completes, a mail will be sent which includes details about
resource usage.

Before submitting MPI jobs, ensure that the appropriate MPI module is
loaded, e.g issue:

    # module load openmpi

#### Hybrid MPI+OpenMP Parallel Batch Jobs

An example job file may look like this:

    #@ job_name = my_job
    #@ output = $(job_name).$(jobid).out
    #@ error  = $(job_name).$(jobid).err
    #@ job_type = parallel
    #@ node = 4
    #@ tasks_per_node = 8
    #@ class = short
    #@ group = triton-ww | triton-ipf | triton-ism | triton-et
    #@ wall_clock_limit = 00:30:00
    #@ resources = ConsumableMemory(1 gb)
    #@ environment = COPY_ALL
    #@ notification = complete
    #@ notify_user = your_email@adress
    #@ queue

    mpirun -x OMP_NUM_THREADS=8 -x LD_LIBRARY_PATH -np 4 --bynode ./my_hybrid_program

This example requests a parallel job with 32 processes (4 nodes, 8 tasks
per node), a runtime of 30 minutes, 1GByte memory requirement per task
and therefore a overall memory requirement of 8GByte per node. Please
keep in mind that each node on Triton only provides 45GByte. The choice
of the correct group is also important and necessary. The mpirun command
starts 4 MPI processes (`--bynode` forces one process per node).
`OMP_NUM_THREADS` is set to 8, so that 8 threads are started per MPI
rank. When the job completes, a mail will be sent which includes details
about resource usage.

### Job File Keywords

| Keyword            | Valid values                                    | Description                                                                          |
|:-------------------|:------------------------------------------------|:-------------------------------------------------------------------------------------|
| `notification`     | `always`, `error`, `start`, `never`, `complete` | When to write notification email.                                                    |
| `notify_user`      | valid email adress                              | Notification email adress.                                                           |
| `output`           | file name                                       | File for stdout of the job.                                                          |
| `error`            | file name                                       | File for stderr of the job.                                                          |
| `job_type`         | `parallel`, `serial`                            | Job type, default is `serial`.                                                       |
| `node`             | `1` - `64`                                      | Number of nodes requested (parallel jobs only).                                      |
| `tasks_per_node`   | `1` - `8`                                       | Number of processors per node requested (parallel jobs only).                        |
| `class`            | see `llclass`                                   | Job queue.                                                                           |
| `group`            | triton-ww, triton-ipf, triton-ism, triton-et    | choose matching group                                                                |
| `wall_clock_limit` | HH:MM:SS                                        | Run time limit of the job.                                                           |
| `resources`        | `name(count)` ... `name(count)`                 | Specifies quantities of the consumable resources consumed by each task of a job step |

Further Information:
\[\[http://publib.boulder.ibm.com/infocenter/clresctr/vxrx/index.jsp?topic=/com.ibm.cluster.loadl35.admin.doc/am2ug_jobkey.html\]\[Full
description of keywords\]\].

### Submit a Job without a Job File

Submission of a job without a job file can be done by the command:
`llsub [llsub_options] <command>`

This command is not part of the IBM Loadleveler software but was
developed at ZIH.

The job file will be created in background by means of the command line
options. Afterwards, the job file will be passed to the command
`llsubmit` which submit the job to LoadLeveler (see above).

Important options are:

| Option                | Default                                                                                      | Description                                                                                                                                                                                                                                                                 |
|:----------------------|:---------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `-J <name>`           | `llsub`                                                                                      | Specifies the name of the job. You can name the job using any combination of letters, numbers, or both. The job name only appears in the long reports of the llq, llstatus, and llsummary commands.                                                                         |
| `-n`                  | `1`                                                                                          | Specifies the total number of tasks of a parallel job you want to run on all available nodes.                                                                                                                                                                               |
| `-T`                  | not specified                                                                                | Specifies the maximum number of OpenMP threads to use per process by setting the environment variable OMP_NUM_THREADS to number.                                                                                                                                            |
| `--o, -oo <filename>` | `<jobname>.<hostname>.<jobid>.out`                                                           | Specifies the name of the file to use as standard output (stdout) when your job step runs.                                                                                                                                                                                  |
| `-e, -oe <filename>`  | `<jobname>.<hostname>.<jobid>.err`                                                           | Specifies the name of the file to use as standard error (stderr) when your job step runs.                                                                                                                                                                                   |
| `-I`                  | not specified                                                                                | Submits an interactive job and sends the job's standard output (or standard error) to the terminal.                                                                                                                                                                         |
| `-q <name>`           | non-interactive: `short` interactive(n`1): =interactive` interactive(n>1): `interactive_par` | Specifies the name of a job class defined locally in your cluster. You can use the llclass command to find out information on job classes.                                                                                                                                  |
| `-x`                  | not specified                                                                                | Puts the node running your job into exclusive execution mode. In exclusive execution mode, your job runs by itself on a node. It is dispatched only to a node with no other jobs running, and LoadLeveler does not send any other jobs to the node until the job completes. |
| `-hosts <number>`     | automatically                                                                                | Specifies the number of nodes requested by a job step. This option is equal to the bsub option -R "span\[hosts=number\]".                                                                                                                                                   |
| `-ptile <number>`     | automatically                                                                                | Specifies the number of nodes requested by a job step. This option is equal to the bsub option -R "span\[ptile=number\]".                                                                                                                                                   |
| `-mem <size>`         | not specified                                                                                | Specifies the requirement of memory which the job needs on a single node. The memory requirement is specified in MB. This option is equal to the bsub option -R "rusage\[mem=size\]".                                                                                       |

The option `-H` prints the list of all available command line options.

Here is an example for an MPI Job:

    llsub -T 1 -n 16 -e err.txt -o out.txt mpirun -x LD_LIBRARY_PATH -np 16 ./my_program

### Interactive Jobs

Interactive Jobs can be submitted by the command:
`llsub -I -q <interactive> <command>`

### Loadleveler Runtime Environment Variables

Loadleveler Runtime Variables give you some information within the job
script, for example:

    #@ job_name = my_job
    #@ output = $(job_name).$(jobid).out
    #@ error  = $(job_name).$(jobid).err
    #@ job_type = parallel
    #@ node = 2
    #@ tasks_per_node = 8
    #@ class = short
    #@ wall_clock_limit = 00:30:00
    #@ resources = ConsumableMemory(1 gb)
    #@ environment = COPY_ALL
    #@ notification = complete
    #@ notify_user = your_email@adress
    #@ queue

    echo $LOADL_PROCESSOR_LIST
    echo $LOADL_STEP_ID
    echo $LOADL_JOB_NAME
    mpirun -np 16 ./my_mpi_program

Further Information:
\[\[http://publib.boulder.ibm.com/infocenter/clresctr/vxrx/index.jsp?topic=/com.ibm.cluster.loadl35.admin.doc/am2ug_envvars.html\]\[Full
description of variables\]\].

## Job Queues

The `llclass` command provides information about each queue. Example
output:

    Name                 MaxJobCPU     MaxProcCPU  Free   Max Description          
                        d+hh:mm:ss     d+hh:mm:ss Slots Slots                      
    --------------- -------------- -------------- ----- ----- ---------------------
    interactive          undefined      undefined    32    32 interactive, exclusive shared nodes, max. 12h runtime
    triton_ism           undefined      undefined     8    80 exclusive, serial + parallel queue, nodes shared, unlimited runtime
    openend              undefined      undefined   272   384 serial + parallel queue, nodes shared, unlimited runtime
    long                 undefined      undefined   272   384 serial + parallel queue, nodes shared, max. 7 days runtime
    medium               undefined      undefined   272   384 serial + parallel queue, nodes shared, max. 3 days runtime
    short                undefined      undefined   272   384 serial + parallel queue, nodes shared, max. 4 hours runtime

## Job Monitoring

### All Jobs in the Queue

    # llq

#### All of One's Own Jobs

    # llq -u username

### Details About Why A Job Has Not Yet Started

    # llq -s job-id

The key information is located at the end of the output, and will look
similar to the following:

    ==================== EVALUATIONS FOR JOB STEP l1f1n01.4604.0 ====================
    The class of this job step is "workq".
    Total number of available initiators of this class on all machines in the cluster: 0
    Minimum number of initiators of this class required by job step: 4
    The number of available initiators of this class is not sufficient for this job step.
    Not enough resources to start now.
    Not enough resources for this step as backfill.

Or it will tell you the **estimated start** time:

    ==================== EVALUATIONS FOR JOB STEP l1f1n01.8207.0 ====================
    The class of this job step is "checkpt".
    Total number of available initiators of this class on all machines in the cluster: 8
    Minimum number of initiators of this class required by job step: 32
    The number of available initiators of this class is not sufficient for this job step.
    Not enough resources to start now.
    This step is top-dog. 
    Considered at: Fri Jul 13 12:12:04 2007
    Will start by: Tue Jul 17 18:10:32 2007

### Generate a long listing rather than the standard one

    # llq -l job-id

This command will give you detailed job information.

### Job Status States

|                  |     |                                                                                                                                                                                                                                                |
|------------------|-----|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Canceled         | CA  | The job has been canceled as by the llcancel command.                                                                                                                                                                                          |
| Completed        | C   | The job has completed.                                                                                                                                                                                                                         |
| Complete Pending | CP  | The job is completed. Some tasks are finished.                                                                                                                                                                                                 |
| Deferred         | D   | The job will not be assigned until a specified date. The start date may have been specified by the user in the Job Command file or it may have been set by LoadLeveler because a parallel job could not obtain enough machines to run the job. |
| Idle             | I   | The job is being considered to run on a machine though no machine has been selected yet.                                                                                                                                                       |
| NotQueued        | NQ  | The job is not being considered to run. A job may enter this state due to an error in the command file or because LoadLeveler can not obtain information that it needs to act on the request.                                                  |
| Not Run          | NR  | The job will never run because a stated dependency in the Job Command file evaluated to be false.                                                                                                                                              |
| Pending          | P   | The job is in the process of starting on one or more machines. The request to start the job has been sent but has not yet been acknowledged.                                                                                                   |
| Rejected         | X   | The job did not start because there was a mismatch or requirements for your job and the resources on the target machine or because the user does not have a valid ID on the target machine.                                                    |
| Reject Pending   | XP  | The job is in the process of being rejected.                                                                                                                                                                                                   |
| Removed          | RM  | The job was canceled by either LoadLeveler or the owner of the job.                                                                                                                                                                            |
| Remove Pending   | RP  | The job is in the process of being removed.                                                                                                                                                                                                    |
| Running          | R   | The job is running.                                                                                                                                                                                                                            |
| Starting         | ST  | The job is starting.                                                                                                                                                                                                                           |
| Submission Error | SX  | The job can not start due to a submission error. Please notify the Bluedawg administration team if you encounter this error.                                                                                                                   |
| System Hold      | S   | The job has been put in hold by a system administrator.                                                                                                                                                                                        |
| System User Hold | HS  | Both the user and a system administrator has put the job on hold.                                                                                                                                                                              |
| Terminated       | TX  | The job was terminated, presumably by means beyond LoadLeveler's control. Please notify the Bluedawg administration team if you encounter this error.                                                                                          |
| User Hold        | H   | The job has been put on hold by the owner.                                                                                                                                                                                                     |
| Vacated          | V   | The started job did not complete. The job will be scheduled again provided that the job may be rescheduled.                                                                                                                                    |
| Vacate Pending   | VP  | The job is in the process of vacating.                                                                                                                                                                                                         |

## Cancel a Job

### A Particular Job

    # llcancel job-id

### All of One's Jobs

    # llcancel -u username

## Job History and Usage Summaries

On each cluster, there exists a file that contains the history of all
jobs run under LoadLeveler. This file is
**/var/loadl/archive/history.archive**, and may be queried using the
**llsummary** command.

An example of usage would be as follows:

    # llsummary -u estrabd /var/loadl/archive/history.archive

And the output would look something like:

           Name   Jobs   Steps        Job Cpu    Starter Cpu     Leverage
        estrabd    118     128       07:55:57       00:00:45        634.6
          TOTAL    118     128       07:55:57       00:00:45        634.6
          Class   Jobs   Steps        Job Cpu    Starter Cpu     Leverage
        checkpt     13      23       03:09:32       00:00:18        631.8
    interactive    105     105       04:46:24       00:00:26        660.9
          TOTAL    118     128       07:55:57       00:00:45        634.6
          Group   Jobs   Steps        Job Cpu    Starter Cpu     Leverage
       No_Group    118     128       07:55:57       00:00:45        634.6
          TOTAL    118     128       07:55:57       00:00:45        634.6
        Account   Jobs   Steps        Job Cpu    Starter Cpu     Leverage
           NONE    118     128       07:55:57       00:00:45        634.6
          TOTAL    118     128       07:55:57       00:00:45        634.6

The **llsummary** tool has a lot of options, which are discussed in its
man pages.

## Check status of each node

    # llstatus

And the output would look something like:

    root@triton[0]:~# llstatus
    Name                      Schedd InQ  Act Startd Run LdAvg Idle Arch      OpSys    
    n01                       Avail     0   0 Idle     0 0.00  2403 AMD64     Linux2   
    n02                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n03                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n04                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n05                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n06                       Avail     0   0 Idle     0 0.71  9999 AMD64     Linux2   
    n07                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n08                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n09                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n10                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n11                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n12                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n13                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n14                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n15                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n16                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n17                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n18                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n19                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n20                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n21                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n22                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n23                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n24                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n25                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n26                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n27                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n28                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n29                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n30                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n31                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n32                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n33                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n34                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n35                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n36                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n37                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n38                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n39                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n40                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n41                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n42                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n43                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n44                       Avail     0   0 Idle     0 0.01  9999 AMD64     Linux2   
    n45                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n46                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n47                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n48                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n49                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n50                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n51                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n52                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n53                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n54                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n55                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n56                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n57                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n58                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n59                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n60                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n61                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n62                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n63                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    n64                       Avail     0   0 Idle     0 0.00  9999 AMD64     Linux2   
    triton                    Avail     0   0 Idle     0 0.00   585 AMD64     Linux2   

    AMD64/Linux2               65 machines      0  jobs      0  running tasks
    Total Machines             65 machines      0  jobs      0  running tasks

    The Central Manager is defined on triton

    The BACKFILL scheduler is in use

    All machines on the machine_list are present.

Detailed status information for a specific node:

    # llstatus -l n54

Further information:
\[\[http://publib.boulder.ibm.com/infocenter/clresctr/vxrx/index.jsp?topic=/com.ibm.cluster.loadl.doc/llbooks.html\]\[IBM
Documentation (see version 3.5)\]\]

-- Main.mark - 2010-06-01
