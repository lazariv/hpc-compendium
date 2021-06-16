# R for data analytics



[ **R** ](https://www.r-project.org/about.html)\<span style="font-size:
1em;"> is a programming language and environment for statistical
computing and graphics. R provides a wide variety of statistical (linear
and nonlinear modelling, classical statistical tests, time-series
analysis, classification, etc) and graphical techniques. R is an
integrated suite of software facilities for data manipulation,
calculation and graphing.\</span>

R possesses an extensive catalogue of statistical and graphical methods.
It includes machine learning algorithms, linear regression, time series,
statistical inference.

**Aim** of this page is to introduce users on how to start working with
the R language on Taurus in general as well as on the HPC-DA system.\<br
/>**Prerequisites:** To work with the R on Taurus you obviously need
access for the Taurus system and basic knowledge about programming and
[SLURM](Slurm) system.

For general information on using the HPC-DA system, see the [Get started
with HPC-DA system](GetStartedWithHPCDA) page.

You can also find the information you need on the HPC-Introduction and
HPC-DA-Introduction presentation slides.

\<br />\<span style="font-size: 1em;">We recommend using
\</span>**Haswell**\<span style="font-size: 1em;">and/or\</span> **
[Romeo](RomeNodes)**\<span style="font-size: 1em;">partitions to work
with R. Please use the ml partition only if you need GPUs! \</span>

## R console

This is a quickstart example. The `srun` command is used to submit a
real-time execution job designed for interactive use with output
monitoring. Please check [the page](Slurm) for details. The R language
available for both types of Taurus nodes/architectures x86 (scs5
software environment) and Power9 (ml software environment).

Haswell partition:

    srun --partition=haswell --ntasks=1 --nodes=1 --cpus-per-task=4 --mem-per-cpu=2583 --time=01:00:00 --pty bash       #job submission in haswell nodes with allocating: 1 task per node, 1 node, 4 CPUs per task with 2583 mb per CPU(core) on 1 hour

    module load modenv/scs5                              #Ensure that you are using the scs5 partition. Example output: The following have been reloaded with a version change: 1) modenv/ml => modenv/scs5
    module available R/3.6                                #Check all availble modules with R version 3.6. You could use also "ml av R" but it gives huge output.
    module load R                                                          #Load default R module Example output: Module R/3.6.0-foss 2019a and 56 dependencies loaded.
    which R                                                                #Checking of current version of R 
    R                                                                      #Start R console

Here are the parameters of the job with all the details to show you the
correct and optimal way to do it. Please allocate the job with respect
to [hardware specification](HardwareTaurus)! Besides, it should be noted
that the value of the \<span>--mem-per-cpu\</span> parameter is
different for the different partitions. it is important to respect \<a
href="SystemTaurus#Memory_Limits" target="\_blank">memory limits\</a>.
Please note that the default limit is 300 MB per cpu.

However, using srun directly on the shell will lead to blocking and
launch an interactive job. Apart from short test runs, it is
**recommended to launch your jobs into the background by using batch
jobs**. For that, you can conveniently place the parameters directly
into the job file which can be submitted using
`sbatch [options] <job file><span>. </span>`\<span style="font-size:
1em;">The examples could be found [here](GetStartedWithHPCDA) or
[here](Slurm). Furthermore, you could work with simple examples in your
home directory but according to \<a href="HPCStorageConcept2019"
target="\_blank">storage concept\</a>** please use \<a href="WorkSpaces"
target="\_blank">workspaces\</a> for your study and work
projects!**\</span>

It is also possible to run Rscript directly (after loading the module):

    Rscript /path/to/script/your_script.R param1 param2                           #run Rscript directly. For instance: Rscript /scratch/ws/mastermann-study_project/da_script.r 

## R with Jupyter notebook

In addition to using interactive srun jobs and batch jobs, there is
another way to work with the **R** on Taurus. JipyterHub is a quick and
easy way to work with jupyter notebooks on Taurus. See\<span
style="font-size: 1em;"> the \<a href="JupyterHub"
target="\_blank">JupyterHub page\</a> for detailed instructions.\</span>

The [production environment](JupyterHub#Standard_environments) of
JupyterHub contains R as a module for all partitions. R could be run in
the Notebook or Console for [JupyterLab](JupyterHub#JupyterLab).

## RStudio

\<a href="<https://rstudio.com/>" target="\_blank">RStudio\</a> is an
integrated development environment (IDE) for R. It includes a console,
syntax-highlighting editor that supports direct code execution, as well
as tools for plotting, history, debugging and workspace management.
RStudio is also available for both Taurus x86 (scs5) and Power9 (ml)
nodes/architectures.

The best option to run RStudio is to use JupyterHub. RStudio will work
in a browser. It is currently available in the **test** environment on
both x86 (**scs5**) and Power9 (**ml**) architectures/partitions. It can
be started similarly as a new kernel from \<a
href="JupyterHub#JupyterLab" target="\_blank">JupyterLab\</a> launcher.
See the picture below.

\<img alt="environments.png" height="70"
src="%ATTACHURL%/environments.png" title="environments.png" width="300"
/>

\<img alt="Launcher.png" height="205" src="%ATTACHURL%/Launcher.png"
title="Launcher.png" width="195" />

Please keep in mind that it is not currently recommended to use the
interactive x11 job with the desktop version of Rstudio, as described,
for example, [here](Slurm#Interactive_X11_47GUI_Jobs) or in introduction
HPC-DA slides. This method is unstable.

## Install packages in R

By default, user-installed packages are stored in the
\<span>/$HOME/R\</span>/ folder inside a subfolder depending on the
architecture (on Taurus: x86 or PowerPC). Install packages using the
shell:

    srun -p haswell -N 1 -n 1 -c 4 --mem-per-cpu=2583 --time=01:00:00 --pty bash     #job submission to the haswell nodes with allocating: 1 task per node, 1 node,  4 CPUs per task with 2583 mb per CPU(core) in 1 hour
    module purge
    module load modenv/scs5                                        #Changing the environment. Example output: The following have been reloaded with a version change: 1) modenv/ml => modenv/scs5

    module load R                                                  #Load R module Example output: Module R/3.6.0-foss-2019a and 56 dependencies loaded.
    which R                                                        #Checking of current version of R
    R                                                              #Start of R console
    install.packages("package_name")                               #For instance: install.packages("ggplot2") 

Note that to allocate the job the slurm parameters are used with
different (short) notations, but with the same values as in the previous
example.

## Deep Learning with R

This chapter will briefly describe working with **ml partition** (Power9
architecture). This means that it will focus on the work with the GPUs,
and the main scenarios will be explained.

\*Important: Please use the ml partition if you need GPUs\* \<span
style="font-size: 1em;"> Otherwise using the x86 partitions (e.g
Haswell) would most likely be more beneficial. \</span>

### R Interface to Tensorflow

The ["Tensorflow" R package](https://tensorflow.rstudio.com/) provides R
users access to the Tensorflow toolset.
[TensorFlow](https://www.tensorflow.org/) is an open-source software
library for numerical computation using data flow graphs.

    srun -p ml -N 1 -n 1 -c 7 --mem-per-cpu=5772 --gres=gpu:1 --time=04:00:00 --pty bash

    module purge                                               #clear modules
    ml modenv/ml                                               #load ml environment
    ml TensorFlow
    ml R

    which python
    mkdir python-virtual-environments                          #Create folder. Please use Workspaces!
    cd python-virtual-environments                             #Go to folder
    python3 -m venv --system-site-packages R-TensorFlow        #create python virtual environment
    source R-TensorFlow/bin/activate                           #activate environment
    module list                                                
    which R

Please allocate the job with respect to [hardware
specification](HardwareTaurus)! Note that the ML nodes have 4way-SMT, so
for every physical core allocated, you will always get 4\*1443mb
=5772mb.

To configure "reticulate" R library to point to the Python executable in
your virtual environment, create a file \<span style="font-size:
1em;">nam\</span>\<span style="font-size: 1em;">ed .Rprofile in your
project directory (e.g. R-TensorFlow) with the following
contents:\</span>

    Sys.setenv(RETICULATE_PYTHON = "/sw/installed/Anaconda3/2019.03/bin/python")    #assign the output of the 'which python' to the RETICULATE_PYTHON 

Let's start R, install some libraries and evaluate the result

    R
    install.packages("reticulate")
    library(reticulate)
    reticulate::py_config()
    install.packages("tensorflow")
    library(tensorflow)
    tf$constant("Hellow Tensorflow")         #In the output 'Tesla V100-SXM2-32GB' should be mentioned

Please find the example of the code in the
[attachment](%ATTACHURL%/TensorflowMNIST.R?t=1597837603). The example
shows the use of the Tensorflow package with the R for the
classification problem related to the MNIST dataset.\<br />\<span
style="font-size: 1em;">As an alternative to the TensorFlow rTorch could
be used. \</span>\<a
href="<https://cran.r-project.org/web/packages/rTorch/index.html>"
target="\_blank">rTorch\</a>\<span style="font-size: 1em;"> is an 'R'
implementation and interface for the \<a href="<https://pytorch.org/>"
target="\_blank">PyTorch\</a> Machine Learning framework\</span>\<span
style="font-size: 1em;">.\</span>

## Parallel computing with R

Generally, the R code is serial. However, many computations in R can be
made faster by the use of parallel computations. Taurus allows a vast
number of options for parallel computations. Large amounts of data
and/or use of complex models are indications of the use of parallelism.

### General information about the R parallelism

There are various techniques and packages in R that allow
parallelization. This chapter concentrates on most general methods and
examples. The Information here is Taurus-specific. The \<a
href="<https://www.rdocumentation.org/packages/parallel/versions/3.6.2>"
target="\_blank">parallel package\</a> will be used for the purpose of
the chapter.

%RED%Note:<span class="twiki-macro ENDCOLOR"></span> Please do not
install or update R packages related to parallelism it could lead to
conflict with other pre-installed packages.

### \<span style="font-size: 1em;">Basic lapply-based parallelism \</span>

**`lapply()`** function is a part of base R. lapply is useful for
performing operations on list-objects. Roughly speaking, lapply is a
vectorisation of the source code but it could be used for
parallelization. To use more than one core with lapply-style
parallelism, you have to use some type of networking so that each node
can communicate with each other and shuffle the relevant data around.
The simple example of using the "pure" lapply parallelism could be found
as the [attachment](%ATTACHURL%/lapply.R).

### Shared-memory parallelism

The `parallel` library includes the `mclapply()` function which is a
shared memory version of lapply. The "mc" stands for "multicore". This
function distributes the `lapply` tasks across multiple CPU cores to be
executed in parallel.

This is a simple option for parallelisation. It doesn't require much
effort to rewrite the serial code to use mclapply function. Check out an
[example](%ATTACHURL%/multicore.R). The cons of using shared-memory
parallelism approach that it is limited by the number of cores(cpus) on
a single node.

<span class="twiki-macro RED"></span> **Important:** <span
class="twiki-macro ENDCOLOR"></span> Please allocate the job with
respect to [hardware specification](HardwareTaurus). The current maximum
number of processors (read as cores) for an SMP-parallel program on
Taurus is 56 (smp2 partition), for the Haswell partition, it is a 24.
The large SMP system (Julia) is coming soon with a total number of 896
nodes.

Submitting a multicore R job to SLURM is very similar to [Submitting an
OpenMP Job](Slurm#Binding_and_Distribution_of_Tasks) since both are
running multicore jobs on a **single** node. Below is an example:

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

Examples of R scripts with the shared-memory parallelism can be found as
an [attachment](%ATTACHURL%/multicore.R) on the bottom of the page.

### Distributed memory parallelism

To use this option we need to start by setting up a cluster, a
collection of workers that will do the job in parallel. There are three
main options for it: MPI cluster, PSOCK cluster and FORK cluster. We use
\<span>makeCluster {parallel}\</span> function to create a set of copies
of **R** running in parallel and communicating over sockets, the type of
the cluster could be specified by the \<span>TYPE \</span>variable.

#### MPI cluster

This way of the R parallelism uses the
[Rmpi](http://cran.r-project.org/web/packages/Rmpi/index.html) package
and the [MPI](https://en.wikipedia.org/wiki/Message_Passing_Interface)
(Message Passing Interface) as a "backend" for its parallel operations.
Parallel R codes submitting a multinode MPI R job to SLURM is very
similar to \<a href="Slurm#Binding_and_Distribution_of_Tasks"
target="\_blank">submitting an MPI Job\</a> since both are running
multicore jobs on multiple nodes. Below is an example of running R
script with the Rmpi on Taurus:

    #!/bin/bash
    #SBATCH --partition=haswell                  #specify the partition
    #SBATCH --ntasks=16                  #This parameter determines how many processes will be spawned. Please use >= 8.
    #SBATCH --cpus-per-task=1
    #SBATCH --time=00:10:00
    #SBATCH -o test_Rmpi.out
    #SBATCH -e test_Rmpi.err

    module purge
    module load modenv/scs5
    module load R

    mpirun -n 1 R CMD BATCH Rmpi.R            #specify the absolute path to the R script, like: /scratch/ws/max1234-Work/R/Rmpi.R

    # when finished writing, submit with sbatch <script_name> 

\<span class="WYSIWYG_TT"> **-ntasks** \</span> SLURM option is the best
and simplest way to run your application with MPI. The number of nodes
required to complete this number of tasks will then be selected. Each
MPI rank is assigned 1 core(CPU).

However, in some specific cases, you can specify the number of nodes and
the number of necessary tasks per node:

    #!/bin/bash
    #SBATCH --nodes=2
    #SBATCH --tasks-per-node=16
    #SBATCH --cpus-per-task=1
    module purge
    module load modenv/scs5
    module load R

    time mpirun -quiet -np 1 R CMD BATCH --no-save --no-restore Rmpi_c.R    #this command will calculate the time of completion for your script

The illustration above shows the binding of an MPI-job. Use an
[example](%ATTACHURL%/Rmpi_c.R) from the attachment. In which 32 global
ranks are distributed over 2 nodes with 16 cores(CPUs) each. Each MPI
rank has 1 core assigned to it.

To use Rmpi and MPI please use one of these partitions: **Haswell**,
**Broadwell** or **Rome**.\<br />**%RED%Important:<span
class="twiki-macro ENDCOLOR"></span>**\<span
style`"font-size: 1em;"> Please allocate the required number of nodes and cores according to the hardware specification: 1 Haswell's node: 2 x [Intel Xeon (12 cores)]; 1 Broadwell's Node: 2 x [Intel Xeon (14 cores)]; 1 Rome's node: 2 x [AMD EPYC (64 cores)]. Please also check the </span><a href="HardwareTaurus" target="_blank">hardware specification</a><span style="font-size: 1em;"> (number of nodes etc). The =sinfo`
command gives you a quick overview of the status of partitions.\</span>

\<span style="font-size: 1em;">Please use \</span>\<span>mpirun\</span>
command \<span style="font-size: 1em;">to run the Rmpi script. It is a
wrapper that enables the communication between processes running on
different machines. \</span>\<span style="font-size: 1em;">We recommend
always use \</span>\<span style="font-size: 1em;">"\</span>\<span>-np
1\</span>\<span style="font-size: 1em;">"\</span>\<span
style="font-size: 1em;"> (the number of MPI processes to launch)\</span>
\<span style="font-size: 1em;">because otherwise, it spawns additional
processes dynamically.\</span>

Examples of R scripts with the Rmpi can be found as attachments at the
bottom of the page.

#### PSOCK cluster

The `type="PSOCK"` uses TCP sockets to transfer data between nodes.
PSOCK is the default on *all* systems. However, if your parallel code
will be executed on Windows as well you should use the PSOCK method. The
advantage of this method is that It does not require external libraries
such as Rmpi. On the other hand, TCP sockets are relatively
[slow](http://glennklockwood.blogspot.com/2013/06/whats-killing-cloud-interconnect.html).
Creating a PSOCK cluster is similar to launching an MPI cluster, but
instead of simply saying how many parallel workers you want, you have to
manually specify the number of nodes according to the hardware
specification and parameters of your job. The example of the code could
be found as an [attachment](%ATTACHURL%/RPSOCK.R?t=1597043002).

#### FORK cluster

The `type="FORK"` behaves exactly like the `mclapply` function discussed
in the previous section. Like `mclapply`, it can only use the cores
available on a single node, but this does not require clustered data
export since all cores use the same memory. You may find it more
convenient to use a FORK cluster with `parLapply` than `mclapply` if you
anticipate using the same code across multicore *and* multinode systems.

### Other parallel options

There are numerous different parallel options for R. However for general
users, we would recommend using the options listed above. However, the
alternatives should be mentioned:

-   \<span>
    [foreach](https://cran.r-project.org/web/packages/foreach/index.html)
    \</span>package. It is functionally equivalent to the [lapply-based
    parallelism](https://www.glennklockwood.com/data-intensive/r/lapply-parallelism.html)
    discussed before but based on the for-loop;
-   [future](https://cran.r-project.org/web/packages/future/index.html)
    package. The purpose of this package is to provide a lightweight and
    unified Future API for sequential and parallel processing of R
    expression via futures;
-   [Poor-man's
    parallelism](https://www.glennklockwood.com/data-intensive/r/alternative-parallelism.html#6-1-poor-man-s-parallelism)
    (simple data parallelism). It is the simplest, but not an elegant
    way to parallelize R code. It runs several copies of the same R
    script where's each read different sectors of the input data;
-   \<a
    href="<https://www.glennklockwood.com/data-intensive/r/alternative-parallelism.html#6-2-hands-off-parallelism>"
    target="\_blank">Hands-off (OpenMP) method\</a>. R has
    [OpenMP](https://www.openmp.org/resources/) support. Thus using
    OpenMP is a simple method where you don't need to know a much about
    the parallelism options in your code. Please be careful and don't
    mix this technique with other methods!

-- Main.AndreiPolitov - 2020-05-18

-   [TensorflowMNIST.R](%ATTACHURL%/TensorflowMNIST.R?t=1597837603)\<span
    style="font-size: 13px;">: TensorflowMNIST.R\</span>
-   [lapply.R](%ATTACHURL%/lapply.R)\<span style="font-size: 13px;">:
    lapply.R\</span>
-   [multicore.R](%ATTACHURL%/multicore.R)\<span style="font-size:
    13px;">: multicore.R\</span>
-   [Rmpi.R](%ATTACHURL%/Rmpi.R)\<span style="font-size: 13px;">:
    Rmpi.R\</span>
-   [Rmpi_c.R](%ATTACHURL%/Rmpi_c.R)\<span style="font-size: 13px;">:
    Rmpi_c.R\</span>
-   [RPSOCK.R](%ATTACHURL%/RPSOCK.R)\<span style="font-size: 13px;">:
    RPSOCK.R\</span>

\<div id="gtx-trans" style="position: absolute; left: 35px; top:
5011.8px;"> \</div>
