# Python for Data Analytics

Python is a high-level interpreted language widely used in research and science. Using ZIH system
allows you to work with python quicker and more effective. Here the general introduction to working
with python on ZIH system is given. For specific machine learning frameworks see respective
documentation in [machine learning](machine_learning.md) section.

## Python Virtual Environments

Often it is useful to create an isolated development environment, which can be shared among
a research group and/or teaching class. For this purpose python virtual environments can be used.
For more details see [here](python_virtual_environments.md).

## Jupyter Notebooks

Jupyter notebooks are a great way for interactive computing in a web
browser. They allow working with data cleaning and transformation,
numerical simulation, statistical modelling, data visualization and machine learning.

On ZIH system a [JupyterHub](../access/jupyterhub.md) is available, which can be used to run
a Jupyter notebook on an HPC node, as well using a GPU when needed.  

## Dask

**Dask** is an open-source library for parallel computing. Dask is a flexible library for parallel
computing in Python.

Dask natively scales Python. It provides advanced parallelism for analytics, enabling performance at
scale for some of the popular tools. For instance: Dask arrays scale Numpy workflows, Dask
dataframes scale Pandas workflows, Dask-ML scales machine learning APIs like Scikit-Learn and
XGBoost.

Dask is composed of two parts:

- Dynamic task scheduling optimized for computation and interactive
  computational workloads.
- Big Data collections like parallel arrays, data frames, and lists
  that extend common interfaces like NumPy, Pandas, or Python
  iterators to larger-than-memory or distributed environments. These
  parallel collections run on top of dynamic task schedulers.

Dask supports several user interfaces:

High-Level:

- Arrays: Parallel NumPy
- Bags: Parallel lists
- DataFrames: Parallel Pandas
- Machine Learning : Parallel Scikit-Learn
- Others from external projects, like XArray

Low-Level:

- Delayed: Parallel function evaluation
- Futures: Real-time parallel function evaluation

### Installation

### Installation Using Conda

Dask is installed by default in [Anaconda](https://www.anaconda.com/download/). To install/update
Dask on a Taurus with using the [conda](https://www.anaconda.com/download/) follow the example:

```Bash
# Job submission in ml nodes with allocating: 1 node, 1 gpu per node, 4 hours
srun -p ml -N 1 -n 1 --mem-per-cpu=5772 --gres=gpu:1 --time=04:00:00 --pty bash
```

Create a conda virtual environment. We would recommend using a workspace. See the example (use
`--prefix` flag to specify the directory).

**Note:** You could work with simple examples in your home directory (where you are loading by
default). However, in accordance with the
[HPC storage concept](../data_lifecycle/hpc_storage_concept2019.md) please use a
[workspaces](../data_lifecycle/workspaces.md) for your study and work projects.

```Bash
conda create --prefix /scratch/ws/0/aabc1234-Workproject/conda-virtual-environment/dask-test python=3.6
```

By default, conda will locate the environment in your home directory:

```Bash
conda create -n dask-test python=3.6
```

Activate the virtual environment, install Dask and verify the installation:

```Bash
ml modenv/ml
ml PythonAnaconda/3.6
conda activate /scratch/ws/0/aabc1234-Workproject/conda-virtual-environment/dask-test python=3.6
which python
which conda
conda install dask
python

from dask.distributed import Client, progress
client = Client(n_workers=4, threads_per_worker=1)
client
```

### Installation Using Pip

You can install everything required for most common uses of Dask (arrays, dataframes, etc)

```Bash
srun -p ml -N 1 -n 1 --mem-per-cpu=5772 --gres=gpu:1 --time=04:00:00 --pty bash

cd /scratch/ws/0/aabc1234-Workproject/python-virtual-environment/dask-test

ml modenv/ml
module load PythonAnaconda/3.6
which python

python3 -m venv --system-site-packages dask-test
source dask-test/bin/activate
python -m pip install "dask[complete]"

python
from dask.distributed import Client, progress
client = Client(n_workers=4, threads_per_worker=1)
client
```

Distributed scheduler

?

### Run Dask on Taurus

The preferred and simplest way to run Dask on HPC systems today both for new, experienced users or
administrator is to use [dask-jobqueue](https://jobqueue.dask.org/).

You can install dask-jobqueue with `pip` or `conda`

Installation with Pip

```Bash
srun -p haswell -N 1 -n 1 -c 4 --mem-per-cpu=2583 --time=01:00:00 --pty bash
cd
/scratch/ws/0/aabc1234-Workproject/python-virtual-environment/dask-test
ml modenv/ml module load PythonAnaconda/3.6 which python

source dask-test/bin/activate pip
install dask-jobqueue --upgrade # Install everything from last released version
```

Installation with Conda

```Bash
srun -p haswell -N 1 -n 1 -c 4 --mem-per-cpu=2583 --time=01:00:00 --pty bash

ml modenv/ml module load PythonAnaconda/3.6 source
dask-test/bin/activate

conda install dask-jobqueue -c conda-forge\</verbatim>
```

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
supports communication of pickleable Python objects. Mpi4py provides
optimized communication of NumPy arrays.

Mpi4py is included as an extension of the SciPy-bundle modules on
taurus.

Please check the SoftwareModulesList for the modules availability. The availability of the mpi4py
in the module you can check by
the `module whatis <name_of_the module>` command. The `module whatis`
command displays a short information and included extensions of the
module.

Moreover, it is possible to install mpi4py in your local conda
environment:

```Bash
srun -p ml --time=04:00:00 -n 1 --pty --mem-per-cpu=8000 bash                            #allocate recources
module load modenv/ml
module load PythonAnaconda/3.6                                                           #load module to use conda
conda create --prefix=<location_for_your_environment> python=3.6 anaconda                #create conda virtual environment

conda activate <location_for_your_environment>                                          #activate your virtual environment

conda install -c conda-forge mpi4py                                                      #install mpi4py

python                                                                                   #start python

from mpi4py import MPI                                                                   #verify your mpi4py
comm = MPI.COMM_WORLD
print("%d of %d" % (comm.Get_rank(), comm.Get_size()))
```
