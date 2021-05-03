# Batch System

Applications on an HPC system can not be run on the login node. They have to be submitted to compute
nodes with dedicated resources for user jobs. Normally a job can be submitted with these data:

* number of CPU cores,
* requested CPU cores have to belong on one node (OpenMP programs) or can distributed (MPI),
* memory per process,
* maximum wall clock time (after reaching this limit the process is killed automatically),
* files for redirection of output and error messages,
* executable and command line parameters.

*Comment:* Please keep in mind that for a large runtime a computation may not reach its end. Try to
create shorter runs (4...8 hours) and use checkpointing. Here is an extreme example from literature
for the waste of large computing resources due to missing checkpoints:

>Earth was a supercomputer constructed to find the question to the answer to the Life, the Universe,
>and Everything by a race of hyper-intelligent pan-dimensional beings. Unfortunately 10 million years
>later, and five minutes before the program had run to completion, the Earth was destroyed by
>Vogons.

(Adams, D. The Hitchhikers Guide Through the Galaxy)

## Slurm

The HRSK-II systems are operated with the batch system [Slurm](https://slurm.schedmd.com). Just
specify the resources you need in terms of cores, memory, and time and your job will be placed on
the system.

### Job Submission

Job submission can be done with the command: `srun [options] <command>`

However, using `srun` directly on the shell will be blocking and launch an interactive job. Apart
from short test runs, it is recommended to launch your jobs into the background by using batch jobs.
For that, you can conveniently put the parameters directly in a job file which you can submit using
`sbatch [options] <job file>`

Some options of srun/sbatch are:

| Slurm Option | Description |
|------------|-------|
| `-n <N>` or `--ntasks <N>`         | set a number of tasks to N(default=1). This determines how many processes will be spawned by srun (for MPI jobs). |
| `-N <N>` or `--nodes <N>`          | set number of nodes that will be part of a job, on each node there will be --ntasks-per-node processes started, if the option --ntasks-per-node is not given, 1 process per node will be started |
| `--ntasks-per-node <N>`            | how many tasks per allocated node to start, as stated in the line before |
| `-c <N>` or `--cpus-per-task <N>`  | this option is needed for multithreaded (e.g. OpenMP) jobs, it tells SLURM to allocate N cores per task allocated; typically N should be equal to the number of threads you program spawns, e.g. it should be set to the same number as OMP_NUM_THREADS |
| `-p <name>` or `--partition <name>`| select the type of nodes where you want to execute your job, on Taurus we currently have haswell, smp, sandy, west, ml and gpu available |
| `--mem-per-cpu <name>`             | specify the memory need per allocated CPU in MB |
| `--time <HH:MM:SS>`                | specify the maximum runtime of your job, if you just put a single number in, it will be interpreted as minutes |
| `--mail-user <your email>`         | tell the batch system your email address to get updates about the status of the jobs |
| `--mail-type ALL`                  | specify for what type of events you want to get a mail; valid options beside ALL are: BEGIN, END, FAIL, REQUEUE |
| `-J <name> or --job-name <name>`   | give your job a name which is shown in the queue, the name will also be included in job emails (but cut after 24 chars within emails) |
| `--exclusive`                      | tell SLURM that only your job is allowed on the nodes allocated to this job; please be aware that you will be charged for all CPUs/cores on the node |
| `-A <project>`                     | Charge resources used by this job to the specified project, useful if a user belongs to multiple projects. |
| `-o <filename>` or `--output <filename>` | specify a file name that will be used to store all normal output (stdout), you can use %j (job id) and %N (name of first node) to automatically adopt the file name to the job, per default stdout goes to "slurm-%j.out" |

<!--NOTE: the target path of this parameter must be writeable on the compute nodes, i.e. it may not point to a read-only mounted file system like /projects.-->
<!---e <filename> or --error <filename>-->

<!--specify a file name that will be used to store all error output (stderr), you can use %j (job id) and %N (name of first node) to automatically adopt the file name to the job, per default stderr goes to "slurm-%j.out" as well-->

<!--NOTE: the target path of this parameter must be writeable on the compute nodes, i.e. it may not point to a read-only mounted file system like /projects.-->
<!---a or --array 	submit an array job, see the extra section below-->
<!---w <node1>,<node2>,... 	restrict job to run on specific nodes only-->
<!---x <node1>,<node2>,... 	exclude specific nodes from job-->
