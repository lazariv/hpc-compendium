# Dask

\<span style="font-size: 1em;"> **Dask** is an open-source library for
parallel computing. Dask is a flexible library for parallel computing in
Python.\</span>

Dask natively scales Python. It\<span style="font-size: 1em;"> provides
advanced parallelism for analytics, enabling performance at scale for
some of the popular tools. For instance: Dask arrays scale Numpy
workflows, Dask dataframes scale Pandas workflows, Dask-ML scales
machine learning APIs like Scikit-Learn and XGBoost\</span>

Dask is composed of two parts:

-   Dynamic task scheduling optimized for computation and interactive
    computational workloads.
-   Big Data collections like parallel arrays, data frames, and lists
    that extend common interfaces like NumPy, Pandas, or Python
    iterators to larger-than-memory or distributed environments. These
    parallel collections run on top of dynamic task schedulers.

Dask supports several user interfaces:

High-Level:

-   Arrays: Parallel NumPy
-   Bags: Parallel lists
-   DataFrames: Parallel Pandas
-   Machine Learning : Parallel Scikit-Learn
-   Others from external projects, like XArray

Low-Level:

-   Delayed: Parallel function evaluation
-   Futures: Real-time parallel function evaluation

## Installation

### installation using Conda

Dask is installed by default in
[Anaconda](https://www.anaconda.com/download/). To install/update Dask
on a Taurus with using the [conda](https://www.anaconda.com/download/)
follow the example:

    srun -p ml -N 1 -n 1 --mem-per-cpu=5772 --gres=gpu:1 --time=04:00:00 --pty bash      #Job submission in ml nodes with allocating: 1 node, 1 gpu per node, 4 hours

Create a conda virtual environment. We would recommend using a
workspace. See the example (use `--prefix` flag to specify the
directory)\<br />\<span style="font-size: 1em;">Note: You could work
with simple examples in your home directory (where you are loading by
default). However, in accordance with the \</span>\<a
href="HPCStorageConcept2019" target="\_blank">storage concept\</a>\<span
style="font-size: 1em;">,\</span>** please use \<a href="WorkSpaces"
target="\_blank">workspaces\</a> for your study and work projects.**

    conda create --prefix /scratch/ws/0/aabc1234-Workproject/conda-virtual-environment/dask-test python=3.6

By default, conda will locate the environment in your home directory:

    conda create -n dask-test python=3.6

Activate the virtual environment, install Dask and verify the
installation:

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

### installation using Pip

You can install everything required for most common uses of Dask
(arrays, dataframes, etc)

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

Distributed scheduler

?

## Run Dask on Taurus

\<span style="font-size: 1em;">The preferred and simplest way to run
Dask on HPC systems today both for new, experienced users or
administrator is to use \</span>
[dask-jobqueue](https://jobqueue.dask.org/)\<span style="font-size:
1em;">.\</span>

You can install dask-jobqueue with `pip <span>or</span>` `conda`

Installation with Pip

    srun -p haswell -N 1 -n 1 -c 4 --mem-per-cpu=2583 --time=01:00:00 --pty bash

\<verbatim>cd
/scratch/ws/0/aabc1234-Workproject/python-virtual-environment/dask-test
ml modenv/ml module load PythonAnaconda/3.6 which python

source dask-test/bin/activate pip install dask-jobqueue --upgrade #
Install everything from last released version\</verbatim>

Installation with Conda

    srun -p haswell -N 1 -n 1 -c 4 --mem-per-cpu=2583 --time=01:00:00 --pty bash

\<verbatim>ml modenv/ml module load PythonAnaconda/3.6 source
dask-test/bin/activate

conda install dask-jobqueue -c conda-forge\</verbatim>

-- Main.AndreiPolitov - 2020-08-26

**\<br />**
