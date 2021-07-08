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

## Login

### SSH Access

The recommended way to connect to the HPC login servers directly via ssh:

```Bash
ssh <zih-login>@taurus.hrsk.tu-dresden.de
```

Please put this command in the terminal and replace `<zih-login>` with your login that you received
during the access procedure. Accept the host verifying and enter your password.

This method requires two conditions:
Linux OS, workstation within the campus network. For other options and
details check the [login page](../access/login.md).

## Data management

### Workspaces

As soon as you have access to HPC-DA you have to manage your data. The main method of working with
data on Taurus is using Workspaces.  You could work with simple examples in your home directory
(where you are loading by default). However, in accordance with the 
[storage concept](../data_lifecycle/hpc_storage_concept2019.md)
**please use** a [workspace](../data_lifecycle/workspaces.md)
for your study and work projects.

You should create your workspace with a similar command:

```Bash
ws_allocate -F scratch Machine_learning_project 50    #allocating workspase in scratch directory for 50 days
```

After the command, you will have an output with the address of the workspace based on scratch. Use
it to store the main data of your project.

For different purposes, you should use different storage systems.  To work as efficient as possible,
consider the following points:

- Save source code etc. in `/home` or `/projects/...`
- Store checkpoints and other massive but temporary data with
  workspaces in: `/scratch/ws/...`
- For data that seldom changes but consumes a lot of space, use
  mid-term storage with workspaces: `/warm_archive/...`
- For large parallel applications where using the fastest file system
  is a necessity, use with workspaces: `/lustre/ssd/...`
- Compilation in `/dev/shm`** or `/tmp`

### Data moving

#### Moving data to/from the HPC machines

To copy data to/from the HPC machines, the Taurus [export nodes](../data_transfer/export_nodes.md)
should be used. They are the preferred way to transfer your data. There are three possibilities to
exchanging data between your local machine (lm) and the HPC machines (hm): **SCP, RSYNC, SFTP**.

Type following commands in the local directory of the local machine. For example, the **`SCP`**
command was used.

#### Copy data from lm to hm

```Bash
scp &lt;file&gt; &lt;zih-user&gt;@taurusexport.hrsk.tu-dresden.de:&lt;target-location&gt;                  #Copy file from your local machine. For example: scp helloworld.txt mustermann@taurusexport.hrsk.tu-dresden.de:/scratch/ws/mastermann-Macine_learning_project/

scp -r &lt;directory&gt; &lt;zih-user&gt;@taurusexport.hrsk.tu-dresden.de:&lt;target-location&gt;          #Copy directory from your local machine.
```

#### Copy data from hm to lm

```Bash
scp &lt;zih-user&gt;@taurusexport.hrsk.tu-dresden.de:&lt;file&gt; &lt;target-location&gt;                  #Copy file. For example: scp mustermann@taurusexport.hrsk.tu-dresden.de:/scratch/ws/mastermann-Macine_learning_project/helloworld.txt /home/mustermann/Downloads

scp -r &lt;zih-user&gt;@taurusexport.hrsk.tu-dresden.de:&lt;directory&gt; &lt;target-location&gt;          #Copy directory
```

#### Moving data inside the HPC machines. Datamover

The best way to transfer data inside the Taurus is the [data mover](../data_transfer/data_mover.md).
It is the special data transfer machine providing the global file systems of each ZIH HPC system.
Datamover provides the best data speed. To load, move, copy etc.  files from one file system to
another file system, you have to use commands with **dt** prefix, such as:

`dtcp, dtwget, dtmv, dtrm, dtrsync, dttar, dtls`

These commands submit a job to the data transfer machines that execute the selected command. Except
for the `dt` prefix, their syntax is the same as the shell command without the `dt`.

```Bash
dtcp -r /scratch/ws/&lt;name_of_your_workspace&gt;/results /luste/ssd/ws/&lt;name_of_your_workspace&gt;       #Copy from workspace in scratch to ssd.<br />dtwget https://www.cs.toronto.edu/~kriz/cifar-100-python.tar.gz                                   #Download archive CIFAR-100.
```

## BatchSystems. SLURM

After logon and preparing your data for further work the next logical step is to start your job. For
these purposes, SLURM is using. Slurm (Simple Linux Utility for Resource Management) is an
open-source job scheduler that allocates compute resources on clusters for queued defined jobs.  By
default, after your logging, you are using the login nodes. The intended purpose of these nodes
speaks for oneself.  Applications on an HPC system can not be run there! They have to be submitted
to compute nodes (ml nodes for HPC-DA) with dedicated resources for user jobs.

Job submission can be done with the command: `-srun [options] <command>.`

This is a simple example which you could use for your start. The `srun` command is used to submit a
job for execution in real-time designed for interactive use, with monitoring the output. For some
details please check [the Slurm page](../jobs_and_resources/slurm.md).

```Bash
srun -p ml -N 1 --gres=gpu:1 --time=01:00:00 --pty --mem-per-cpu=8000 bash   #Job submission in ml nodes with allocating: 1 node, 1 gpu per node, with 8000 mb on 1 hour.
```

However, using srun directly on the shell will lead to blocking and launch an interactive job. Apart
from short test runs, it is **recommended to launch your jobs into the background by using batch
jobs**. For that, you can conveniently put the parameters directly into the job file which you can
submit using `sbatch [options] <job file>.`

This is the example of the sbatch file to run your application:

```Bash
#!/bin/bash
#SBATCH --mem=8GB                         # specify the needed memory
#SBATCH -p ml                             # specify ml partition
#SBATCH --gres=gpu:1                      # use 1 GPU per node (i.e. use one GPU per task)
#SBATCH --nodes=1                         # request 1 node
#SBATCH --time=00:15:00                   # runs for 10 minutes
#SBATCH -c 1                              # how many cores per task allocated
#SBATCH -o HLR_name_your_script.out       # save output message under HLR_${SLURMJOBID}.out
#SBATCH -e HLR_name_your_script.err       # save error messages under HLR_${SLURMJOBID}.err

module load modenv/ml
module load TensorFlow

python machine_learning_example.py

## when finished writing, submit with:  sbatch &lt;script_name&gt; For example: sbatch machine_learning_script.slurm
```

The `machine_learning_example.py` contains a simple ml application based on the mnist model to test
your sbatch file. It could be found as the [attachment] **todo**
%ATTACHURL%/machine_learning_example.py in the bottom of the page.

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

There is [JupyterHub](jupyterhub.md) on Taurus, where you can simply run your Jupyter notebook on
HPC nodes. Also, for more specific cases you can run a manually created remote jupyter server. You
can find the manual server setup [here](deep_learning.md). However, the simplest option for
beginners is using JupyterHub.

JupyterHub is available at
[taurus.hrsk.tu-dresden.de/jupyter](https://taurus.hrsk.tu-dresden.de/jupyter)

After logging, you can start a new session and configure it. There are simple and advanced forms to
set up your session. On the simple form, you have to choose the "IBM Power (ppc64le)" architecture.
You can select the required number of CPUs and GPUs. For the acquaintance with the system through
the examples below the recommended amount of CPUs and 1 GPU will be enough.
With the advanced form, you can use
the configuration with 1 GPU and 7 CPUs. To access for all your workspaces use " / " in the
workspace scope. Please check updates and details [here](jupyterhub.md).

Several Tensorflow and PyTorch examples for the Jupyter notebook have been prepared based on some
simple tasks and models which will give you an understanding of how to work with ML frameworks and
JupyterHub. It could be found as the [attachment] **todo** %ATTACHURL%/machine_learning_example.py
in the bottom of the page. A detailed explanation and examples for TensorFlow can be found
[here](tensor_flow_on_jupyter_notebook.md). For the Pytorch - [here](py_torch.md).  Usage information
about the environments for the JupyterHub could be found [here](jupyterhub.md) in the chapter
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
for using virtual machines; [Manual method](cloud.md) - it requires more
operations but gives you more flexibility and reliability.

- [machine_learning_example.py] **todo** %ATTACHURL%/machine_learning_example.py:
  machine_learning_example.py
- [example_TensofFlow_MNIST.zip] **todo** %ATTACHURL%/example_TensofFlow_MNIST.zip:
  example_TensofFlow_MNIST.zip
- [example_Pytorch_MNIST.zip] **todo** %ATTACHURL%/example_Pytorch_MNIST.zip:
  example_Pytorch_MNIST.zip
- [example_Pytorch_image_recognition.zip] **todo** %ATTACHURL%/example_Pytorch_image_recognition.zip:
  example_Pytorch_image_recognition.zip
- [example_TensorFlow_Automobileset.zip] **todo** %ATTACHURL%/example_TensorFlow_Automobileset.zip:
  example_TensorFlow_Automobileset.zip
- [HPC-Introduction.pdf] **todo** %ATTACHURL%/HPC-Introduction.pdf:
  HPC-Introduction.pdf
- [HPC-DA-Introduction.pdf] **todo** %ATTACHURL%/HPC-DA-Introduction.pdf :
  HPC-DA-Introduction.pdf
