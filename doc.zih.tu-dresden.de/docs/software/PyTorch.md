# Pytorch for Data Analytics

[PyTorch](https://pytorch.org/) is an open-source machine learning framework. 
It is an optimized tensor library for deep learning using GPUs and CPUs. 
PyTorch is a machine learning tool developed by Facebooks AI division 
to process large-scale object detection, segmentation, classification, etc.
PyTorch provides a core datastructure, the tensor, a multi-dimensional array that shares many 
similarities with Numpy arrays. 
PyTorch also consumed Caffe2 for its backend and added support of ONNX.

**Prerequisites:** To work with PyTorch you obviously need [access](../access/Login.md) for the 
Taurus system and basic knowledge about Python, Numpy and SLURM system.

**Aim** of this page is to introduce users on how to start working with PyTorch on the 
[HPC-DA](../use_of_hardware/Power9.md) system -  part of the TU Dresden HPC system.

There are numerous different possibilities of how to work with PyTorch on Taurus. 
Here we will consider two main methods.

1\. The first option is using Jupyter notebook with HPC-DA nodes. The easiest way is by using [Jupyterhub](JupyterHub.md).
It is a recommended way for beginners in PyTorch 
and users who are just starting their work with Taurus.

2\. The second way is using the Modules system and Python or conda virtual environment. 
See [the Python page](Python.md) for the HPC-DA system.

Note: The information on working with the PyTorch using Containers could
be found [here](containers.md).

## Get started with PyTorch

### Virtual environment

For working with PyTorch and python packages using virtual environments (kernels) is necessary.

Creating and using your kernel (environment) has the benefit that you can install your preferred 
python packages and use them in your notebooks.

A virtual environment is a cooperatively isolated runtime environment that allows Python users and 
applications to install and upgrade Python distribution packages without interfering with 
the behaviour of other Python applications running on the same system. So the 
[Virtual environment](https://docs.python.org/3/glossary.html#term-virtual-environment) 
is a self-contained directory tree that contains a Python installation for a particular version of 
Python, plus several additional packages. At its core, the main purpose of 
Python virtual environments is to create an isolated environment for Python projects. 
Python virtual environment is the main method to work with Deep Learning software as PyTorch on the 
HPC-DA system.

### Conda and Virtualenv

There are two methods of how to work with virtual environments on
Taurus:

1.**Vitualenv (venv)** is a standard Python tool to create isolated Python environments. 
In general, It is the preferred interface for managing installations and virtual environments 
on Taurus. 
It has been integrated into the standard library under the 
[venv module](https://docs.python.org/3/library/venv.html). 
We recommend using **venv** to work with Python packages and Tensorflow on Taurus.

2\. The **conda** command is the interface for managing installations and virtual environments on 
Taurus. 
The **conda** is a tool for managing and deploying applications, environments and packages. 
Conda is an open-source package management system and environment management system from Anaconda. 
The conda manager is included in all versions of Anaconda and Miniconda.
**Important note!** Due to the use of Anaconda to create PyTorch modules for the ml partition, 
it is recommended to use the conda environment for working with the PyTorch to avoid conflicts over 
the sources of your packages (pip or conda).

**Note:** Keep in mind that you **cannot** use conda for working with the virtual environments 
previously created with Vitualenv tool and vice versa

This example shows how to install and start working with PyTorch (with
using module system)

    srun -p ml -N 1 -n 1 -c 2 --gres=gpu:1 --time=01:00:00 --pty --mem-per-cpu=5772 bash #Job submission in ml nodes with 1 gpu on 1 node with 2 CPU and with 5772 mb for each cpu.
    module load modenv/ml                        #Changing the environment. Example output: The following have been reloaded with a version change:  1) modenv/scs5 => modenv/ml
    mkdir python-virtual-environments            #Create folder
    cd python-virtual-environments               #Go to folder
    module load PythonAnaconda/3.6                      #Load Anaconda with Python. Example output: Module Module PythonAnaconda/3.6 loaded.
    which python                                                 #Check which python are you using
    python3 -m venv --system-site-packages envtest               #Create virtual environment
    source envtest/bin/activate                                  #Activate virtual environment. Example output: (envtest) bash-4.2$
    module load PyTorch                                          #Load PyTorch module. Example output: Module PyTorch/1.1.0-PythonAnaconda-3.6 loaded.
    python                                                       #Start python
    import torch
    torch.version.__version__                                    #Example output: 1.1.0

Keep in mind that using **srun** directly on the shell will lead to blocking and launch an 
interactive job. Apart from short test runs, 
it is **recommended to launch your jobs into the background by using batch jobs**. 
For that, you can conveniently put the parameters directly into the job file 
which you can submit using *sbatch [options] <job_file_name>*.

## Running the model and examples

Below are examples of Jupyter notebooks with PyTorch models which you can run on ml nodes of HPC-DA.

There are two ways how to work with the Jupyter notebook on HPC-DA system. You can use a  
[remote Jupyter server](DeepLearning.md) or [JupyterHub](JupyterHub.md). 
Jupyterhub is a simple and recommended way to use PyTorch.
We are using Jupyterhub for our examples. 

Prepared examples of PyTorch models give you an understanding of how to work with 
Jupyterhub and PyTorch models. It can be useful and instructive to start 
your acquaintance with PyTorch and HPC-DA system from these simple examples.

JupyterHub is available here: [https://taurus.hrsk.tu-dresden.de/jupyter](https://taurus.hrsk.tu-dresden.de/jupyter)

After login, you can start a new session by clicking on the button.

**Note:** Detailed guide (with pictures and instructions) how to run the Jupyterhub 
you could find on [the page](JupyterHub.md).

Please choose the "IBM Power (ppc64le)". You need to download an example 
(prepared as jupyter notebook file) that already contains all you need for the start of the work. 
Please put the file into your previously created virtual environment in your working directory or 
use the kernel for your notebook [see Jupyterhub page](JupyterHub.md).

Note: You could work with simple examples in your home directory but according to 
[HPCStorageConcept2019](../data_management/HPCStorageConcept2019.md) please use **workspaces** 
for your study and work projects. 
For this reason, you have to use advanced options of Jupyterhub and put "/" in "Workspace scope" field.

To download the first example (from the list below) into your previously created 
virtual environment you could use the following command:

    ws_list                                      #list of your workspaces
    cd &lt;name_of_your_workspace&gt;                  #go to workspace

    wget https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/PyTorch/example_MNIST_Pytorch.zip
    unzip example_MNIST_Pytorch.zip

Also, you could use kernels for all notebooks, not only for them which
placed in your virtual environment. See the [jupyterhub](JupyterHub.md) page.

Examples:

1\. Simple MNIST model. The MNIST database is a large database of handwritten digits that is 
commonly used for training various image processing systems. PyTorch allows us to import and 
download the MNIST dataset directly from the Torchvision - package consists of datasets, 
model architectures and transformations.
The model contains a neural network with sequential architecture and typical modules 
for this kind of models. Recommended parameters for running this model are 1 GPU and 7 cores (28 thread)

(example_MNIST_Pytorch.zip)

### Running the model

Open [JupyterHub](JupyterHub.md) and follow instructions above.

In Jupyterhub documents are organized with tabs and a very versatile split-screen feature. 
On the left side of the screen, you can open your file. Use 'File-Open from Path' 
to go to your workspace (e.g. `scratch/ws/<username-name_of_your_ws>`). 
You could run each cell separately step by step and analyze the result of each step. 
Default command for running one cell Shift+Enter'. Also, you could run all cells with the command '
run all cells' in the 'Run' Tab.

## Components and advantages of the PyTorch

### Pre-trained networks

The PyTorch gives you an opportunity to use pre-trained models and networks for your purposes 
(as a TensorFlow for instance) especially for computer vision and image recognition. As you know 
computer vision is one of the fields that have been most impacted by the advent of deep learning.

We will use a network trained on ImageNet, taken from the TorchVision project, 
which contains a few of the best performing neural network architectures for computer vision, 
such as AlexNet, one of the early breakthrough networks for image recognition, and ResNet, 
which won the ImageNet classification, detection, and localization competitions, in 2015. 
[TorchVision](https://pytorch.org/vision/stable/index.html) also has easy access to datasets like 
ImageNet and other utilities for getting up 
to speed with computer vision applications in PyTorch. 
The pre-defined models can be found in torchvision.models.

**Important note**: For the ml nodes only the Torchvision 0.2.2. is available (10.11.20). 
The last updates from IBM include only Torchvision 0.4.1 CPU version. 
Be careful some features from modern versions of Torchvision are not available in the 0.2.2 
(e.g. some kinds of `transforms`). Always check the version with: `print(torchvision.__version__)`

Examples:

1. Image recognition example. This PyTorch script is using Resnet to single image classification.
Recommended parameters for running this model are 1 GPU and 7 cores (28 thread).

(example_Pytorch_image_recognition.zip)

Remember that for using [JupyterHub service](JupyterHub.md) 
for PyTorch you need to create and activate 
a virtual environment (kernel) with loaded essential modules (see "envtest" environment form the virtual
environment example.

Run the example in the same way as the previous example (MNIST model).

### Using Multiple GPUs with PyTorch

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

Remember that for using [JupyterHub service](JupyterHub.md) 
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

Keep in mind that only one memory parameter (`--mem-per-cpu` = <MB> or `--mem`=<MB>) can be specified

## F.A.Q

-   (example_MNIST_Pytorch.zip)
-   (example_Pytorch_image_recognition.zip)
-   (example_PyTorch_parallel.zip)
