# Python for Data Analytics

Python is a high-level interpreted language widely used in research and
science. Using HPC allows you to work with python quicker and more
effective. TU Dresden HPC system (ZIH system) allows working with a lot of available packages and
libraries which give more useful functionalities and allow use all
features of Python and to avoid minuses.

**Prerequisites:** To work with PyTorch you obviously need [access](../access/ssh_login.md) for the
ZIH system and basic knowledge about Python, Numpy and Slurm system.

**Aim** of this page is to introduce users on how to start working with Python on the
[High-Performance Computing and Data Analytics](../jobs_and_resources/power9.md) system -  part of the TU Dresden HPC system.

There are three main options on how to work with Keras and Tensorflow on the ZIH system: 1. Modules; 2.
[JupyterNotebook](../access/jupyterhub.md); 3.[Containers](containers.md). The main way is using
the [Modules system](modules.md) and Python virtual environment.

Note: You could work with simple examples in your home directory but according to
[HPCStorageConcept2019](../data_lifecycle/overview.md) please use **workspaces**
for your study and work projects.

## Virtual environment

There are two methods of how to work with virtual environments on
on the ZIH system:

1. **Vitualenv** is a standard Python tool to create isolated Python environments.
   It is the preferred interface for
   managing installations and virtual environments on the system and part of the Python modules.

2. **Conda** is an alternative method for managing installations and
virtual environments on the cluster. Conda is an open-source package
management system and environment management system from Anaconda. The
conda manager is included in all versions of Anaconda and Miniconda.

**Note:** Keep in mind that you **cannot** use virtualenv for working
with the virtual environments previously created with conda tool and
vice versa! Prefer virtualenv whenever possible.

This example shows how to start working
with **Virtualenv** and Python virtual environment (using the module system)

```console
marie@login$ srun -p ml -N 1 -n 1 -c 7 --mem-per-cpu=5772 --gres=gpu:1 --time=04:00:00 --pty bash   #Job submission in ml nodes with 1 gpu on 1 node.

marie@compute$ mkdir python-environments        # Optional: Create folder. Please use Workspaces!

marie@compute$ module load modenv/ml            # Changing the environment. Example output: The following have been reloaded with a version change: 1 modenv/scs5 => modenv/ml
marie@compute$ ml av Python                     #Check the available modules with Python
marie@compute$ module load Python               #Load default Python. Example output: Module Python/3.7 4-GCCcore-8.3.0 with 7 dependencies loaded
marie@compute$ which python                                                   #Check which python are you using
marie@compute$ virtualenv --system-site-packages python-environments/envtest  #Create virtual environment
marie@compute$ source python-environments/envtest/bin/activate                #Activate virtual environment. Example output: (envtest) bash-4.2$
marie@compute$ python                                                         #Start python
```
```python
from time import gmtime, strftime
print(strftime("%Y-%m-%d %H:%M:%S", gmtime()))                 #Example output: 2019-11-18 13:54:16
deactivate                                                     #Leave the virtual environment
```

The [virtualenv](https://virtualenv.pypa.io/en/latest/) Python module (Python 3) provides support
for creating virtual environments with their own sitedirectories, optionally isolated from system
site directories. Each virtual environment has its own Python binary (which matches the version of
the binary that was used to create this environment) and can have its own independent set of
installed Python packages in its site directories. This allows you to manage separate package
installations for different projects. It essentially allows us to create a virtual isolated Python
installation and install packages into that virtual installation. When you switch projects, you can
simply create a new virtual environment and not have to worry about breaking the packages installed
in other environments.

In your virtual environment, you can use packages from the (Complete List of
Modules)(SoftwareModulesList) or if you didn't find what you need you can install required packages
with the command: `pip install`. With the command `pip freeze`, you can see a list of all installed
packages and their versions.

This example shows how to start working with **Conda** and virtual
environment (with using module system)

```console
marie@login$ srun -p ml -N 1 -n 1 -c 7 --mem-per-cpu=5772 --gres=gpu:1 --time=04:00:00 --pty bash  # Job submission in ml nodes with 1 gpu on 1 node.

marie@compute$ module load modenv/ml
marie@compute$ mkdir conda-virtual-environments            #create a folder
marie@compute$ cd conda-virtual-environments               #go to folder
marie@compute$ which python                                #check which python are you using
marie@compute$ module load PythonAnaconda/3.6              #load Anaconda module
marie@compute$ which python                                #check which python are you using now

marie@compute$ conda create -n conda-testenv python=3.6        #create virtual environment with the name conda-testenv and Python version 3.6
marie@compute$ conda activate conda-testenv                    #activate conda-testenv virtual environment

marie@compute$ conda deactivate                                #Leave the virtual environment
```

You can control where a conda environment
lives by providing a path to a target directory when creating the
environment. For example, the following command will create a new
environment in a workspace located in `scratch`

```console
marie@login$ conda create --prefix /scratch/ws/<name_of_your_workspace>/conda-virtual-environment/<name_of_your_environment>
```

Please pay attention,
using srun directly on the shell will lead to blocking and launch an
interactive job. Apart from short test runs, it is **recommended to
launch your jobs into the background by using Slurm**. For that, you can conveniently put
the parameters directly into the job file which you can submit using
`sbatch [options] <job file>.`

## Jupyter Notebooks

Jupyter notebooks are a great way for interactive computing in your web
browser. Jupyter allows working with data cleaning and transformation,
numerical simulation, statistical modelling, data visualization and of
course with machine learning.

There are two general options on how to work Jupyter notebooks using
HPC.

On the ZIH system, there is [JupyterHub](../access/jupyterhub.md) where you can simply run your Jupyter
notebook on HPC nodes. Also, you can run a remote jupyter server within a sbatch GPU job and with
the modules and packages you need. The manual server setup you can find [here](deep_learning.md).

With Jupyterhub you can work with general
data analytics tools. This is the recommended way to start working with
the ZIH system. However, some special instruments could not be available on
the Jupyterhub.

**Keep in mind that the remote Jupyter server can offer more freedom with settings and approaches.**

## MPI for Python

Message Passing Interface (MPI) is a standardized and portable
message-passing standard designed to function on a wide variety of
parallel computing architectures. The Message Passing Interface (MPI) is
a library specification that allows HPC to pass information between its
various nodes and clusters. MPI designed to provide access to advanced
parallel hardware for end-users, library writers and tool developers.

### Why use MPI?

MPI provides a powerful, efficient and portable way to express parallel
programs.
Among many parallel computational models, message-passing has proven to be an effective one.

### Parallel Python with mpi4py

Mpi4py(MPI for Python) package provides bindings of the MPI standard for
the python programming language, allowing any Python program to exploit
multiple processors.

#### Why use mpi4py?

Mpi4py based on MPI-2 C++ bindings. It supports almost all MPI calls.
This implementation is popular on Linux clusters and in the SciPy
community. Operations are primarily methods of communicator objects. It
supports the communication of pickleable Python objects. Mpi4py provides
optimized communication of NumPy arrays.

Mpi4py is included as an extension of the SciPy-bundle modules on
the ZIH system for all software environments (scs5, ml, hiera(alpha)).

Please check the SoftwareModulesList for the modules availability.
The availability of the mpi4py
in the module, you can check by
the `module whatis <name_of_the module>` command. The `module whatis`
command displays short information and included extensions of the
module.

The `module spider <name_of_the module>` command
will show you all available modules for
all software partitions with this name
For detailed information about a specific "mpi4py" package
(including how to load the modules) use
the module's full name, e.g:
`module spider mpi4py/3.0.3`

Moreover, it is possible to install mpi4py in your local conda
environment:

```console
marie@login$ srun -p ml --time=04:00:00 -n 1 --pty --mem-per-cpu=8000 bash                            #allocate recources
marie@compute$ module load modenv/ml
marie@compute$ module load PythonAnaconda/3.6                                                         #load module to use conda
marie@compute$ conda create --prefix=<location_for_your_environment> python=3.6 anaconda              #create conda virtual environment

marie@compute$ conda activate <location_for_your_environment>                                       #activate your virtual environment

marie@compute$ conda install -c conda-forge mpi4py                                                  #install mpi4py

marie@compute$ python                                                                               #start python
```
```python
from mpi4py import MPI                                                                   #verify your mpi4py
comm = MPI.COMM_WORLD
print("%d of %d" % (comm.Get_rank(), comm.Get_size()))
```

For the multi-node case use a script similar with this:

```Bash
#!/bin/bash
#SBATCH --nodes=2
#SBATCH -p ml
#SBATCH --tasks-per-node=2
#SBATCH --cpus-per-task=1

module load modenv/ml
module load PythonAnaconda/3.6

eval "$(conda shell.bash hook)"
conda activate /home/marie/conda-virtual-environment/kernel2 && srun python mpi4py_test.py    #specify name of your virtual environment
```

For the verification of the multi-node case, you can use as a test
file the python-code from the previous part (with verification of the installation).

### Horovod

[Horovod](https://github.com/horovod/horovod) is the open source distributed training
framework for TensorFlow, Keras, PyTorch. It is supposed to make it easy
to develop distributed deep learning projects and speed them up with
TensorFlow.

#### Why use Horovod?

Horovod allows you to easily take a single-GPU TensorFlow and Pytorch
program and successfully train it on many GPUs! In
some cases, the MPI model is much more straightforward and requires far
less code changes than the distributed code from TensorFlow for
instance, with parameter servers. Horovod uses MPI and NCCL which gives
in some cases better results than pure TensorFlow and PyTorch.

#### Horovod as a module

Horovod is available as a module with **TensorFlow** or **PyTorch**for **all** module environments.
Please check the [software module list](modules.md) for the current version of the software.
Horovod can be loaded like other software on the system:

```console
marie@compute$ ml av Horovod            #Check available modules with Python
marie@compute$ module load Horovod      #Loading of the module
```

#### Horovod installation

However, if it is necessary to use Horovod with **PyTorch** or use
another version of Horovod it is possible to install it manually. To
install Horovod you need to create a virtual environment and load the
dependencies (e.g. MPI). Installing PyTorch can take a few hours and is
not recommended

**Note:** You could work with simple examples in your home directory but **please use workspaces
for your study and work projects** (see the Storage concept).

Setup:

```console
marie@login$ srun -N 1 --ntasks-per-node=6 -p ml --time=08:00:00 --pty bash                    #allocate a Slurm job allocation, which is a set of resources (nodes)
marie@compute$ module load modenv/ml                                                             #Load dependencies by using modules
marie@compute$ module load OpenMPI/3.1.4-gcccuda-2018b
marie@compute$ module load Python/3.6.6-fosscuda-2018b
marie@compute$ module load cuDNN/7.1.4.18-fosscuda-2018b
marie@compute$ module load CMake/3.11.4-GCCcore-7.3.0
marie@compute$ virtualenv --system-site-packages <location_for_your_environment>                 #create virtual environment
marie@compute$ source <location_for_your_environment>/bin/activate                               #activate virtual environment
```

Or when you need to use conda:

```console
marie@login$ srun -N 1 --ntasks-per-node=6 -p ml --time=08:00:00 --pty bash               #allocate a Slurm job allocation, which is a set of resources (nodes)
marie@compute$ module load modenv/ml                                                      #Load dependencies by using modules
marie@compute$ module load OpenMPI/3.1.4-gcccuda-2018b
marie@compute$ module load PythonAnaconda/3.6
marie@compute$ module load cuDNN/7.1.4.18-fosscuda-2018b
marie@compute$ module load CMake/3.11.4-GCCcore-7.3.0

conda create --prefix=<location_for_your_environment> python=3.6 anaconda                 #create virtual environment

conda activate  <location_for_your_environment>                                           #activate virtual environment
```

Install Pytorch (not recommended)

```console
marie@login$ cd /tmp
marie@login$ git clone https://github.com/pytorch/pytorch                                  #clone Pytorch from the source
marie@login$ cd pytorch                                                                    #go to folder
marie@login$ git checkout v1.7.1                                                           #Checkout version (example: 1.7.1)
marie@login$ git submodule update --init                                                   #Update dependencies

#load your venv virtual environment

marie@compute$ python setup.py install                                                       #install it with python
```

##### Install Horovod for Pytorch with python and pip

In the example presented installation for the Pytorch without
TensorFlow. Adapt as required and refer to the horovod documentation for
details.

```console
marie@compute$ HOROVOD_GPU_ALLREDUCE=MPI HOROVOD_WITHOUT_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_WITHOUT_MXNET=1 pip install --no-cache-dir horovod
```

##### Verify that Horovod works

```console
marie@compute$ python                                           #start python
```
```python
import torch                                     #import pytorch
import horovod.torch as hvd                      #import horovod
hvd.init()                                       #initialize horovod
hvd.size()
hvd.rank()
print('Hello from:', hvd.rank())
```

##### Horovod with NCCL

If you want to use NCCL instead of MPI you can specify that in the
install command after loading the NCCL module:

```console
marie@compute$ module load NCCL/2.3.7-fosscuda-2018b
marie@compute$ HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_GPU_BROADCAST=NCCL HOROVOD_WITHOUT_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_WITHOUT_MXNET=1 pip install --no-cache-dir horovod
```
