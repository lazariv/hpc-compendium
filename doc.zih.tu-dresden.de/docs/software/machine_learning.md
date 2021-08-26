# Machine Learning

This is an introduction of how to run machine learning applications on ZIH systems.
For machine learning purposes, we recommend to use the **Alpha** and/or **ML** partitions.

## ML partition

The compute nodes of the ML partition are built on the base of [Power9](https://www.ibm.com/it-infrastructure/power/power9)
architecture from IBM. The system was created for AI challenges, analytics and working with,
Machine learning, data-intensive workloads, deep-learning frameworks and accelerated databases.

The main feature of the nodes is the ability to work with the
[NVIDIA Tesla V100](https://www.nvidia.com/en-gb/data-center/tesla-v100/) GPU with **NV-Link**
support that allows a total bandwidth with up to 300 gigabytes per second (GB/sec). Each node on the
ml partition has 6x Tesla V-100 GPUs. You can find a detailed specification of the partition [here](../jobs_and_resources/power9.md).

**Note:** The ML partition is based on the PowerPC Architecture, which means that the software built
for x86_64 will not work on this partition. Also, users need to use the modules which are
specially made for the ml partition (from `modenv/ml`).

### Modules

On the **ML** partition load the module environment:

```console
marie@login$ srun -p ml --gres=gpu:1 -n 1 -c 7 --pty --mem-per-cpu=8000 bash    #Job submission in ml nodes with 1 gpu on 1 node with 8000 Mb per CPU
marie@ml$ module load modenv/ml    #example output: The following have been reloaded with a version change:  1) modenv/scs5 => modenv/ml
```

## Alpha partition

- describe alpha partition

### Modules

On the **Alpha** partition load the module environment:

```console
marie@login$ srun -p alpha --gres=gpu:1 -n 1 -c 7 --pty --mem-per-cpu=8000 bash   #Job submission on alpha nodes with 1 gpu on 1 node with 8000 Mb per CPU
marie@romeo$ module load modenv/scs5
```

## Machine Learning Console and Virtual Environment

A virtual environment is a cooperatively isolated run-time environment that allows Python users and
applications to install and update Python distribution packages without interfering with the
behavior of other Python applications running on the same system. At its core, the main purpose of
Python virtual environments is to create an isolated environment for Python projects.

### Conda virtual environment

[Conda](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)
is an open-source package management system and environment management system from the Anaconda.

```console
marie@login$ srun -p ml -N 1 -n 1 -c 2 --gres=gpu:1 --time=01:00:00 --pty --mem-per-cpu=8000 bash   #job submission in ml nodes with allocating: 1 node, 1 task per node, 2 CPUs per task, 1 gpu per node, with 8000 mb on 1 hour.
marie@ml$ module load modenv/ml                    #example output: The following have been reloaded with a version change:  1) modenv/scs5 =&gt; modenv/ml
marie@ml$ mkdir python-virtual-environments        #create folder for your environments
marie@ml$ cd python-virtual-environments           #go to folder
marie@ml$ which python                             #check which python are you using
marie@ml$ python3 -m venv --system-site-packages env                         #create virtual environment "env" which inheriting with global site packages
marie@ml$ source env/bin/activate                                            #activate virtual environment "env". Example output: (env) bash-4.2$
```

The inscription (env) at the beginning of each line represents that now you are in the virtual
environment.

### Python virtual environment

**virtualenv (venv)** is a standard Python tool to create isolated Python environments.
It has been integrated into the standard library under the [venv module](https://docs.python.org/3/library/venv.html).

```console
marie@login$ srun -p ml -N 1 -n 1 -c 2 --gres=gpu:1 --time=01:00:00 --pty --mem-per-cpu=8000 bash   #job submission in ml nodes with allocating: 1 node, 1 task per node, 2 CPUs per task, 1 gpu per node, with 8000 mb on 1 hour.
marie@ml$ module load modenv/ml                    #example output: The following have been reloaded with a version change:  1) modenv/scs5 =&gt; modenv/ml
marie@ml$ mkdir python-virtual-environments        #create folder for your environments
marie@ml$ cd python-virtual-environments           #go to folder
marie@ml$ which python                             #check which python are you using
marie@ml$ python3 -m venv --system-site-packages env                         #create virtual environment "env" which inheriting with global site packages
marie@ml$ source env/bin/activate                                            #activate virtual environment "env". Example output: (env) bash-4.2$
```

The inscription (env) at the beginning of each line represents that now you are in the virtual
environment.

Note: However in case of using [sbatch files](link) to send your job you usually don't need a
virtual environment.

## Machine Learning with Jupyter

The [Jupyter Notebook](https://jupyter.org/) is an open-source web application that allows you to
create documents containing live code, equations, visualizations, and narrative text. [JupyterHub](../access/jupyterhub.md)
allows to work with machine learning frameworks (e.g. TensorFlow or PyTorch) on Taurus and to run
your Jupyter notebooks on HPC nodes.

After accessing JupyterHub, you can start a new session and configure it. For machine learning
purposes, select either **Alpha** or **ML** partition and the resources, your application requires.

## Machine Learning with Containers

Some machine learning tasks require using containers. In the HPC domain, the [Singularity](https://singularity.hpcng.org/)
container system is a widely used tool. Docker containers can also be used by Singularity. You can
find further information on working with containers on ZIH systems [here](containers.md)

There are two sources for containers for Power9 architecture with
TensorFlow and PyTorch on the board:

* [TensorFlow-ppc64le](https://hub.docker.com/r/ibmcom/tensorflow-ppc64le):
  Community-supported `ppc64le` docker container for TensorFlow.
* [PowerAI container](https://hub.docker.com/r/ibmcom/powerai/):
  Official Docker container with TensorFlow, PyTorch and many other packages.
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

|       |                                         |
|-------|-----------------------------------------|
| NCCL  | `/usr/local/cuda/targets/ppc64le-linux` |
| cuDNN | `/usr/local/cuda/targets/ppc64le-linux` |

Note: For optimal NCCL performance it is recommended to set the
**NCCL_MIN_NRINGS** environment variable during execution. You can try
different values but 4 should be a pretty good starting point.

```console
marie@compute$ export NCCL_MIN_NRINGS=4
```

### HPC

The following HPC related software is installed on all nodes:

|                  |                          |
|------------------|--------------------------|
| IBM Spectrum MPI | `/opt/ibm/spectrum_mpi/` |
| PGI compiler     | `/opt/pgi/`              |
| IBM XLC Compiler | `/opt/ibm/xlC/`          |
| IBM XLF Compiler | `/opt/ibm/xlf/`          |
| IBM ESSL         | `/opt/ibmmath/essl/`     |
| IBM PESSL        | `/opt/ibmmath/pessl/`    |
