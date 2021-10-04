# Machine Learning

This is an introduction of how to run machine learning applications on ZIH systems.
For machine learning purposes, we recommend to use the partitions `alpha` and/or `ml`.

## Partition `ml`

The compute nodes of the partition ML are built on the base of
[Power9 architecture](https://www.ibm.com/it-infrastructure/power/power9) from IBM. The system was created
for AI challenges, analytics and working with data-intensive workloads and accelerated databases.

The main feature of the nodes is the ability to work with the
[NVIDIA Tesla V100](https://www.nvidia.com/en-gb/data-center/tesla-v100/) GPU with **NV-Link**
support that allows a total bandwidth with up to 300 GB/s. Each node on the
partition ML has 6x Tesla V-100 GPUs. You can find a detailed specification of the partition in our
[Power9 documentation](../jobs_and_resources/power9.md).

!!! note

    The partition ML is based on the Power9 architecture, which means that the software built
    for x86_64 will not work on this partition. Also, users need to use the modules which are
    specially build for this architecture (from `modenv/ml`).

### Modules

On the partition ML load the module environment:

```console
marie@ml$ module load modenv/ml
The following have been reloaded with a version change:  1) modenv/scs5 => modenv/ml
```

### Power AI

There are tools provided by IBM, that work on partition ML and are related to AI tasks.
For more information see our [Power AI documentation](power_ai.md).

## Partition: Alpha

Another partition for machine learning tasks is Alpha. It is mainly dedicated to
[ScaDS.AI](https://scads.ai/) topics. Each node on Alpha has 2x AMD EPYC CPUs, 8x NVIDIA A100-SXM4
GPUs, 1 TB RAM and 3.5 TB local space (`/tmp`) on an NVMe device. You can find more details of the
partition in our [Alpha Centauri](../jobs_and_resources/alpha_centauri.md) documentation.

### Modules

On the partition alpha load the module environment:

```console
marie@alpha$ module load modenv/hiera
The following have been reloaded with a version change:  1) modenv/ml => modenv/hiera
```

!!! note

    On partition Alpha, the most recent modules are build in `hiera`. Alternative modules might be
    build in `scs5`.

## Machine Learning via Console

### Python and Virtual Environments

Python users should use a [virtual environment](python_virtual_environments.md) when conducting
machine learning tasks via console.

For more details on machine learning or data science with Python see
[data analytics with Python](data_analytics_with_python.md).

### R

R also supports machine learning via console. It does not require a virtual environment due to a
different package management.

For more details on machine learning or data science with R see
[data analytics with R](data_analytics_with_r.md#r-console).

## Machine Learning with Jupyter

The [Jupyter Notebook](https://jupyter.org/) is an open-source web application that allows you to
create documents containing live code, equations, visualizations, and narrative text.
[JupyterHub](../access/jupyterhub.md) allows to work with machine learning frameworks (e.g.
TensorFlow or PyTorch) on ZIH systems and to run your Jupyter notebooks on HPC nodes.

After accessing JupyterHub, you can start a new session and configure it. For machine learning
purposes, select either partition **Alpha** or **ML** and the resources, your application requires.

In your session you can use [Python](data_analytics_with_python.md#jupyter-notebooks),
[R](data_analytics_with_r.md#r-in-jupyterhub) or [RStudio](data_analytics_with_rstudio.md) for your
machine learning and data science topics.

## Machine Learning with Containers

Some machine learning tasks require using containers. In the HPC domain, the
[Singularity](https://singularity.hpcng.org/) container system is a widely used tool. Docker
containers can also be used by Singularity. You can find further information on working with
containers on ZIH systems in our [containers documentation](containers.md).

There are two sources for containers for Power9 architecture with TensorFlow and PyTorch on the
board:

* [TensorFlow-ppc64le](https://hub.docker.com/r/ibmcom/tensorflow-ppc64le):
  Community-supported `ppc64le` docker container for TensorFlow.
* [PowerAI container](https://hub.docker.com/r/ibmcom/powerai/):
  Official Docker container with TensorFlow, PyTorch and many other packages.

!!! note

    You could find other versions of software in the container on the "tag" tab on the docker web
    page of the container.

In the following example, we build a Singularity container with TensorFlow from the DockerHub and
start it:

```console
marie@ml$ singularity build my-ML-container.sif docker://ibmcom/tensorflow-ppc64le    #create a container from the DockerHub with the last TensorFlow version
[...]
marie@ml$ singularity run --nv my-ML-container.sif    #run my-ML-container.sif container supporting the Nvidia's GPU. You can also work with your container by: singularity shell, singularity exec
[...]
```

## Additional Libraries for Machine Learning

The following NVIDIA libraries are available on all nodes:

| Name  |  Path                                   |
|-------|-----------------------------------------|
| NCCL  | `/usr/local/cuda/targets/ppc64le-linux` |
| cuDNN | `/usr/local/cuda/targets/ppc64le-linux` |

!!! note

    For optimal NCCL performance it is recommended to set the
    **NCCL_MIN_NRINGS** environment variable during execution. You can try
    different values but 4 should be a pretty good starting point.

```console
marie@compute$ export NCCL_MIN_NRINGS=4
```

### HPC-Related Software

The following HPC related software is installed on all nodes:

| Name             |  Path                    |
|------------------|--------------------------|
| IBM Spectrum MPI | `/opt/ibm/spectrum_mpi/` |
| PGI compiler     | `/opt/pgi/`              |
| IBM XLC Compiler | `/opt/ibm/xlC/`          |
| IBM XLF Compiler | `/opt/ibm/xlf/`          |
| IBM ESSL         | `/opt/ibmmath/essl/`     |
| IBM PESSL        | `/opt/ibmmath/pessl/`    |

## Datasets for Machine Learning

There are many different datasets designed for research purposes. If you would like to download some
of them, keep in mind that many machine learning libraries have direct access to public datasets
without downloading it, e.g. [TensorFlow Datasets](https://www.tensorflow.org/datasets). If you
still need to download some datasets use [datamover](../data_transfer/datamover.md) machine.

### The ImageNet Dataset

The ImageNet project is a large visual database designed for use in visual object recognition
software research. In order to save space in the filesystem by avoiding to have multiple duplicates
of this lying around, we have put a copy of the ImageNet database (ILSVRC2012 and ILSVR2017) under
`/scratch/imagenet` which you can use without having to download it again. For the future, the
ImageNet dataset will be available in
[Warm Archive](../data_lifecycle/workspaces.md#mid-term-storage). ILSVR2017 also includes a dataset
for recognition objects from a video. Please respect the corresponding
[Terms of Use](https://image-net.org/download.php).
