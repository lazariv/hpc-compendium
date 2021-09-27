# Dask

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

## Installation

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
`module spider dask/2.8.0-Python-3.7.4`

The availability of the exact packages
in the module can be checked by the
`module whatis <name_of_the_module> command`.
The `module whatis`
command displays a short information and included extensions of the
module.

### Installation Using Conda

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

**Note:** You could work with simple examples
in your home directory (where you are loading by
default). However, in accordance with the
[HPC storage concept](../data_lifecycle/overview.md) please use a
[Workspace](../data_lifecycle/workspaces.md) for your study and work projects.

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

### Installation Using Pip

You can install everything required for most common uses of Dask (arrays, dataframes, etc)

```console
marie@login$ srun -p ml -N 1 -n 1 --mem-per-cpu=5772 --gres=gpu:1 --time=04:00:00 --pty bash

marie@compute$ cd /scratch/ws/0/aabc1234-Workproject/python-virtual-environment/dask-test

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

## Scheduling by Dask

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

### Distributed Scheduler

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

#### Dask-mpi

You can launch a Dask network using
`mpirun` or `mpiexec` and the `dask-mpi` command line executable.
This depends on the mpi4py library (see the [python page](python.md)).
For more detailed information please check
[here](https://docs.dask.org/en/latest/setup/hpc.html#using-mpi).

#### Dask-jobqueue

As was written before the preferred and simplest way to run Dask on HPC is
to use [Dask-jobqueue](https://jobqueue.dask.org/).
It allows an easy deployment of Dask Distributed on HPC with Slurm
or other job queuing systems.

##### Installation of Dask-jobqueue

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
