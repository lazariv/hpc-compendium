# Alpha Centauri - Multi-GPU cluster with NVIDIA A100

The sub-cluster "AlphaCentauri" had been installed for AI-related computations (ScaDS.AI).

## Hardware

- 34 nodes, each with 8 x NVIDIA A100-SXM4 (40 GB RAM) 2 x AMD EPYC CPU 7352 (24 cores) @ 2.3 GHz,
- MultiThreading enabled
  - 1 TB RAM 3.5 TB /tmp local NVMe device Hostnames: taurusi\[8001-8034\] Slurm partition
  - **`alpha`**

## Hints for the usage

These nodes of the cluster can be used like other "normal" GPU nodes (ml, gpu2).

**Attention:** These GPUs may only be used with **CUDA 11** or later. Earlier versions do not
recognize the new hardware properly or cannot fully utilize it. Make sure the software you are using
is built against this library.

## Typical tasks

Machine learning frameworks as TensorFlow and PyTorch are industry
standards now. The example of work with PyTorch on the new AlphaCentauri sub-cluster is illustrated
below in brief examples.

There are three main options on how to work with Tensorflow and PyTorch on the Alpha Centauri
cluster:

1. **Modules**
1  **Virtual Environments (manual software installation)**
1. [JupyterHub](https://taurus.hrsk.tu-dresden.de/)
1. [Containers](../software/containers.md)

### Modules

The easiest way is using the [module system](../software/modules.md) and Python virtual environment.
Modules are a way to use frameworks, compilers, loader, libraries, and utilities. The software
environment for the **alpha** partition is available under the name **hiera**:

```Bash
module load modenv/hiera
```

Machine learning frameworks **PyTorch** and **TensorFlow**available for **alpha** partition as
modules with CUDA11, GCC 10 and OpenMPI4:

```Bash
module load modenv/hiera GCC/10.2.0 CUDA/11.1.1 OpenMPI/4.0.5 PyTorch/1.7.1
module load modenv/hiera GCC/10.2.0 CUDA/11.1.1 OpenMPI/4.0.5 TensorFlow/2.4.1
```

**Hint**: To check the available modules for the **hiera** software environment, use the command:

```Bash
module available
```

To show all the dependencies you need to load for the core module, use the command:

```Bash
module spider <name_of_the_module>
```

### Virtual Environments

It is necessary to use virtual environments for your work with Python. A virtual environment is a
cooperatively isolated runtime environment.  There are two main options to use virtual environments:
venv (standard Python tool) and

1. **Vitualenv** is a standard Python tool to create isolated Python environments. It is the
**preferred** interface for managing installations and virtual environments on Taurus and part of
the Python modules.

1. [Conda](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#activating-an-environment)
is an alternative method for managing installations and virtual environments on Taurus. Conda is an
open-source package management system and environment management system from Anaconda. The conda
manager is included in all versions of Anaconda and Miniconda.

**Note**: There are two sub-partitions of the alpha partition: alpha and
alpha-interactive. Please use alpha-interactive for the interactive jobs and alpha for the batch
jobs.

Examples with conda and venv will be presented below. Also, there is an example of an interactive
job for the AlphaCentauri sub-cluster using the `alpha-interactive` partition:

```Bash
srun -p alpha-interactive -N 1 -n 1 --gres=gpu:1 --time=01:00:00 --pty bash  # Job submission in
alpha nodes with 1 gpu on 1 node.

mkdir conda-virtual-environments            #create a folder, please use Workspaces!
cd conda-virtual-environments               #go to folder
which python                                #check which python are you using ml modenv/hiera
ml Miniconda3
which python                                #check which python are you using now
conda create -n conda-testenv python=3.8    #create virtual environment with the name conda-testenv and Python version 3.8
conda activate
conda-testenv                               #activate conda-testenv virtual environment
conda deactivate                            #Leave the virtual environment
```

New software for data analytics is emerging faster than we can install it. If you urgently need a
certain version we advise you to manually install it (the machine learning frameworks and required
packages) in your virtual environment (or use a [container](../software/containers.md).

The **Virtualenv** example:

```Bash
srun -p alpha-interactive -N 1 -n 1 --gres=gpu:1 --time=01:00:00 --pty bash
#Job submission in alpha nodes with 1 gpu on 1 node.

mkdir python-environments && cd "$_"           # Optional: Create folder. Please use Workspaces!

module load modenv/hiera modenv/hiera GCC/10.2.0 CUDA/11.1.1 OpenMPI/4.0.5 Python/3.8.6   #Changing the environment and load necessary modules
which python                                                     #Check which python are you using
virtualenv --system-site-packages python-environments/envtest    #Create virtual environment
source python-environments/envtest/bin/activate                  #Activate virtual environment. Example output: (envtest) bash-4.2$
```

Example of using **Conda** with a Pytorch and Pillow installation:

```Bash
conda activate conda-testenv
conda install pytorch torchvision cudatoolkit=11.1 -c pytorch -c nvidia
conda install -c anaconda pillow
```

Verify installation for the **Venv** example:

```Bash
python                                                           #Start python from time import
gmtime, strftime print(strftime("%Y-%m-%d %H:%M:%S", gmtime()))  #Example output: 2019-11-18 13:54:16

deactivate                                                       #Leave the virtual environment
```

Verify installation for the **Conda** example:

```Bash
python                      #Start python import torch torch.version.__version__   #Example output: 1.8.1
```

There is an example of the batch script for the typical usage of the Alpha Centauri cluster:

```Bash
#!/bin/bash #SBATCH --mem=40GB                # specify the needed memory. Same amount memory as
on the GPU #SBATCH -p alpha                  # specify Alpha-Centauri partition #SBATCH
--gres=gpu:1              # use 1 GPU per node (i.e. use one GPU per task) #SBATCH --nodes=1
# request 1 node #SBATCH --time=00:15:00           # runs for 15 minutes #SBATCH -c 2
# how many cores per task allocated #SBATCH -o HLR_name_your_script.out        # save output
message under HLR_${SLURMJOBID}.out #SBATCH -e HLR_name_your_script.err        # save error
messages under HLR_${SLURMJOBID}.err

module load modenv/hiera eval "$(conda shell.bash hook)" conda activate conda-testenv && python
machine_learning_example.py

## when finished writing, submit with:  sbatch <script_name> For example: sbatch
machine_learning_script.sh
```

The Alpha Centauri sub-cluster has the NVIDIA A100-SXM4 with 40 GB RAM each. Thus It is prudent to
have the same memory on the host (cpu). The number of cores is free for the users to define, at the
moment.

### JupyterHub

There is [JupyterHub](../access/jupyterhub.md) on Taurus, where you can simply run
your Jupyter notebook on Alpha-Centauri sub-cluster. Also, for more specific cases you can run a
manually created remote jupyter server. You can find the manual server setup
[here](../software/deep_learning.md). However, the simplest option for beginners is using
JupyterHub.

JupyterHub is available at
[taurus.hrsk.tu-dresden.de/jupyter](https://taurus.hrsk.tu-dresden.de/jupyter).

After logging, you can start a new session and configure it. There are simple and advanced forms to
set up your session. The `alpha` partition is available in advanced form. You have to choose the
alpha partition in the partition field. The resource recommendations to allocate are
the same as described above for the batch script example (not confuse `--mem-per-cpu` with `--mem`
parameter).

### Containers

On Taurus [Singularity](https://sylabs.io/) is used as a standard container
solution. It can be run on the `alpha` partition as well. Singularity enables users to have full
control of their environment. Detailed information about containers can be found
[here](../software/containers.md).

Nvidia
[NGC](https://developer.nvidia.com/blog/how-to-run-ngc-deep-learning-containers-with-singularity/)
containers can be used as an effective solution for machine learning related tasks. (Downloading
containers requires registration).  Nvidia-prepared containers with software solutions for specific
scientific problems can simplify the deployment of deep learning workloads on HPC. NGC containers
have shown consistent performance compared to directly run code.

## Examples

There is a test example of a deep learning task that could be used for the test. For the correct
work, Pytorch and Pillow package should be installed in your virtual environment (how it was shown
above in the interactive job example)

- [example_pytorch_image_recognition.zip]**todo attachment**
<!--%ATTACHURL%/example_pytorch_image_recognition.zip:-->
    <!--example_pytorch_image_recognition.zip-->
