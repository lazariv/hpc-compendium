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

[Dask](https://dask.org/) is a flexible and open-source library
for parallel computing in Python.
It replaces some Python data structures with parallel versions
in order to provide advanced
parallelism for analytics, enabling performance at scale
for some of the popular tools.
For instance: Dask arrays replace NumPy arrays,
Dask dataframes replace Pandas dataframes.
Furthermore, Dask-ML scales machine learning APIs like Scikit-Learn and XGBoost.

Dask is composed of two parts:

- Dynamic task scheduling optimized for computation and interactive
  computational workloads.
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

#### Dask Modules on ZIH Systems

On ZIH systems, Dask is available as a module.
Check available versions and load your preferred one:

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

The preferred way is to use Dask as a separate module as was described above.
However, you can use it as part of the **Anaconda** module, e.g: `module load Anaconda3`.

#### Scheduling by Dask

Whenever you use functions on Dask collections (Dask Array, Dask Bag, etc.), Dask models these as
single tasks forming larger task graphs in the background without you noticing.
After Dask generates these task graphs,
it needs to execute them on parallel hardware.
This is the job of a task scheduler.
Please use Distributed scheduler for your
Dask computations on the cluster and avoid using a Single machine scheduler.

##### Distributed Scheduler

There are a variety of ways to set Distributed scheduler.
However, `dask.distributed` scheduler will be used for many of them.
To use the `dask.distributed` scheduler you must set up a Client:

```python
from dask.distributed import Client
client = Client(...)  # Connect to distributed cluster and override default
df.x.sum().compute()  # This now runs on the distributed system
```

The idea behind Dask is to scale Python and distribute computation among the workers (multiple
machines, jobs).
The preferred and simplest way to run Dask on ZIH systems
today both for new or experienced users
is to use **[dask-jobqueue](https://jobqueue.dask.org/)**.

However, Dask-jobqueue is slightly oriented toward
interactive analysis
usage, and it might be better to use tools like
**[Dask-mpi](https://docs.dask.org/en/latest/setup/hpc.html#using-mpi)**
in some routine batch production workloads.

##### Dask-mpi

You can launch a Dask network using
`mpirun` or `mpiexec` and the `dask-mpi` command line executable.
This depends on the [mpi4py library](#mpi4py-mpi-for-python).
For more detailed information, please check
[the official documentation](https://docs.dask.org/en/latest/setup/hpc.html#using-mpi).

##### Dask-jobqueue

[Dask-jobqueue](https://jobqueue.dask.org/) can be used as the standard way
to use dask for most users.
It allows an easy deployment of Dask Distributed on HPC with Slurm
or other job queuing systems.

Dask-jobqueue is available as an extension
for a Dask module (which can be loaded by: `module load dask`).

The availability of the exact packages (such a Dask-jobqueue)
in the module can be checked by the
`module whatis <name_of_the_module>` command, e.g. `module whatis dask`.

Moreover, it is possible to install and use `dask-jobqueue`
in your local python environments.
You can install Dask-jobqueue with `pip` or `conda`.

###### Example of Using Dask-Jobqueue with SLURMCluster

[Dask-jobqueue](https://jobqueue.dask.org/en/latest/howitworks.html#workers-vs-jobs)
allows running jobs on the ZIH system
inside the python code and scale computations over the jobs.
[Dask-jobqueue](https://jobqueue.dask.org/en/latest/howitworks.html#workers-vs-jobs)
creates a Dask Scheduler in the Python process
where the cluster object is instantiated.
Please check the example of a definition of the cluster object
for the partition `alpha` (queue at the dask terms) on the ZIH system:

```python
from dask_jobqueue import SLURMCluster

cluster = SLURMCluster(queue='alpha',
  cores=8,
  processes=2,
  project='p_marie',
  memory="8GB",
  walltime="00:30:00")

```

These parameters above specify the characteristics of a
single job or a single compute node,
rather than the characteristics of your computation as a whole.
It hasn’t actually launched any jobs yet.
For the full computation, you will then ask for a number of
jobs using the scale command, e.g : `cluster.scale(2)`.
Thus, you have to specify a `SLURMCluster` by `dask_jobqueue`,
scale it and use it for your computations. There is an example:

```python
from distributed import Client
from dask_jobqueue import SLURMCluster
from dask import delayed

cluster = SLURMCluster(queue='alpha',
  cores=8,
  processes=2,
  project='p_marie',
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

The Python code for setting up Slurm clusters
and scaling clusters can be run by the `srun`
(but remember that using `srun` directly on the shell
blocks the shell and launches an
interactive job) or batch jobs or
[JupyterHub](../access/jupyterhub.md) with loaded Dask
(by module or by Python virtual environment).

!!! note
    The job to run original code (de facto an interface) with a setup should be simple and light.
    Please don't use a lot of resources for that.

The following example shows using
Dask by `dask-jobqueue` with `SLURMCluster` and `dask.array`
for the Monte-Carlo estimation of Pi.

??? example "Example of using SLURMCluster"

    ```python
    #use of dask-jobqueue for the estimation of Pi by Monte-Carlo method

    import time
    from time import time, sleep
    from dask.distributed import Client
    from dask_jobqueue import SLURMCluster
    import subprocess as sp

    import dask.array as da
    import numpy as np

    #setting up the dashboard

    uid = int( sp.check_output('id -u', shell=True).decode('utf-8').replace('\n','') )
    portdash = 10001 + uid

    #create a Slurm cluster, please specify your project

    cluster = SLURMCluster(queue='alpha', cores=2, project='p_marie', memory="8GB", walltime="00:30:00", extra=['--resources gpu=1'], scheduler_options={"dashboard_address": f":{portdash}"})

    #submit the job to the scheduler with the number of nodes (here 2) requested:

    cluster.scale(2)

    #wait for Slurm to allocate a resources

    sleep(120)

    #check resources

    client = Client(cluster)
    client

    #real calculations with a Monte Carlo method

    def calc_pi_mc(size_in_bytes, chunksize_in_bytes=200e6):
      """Calculate PI using a Monte Carlo estimate."""

      size = int(size_in_bytes / 8)
      chunksize = int(chunksize_in_bytes / 8)

      xy = da.random.uniform(0, 1, size=(size / 2, 2), chunks=(chunksize / 2, 2))

      in_circle = ((xy ** 2).sum(axis=-1) < 1)
      pi = 4 * in_circle.mean()

      return pi

    def print_pi_stats(size, pi, time_delta, num_workers):
      """Print pi, calculate offset from true value, and print some stats."""
      print(f"{size / 1e9} GB\n"
            f"\tMC pi: {pi : 13.11f}"
            f"\tErr: {abs(pi - np.pi) : 10.3e}\n"
            f"\tWorkers: {num_workers}"
            f"\t\tTime: {time_delta : 7.3f}s")

    #let's loop over different volumes of double-precision random numbers and estimate it

    for size in (1e9 * n for n in (1, 10, 100)):

      start = time()
      pi = calc_pi_mc(size).compute()
      elaps = time() - start

      print_pi_stats(size, pi, time_delta=elaps, num_workers=len(cluster.scheduler.workers))

    #Scaling the Cluster to twice its size and re-run the experiments

    new_num_workers = 2 * len(cluster.scheduler.workers)

    print(f"Scaling from {len(cluster.scheduler.workers)} to {new_num_workers} workers.")

    cluster.scale(new_num_workers)

    sleep(120)

    client

    #Re-run same experiments with doubled cluster

    for size in (1e9 * n for n in (1, 10, 100)):

      start = time()
      pi = calc_pi_mc(size).compute()
      elaps = time() - start

      print_pi_stats(size, pi, time_delta=elaps, num_workers=len(cluster.scheduler.workers))
    ```

Please check the availability of resources that you want to allocate
by the script for the example above.
You can do it with `sinfo` command. The script doesn't work
without available cluster resources.

### Mpi4py -  MPI for Python

Message Passing Interface (MPI) is a standardized and
portable message-passing standard, designed to
function on a wide variety of parallel computing architectures.

Mpi4py (MPI for Python) provides bindings of the MPI standard for
the Python programming language,
allowing any Python program to exploit multiple processors.

Mpi4py is based on MPI-2 C++ bindings. It supports almost all MPI calls.
It supports communication of pickle-able Python objects.
Mpi4py provides optimized communication of NumPy arrays.

Mpi4py is included in the SciPy-bundle modules on the ZIH system.

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

Other versions of the package can be found with:

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
  For detailed information about a specific "mpi4py" package (including how to load the modules), use the module's full name.
  Note that names that have a trailing (E) are extensions provided by other modules.
  For example:

     $ module spider mpi4py/3.0.3
-----------------------------------------------------------------------------------------------------------------------------------------
```

Moreover, it is possible to install mpi4py in your local conda
environment.

The example of mpi4py usage for the verification that
mpi4py is running correctly can be found below:

```python
from mpi4py import MPI
comm = MPI.COMM_WORLD
print("%d of %d" % (comm.Get_rank(), comm.Get_size()))
```

For the multi-node case, use a script similar to this:

```bash
#!/bin/bash
#SBATCH --nodes=2
#SBATCH --partition=ml
#SBATCH --tasks-per-node=2
#SBATCH --cpus-per-task=1

module load modenv/ml
module load PythonAnaconda/3.6

eval "$(conda shell.bash hook)"
conda activate /home/marie/conda-virtual-environment/kernel2 && srun python mpi4py_test.py    #specify name of your virtual environment
```

For the verification of the multi-node case,
you can use the Python code from the previous part
(with verification of the installation) as a test file.
