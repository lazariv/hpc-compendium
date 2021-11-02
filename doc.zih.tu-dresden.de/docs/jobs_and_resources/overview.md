# HPC Resources and Jobs

ZIH operates a high performance computing (HPC) system with more than 60.000 cores, 720 GPUs, and a
flexible storage hierarchy with about 16 PB total capacity. The HPC system provides an optimal
research environment especially in the area of data analytics and machine learning as well as for
processing extremely large data sets. Moreover it is also a perfect platform for highly scalable,
data-intensive and compute-intensive applications.

With shared [login nodes](#login-nodes) and [filesystems](../data_lifecycle/file_systems.md) our
HPC system enables users to easily switch between [the components](hardware_overview.md), each
specialized for different application scenarios.

When log in to ZIH systems, you are placed on a login node where you can
[manage data life cycle](../data_lifecycle/overview.md),
[setup experiments](../data_lifecycle/experiments.md),
execute short tests and compile moderate projects. The login nodes cannot be used for real
experiments and computations. Long and extensive computational work and experiments have to be
encapsulated into so called **jobs** and scheduled to the compute nodes.

Follow the page [Slurm](slurm.md) for comprehensive documentation using the batch system at
ZIH systems. There is also a page with extensive set of [Slurm examples](slurm_examples.md).

## Selection of Suitable Hardware

### What do I need, a CPU or GPU?

If an application is designed to run on GPUs this is normally announced unmistakable since the
efforts of adapting an existing software to make use of a GPU can be overwhelming.
And even if the software was listed in [NVIDIA's list of GPU-Accelerated Applications](https://www.nvidia.com/content/dam/en-zz/Solutions/Data-Center/tesla-product-literature/gpu-applications-catalog.pdf)
only certain parts of the computations may run on the GPU.

To answer the question: The easiest way is to compare a typical computation
on a normal node and on a GPU node. (Make sure to eliminate the influence of different
CPU types and different number of cores.) If the execution time with GPU is better
by a significant factor then this might be the obvious choice.

??? note "Difference in Architecture"

    The main difference between CPU and GPU architecture is that a CPU is designed to handle a wide
    range of tasks quickly, but are limited in the concurrency of tasks that can be running.
    While GPUs can process data much faster than a CPU due to massive parallelism
    (but the amount of data which
    a single GPU's core can handle is small), GPUs are not as versatile as CPUs.

### Available Hardware

ZIH provides a broad variety of compute resources ranging from normal server CPUs of different
manufactures, large shared memory nodes, GPU-assisted nodes up to highly specialized resources for
[Machine Learning](../software/machine_learning.md) and AI.
The page [ZIH Systems](hardware_overview.md) holds a comprehensive overview.

The desired hardware can be specified by the partition `-p, --partition` flag in Slurm.
The majority of the basic tasks can be executed on the conventional nodes like a Haswell. Slurm will
automatically select a suitable partition depending on your memory and GPU requirements.

### Parallel Jobs

**MPI jobs:** For MPI jobs typically allocates one core per task. Several nodes could be allocated
if it is necessary. The batch system [Slurm](slurm.md) will automatically find suitable hardware.
Normal compute nodes are perfect for this task.

**OpenMP jobs:** SMP-parallel applications can only run **within a node**, so it is necessary to
include the [batch system](slurm.md) options `-N 1` and `-n 1`. Using `--cpus-per-task N` Slurm will
start one task and you will have `N` CPUs. The maximum number of processors for an SMP-parallel
program is 896 on partition `julia`, see [partitions](partitions_and_limits.md).

Partitions with GPUs are best suited for **repetitive** and **highly-parallel** computing tasks. If
you have a task with potential [data parallelism](../software/gpu_programming.md) most likely that
you need the GPUs.  Beyond video rendering, GPUs excel in tasks such as machine learning, financial
simulations and risk modeling. Use the partitions `gpu2` and `ml` only if you need GPUs! Otherwise
using the x86-based partitions most likely would be more beneficial.

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

## Exclusive Reservation of Hardware

If you need for some special reasons, e.g., for benchmarking, a project or paper deadline, parts of
our machines exclusively, we offer the opportunity to request and reserve these parts for your
project.

Please send your request **7 working days** before the reservation should start (as that's our
maximum time limit for jobs and it is therefore not guaranteed that resources are available on
shorter notice) with the following information to the
[HPC support](mailto:hpcsupport@zih.tu-dresden.de?subject=Request%20for%20a%20exclusive%20reservation%20of%20hardware&body=Dear%20HPC%20support%2C%0A%0AI%20have%20the%20following%20request%20for%20a%20exclusive%20reservation%20of%20hardware%3A%0A%0AProject%3A%0AReservation%20owner%3A%0ASystem%3A%0AHardware%20requirements%3A%0ATime%20window%3A%20%3C%5Byear%5D%3Amonth%3Aday%3Ahour%3Aminute%20-%20%5Byear%5D%3Amonth%3Aday%3Ahour%3Aminute%3E%0AReason%3A):

- `Project:` *Which project will be credited for the reservation?*
- `Reservation owner:` *Who should be able to run jobs on the
  reservation? I.e., name of an individual user or a group of users
  within the specified project.*
- `System:` *Which machine should be used?*
- `Hardware requirements:` *How many nodes and cores do you need? Do
  you have special requirements, e.g., minimum on main memory,
  equipped with a graphic card, special placement within the network
  topology?*
- `Time window:` *Begin and end of the reservation in the form
  `year:month:dayThour:minute:second` e.g.: 2020-05-21T09:00:00*
- `Reason:` *Reason for the reservation.*

!!! hint

    Please note that your project CPU hour budget will be credited for the reserved hardware even if
    you don't use it.
