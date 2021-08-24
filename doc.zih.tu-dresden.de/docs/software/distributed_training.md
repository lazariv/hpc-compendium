# Distributed Training

## Internal Distribution

## External Distribution

### Horovod

[Horovod](https://github.com/horovod/horovod) is the open source distributed training
framework for TensorFlow, Keras, PyTorch. It is supposed to make it easy
to develop distributed deep learning projects and speed them up with
TensorFlow.

#### Why use Horovod?

Horovod allows you to easily take a single-GPU TensorFlow and Pytorch
program and successfully train it on many GPUs! In
some cases, the MPI model is much more straightforward and requires far
less code changes than the distributed code from TensorFlow for
instance, with parameter servers. Horovod uses MPI and NCCL which gives
in some cases better results than pure TensorFlow and PyTorch.

#### Horovod as a module

Horovod is available as a module with **TensorFlow** or **PyTorch**for **all** module environments.
Please check the [software module list](modules.md) for the current version of the software.
Horovod can be loaded like other software on the Taurus:

```Bash
ml av Horovod            #Check available modules with Python
module load Horovod      #Loading of the module
```

#### Horovod installation

However, if it is necessary to use Horovod with **PyTorch** or use
another version of Horovod it is possible to install it manually. To
install Horovod you need to create a virtual environment and load the
dependencies (e.g. MPI). Installing PyTorch can take a few hours and is
not recommended

**Note:** You could work with simple examples in your home directory but **please use workspaces
for your study and work projects** (see the Storage concept).

Setup:

```Bash
srun -N 1 --ntasks-per-node=6 -p ml --time=08:00:00 --pty bash                    #allocate a Slurm job allocation, which is a set of resources (nodes)
module load modenv/ml                                                             #Load dependencies by using modules
module load OpenMPI/3.1.4-gcccuda-2018b
module load Python/3.6.6-fosscuda-2018b
module load cuDNN/7.1.4.18-fosscuda-2018b
module load CMake/3.11.4-GCCcore-7.3.0
virtualenv --system-site-packages <location_for_your_environment>                 #create virtual environment
source <location_for_your_environment>/bin/activate                               #activate virtual environment
```

Or when you need to use conda:

```Bash
srun -N 1 --ntasks-per-node=6 -p ml --time=08:00:00 --pty bash                            #allocate a Slurm job allocation, which is a set of resources (nodes)
module load modenv/ml                                                                     #Load dependencies by using modules
module load OpenMPI/3.1.4-gcccuda-2018b
module load PythonAnaconda/3.6
module load cuDNN/7.1.4.18-fosscuda-2018b
module load CMake/3.11.4-GCCcore-7.3.0

conda create --prefix=<location_for_your_environment> python=3.6 anaconda                 #create virtual environment

conda activate  <location_for_your_environment>                                           #activate virtual environment
```

Install Pytorch (not recommended)

```Bash
cd /tmp
git clone https://github.com/pytorch/pytorch                                  #clone Pytorch from the source
cd pytorch                                                                    #go to folder
git checkout v1.7.1                                                           #Checkout version (example: 1.7.1)
git submodule update --init                                                   #Update dependencies
python setup.py install                                                       #install it with python
```

##### Install Horovod for Pytorch with python and pip

In the example presented installation for the Pytorch without
TensorFlow. Adapt as required and refer to the horovod documentation for
details.

```Bash
HOROVOD_GPU_ALLREDUCE=MPI HOROVOD_WITHOUT_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_WITHOUT_MXNET=1 pip install --no-cache-dir horovod
```

##### Verify that Horovod works

```Bash
python                                           #start python
import torch                                     #import pytorch
import horovod.torch as hvd                      #import horovod
hvd.init()                                       #initialize horovod
hvd.size()
hvd.rank()
print('Hello from:', hvd.rank())
```

##### Horovod with NCCL

If you want to use NCCL instead of MPI you can specify that in the
install command after loading the NCCL module:

```Bash
module load NCCL/2.3.7-fosscuda-2018b
HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_GPU_BROADCAST=NCCL HOROVOD_WITHOUT_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_WITHOUT_MXNET=1 pip install --no-cache-dir horovod
```
