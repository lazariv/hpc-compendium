# Machine Learning

On the machine learning nodes, you can use the tools from [IBM Power
AI](power_ai.md).

# Get started with HPC-DA

HPC-DA (High-Performance Computing and Data Analytics) is a part of TU-Dresden general purpose HPC
cluster (Taurus). HPC-DA is the best **option** for **Machine learning, Deep learning** applications
and tasks connected with the big data.

**This is an introduction of how to run machine learning applications on the HPC-DA system.**

The main **aim** of this guide is to help users who have started working with Taurus and focused on
working with Machine learning frameworks such as TensorFlow or Pytorch.

**Prerequisites:** To work with HPC-DA, you need [Login](../access/login.md) for the Taurus system
and preferably have basic knowledge about High-Performance computers and Python.

**Disclaimer:** This guide provides the main steps on the way of using Taurus, for details please
follow links in the text.

You can also find the information you need on the
[HPC-Introduction] **todo** %ATTACHURL%/HPC-Introduction.pdf?t=1585216700 and
[HPC-DA-Introduction] *todo** %ATTACHURL%/HPC-DA-Introduction.pdf?t=1585162693 presentation slides.

## Why should I use HPC-DA? The architecture and feature of the HPC-DA

HPC-DA built on the base of [Power9](https://www.ibm.com/it-infrastructure/power/power9)
architecture from IBM. HPC-DA created from
[AC922 IBM servers](https://www.ibm.com/ie-en/marketplace/power-systems-ac922), which was created
for AI challenges, analytics and working with, Machine learning, data-intensive workloads,
deep-learning frameworks and accelerated databases. POWER9 is the processor with state-of-the-art
I/O subsystem technology, including next-generation NVIDIA NVLink, PCIe Gen4 and OpenCAPI.
[Here](../jobs_and_resources/power9.md) you could find a detailed specification of the TU Dresden
HPC-DA system.

The main feature of the Power9 architecture (ppc64le) is the ability to work the
[NVIDIA Tesla V100](https://www.nvidia.com/en-gb/data-center/tesla-v100/) GPU with **NV-Link**
support. NV-Link technology allows increasing a total bandwidth of 300 gigabytes per second (GB/sec)

- 10X the bandwidth of PCIe Gen 3. The bandwidth is a crucial factor for deep learning and machine
    learning applications.

**Note:** The Power9 architecture not so common as an x86 architecture. This means you are not so
flexible with choosing applications for your projects. Even so, the main tools and applications are
available. See available modules here.

**Please use the ml partition if you need GPUs!** Otherwise using the x86 partitions (e.g Haswell)
most likely would be more beneficial.

## Start your application

As stated before HPC-DA was created for deep learning, machine learning applications. Machine
learning frameworks as TensorFlow and PyTorch are industry standards now.

There are three main options on how to work with Tensorflow and PyTorch:

1. **Modules**
1. **JupyterNotebook**
1. **Containers**

### Modules

The easiest way is using the [modules system](modules.md) and Python virtual environment. Modules
are a way to use frameworks, compilers, loader, libraries, and utilities. The module is a user
interface that provides utilities for the dynamic modification of a user's environment without
manual modifications. You could use them for srun , bath jobs (sbatch) and the Jupyterhub.

A virtual environment is a cooperatively isolated runtime environment that allows Python users and
applications to install and update Python distribution packages without interfering with the
behaviour of other Python applications running on the same system. At its core, the main purpose of
Python virtual environments is to create an isolated environment for Python projects.

**Vitualenv (venv)** is a standard Python tool to create isolated Python environments. We recommend
using venv to work with Tensorflow and Pytorch on Taurus. It has been integrated into the standard
library under the [venv module](https://docs.python.org/3/library/venv.html). However, if you have
reasons (previously created environments etc) you could easily use conda. The conda is the second
way to use a virtual environment on the Taurus.
[Conda](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)
is an open-source package management system and environment management system from the Anaconda.

As was written in the previous chapter, to start the application (using
modules) and to run the job exist two main options:

- The `srun` command:**

```Bash
srun -p ml -N 1 -n 1 -c 2 --gres=gpu:1 --time=01:00:00 --pty --mem-per-cpu=8000 bash   #job submission in ml nodes with allocating: 1 node, 1 task per node, 2 CPUs per task, 1 gpu per node, with 8000 mb on 1 hour.

module load modenv/ml                    #example output: The following have been reloaded with a version change:  1) modenv/scs5 =&gt; modenv/ml

mkdir python-virtual-environments        #create folder for your environments
cd python-virtual-environments           #go to folder
module load TensorFlow                   #load TensorFlow module to use python. Example output: Module Module TensorFlow/2.1.0-fosscuda-2019b-Python-3.7.4 and 31 dependencies loaded.
which python                             #check which python are you using
python3 -m venv --system-site-packages env                         #create virtual environment "env" which inheriting with global site packages
source env/bin/activate                                            #activate virtual environment "env". Example output: (env) bash-4.2$
```

The inscription (env) at the beginning of each line represents that now you are in the virtual
environment.

Now you can check the working capacity of the current environment.

```Bash
python                                                           # start python
import tensorflow as tf
print(tf.__version__)                                            # example output: 2.1.0
```

The second and main option is using batch jobs (`sbatch`). It is used to submit a job script for
later execution. Consequently, it is **recommended to launch your jobs into the background by using
batch jobs**. To launch your machine learning application as well to srun job you need to use
modules. See the previous chapter with the sbatch file example.

Versions: TensorFlow 1.14, 1.15, 2.0, 2.1; PyTorch 1.1, 1.3 are available. (25.02.20)

Note: However in case of using sbatch files to send your job you usually don't need a virtual
environment.

### JupyterNotebook

The Jupyter Notebook is an open-source web application that allows you to create documents
containing live code, equations, visualizations, and narrative text. Jupyter notebook allows working
with TensorFlow on Taurus with GUI (graphic user interface) in a **web browser** and the opportunity
to see intermediate results step by step of your work. This can be useful for users who dont have
huge experience with HPC or Linux.

There is [JupyterHub](../access/jupyterhub.md) on Taurus, where you can simply run your Jupyter
notebook on HPC nodes. Also, for more specific cases you can run a manually created remote jupyter
server. You can find the manual server setup [here](deep_learning.md). However, the simplest option
for beginners is using JupyterHub.

JupyterHub is available at
[taurus.hrsk.tu-dresden.de/jupyter](https://taurus.hrsk.tu-dresden.de/jupyter)

After logging, you can start a new session and configure it. There are simple and advanced forms to
set up your session. On the simple form, you have to choose the "IBM Power (ppc64le)" architecture.
You can select the required number of CPUs and GPUs. For the acquaintance with the system through
the examples below the recommended amount of CPUs and 1 GPU will be enough.
With the advanced form, you can use
the configuration with 1 GPU and 7 CPUs. To access for all your workspaces use " / " in the
workspace scope. Please check updates and details [here](../access/jupyterhub.md).

Several Tensorflow and PyTorch examples for the Jupyter notebook have been prepared based on some
simple tasks and models which will give you an understanding of how to work with ML frameworks and
JupyterHub. It could be found as the [attachment] **todo** %ATTACHURL%/machine_learning_example.py
in the bottom of the page. A detailed explanation and examples for TensorFlow can be found
[here](tensor_flow_on_jupyter_notebook.md). For the Pytorch - [here](py_torch.md).  Usage information
about the environments for the JupyterHub could be found [here](../access/jupyterhub.md) in the chapter
*Creating and using your own environment*.

Versions: TensorFlow 1.14, 1.15, 2.0, 2.1; PyTorch 1.1, 1.3 are
available. (25.02.20)

### Containers

Some machine learning tasks such as benchmarking require using containers. A container is a standard
unit of software that packages up code and all its dependencies so the application runs quickly and
reliably from one computing environment to another.  Using containers gives you more flexibility
working with modules and software but at the same time requires more effort.

On Taurus [Singularity](https://sylabs.io/) is used as a standard container solution.  Singularity
enables users to have full control of their environment.  This means that **you dont have to ask an
HPC support to install anything for you - you can put it in a Singularity container and run!**As
opposed to Docker (the beat-known container solution), Singularity is much more suited to being used
in an HPC environment and more efficient in many cases. Docker containers also can easily be used by
Singularity from the [DockerHub](https://hub.docker.com) for instance. Also, some containers are
available in [Singularity Hub](https://singularity-hub.org/).

The simplest option to start working with containers on HPC-DA is importing from Docker or
SingularityHub container with TensorFlow. It does **not require root privileges** and so works on
Taurus directly:

```Bash
srun -p ml -N 1 --gres=gpu:1 --time=02:00:00 --pty --mem-per-cpu=8000 bash           #allocating resourses from ml nodes to start the job to create a container.<br />singularity build my-ML-container.sif docker://ibmcom/tensorflow-ppc64le             #create a container from the DockerHub with the last TensorFlow version<br />singularity run --nv my-ML-container.sif                                            #run my-ML-container.sif container with support of the Nvidia's GPU. You could also entertain with your container by commands: singularity shell, singularity exec
```

There are two sources for containers for Power9 architecture with
Tensorflow and PyTorch on the board:

* [Tensorflow-ppc64le](https://hub.docker.com/r/ibmcom/tensorflow-ppc64le):
  Community-supported ppc64le docker container for TensorFlow.
* [PowerAI container](https://hub.docker.com/r/ibmcom/powerai/):
  Official Docker container with Tensorflow, PyTorch and many other packages.
  Heavy container. It requires a lot of space. Could be found on Taurus.

Note: You could find other versions of software in the container on the "tag" tab on the docker web
page of the container.

To use not a pure Tensorflow, PyTorch but also with some Python packages
you have to use the definition file to create the container
(bootstrapping). For details please see the [Container](containers.md) page
from our wiki. Bootstrapping **has required root privileges** and
Virtual Machine (VM) should be used! There are two main options on how
to work with VM on Taurus: [VM tools](vm_tools.md) - automotive algorithms
for using virtual machines; [Manual method](virtual_machines.md) - it requires more
operations but gives you more flexibility and reliability.


## Interactive Session Examples

### Tensorflow-Test

    tauruslogin6 :~> srun -p ml --gres=gpu:1 -n 1 --pty --mem-per-cpu=10000 bash
    srun: job 4374195 queued and waiting for resources
    srun: job 4374195 has been allocated resources
    taurusml22 :~> ANACONDA2_INSTALL_PATH='/opt/anaconda2'
    taurusml22 :~> ANACONDA3_INSTALL_PATH='/opt/anaconda3'
    taurusml22 :~> export PATH=$ANACONDA3_INSTALL_PATH/bin:$PATH
    taurusml22 :~> source /opt/DL/tensorflow/bin/tensorflow-activate
    taurusml22 :~> tensorflow-test
    Basic test of tensorflow - A Hello World!!!...

    #or:
    taurusml22 :~> module load TensorFlow/1.10.0-PythonAnaconda-3.6

Or to use the whole node: `--gres=gpu:6 --exclusive --pty`

### In Singularity container:

    rotscher@tauruslogin6:~&gt; srun -p ml --gres=gpu:6 --pty bash
    [rotscher@taurusml22 ~]$ singularity shell --nv /scratch/singularity/powerai-1.5.3-all-ubuntu16.04-py3.img
    Singularity powerai-1.5.3-all-ubuntu16.04-py3.img:~&gt; export PATH=/opt/anaconda3/bin:$PATH
    Singularity powerai-1.5.3-all-ubuntu16.04-py3.img:~&gt; . /opt/DL/tensorflow/bin/tensorflow-activate
    Singularity powerai-1.5.3-all-ubuntu16.04-py3.img:~&gt; tensorflow-test

## Additional libraries

The following NVIDIA libraries are available on all nodes:

|       |                                       |
|-------|---------------------------------------|
| NCCL  | /usr/local/cuda/targets/ppc64le-linux |
| cuDNN | /usr/local/cuda/targets/ppc64le-linux |

Note: For optimal NCCL performance it is recommended to set the
**NCCL_MIN_NRINGS** environment variable during execution. You can try
different values but 4 should be a pretty good starting point.

    export NCCL_MIN_NRINGS=4

\<span style="color: #222222; font-size: 1.385em;">HPC\</span>

The following HPC related software is installed on all nodes:

|                  |                        |
|------------------|------------------------|
| IBM Spectrum MPI | /opt/ibm/spectrum_mpi/ |
| PGI compiler     | /opt/pgi/              |
| IBM XLC Compiler | /opt/ibm/xlC/          |
| IBM XLF Compiler | /opt/ibm/xlf/          |
| IBM ESSL         | /opt/ibmmath/essl/     |
| IBM PESSL        | /opt/ibmmath/pessl/    |
