# Jobs and Resources

When log in to ZIH systems, you are placed on a *login node* **TODO** link to login nodes section
where you can [manage data life cycle](../data_lifecycle/overview.md),
[setup experiments](../data_lifecycle/experiments.md), execute short tests and compile moderate
projects. The login nodes cannot be used for real experiments and computations. Long and extensive
computational work and experiments have to be encapsulated into so called **jobs** and scheduled to
the compute nodes.

<!--Login nodes which are using for login can not be used for your computations.-->
<!--To run software, do calculations and experiments, or compile your code compute nodes have to be used.-->

ZIH uses the batch system Slurm for resource management and job scheduling.
<!--[HPC Introduction]**todo link** is a good resource to get started with it.-->

??? note "Batch Job"

    In order to allow the batch scheduler an efficient job placement it needs these
    specifications:

    * **requirements:** cores, memory per core, (nodes), additional resources (GPU),
    * maximum run-time,
    * HPC project (normally use primary group which gives id),
    * who gets an email on which occasion,

    The runtime environment (see [here](../software/overview.md)) as well as the executable and
    certain command-line arguments have to be specified to run the computational work.

??? note "Batch System"

    The batch system is the central organ of every HPC system users interact with its compute
    resources. The batchsystem finds an adequate compute system (partition/island) for your compute
    jobs. It organizes the queueing and messaging, if all resources are in use. If resources are
    available for your job, the batch system allocates and connects to these resources, transfers
    run-time environment, and starts the job.

Follow the page [Slurm](slurm.md) for comprehensive documentation using the batch system at
ZIH systems. There is also a page with extensive set of [Slurm examples](slurm_examples.md).

## Selection of Suitable Hardware

### What do I need a CPU or GPU?

The main difference between CPU and GPU architecture is that a CPU is designed to handle a wide
range of tasks quickly, but are limited in the concurrency of tasks that can be running. While GPUs
can process data much faster than a CPU due to massive parallelism (but the amount of data which
a single GPU's core can handle is small), GPUs are not as versatile as CPUs.

### Available Hardware

ZIH provides a broad variety of compute resources ranging from normal server CPUs of different
manufactures, to large shared memory nodes, GPU-assisted nodes up to highly specialized resources for
[Machine Learning](../software/machine_learning.md) and AI.
The page [Hardware Taurus](hardware_taurus.md) holds a comprehensive overview.

The desired hardware can be specified by the partition `-p, --partition` flag in Slurm.
The majority of the basic tasks can be executed on the conventional nodes like a Haswell. Slurm will
automatically select a suitable partition depending on your memory and GPU requirements.

### Parallel Jobs

**MPI jobs:** For MPI jobs typically allocates one core per task. Several nodes could be allocated
if it is necessary. Slurm will automatically find suitable hardware. Normal compute nodes are
perfect for this task.

**OpenMP jobs:** SMP-parallel applications can only run **within a node**, so it is necessary to
include the options `-N 1` and `-n 1`. Using `--cpus-per-task N` Slurm will start one task and you
will have N CPUs. The maximum number of processors for an SMP-parallel program is 896 on Taurus
([SMP]**todo link** island).

**GPUs** partitions are best suited for **repetitive** and **highly-parallel** computing tasks. If
you have a task with potential [data parallelism]**todo link** most likely that you need the GPUs.
Beyond video rendering, GPUs excel in tasks such as machine learning, financial simulations and risk
modeling. Use the gpu2 and ml partition only if you need GPUs! Otherwise using the x86 partitions
(e.g Haswell) most likely would be more beneficial.

**Interactive jobs:** Slurm can forward your X11 credentials to the first node (or even all) for a job
with the `--x11` option. To use an interactive job you have to specify `-X` flag for the ssh login.

## Interactive vs. Batch Mode

However, using `srun` directly on the Shell will lead to blocking and launch an interactive job.
Apart from short test runs, it is recommended to encapsulate your experiments and computational
tasks into batch jobs and submit them to the batch system. For that, you can conveniently put the
parameters directly into the job file which you can submit using `sbatch [options] <job file>`.

## Processing of Data for Input and Output

Pre-processing and post-processing of the data is a crucial part for the majority of data-dependent
projects. The quality of this work influence on the computations. However, pre- and post-processing
in many cases can be done completely or partially on a local system and then transferred to ZIH
systems. Please use ZIH systems primarily for the computation-intensive tasks.

<!--Useful links: [Batch Systems]**todo link**, [Hardware Taurus]**todo link**, [HPC-DA]**todo link**,-->
<!--[Slurm]**todo link**-->
