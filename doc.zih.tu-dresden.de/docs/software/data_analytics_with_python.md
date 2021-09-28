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

[Dask](https://dask.org/) is a flexible and open-source library for parallel computing in Python.
It replaces some Python data structures with parallel versions in order to provide advanced
parallelism for analytics, enabling performance at scale for some of the popular tools. For
instance: Dask arrays replace NumPy arrays, Dask dataframes replace Pandas dataframes.
Furthermore, Dask-ML scales machine learning APIs like Scikit-Learn and XGBoost.

Dask is composed of two parts:

- Dynamic task scheduling optimized for computation and interactive computational workloads.
- Big Data collections like parallel arrays, data frames, and lists that extend common interfaces
  like NumPy, Pandas, or Python iterators to larger-than-memory or distributed environments.
  These parallel collections run on top of dynamic task schedulers.

Dask supports several user interfaces:

- High-Level
    - Arrays: Parallel NumPy
    - Bags: Parallel lists
    - DataFrames: Parallel Pandas
    - Machine Learning: Parallel Scikit-Learn
    - Others from external projects, like XArray
- Low-Level
    - Delayed: Parallel function evaluation
    - Futures: Real-time parallel function evaluation

#### Dask Usage

On ZIH systems, Dask is available as a module. Check available versions and load your preferred one:

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

The preferred and simplest way to run Dask on ZIH system is using
[dask-jobqueue](https://jobqueue.dask.org/).

**TODO** create better example with jobqueue

```python
from dask.distributed import Client, progress
client = Client(n_workers=4, threads_per_worker=1)
client
```

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

Check if mpi4py is running correctly

```python
from mpi4py import MPI
comm = MPI.COMM_WORLD
print("%d of %d" % (comm.Get_rank(), comm.Get_size()))
```

**TODO** verify mpi4py installation
