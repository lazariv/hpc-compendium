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
numerical simulation, statistical modeling, data visualization and machine learning.

On ZIH system a [JupyterHub](../access/jupyterhub.md) is available, which can be used to run
a Jupyter notebook on an HPC node, as well using a GPU when needed.  

## Parallel Computing with Python

### Dask

[Dask](https://dask.org/) is a flexible and open-source library for parallel computing in Python.
It scales Python and provides advanced parallelism for analytics, enabling performance at
scale for some of the popular tools. For instance: Dask arrays scale NumPy workflows, Dask
dataframes scale Pandas workflows, Dask-ML scales machine learning APIs like Scikit-Learn and
XGBoost.

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

#### Dask Installation

!!! hint
    This step might be obsolete, since the library may be already available as a module.
    Check it with
    ```console
    marie@compute$ module spider dask
    ```

The installation of Dask is very easy and can be done by a user using a [virtual environment](python_virtual_environments.md)

```console
marie@compute$ module load SciPy-bundle/2020.11-fosscuda-2020b Pillow/8.0.1-GCCcore-10.2.0
marie@compute$ virtualenv --system-site-packages dask-test
created virtual environment CPython3.8.6.final.0-64 in 10325ms
  creator CPython3Posix(dest=~/dask-test, clear=False, global=True)
  seeder FromAppData(download=False, pip=bundle, setuptools=bundle, wheel=bundle, via=copy, app_data_dir=~/.local/share/virtualenv)
    added seed packages: pip==21.1.3, setuptools==57.4.0, wheel==0.36.2
  activators BashActivator,CShellActivator,FishActivator,PowerShellActivator,PythonActivator,XonshActivator
marie@compute$ source dask-test/bin/activate
(dask-test) marie@compute$ pip install dask dask-jobqueue
[...]
marie@compute$ python -c "import dask; print(dask.__version__)"
2021.08.1
```

The preferred and simplest way to run Dask on HPC system is using
[dask-jobqueue](https://jobqueue.dask.org/).

**TODO** create better example with jobqueue

```python
from dask.distributed import Client, progress
client = Client(n_workers=4, threads_per_worker=1)
client
```

### mpi4py -  MPI for Python

Message Passing Interface (MPI) is a standardized and portable
message-passing standard designed to function on a wide variety of
parallel computing architectures. The Message Passing Interface (MPI) is
a library specification that allows HPC to pass information between its
various nodes and clusters. MPI is designed to provide access to advanced
parallel hardware for end-users, library writers and tool developers.

mpi4py(MPI for Python) package provides bindings of the MPI standard for
the python programming language, allowing any Python program to exploit
multiple processors.

mpi4py based on MPI-2 C++ bindings. It supports almost all MPI calls.
This implementation is popular on Linux clusters and in the SciPy
community. Operations are primarily methods of communicator objects. It
supports communication of pickle-able Python objects. mpi4py provides
optimized communication of NumPy arrays.

mpi4py is included as an extension of the SciPy-bundle modules on an HPC system

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
