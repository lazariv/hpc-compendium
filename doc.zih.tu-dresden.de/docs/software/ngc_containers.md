# GPU-accelerated Containers for Deep Learning (NGC Containers)

A [container](containers.md) is an executable and portable unit of software.
On ZIH systems, [Singularity](https://sylabs.io/) is used as a standard container solution.

[NGC](https://developer.nvidia.com/ai-hpc-containers),
a registry of highly GPU-optimized software,
has been enabling scientists and researchers by providing regularly updated
and validated containers of HPC and AI applications.
NGC containers are **GPU-optimized** containers
for deep learning, machine learning, visualization:

- Built-in libraries and dependencies;
- Faster training with Automatic Mixed Precision (AMP);
- Opportunity to scale up from single-node to multi-node systems;
- Performance optimized.

!!! note "Advantages of NGC containers"
    - NGC containers were highly optimized for cluster usage.
        The performance provided by NGC containers is comparable to the performance
        provided by the modules on the ZIH system (which is potentially the most performant way).
        NGC containers are a quick and efficient way to apply the best models
        on your dataset on a ZIH system;
    - NGC containers allow using an exact version of the software
        without installing it with all prerequisites manually.
        Manual installation can result in poor performance (e.g. using conda to install a software).

## Run NGC Containers on the ZIH System

The first step is a choice of the necessary software (container) to run.
The [NVIDIA NGC catalog](https://ngc.nvidia.com/catalog)
contains a host of GPU-optimized containers for deep learning,
machine learning, visualization, and HPC applications that are tested
for performance, security, and scalability.
It is necessary to register to have full access to the catalog.

To find a container that fits the requirements of your task, please check
the [official examples page](https://github.com/NVIDIA/DeepLearningExamples)
with the list of main containers with their features and peculiarities.

### Run NGC container on a Single GPU

!!! note
    Almost all NGC containers can work with a single GPU.

To use NGC containers, it is necessary to understand the main Singularity commands.

If you are not familiar with Singularity's syntax, please find the information on the
[official page](https://sylabs.io/guides/3.0/user-guide/quick_start.html#interact-with-images).
However, some main commands will be explained.

Create a container from the image from the NGC catalog.
(For this example, the alpha is used):

```console
marie@login$ srun --partition=alpha --nodes=1 --ntasks-per-node=1 --ntasks=1 --gres=gpu:1 --time=08:00:00 --pty --mem=50000 bash

marie@compute$ cd /scratch/ws/<name_of_your_workspace>/containers   #please create a Workspace

marie@compute$ singularity pull pytorch:21.08-py3.sif docker://nvcr.io/nvidia/pytorch:21.08-py3
```

Now, you have a fully functional PyTorch container.

Please pay attention, using `srun` directly on the shell will lead to
background by using batch jobs.
For that, you can conveniently put the parameters directly into the job file,
which you can submit using `sbatch` command.

In the majority of cases, the container doesn't contain the dataset for training models.
To download the dataset, please follow the
[instructions](https://github.com/NVIDIA/DeepLearningExamples) for the exact container.
Also, you can find the instructions in a README file which you can find inside the container:

```console
marie@compute$ singularity exec pytorch:21.06-py3_beegfs vim /workspace/examples/resnet50v1.5/README.md
```

It is recommended to run the container with a single command.
However, for the educational purpose, the separate commands will be presented below:

```console
marie@login$ srun --partition=alpha --nodes=1 --ntasks-per-node=1 --ntasks=1 --gres=gpu:1 --time=08:00:00 --pty --mem=50000 bash
```

Run a shell within a container with the `singularity shell` command:

```console
marie@compute$ singularity shell --nv -B /scratch/imagenet:/data/imagenet pytorch:21.06-py3
```

The flag `--nv` in the command above was used to enable Nvidia support for GPU usage
and a flag `-B` for a user-bind path specification.

Run the training inside the container:

```console
marie@container$ python /workspace/examples/resnet50v1.5/multiproc.py --nnodes=1 --nproc_per_node=1 \
                --node_rank=0 /workspace/examples/resnet50v1.5/main.py --data-backend dali-cpu \
                --raport-file raport.json -j16 -p 100 --lr 2.048 --optimizer-batch-size 2048 --warmup 8 \
                --arch resnet50 -c fanin --label-smoothing 0.1 --lr-schedule cosine --mom 0.875 \
                --wd 3.0517578125e-05 -b 256 --epochs 90 /data/imagenet
```

!!! warning
    Please keep in mind that it is necessary to specify the amount of resources that you use inside
    the container, especially if you have allocated more resources in the cluster. Regularly, you
    can do it with flags such as `--nproc_per_node`. You can find more information in the README
    file inside the container.

As an example, please find the full command to run the ResNet50 model
on the ImageNet dataset inside the PyTorch container:

```console
marie@login$ srun --partition=alpha --nodes=1 --ntasks-per-node=1 --ntasks=1 --gres=gpu:1 --time=08:00:00 --pty --mem=50000 \
                singularity exec --nv -B /scratch/ws/0/anpo879a-ImgNet/imagenet:/data/imagenet pytorch:21.06-py3 \
                python /workspace/examples/resnet50v1.5/multiproc.py --nnodes=1 --nproc_per_node 1 \
                --node_rank=0 /workspace/examples/resnet50v1.5/main.py --data-backend dali-cpu --raport-file raport.json \
                -j16 -p 100 --lr 2.048 --optimizer-batch-size 2048 --warmup 8 --arch resnet50 -c fanin --label-smoothing 0.1 \
                --lr-schedule cosine --mom 0.875 --wd 3.0517578125e-05 -b 256 --epochs 90 /data/imagenet
```

### Multi-GPU Usage

The majority of the NGC containers allow you to use multiple GPUs from one node
to run the model inside the container.
However, the NGC containers were made by Nvidia for the Nvidia cluster,
which is not ZIH system.
Moreover, editing NGC containers requires root privileges,
which can be done only with [containers](containers.md) on ZIH systems.
Thus, there is no guarantee that all NGC containers work right out of the box.

However, PyTorch and TensorFlow containers support multi-GPU usage.

An example of using the PyTorch container for the training of the ResNet50 model
on the classification task on the ImageNet dataset is presented below:

```console
marie@login$ srun --partition=alpha --nodes=1 --ntasks-per-node=8 --ntasks=8 --gres=gpu:8 --time=08:00:00 --pty --mem=700G bash
```

```console
marie@alpha$ singularity exec --nv -B /scratch/ws/0/marie-ImgNet/imagenet:/data/imagenet pytorch:21.06-py3 \
                python /workspace/examples/resnet50v1.5/multiproc.py --nnodes=1 --nproc_per_node 8 \
                --node_rank=0 /workspace/examples/resnet50v1.5/main.py --data-backend dali-cpu \
                --raport-file raport.json -j16 -p 100 --lr 2.048 --optimizer-batch-size 2048 --warmup 8 \
                --arch resnet50 -c fanin --label-smoothing 0.1 --lr-schedule cosine --mom 0.875 \
                --wd 3.0517578125e-05 -b 256 --epochs 90 /data/imagenet
```

Please pay attention to the parameter `--nproc_per_node`.
The value is equal to 8 because 8 GPUs per node were allocated with `--gres=gpu:8`.

### Multi-node Usage

There are few NGC containers with Multi-node support
[available](https://github.com/NVIDIA/DeepLearningExamples).
Moreover, the realization of the multi-node usage depends on the authors
of the exact container.
Thus, right now, it is not possible to run NGC containers with multi-node support
on the ZIH system without changing the source code inside the container.
