# Use of Hardware

To run the software, do some calculations or compile your code compute nodes have to be used. Login
nodes which are using for login can not be used for your computations. Submit your tasks (by using
[jobs]**todo link**) to compute nodes. The [Slurm](jobs/index.md) (scheduler to handle your jobs) is
using on Taurus for this purposes. [HPC Introduction]**todo link** is a good resource to get started
with it.

## What do I need a CPU or GPU?

The main difference between CPU and GPU architecture is that a CPU is designed to handle a wide
range of tasks quickly, but are limited in the concurrency of tasks that can be running. While GPUs
can process data much faster than a CPU due to massive parallelism (but the amount of data which
a single GPU's core can handle is small), GPUs are not as versatile as CPUs.

## Selection of Suitable Hardware

Available [hardware]**todo link**: Normal compute nodes (Haswell[[64]**todo link**, [128]**todo link**,
[256]**todo link**], Broadwell, [Rome]**todo link**), Large SMP nodes, Accelerator(GPU) nodes: (gpu2
partition, [ml partition]**todo link**).

The exact partition could be specified by `-p` flag with the srun command or in your batch job.

Majority of the basic task could be done on the conventional nodes like a Haswell. Slurm will
automatically select a suitable partition depending on your memory and --gres (gpu) requirements. If
you do not specify the partition most likely you will be addressed to the Haswell partition (1328
nodes in total).

### Parallel Jobs

**MPI jobs:** For MPI jobs typically allocates one core per task. Several nodes could be allocated
if it is necessary. Slurm will automatically find suitable hardware. Normal compute nodes are
perfect for this task.

**OpenMP jobs:** An SMP-parallel job can only run **within a node**, so it is necessary to include the
options `-N 1` and `-n 1`. Using `--cpus-per-task N` Slurm will start one task and you will have N CPUs.
The maximum number of processors for an SMP-parallel program is 896 on Taurus ([SMP]**todo link** island).

**GPUs** partitions are best suited for **repetitive** and **highly-parallel** computing tasks. If
you have a task with potential [data parallelism]**todo link** most likely that you need the GPUs.
Beyond video rendering, GPUs excel in tasks such as machine learning, financial simulations and risk
modeling. Use the gpu2 and ml partition only if you need GPUs! Otherwise using the x86 partitions
(e.g Haswell) most likely would be more beneficial.

**Interactive jobs:** Slurm can forward your X11 credentials to the first (or even all) node for a job
with the `--x11` option. To use an interactive job you have to specify `-X` flag for the ssh login.

## Interactive vs. sbatch

However, using srun directly on the shell will lead to blocking and launch an interactive job. Apart
from short test runs, it is recommended to launch your jobs into the background by using batch jobs.
For that, you can conveniently put the parameters directly into the job file which you can submit
using `sbatch [options] <job file>`.

## Processing of Data for Input and Output

Pre-processing and post-processing of the data is a crucial part for the majority of data-dependent
projects. The quality of this work influence on the computations. However, pre- and post-processing
in many cases can be done completely or partially on a local pc and then transferred to the Taurus.
Please use Taurus for the computation-intensive tasks. 

Useful links: [Batch Systems]**todo link**, [Hardware Taurus]**todo link**, [HPC-DA]**todo link**,
[Slurm]**todo link**
