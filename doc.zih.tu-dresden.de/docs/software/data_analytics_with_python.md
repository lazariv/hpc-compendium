# Python for Data Analytics

Python is a high-level interpreted language widely used in research and science. Using ZIH system
allows you to work with Python quicker and more effective. Here, a general introduction to working
with Python on ZIH systems is given. Further documentation is available for specific
[machine learning frameworks](machine_learning.md).

## Python Console and Virtual Environments

Often, it is useful to create an isolated development environment, which can be shared among
a research group and/or teaching class. For this purpose,
[Python virtual environments](python_virtual_environments.md) can be used.

The interactive Python interpreter can also be used on ZIH systems via an interactive job:

```console
marie@login$ srun --partition=haswell --gres=gpu:1 --ntasks=1 --cpus-per-task=7 --pty --mem-per-cpu=8000 bash
marie@haswell$ module load Python
marie@haswell$ python
Python 3.8.6 (default, Feb 17 2021, 11:48:51)
[GCC 10.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

## Jupyter Notebooks

Jupyter notebooks allow to analyze data interactively using your web browser. One advantage of
Jupyter is, that code, documentation and visualization can be included in a single notebook, so that
it forms a unit. Jupyter notebooks can be used for many tasks, such as data cleaning and
transformation, numerical simulation, statistical modeling, data visualization and also machine
learning.

On ZIH systems, a [JupyterHub](../access/jupyterhub.md) is available, which can be used to run a
Jupyter notebook on a node, using a GPU when needed.

## Parallel Computing with Python

### Pandas with Pandarallel

[Pandas](https://pandas.pydata.org/){:target="_blank"} is a widely used library for data
analytics in Python.
In many cases, an existing source code using Pandas can be easily modified for parallel execution by
using the [pandarallel](https://github.com/nalepae/pandarallel/tree/v1.5.2) module. The number of
threads that can be used in parallel depends on the number of cores (parameter `--cpus-per-task`)
within the Slurm request, e.g.

```console
marie@login$ srun --partition=haswell --cpus-per-task=4 --mem=2G --hint=nomultithread --pty --time=8:00:00 bash
```

The above request allows to use 4 parallel threads.

The following example shows how to parallelize the apply method for pandas dataframes with the
pandarallel module. If the pandarallel module is not installed already, use a
[virtual environment](python_virtual_environments.md) to install the module.

??? example

    ```python
    import pandas as pd
    import numpy as np
    from pandarallel import pandarallel

    pandarallel.initialize()
    # unfortunately the initialize method gets the total number of physical cores without
    # taking into account allocated cores by Slurm, but the choice of the -c parameter is of relevance here

    N_rows = 10**5
    N_cols = 5
    df = pd.DataFrame(np.random.randn(N_rows, N_cols))

    # here some function that needs to be executed in parallel
    def transform(x):
        return(np.mean(x))

    print('calculate with normal apply...')
    df.apply(func=transform, axis=1)

    print('calculate with pandarallel...')
    df.parallel_apply(func=transform, axis=1)
    ```
For more examples of using pandarallel check out
[https://github.com/nalepae/pandarallel/blob/master/docs/examples.ipynb](https://github.com/nalepae/pandarallel/blob/master/docs/examples.ipynb).

### Dask

**Dask** is an open-source library for parallel computing.
Dask is a flexible library for parallel
computing in Python.

Dask natively scales Python.
It provides advanced parallelism, enabling performance at
scale for some of the popular tools.
For instance: Dask arrays scale NumPy workflows, Dask
dataframes scale Pandas workflows,
Dask-ML scales machine learning programming interfaces like Scikit-Learn and
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

#### Installation

Dask is available as module on
ZIH system for all software environments (scs5, ml, hiera(alpha)).
To load the module for the corresponding
software environment: `ml dask`

Please check the modules availability.

The `module spider <name_of_the module>` command
will show you all available modules for
all software partitions with this name.
For detailed information about a specific "Dask" package
(including how to load the modules) use
the module's full name, e.g:
```console
marie@compute$ module spider dask
------------------------------------------------------------------------------------------
    dask:
----------------------------------------------------------------------------------------------
    Versions:
        dask/2.8.0-fosscuda-2019b-Python-3.7.4
        dask/2.8.0-Python-3.7.4
        dask/2.8.0 (E)
[...]
marie@compute$ module load dask/2.8.0-fosscuda-2019b-Python-3.7.4
marie@compute$ python -c "import dask; print(dask.__version__)"
2021.08.1
```

The availability of the exact packages
in the module can be checked by the
`module whatis <name_of_the_module> command`.
The `module whatis`
command displays a short information and included extensions of the
module.

##### Installation Using Conda

Moreover, it is possible to install and use Dask in your local conda
environment:

Dask is installed by default in
[Anaconda](https://www.anaconda.com/download/).
To install/update
Dask on the system with using the
[conda](https://www.anaconda.com/download/) follow the example:

```console
marie@login$ srun -p ml -N 1 -n 1 --mem-per-cpu=5772 --gres=gpu:1 --time=04:00:00 --pty bash
```

Create a conda virtual environment. We would recommend
using a Workspace. See the example (use
`--prefix` flag to specify the directory).

!!! note
    You could work with simple examples in your home directory (where you are loading by default).
    However, in accordance with the [HPC storage concept](../data_lifecycle/overview.md) please use
    a [Workspace](../data_lifecycle/workspaces.md) for your study and work projects.

```console
marie@compute$ conda create --prefix /scratch/ws/0/marie-Workproject/conda-virtual-environment/dask-test python=3.6
```

By default, conda will locate the environment in your home directory:

```console
marie@compute$ conda create -n dask-test python=3.6
```

Activate the virtual environment, install Dask and verify the installation:

```console
marie@compute$ ml modenv/ml
marie@compute$ ml PythonAnaconda/3.6
marie@compute$ conda activate /scratch/ws/0/marie-Workproject/conda-virtual-environment/dask-test python=3.6
marie@compute$ which python
marie@compute$ which conda
marie@compute$ conda install dask
marie@compute$ python                            #start python
```

```python
from dask.distributed import Client, progress
client = Client(n_workers=4, threads_per_worker=1)
client
```

##### Installation Using Pip

You can install everything required for most common uses of Dask (arrays, dataframes, etc)

```console
marie@login$ srun -p ml -N 1 -n 1 --mem-per-cpu=5772 --gres=gpu:1 --time=04:00:00 --pty bash

marie@compute$ cd /scratch/ws/0/marie-Workproject/python-virtual-environment/dask-test

marie@compute$ ml modenv/ml
marie@compute$ module load PythonAnaconda/3.6
marie@compute$ which python

marie@compute$ python3 -m venv --system-site-packages dask-test
marie@compute$ source dask-test/bin/activate
marie@compute$ python -m pip install "dask[complete]"
```

```python
from dask.distributed import Client, progress
client = Client(n_workers=4, threads_per_worker=1)
client
```

#### Scheduling by Dask

One of the main features of Dask is large-scale Dask collections
(Dask Array, Dask Bag, etc). All of them are using task graphs.
After Dask generates these task graphs,
it needs to execute them on parallel hardware.
This is the job of a task scheduler.

Dask has two families of task schedulers:

- Single machine scheduler: This scheduler provides basic features
on a local process or thread pool. It can only be used on a single machine
nd does not scale. It's not interesting in the context of HPC.

- Distributed scheduler: This scheduler is more sophisticated,
offers more features, but also requires a bit more effort to set up.
It can run locally or distribute across a cluster

##### Distributed Scheduler

There are a variety of ways to set Distributed scheduler.
However, `dask.distributed` scheduler will be used for many of them.
To use the `dask.distributed` scheduler you must set up a Client:

```python
from dask.distributed import Client
client = Client(...)  # Connect to distributed cluster and override default
df.x.sum().compute()  # This now runs on the distributed system
```

The idea behind the Dask is to scale Python and
distribute it among the workers (multiple machines, jobs).
There are different ways to do that
(for a single machine or for distributed cluster).
This page will be focus mainly on Dask for HPC.

The preferred and simplest way to run Dask on ZIH systems
today both for new or experienced users
is to use **[dask-jobqueue](https://jobqueue.dask.org/)**.

However, Dask-jobqueue is slightly oriented toward
interactive analysis
usage, and it might be better to use tools like
**[Dask-mpi](https://docs.dask.org/en/latest/setup/hpc.html#using-mpi)**
in some routine batch production workloads.

###### Dask-mpi

You can launch a Dask network using
`mpirun` or `mpiexec` and the `dask-mpi` command line executable.
This depends on the mpi4py library (see the [python page](python.md)).
For more detailed information please check
[here](https://docs.dask.org/en/latest/setup/hpc.html#using-mpi).

###### Dask-jobqueue

As was written before the preferred and simplest way to run Dask on HPC is
to use [Dask-jobqueue](https://jobqueue.dask.org/).
It allows an easy deployment of Dask Distributed on HPC with Slurm
or other job queuing systems.

###### Installation of Dask-jobqueue

Dask-jobqueue is available as an extension
for a Dask module (which can be loaded by: `module load dask`)

The availability of the exact packages (such a Dask-jobqueue)
in the module can be checked by the
`module whatis <name_of_the_module> command`.

Moreover, it is possible to install and use `dask-jobqueue`
in you local environments.
You can install Dask-jobqueue with `pip` or `conda`

###### Installation with Pip

```console
marie@login$ srun -p haswell -N 1 -n 1 -c 4 --mem-per-cpu=2583 --time=01:00:00 --pty bash
marie@compute$ cd /scratch/ws/0/marie-Workproject/python-virtual-environment/dask-test
marie@compute$ ml modenv/ml 
marie@compute$ module load PythonAnaconda/3.6 
marie@compute$ which python

marie@compute$ source dask-test/bin/activate              #Activate virtual environment
marie@compute$ pip install dask-jobqueue --upgrade        #Install everything from last released version
```

###### Installation with Conda

```console
marie@login$ srun -p haswell -N 1 -n 1 -c 4 --mem-per-cpu=2583 --time=01:00:00 --pty bash

marie@compute$ ml modenv/ml 
marie@compute$ module load PythonAnaconda/3.6 
marie@compute$ source dask-test/bin/activate

marie@compute$ conda install dask-jobqueue -c conda-forge
```

###### Example of use Dask-jobqueue with SLURMCluster

[Dask-jobqueue](https://jobqueue.dask.org/en/latest/howitworks.html#workers-vs-jobs)
allows running jobs on ZIH system
inside the python code and scale computations over the jobs.
[Dask-jobqueue](https://jobqueue.dask.org/en/latest/howitworks.html#workers-vs-jobs)
creates a Dask Scheduler in the Python process
where the cluster object is instantiated.
Please check the example of a definition of the cluster object
for the alpha partition (queue at the dask terms) on ZIH system:

```python
from dask_jobqueue import SLURMCluster

cluster = SLURMCluster(queue='alpha', 
  cores=8,
  processes=2, 
  project='p_scads', 
  memory="8GB", 
  walltime="00:30:00")

```

These parameters above specify the characteristics of a
single job or a single compute node,
rather than the characteristics of your computation as a whole.
It hasn’t actually launched any jobs yet.
For the full computation, you will then ask for a number of
jobs using the scale command, e.g :`cluster.scale(2)`.
Thus you have to specify a SLURMCluster by `dask-jobqueue`
scale it and use it for your computations. There is an example:

```python
from distributed import Client
from dask_jobqueue import SLURMCluster
from dask import delayed

cluster = SLURMCluster(queue='alpha', 
  cores=8,
  processes=2, 
  project='p_scads', 
  memory="80GB", 
  walltime="00:30:00",
  extra=['--resources gpu=1'])

cluster.scale(2)             #scale it to 2 workers! 
client = Client(cluster)     #command will show you number of workers (python objects corresponds to jobs)
```

Please have a look at the `extra` parameter in the script above.
This could be used to specify a
special hardware availability that the scheduler
is not aware of, for example, GPUs.
Please don't forget to specify the name of your project.

The python code for setting up Slurm clusters
and scaling clusters can be run by the `srun`
(but remember that using `srun` directly on the shell
blocks the shell and launches an
interactive job) or batch jobs or [JupyterHub](../access/jupyterhub.md)
**Note**: The job to run original code (de facto an interface) with
a setup should be simple and light.
Please don't use a lot of resources for that.  

[Here](misc/dask_test.py) you can find an example of using
Dask by `dask-jobqueue` with `SLURMCluster` and `dask.array`
for the Monte-Carlo estimation of Pi.
``

### mpi4py -  MPI for Python

Message Passing Interface (MPI) is a standardized and portable message-passing standard, designed to
function on a wide variety of parallel computing architectures. The Message Passing Interface (MPI)
is a library specification that allows HPC to pass information between its various nodes and
clusters. MPI is designed to provide access to advanced parallel hardware for end-users, library
writers and tool developers.

mpi4py (MPI for Python) provides bindings of the MPI standard for the Python programming
language, allowing any Python program to exploit multiple processors.

mpi4py is based on MPI-2 C++ bindings. It supports almost all MPI calls. This implementation is
popular on Linux clusters and in the SciPy community. Operations are primarily methods of
communicator objects. It supports communication of pickle-able Python objects. mpi4py provides
optimized communication of NumPy arrays.

mpi4py is included in the SciPy-bundle modules on the ZIH system.

```console
marie@compute$ module load SciPy-bundle/2020.11-foss-2020b
Module SciPy-bundle/2020.11-foss-2020b and 28 dependencies loaded.
marie@compute$ pip list
Package                       Version
----------------------------- ----------
[...]
mpi4py                        3.0.3
[...]
```

Other versions of the package can be found with

```console
marie@compute$ module spider mpi4py
-----------------------------------------------------------------------------------------------------------------------------------------
  mpi4py:
-----------------------------------------------------------------------------------------------------------------------------------------
     Versions:
        mpi4py/1.3.1
        mpi4py/2.0.0-impi
        mpi4py/3.0.0 (E)
        mpi4py/3.0.2 (E)
        mpi4py/3.0.3 (E)

Names marked by a trailing (E) are extensions provided by another module.

-----------------------------------------------------------------------------------------------------------------------------------------
  For detailed information about a specific "mpi4py" package (including how to load the modules) use the module's full name.
  Note that names that have a trailing (E) are extensions provided by other modules.
  For example:

     $ module spider mpi4py/3.0.3
-----------------------------------------------------------------------------------------------------------------------------------------
```

Moreover, it is possible to install Mpi4py in your local conda
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

Check if mpi4py is running correctly

```python
from mpi4py import MPI
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
