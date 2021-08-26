# Machine Learning

This is an introduction of how to run machine learning applications on ZIH systems.
For machine learning purposes, we recommend to use the **Alpha** and/or **ML** partitions.

## ML partition

The compute nodes of the ML partition are built on the base of [Power9](https://www.ibm.com/it-infrastructure/power/power9)
architecture from IBM. The system was created for AI challenges, analytics and working with
data-intensive workloads and accelerated databases.

The main feature of the nodes is the ability to work with the
[NVIDIA Tesla V100](https://www.nvidia.com/en-gb/data-center/tesla-v100/) GPU with **NV-Link**
support that allows a total bandwidth with up to 300 gigabytes per second (GB/sec). Each node on the
ml partition has 6x Tesla V-100 GPUs. You can find a detailed specification of the partition [here](../jobs_and_resources/power9.md).

**Note:** The ML partition is based on the Power9 architecture, which means that the software built
for x86_64 will not work on this partition. Also, users need to use the modules which are
specially made for the ml partition (from modenv/ml).

### Modules

On the **ML** partition load the module environment:

```console
marie@login$ srun -p ml --gres=gpu:1 -n 1 -c 7 --pty --mem-per-cpu=8000 bash    #Job submission in ml nodes with 1 gpu on 1 node with 8000 Mb per CPU
marie@ml$ module load modenv/ml    #example output: The following have been reloaded with a version change:  1) modenv/scs5 => modenv/ml
```

## Alpha partition

Another partition for machine learning tasks is Alpha. It is mainly dedicated to [ScaDS.AI](https://scads.ai/)
topics. Each node on Alpha has 2x AMD EPYC CPUs, 8x NVIDIA A100-SXM4 GPUs, 1TB RAM and 3.5TB local
space (/tmp) on an NVMe device. You can find more details of the partition [here](../jobs_and_resources/alpha_centauri.md).

### Modules

On the **Alpha** partition load the module environment:

```console
marie@login$ srun -p alpha --gres=gpu:1 -n 1 -c 7 --pty --mem-per-cpu=8000 bash   #Job submission on alpha nodes with 1 gpu on 1 node with 8000 Mb per CPU
marie@romeo$ module load modenv/scs5
```

## Machine Learning via Console

### Python and Virtual Environments

Python users should use a virtual environment when conducting machine learning tasks via console.
In case of using [sbatch files](../jobs_and_resources/batch_systems.md) to send your job you usually
don't need a virtual environment.

For more details on machine learning or data science with Python see [here](data_analytics_with_python.md).

### R

R also supports machine learning via console. It does not require a virtual environment due to a
different package managment.

For more details on machine learning or data science with R see [here](../data_analytics_with_r/#r-console).

## Machine Learning with Jupyter

The [Jupyter Notebook](https://jupyter.org/) is an open-source web application that allows you to
create documents containing live code, equations, visualizations, and narrative text. [JupyterHub](../access/jupyterhub.md)
allows to work with machine learning frameworks (e.g. TensorFlow or Pytorch) on Taurus and to run
your Jupyter notebooks on HPC nodes.

After accessing JupyterHub, you can start a new session and configure it. For machine learning
purposes, select either **Alpha** or **ML** partition and the resources, your application requires.

In your session you can use [Python](../data_analytics_with_python/#jupyter-notebooks), [R](../data_analytics_with_r/#r-in-jupyterhub)
or [R studio](data_analytics_with_rstudio) for your machine learning and data science topics.

## Machine Learning with Containers

Some machine learning tasks require using containers. In the HPC domain, the [Singularity](https://singularity.hpcng.org/)
container system is a widely used tool. Docker containers can also be used by Singularity. You can
find further information on working with containers on ZIH systems [here](containers.md)

There are two sources for containers for Power9 architecture with
Tensorflow and PyTorch on the board:

* [Tensorflow-ppc64le](https://hub.docker.com/r/ibmcom/tensorflow-ppc64le):
  Community-supported ppc64le docker container for TensorFlow.
* [PowerAI container](https://hub.docker.com/r/ibmcom/powerai/):
  Official Docker container with Tensorflow, PyTorch and many other packages.
  Heavy container. It requires a lot of space. Could be found on Taurus.

Note: You could find other versions of software in the container on the "tag" tab on the docker web
page of the container.

In the following example, we build a Singularity container with TensorFlow from the DockerHub and
start it:

```console
marie@login$ srun -p ml -N 1 --gres=gpu:1 --time=02:00:00 --pty --mem-per-cpu=8000 bash           #allocating resourses from ml nodes to start the job to create a container.
marie@ml$ singularity build my-ML-container.sif docker://ibmcom/tensorflow-ppc64le             #create a container from the DockerHub with the last TensorFlow version
marie@ml$ singularity run --nv my-ML-container.sif                                            #run my-ML-container.sif container with support of the Nvidia's GPU. You could also entertain with your container by commands: singularity shell, singularity exec
```

## Additional Libraries for Machine Learning

The following NVIDIA libraries are available on all nodes:

|       |                                       |
|-------|---------------------------------------|
| NCCL  | /usr/local/cuda/targets/ppc64le-linux |
| cuDNN | /usr/local/cuda/targets/ppc64le-linux |

Note: For optimal NCCL performance it is recommended to set the
**NCCL_MIN_NRINGS** environment variable during execution. You can try
different values but 4 should be a pretty good starting point.

```console
marie@compute$ export NCCL_MIN_NRINGS=4
```

### HPC related Software

The following HPC related software is installed on all nodes:

|                  |                        |
|------------------|------------------------|
| IBM Spectrum MPI | /opt/ibm/spectrum_mpi/ |
| PGI compiler     | /opt/pgi/              |
| IBM XLC Compiler | /opt/ibm/xlC/          |
| IBM XLF Compiler | /opt/ibm/xlf/          |
| IBM ESSL         | /opt/ibmmath/essl/     |
| IBM PESSL        | /opt/ibmmath/pessl/    |
