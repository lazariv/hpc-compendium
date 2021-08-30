# Distributed Training

## Internal Distribution

### Distributed TensorFlow

TODO

### Distributed Pytorch

Hint: just copied some old content as starting point

#### Using Multiple GPUs with PyTorch

Effective use of GPUs is essential, and it implies using parallelism in
your code and model. Data Parallelism and model parallelism are effective instruments
to improve the performance of your code in case of GPU using.

The data parallelism is a widely-used technique. It replicates the same model to all GPUs,
where each GPU consumes a different partition of the input data. You could see this method [here](https://pytorch.org/tutorials/beginner/blitz/data_parallel_tutorial.html).

The example below shows how to solve that problem by using model
parallel, which, in contrast to data parallelism, splits a single model
onto different GPUs, rather than replicating the entire model on each
GPU. The high-level idea of model parallel is to place different sub-networks of a model onto different
devices. As the only part of a model operates on any individual device, a set of devices can
collectively serve a larger model.

It is recommended to use [DistributedDataParallel]
(https://pytorch.org/docs/stable/generated/torch.nn.parallel.DistributedDataParallel.html),
instead of this class, to do multi-GPU training, even if there is only a single node.
See: Use nn.parallel.DistributedDataParallel instead of multiprocessing or nn.DataParallel.
Check the [page](https://pytorch.org/docs/stable/notes/cuda.html#cuda-nn-ddp-instead) and
[Distributed Data Parallel](https://pytorch.org/docs/stable/notes/ddp.html#ddp).

Examples:

1\. The parallel model. The main aim of this model to show the way how
to effectively implement your neural network on several GPUs. It
includes a comparison of different kinds of models and tips to improve
the performance of your model. **Necessary** parameters for running this
model are **2 GPU** and 14 cores (56 thread).

(example_PyTorch_parallel.zip)

Remember that for using [JupyterHub service](../access/jupyterhub.md)
for PyTorch you need to create and activate
a virtual environment (kernel) with loaded essential modules.

Run the example in the same way as the previous examples.

#### Distributed data-parallel

[DistributedDataParallel](https://pytorch.org/docs/stable/nn.html#torch.nn.parallel.DistributedDataParallel)
(DDP) implements data parallelism at the module level which can run across multiple machines.
Applications using DDP should spawn multiple processes and create a single DDP instance per process.
DDP uses collective communications in the [torch.distributed]
(https://pytorch.org/tutorials/intermediate/dist_tuto.html)
package to synchronize gradients and buffers.

The tutorial could be found [here](https://pytorch.org/tutorials/intermediate/ddp_tutorial.html).

To use distributed data parallelisation on Taurus please use following
parameters: `--ntasks-per-node` -parameter to the number of GPUs you use
per node. Also, it could be useful to increase `memomy/cpu` parameters
if you run larger models. Memory can be set up to:

--mem=250000 and --cpus-per-task=7 for the **ml** partition.

--mem=60000 and --cpus-per-task=6 for the **gpu2** partition.

Keep in mind that only one memory parameter (`--mem-per-cpu` = <MB> or `--mem`=<MB>) can be
specified

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
