# R for Data Analytics

[R](https://www.r-project.org/about.html) is a programming language and environment for statistical
computing and graphics. R provides a wide variety of statistical (linear and nonlinear modeling,
classical statistical tests, time-series analysis, classification, etc) and graphical techniques. R
is an integrated suite of software facilities for data manipulation, calculation and
graphing.

R possesses an extensive catalog of statistical and graphical methods.  It includes machine
learning algorithms, linear regression, time series, statistical inference.

We recommend using **Haswell** and/or **Romeo** partitions to work with R. For more details
see [here](../jobs_and_resources/hardware_taurus.md).

## R Console

In the following example the `srun` command is used to submit a real-time execution job
designed for interactive use with monitoring the output. Please check
[the Slurm page](../jobs_and_resources/slurm.md) for details.

```Bash
# job submission on haswell nodes with allocating: 1 task, 1 node, 4 CPUs per task with 2541 mb per CPU(core) for 1 hour
tauruslogin$ srun --partition=haswell --ntasks=1 --nodes=1 --cpus-per-task=4 --mem-per-cpu=2541 --time=01:00:00 --pty bash

# Ensure that you are using the scs5 environment
module load modenv/scs5
# Check all available modules for R with version 3.6
module available R/3.6
# Load default R module
module load R
# Checking the current R version
which R
# Start R console
R
```

Using `srun` is recommended only for short test runs, while for larger runs batch jobs should be
used. The examples can be found [here](get_started_with_hpcda.md) or
[here](../jobs_and_resources/slurm.md).

It is also possible to run `Rscript` command directly (after loading the module):

```Bash
# Run Rscript directly. For instance: Rscript /scratch/ws/0/marie-study_project/my_r_script.R
Rscript /path/to/script/your_script.R param1 param2
```

## R in JupyterHub

In addition to using interactive and batch jobs, it is possible to work with **R** using
[JupyterHub](../access/jupyterhub.md).

The production and test [environments](../access/jupyterhub.md#standard-environments) of
JupyterHub contain R kernel. It can be started either in the notebook or in the console.

## RStudio

For using R with RStudio please refer to [Data Analytics with RStudio](data_analytics_with_rstudio.md).

## Install Packages in R

By default, user-installed packages are saved in the users home in a folder depending on
the architecture (x86 or PowerPC). Therefore the packages should be installed using interactive
jobs on the compute node:

```Bash
srun -p haswell --ntasks=1 --nodes=1 --cpus-per-task=4 --mem-per-cpu=2541 --time=01:00:00 --pty bash

module purge
module load modenv/scs5
module load R
R -e 'install.packages("package_name")'  #For instance: 'install.packages("ggplot2")'
```

## Deep Learning with R

The deep learning frameworks perform extremely fast when run on accelerators such as GPU.
Therefore, using nodes with built-in GPUs ([ml](../jobs_and_resources/power9.md) or
[alpha](../jobs_and_resources/alpha_centauri.md) partitions) is beneficial for the examples here.

### R Interface to TensorFlow

The ["TensorFlow" R package](https://tensorflow.rstudio.com/) provides R users access to the
TensorFlow framework. [TensorFlow](https://www.tensorflow.org/) is an open-source software library
for numerical computation using data flow graphs.

```Bash
srun --partition=ml --ntasks=1 --nodes=1 --cpus-per-task=7 --mem-per-cpu=5772 --gres=gpu:1 --time=04:00:00 --pty bash

module purge
ml modenv/ml
ml TensorFlow
ml R

which python
mkdir python-virtual-environments  # Create a folder for virtual environments
cd python-virtual-environments
python3 -m venv --system-site-packages R-TensorFlow        #create python virtual environment
source R-TensorFlow/bin/activate                           #activate environment
module list
which R
```

Please allocate the job with respect to
[hardware specification](../jobs_and_resources/hardware_taurus.md)! Note that the nodes on `ml`
partition have 4way-SMT, so for every physical core allocated, you will always get 4\*1443Mb=5772mb.

In order to interact with Python-based frameworks (like TensorFlow) `reticulate` R library is used.
To configure it to point to the correct Python executable in your virtual environment, create
a file named `.Rprofile` in your project directory (e.g. R-TensorFlow) with the following
contents:

```R
Sys.setenv(RETICULATE_PYTHON = "/sw/installed/Anaconda3/2019.03/bin/python")    #assign the output of the 'which python' from above to RETICULATE_PYTHON
```

Let's start R, install some libraries and evaluate the result:

```R
install.packages("reticulate")
library(reticulate)
reticulate::py_config()
install.packages("tensorflow")
library(tensorflow)
tf$constant("Hello TensorFlow")         #In the output 'Tesla V100-SXM2-32GB' should be mentioned
```

??? example
    The example shows the use of the TensorFlow package with the R for the classification problem
    related to the MNIST data set.
    ```R
    library(tensorflow)
    library(keras)

    # Data preparation
    batch_size <- 128
    num_classes <- 10
    epochs <- 12

    # Input image dimensions
    img_rows <- 28
    img_cols <- 28

    # Shuffled and split the data between train and test sets
    mnist <- dataset_mnist()
    x_train <- mnist$train$x
    y_train <- mnist$train$y
    x_test <- mnist$test$x
    y_test <- mnist$test$y

    # Redefine dimension of train/test inputs
    x_train <- array_reshape(x_train, c(nrow(x_train), img_rows, img_cols, 1))
    x_test <- array_reshape(x_test, c(nrow(x_test), img_rows, img_cols, 1))
    input_shape <- c(img_rows, img_cols, 1)

    # Transform RGB values into [0,1] range
    x_train <- x_train / 255
    x_test <- x_test / 255

    cat('x_train_shape:', dim(x_train), '\n')
    cat(nrow(x_train), 'train samples\n')
    cat(nrow(x_test), 'test samples\n')

    # Convert class vectors to binary class matrices
    y_train <- to_categorical(y_train, num_classes)
    y_test <- to_categorical(y_test, num_classes)

    # Define Model
    model <- keras_model_sequential() %>%
      layer_conv_2d(filters = 32, kernel_size = c(3,3), activation = 'relu',
                    input_shape = input_shape) %>%
      layer_conv_2d(filters = 64, kernel_size = c(3,3), activation = 'relu') %>%
      layer_max_pooling_2d(pool_size = c(2, 2)) %>%
      layer_dropout(rate = 0.25) %>%
      layer_flatten() %>%
      layer_dense(units = 128, activation = 'relu') %>%
      layer_dropout(rate = 0.5) %>%
      layer_dense(units = num_classes, activation = 'softmax')

    # Compile model
    model %>% compile(
      loss = loss_categorical_crossentropy,
      optimizer = optimizer_adadelta(),
      metrics = c('accuracy')
    )

    # Train model
    model %>% fit(
      x_train, y_train,
      batch_size = batch_size,
      epochs = epochs,
      validation_split = 0.2
    )
    scores <- model %>% evaluate(
      x_test, y_test, verbose = 0
    )

    # Output metrics
    cat('Test loss:', scores[[1]], '\n')
    cat('Test accuracy:', scores[[2]], '\n')
    ```

## Parallel Computing with R

Generally, the R code is serial. However, many computations in R can be made faster by the use of
parallel computations. Taurus allows a vast number of options for parallel computations. Large
amounts of data and/or use of complex models are indications to use parallelization.

### General Information about the R Parallelism

There are various techniques and packages in R that allow parallelization. This section
concentrates on most general methods and examples. The Information here is Taurus-specific.
The [parallel](https://www.rdocumentation.org/packages/parallel/versions/3.6.2) library
will be used below.

!!! warning
    Please do not install or update R packages related to parallelism as it could lead to
    conflicts with other preinstalled packages.

### Basic lapply-Based Parallelism

`lapply()` function is a part of base R. lapply is useful for performing operations on list-objects.
Roughly speaking, lapply is a vectorization of the source code and it is the first step before
explicit parallelization of the code.

### Shared-Memory Parallelism

The `parallel` library includes the `mclapply()` function which is a shared memory version of
lapply. The "mc" stands for "multicore". This function distributes the `lapply` tasks across
multiple CPU cores to be executed in parallel.

This is a simple option for parallelization. It doesn't require much effort to rewrite the serial
code to use `mclapply` function. Check out an example below.

??? example
    ```R
    library(parallel)

    # here some function that needs to be executed in parallel
    average <- function(size){
      norm_vector <- rnorm(n=size, mean=mu, sd=sigma)
      return(mean(norm_vector))
    }

    # variable initialization
    mu <- 1.0
    sigma <- 1.0
    vector_length <- 10^7
    n_repeat <- 100
    sample_sizes <- rep(vector_length, times=n_repeat)


    # shared-memory version
    threads <- as.integer(Sys.getenv("SLURM_CPUS_ON_NODE"))
    # here the name of the variable depends on the correct sbatch configuration
    # unfortunately the built-in function gets the total number of physical cores without
    # taking into account allocated cores by Slurm

    list_of_averages <- mclapply(X=sample_sizes, FUN=average, mc.cores=threads)  # apply function "average" 100 times
    ```

The disadvantages of using shared-memory parallelism approach are, that the number of parallel
tasks is limited to the number of cores on a single node. The maximum number of cores on a single
node can be found [here](../jobs_and_resources/hardware_taurus.md).

Submitting a multicore R job to Slurm is very similar to submitting an
[OpenMP Job](../jobs_and_resources/slurm.md#binding-and-distribution-of-tasks),
since both are running multicore jobs on a **single** node. Below is an example:

```Bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --time=00:10:00
#SBATCH -o test_Rmpi.out
#SBATCH -e test_Rmpi.err

module purge
module load modenv/scs5
module load R

R CMD BATCH Rcode.R
```

### Distributed-Memory Parallelism

In order to go beyond the limitation of the number of cores on a single node, a cluster of workers
shall be set up. There are three options for it: MPI, PSOCK and FORK clusters.
We use `makeCluster` function from `parallel` library to create a set of copies of R processes
running in parallel. The desired type of the cluster can be specified with a parameter `TYPE`.

#### MPI Cluster

This way of the R parallelism uses the
[Rmpi](http://cran.r-project.org/web/packages/Rmpi/index.html) package and the
[MPI](https://en.wikipedia.org/wiki/Message_Passing_Interface) (Message Passing Interface) as a
"back-end" for its parallel operations. The MPI-based job in R is very similar to submitting an
[MPI Job](../jobs_and_resources/slurm.md#binding-and-distribution-of-tasks) since both are running
multicore jobs on multiple nodes. Below is an example of running R script with the Rmpi on Taurus:

```Bash
#!/bin/bash
#SBATCH --partition=haswell      # specify the partition
#SBATCH --ntasks=32              # this parameter determines how many processes will be spawned, please use >=8
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH -o test_Rmpi.out
#SBATCH -e test_Rmpi.err

module purge
module load modenv/scs5
module load R

mpirun -np 1 R CMD BATCH Rmpi.R   # specify the absolute path to the R script, like: /scratch/ws/marie-Work/R/Rmpi.R

# submit with sbatch <script_name>
```

Slurm option `--ntasks` controls the total number of parallel tasks. The number of
nodes required to complete this number of tasks will be automatically selected.
However, in some specific cases, you can specify the number of nodes and the number of necessary
tasks per node explicitly:

```Bash
#!/bin/bash
#SBATCH --nodes=2
#SBATCH --tasks-per-node=16
#SBATCH --cpus-per-task=1
module purge
module load modenv/scs5
module load R

mpirun -np 1 R CMD BATCH --no-save --no-restore Rmpi_c.R
```

Use an example below, where 32 global ranks are distributed over 2 nodes with 16 cores each.
Each MPI rank has 1 core assigned to it.

??? example
    ```R
    library(Rmpi)

    # initialize an Rmpi environment
    ns <- mpi.universe.size()-1
    mpi.spawn.Rslaves(nslaves=ns)

    # send these commands to the slaves
    mpi.bcast.cmd( id <- mpi.comm.rank() )
    mpi.bcast.cmd( ns <- mpi.comm.size() )
    mpi.bcast.cmd( host <- mpi.get.processor.name() )

    # all slaves execute this command
    mpi.remote.exec(paste("I am", id, "of", ns, "running on", host))

    # close down the Rmpi environment
    mpi.close.Rslaves(dellog = FALSE)
    mpi.exit()
    ```

Another example:

??? example
    ```R
    library(Rmpi)
    library(parallel)

    # here some function that needs to be executed in parallel
    average <- function(size){
      norm_vector <- rnorm(n=size, mean=mu, sd=sigma)
      return(mean(norm_vector))
    }

    # variable initialization
    mu <- 1.0
    sigma <- 1.0
    vector_length <- 10^7
    n_repeat <- 100
    sample_sizes <- rep(vector_length, times=n_repeat)

    # cluster setup
    # get number of available MPI ranks
    threads = mpi.universe.size()-1
    print(paste("The cluster of size", threads, "will be setup..."))

    # initialize MPI cluster
    cl <- makeCluster(threads, type="MPI", outfile="")

    # distribute required variables for the execution over the cluster
    clusterExport(cl, list("mu","sigma"))

    list_of_averages <- parLapply(X=sample_sizes, fun=average, cl=cl)

    # shut down the cluster
    #snow::stopCluster(cl)  # usually it hangs over here with OpenMPI > 2.0. In this case this command may be avoided, Slurm will clean up after the job finishes
    ```

To use Rmpi and MPI please use one of these partitions: **haswell**, **broadwell** or **rome**.

Use `mpirun` command to start the R script. It is a wrapper that enables the communication
between processes running on different nodes. It is important to use `-np 1` (the number of spawned
processes by `mpirun`), since the R takes care of it with `makeCluster` function.

#### PSOCK cluster

The `type="PSOCK"` uses TCP sockets to transfer data between nodes. PSOCK is the default on *all*
systems. The advantage of this method is that it does not require external libraries such as MPI.
On the other hand, TCP sockets are relatively
[slow](http://glennklockwood.blogspot.com/2013/06/whats-killing-cloud-interconnect.html). Creating
a PSOCK cluster is similar to launching an MPI cluster, but instead of specifying the number of
parallel workers, you have to manually specify the number of nodes according to the
hardware specification and parameters of your job.

??? example
    ```R
    library(parallel)

    # a function that needs to be executed in parallel
    average <- function(size){
      norm_vector <- rnorm(n=size, mean=mu, sd=sigma)
      return(mean(norm_vector))
    }

    # variable initialization
    mu <- 1.0
    sigma <- 1.0
    vector_length <- 10^7
    n_repeat <- 100
    sample_sizes <- rep(vector_length, times=n_repeat)

    # cluster setup

    # get number of available nodes (should be equal to "ntasks")
    mynodes = 8
    print(paste("The cluster of size", threads, "will be setup..."))

    # initialize cluster
    cl <- makeCluster(mynodes, type="PSOCK", outfile="")

    # distribute required variables for the execution over the cluster
    clusterExport(cl, list("mu","sigma"))

    list_of_averages <- parLapply(X=sample_sizes, fun=average, cl=cl)

    # shut down the cluster
    print(paste("Program finished"))
    ```

#### FORK cluster

The `type="FORK"` method behaves exactly like the `mclapply` function discussed in the previous
section. Like `mclapply`, it can only use the cores available on a single node. However this method
requires exporting the workspace data to other processes. The FORK method in a combination with
`parLapply` function might be used in situations, where different source code should run on each
parallel process.

### Other parallel options

- [foreach](https://cran.r-project.org/web/packages/foreach/index.html) library.
  It is functionally equivalent to the
  [lapply-based parallelism](https://www.glennklockwood.com/data-intensive/r/lapply-parallelism.html)
  discussed before but based on the for-loop
- [future](https://cran.r-project.org/web/packages/future/index.html)
  library. The purpose of this package is to provide a lightweight and
  unified Future API for sequential and parallel processing of R
  expression via futures
- [Poor-man's parallelism](https://www.glennklockwood.com/data-intensive/r/alternative-parallelism.html#6-1-poor-man-s-parallelism)
  (simple data parallelism). It is the simplest, but not an elegant way to parallelize R code.
  It runs several copies of the same R script where's each read different sectors of the input data
- [Hands-off (OpenMP)](https://www.glennklockwood.com/data-intensive/r/alternative-parallelism.html#6-2-hands-off-parallelism)
  method. R has [OpenMP](https://www.openmp.org/resources/) support. Thus using OpenMP is a simple
  method where you don't need to know much about the parallelism options in your code. Please be
  careful and don't mix this technique with other methods!
