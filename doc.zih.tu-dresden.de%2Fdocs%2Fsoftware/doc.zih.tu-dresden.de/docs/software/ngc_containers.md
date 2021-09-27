# GPU-accelerated containers for deep learning (NGC containers)

## Containers

Containers are executable portable units of software in which 
application code is packaged, along with its 
libraries and dependencies. 
[Containerization](https://www.ibm.com/cloud/learn/containerization) encapsulating or packaging up
software code and all its dependencies to run uniformly and consistently 
on any infrastructure with other words it is agnostic to host sprefic environment like OS, etc.

Containers are a widely adopted method of taming the complexity of deploying HPC and AI software. 
The entire software environment, from the deep learning framework itself, 
down to the math and communication libraries are necessary for performance, is packaged into 
a single bundle. Since workloads inside a container 
always use the same environment, the performance is reproducible and portable.

On Taurus [Singularity](https://sylabs.io/) used as a standard container solution.

## NGC containers

[NGC](https://developer.nvidia.com/ai-hpc-containers), a registry of highly GPU-optimized software, 
has been enabling scientists and researchers by providing regularly updated 
and validated containers of HPC and AI applications.

NGC containers support Singularity.

NGC containers are optimized for high-performance computing (HPC) applications.
NGC containers are **GPU-optimized** containers 
for **deep learning,** **machine learning**, visualization:

- Built-in libraries and dependencies

- Faster training with Automatic Mixed Precision (AMP)

- Opportunity to scaling up from single-node to multi-node systems
  
- Allowing you to develop on the cloud, on premises, or at the edge

- Highly versatile with support for various container runtimes such as Docker, Singularity, cri-o, etc

- Performance optimized

## Run NGC containers on ZIH system

### Preparation

The first step is a choice of the necessary software (container) to run. 
The [NVIDIA NGC catalog](https://ngc.nvidia.com/catalog) 
contains a host of GPU-optimized containers for deep learning, 
machine learning, visualization, and high-performance computing (HPC) applications that are tested 
for performance, security, and scalability. 
It is necessary to register to have a full access to the catalouge.

To find a container which fits to the requirements of your task please check 
the [resourse](https://github.com/NVIDIA/DeepLearningExamples) 
with the list of main containers with their features and precularities.

### Building and Run the Container

To use NGC containers it is necessary to undertend main Singularity commands.
If you are nor familiar with singularity syntax please find the information [here](https://sylabs.io/guides/3.0/user-guide/quick_start.html#interact-with-images).

Create a container from the image from the NGC catalog. For the exemple alpha partition was used.

```console
marie@login$ srun -p alpha --nodes 1 --ntasks-per-node 1 --ntasks 1 --gres=gpu:1 --time=08:00:00 --pty --mem=50000 bash    #allocate alpha partition with one GPU

marie@compute$ cd /scratch/ws/<name_of_your_workspace>/containers   #please create a Workspace

marie@compute$ singularity pull pytorch:21.08-py3.sif docker://nvcr.io/nvidia/pytorch:21.08-py3
```

Now you have a fully functional PyTorch container.

In majority of cases the container doesn't containe the datasets for training models. 
To download the dataset please follow the instructions for the exact container [here](https://github.com/NVIDIA/DeepLearningExamples).
Also you can find the instructions in a README file which you can find inside the container:

```console
marie@compute$ singularity exec pytorch:21.06-py3_beegfs vim /workspace/examples/resnet50v1.5/README.md
```

As an exemple please find the full command to run the Resnet50 model on the ImageNet dataset 
inside the PyTorch container

```console
marie@compute$ singularity exec --nv -B /scratch/ws/0/anpo879a-ImgNet/imagenet:/data/imagenet pytorch:21.06-py3 python /workspace/examples/resnet50v1.5/multiproc.py --nnodes=1 --nproc_per_node 1 --node_rank=0 /workspace/examples/resnet50v1.5/main.py --data-backend dali-cpu --raport-file raport.json -j16 -p 100 --lr 2.048 --optimizer-batch-size 2048 --warmup 8 --arch resnet50 -c fanin --label-smoothing 0.1 --lr-schedule cosine --mom 0.875 --wd 3.0517578125e-05 -b 256 --epochs 90 /data/imagenet
```
