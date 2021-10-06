# Distributed Training

## Internal Distribution

Training a machine learning model can be a very time-consuming task.
Distributed training allows scaling up deep learning tasks,
so we can train very large models and speed up training time.

There are two paradigms for distributed training:

1. data parallelism:
each device has a replica of the model and computes over different parts of the data.
2. model parallelism:
models are distributed over multiple devices.

In the following we will stick to the concept of data parallelism because it is a widely-used
technique.
There are basically two strategies to train the scattered data throughout the devices:

1. synchronous training: devices (workers) are trained over different slices of the data and at the
end of each step gradients are aggregated.
2. asynchronous training:
all devices are independently trained over the data and update variables asynchronously.

### Distributed TensorFlow

[TensorFlow](https://www.tensorflow.org/guide/distributed_training) provides a high-end API to
train your model and distribute the training on multiple GPUs or machines with minimal code changes.

The primary distributed training method in TensorFlow is `tf.distribute.Strategy`.
There are multiple strategies that distribute the training depending on the specific use case,
the data and the model.

TensorFlow refers to the synchronous training as mirrored strategy.
There are two mirrored strategies available whose principles are the same:

- `tf.distribute.MirroredStrategy` supports the training on multiple GPUs on one machine.
- `tf.distribute.MultiWorkerMirroredStrategy` for multiple machines, each with multiple GPUs.

The Central Storage Strategy applies to environments where the GPUs might not be able to store
the entire model:

- `tf.distribute.experimental.CentralStorageStrategy` supports the case of a single machine
with multiple GPUs.

The CPU holds the global state of the model and GPUs perform the training.

In some cases asynchronous training might be the better choice for example if workers differ on
capability, are down for maintenance, or have different priorities.
The Parameter Server Strategy is capable of applying asynchronous training:

- `tf.distribute.experimental.ParameterServerStrategy` requires several Parameter Server and Worker.

The Parameter Server holds the parameters and is responsible for updating
the global state of the models.
Each worker runs the training loop independently.

#### Example

In this case, we will go through an example with Multi Worker Mirrored Strategy.
Multi-node training requires a `TF_CONFIG` environment variable to be set which will
be different on each node.

```bash
TF_CONFIG='{"cluster": {"worker": ["10.1.10.58:12345", "10.1.10.250:12345"]}, "task": {"index": 0, "type": "worker"}}' python main.py
```

The `cluster` field describes how the cluster is set up (same on each node).
Here, the cluster has two nodes referred to as workers.
The `IP:port` information is listed in the `worker` array.
The `task` field varies from node to node.
It specifies the type and index of the node.
In this case, the training job runs on worker 0, which is `10.1.10.58:12345`.
We need to adapt this snippet for each node.
The second node will have `'task': {'index': 1, 'type': 'worker'}`.

With two modifications we can parallelize the serial code:
We need to initialize the distributed strategy:

```python
strategy = tf.distribute.experimental.MultiWorkerMirroredStrategy()
```

And define the model under the strategy scope:

```python
with strategy.scope():
    model = resnet.resnet56(img_input=img_input, classes=NUM_CLASSES)
    model.compile(
        optimizer=opt,
        loss='sparse_categorical_crossentropy',
        metrics=['sparse_categorical_accuracy'])
model.fit(train_dataset,
    epochs=NUM_EPOCHS)
```

To run distributed training, the training script needs to be copied to all nodes,
in this case on two nodes.
TensorFlow is available as a module.
Check for the version.
The `TF_CONFIG` environment variable can be set as a prefix to the command.
Now, run the script on the Alpha partition simultaneously on both nodes:

```bash
#!/bin/bash

#SBATCH --job-name=distr
#SBATCH --partition=alpha
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --mem=64000
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=14
#SBATCH --gres=gpu:1
#SBATCH --time=01:00:00

function print_nodelist {
        scontrol show hostname $SLURM_NODELIST
}
NODE_1=$(print_nodelist | awk '{print $1}' | sort -u | head -n 1)
NODE_2=$(print_nodelist | awk '{print $1}' | sort -u | tail -n 1)
IP_1=$(dig +short ${NODE_1}.taurus.hrsk.tu-dresden.de)
IP_2=$(dig +short ${NODE_2}.taurus.hrsk.tu-dresden.de)

module load modenv/hiera
module load modenv/hiera GCC/10.2.0 CUDA/11.1.1 OpenMPI/4.0.5 TensorFlow/2.4.1

# On the first node
TF_CONFIG='{"cluster": {"worker": ["'"${NODE_1}"':33562", "'"${NODE_2}"':33561"]}, "task": {"index": 0, "type": "worker"}}' srun -w ${NODE_1} -N 1 --ntasks=1 --gres=gpu:1 python main_ddl.py &

# On the second node
TF_CONFIG='{"cluster": {"worker": ["'"${NODE_1}"':33562", "'"${NODE_2}"':33561"]}, "task": {"index": 1, "type": "worker"}}' srun -w ${NODE_2} -N 1 --ntasks=1 --gres=gpu:1 python main_ddl.py &

wait
```

### Distributed PyTorch

!!! note
    This section is under construction

#### Using Multiple GPUs with PyTorch

The example below shows how to solve that problem by using model parallelism, which in contrast to
data parallelism splits a single model onto different GPUs, rather than replicating the entire
model on each GPU.
The high-level idea of model parallelism is to place different sub-networks of a model onto
different devices.
As only part of a model operates on any individual device a set of devices can collectively
serve a larger model.

It is recommended to use
[DistributedDataParallel](https://pytorch.org/docs/stable/generated/torch.nn.parallel.DistributedDataParallel.html),
instead of this class, to do multi-GPU training, even if there is only a single node.
See: Use nn.parallel.DistributedDataParallel instead of multiprocessing or nn.DataParallel.
Check the [page](https://pytorch.org/docs/stable/notes/cuda.html#cuda-nn-ddp-instead) and
[Distributed Data Parallel](https://pytorch.org/docs/stable/notes/ddp.html#ddp).

Examples:

1. The parallel model.
The main aim of this model to show the way how to effectively implement your
neural network on several GPUs.
It includes a comparison of different kinds of models and tips to improve the performance
of your model.
**Necessary** parameters for running this model are **2 GPU** and 14 cores.

(example_PyTorch_parallel.zip)

Remember that for using [JupyterHub service](../access/jupyterhub.md) for PyTorch you need to
create and activate a virtual environment (kernel) with loaded essential modules.

Run the example in the same way as the previous examples.

#### Distributed data-parallel

[DistributedDataParallel](https://pytorch.org/docs/stable/nn.html#torch.nn.parallel.DistributedDataParallel)
(DDP) implements data parallelism at the module level which can run across multiple machines.
Applications using DDP should spawn multiple processes and create a single DDP instance per process.
DDP uses collective communications in the
[torch.distributed](https://pytorch.org/tutorials/intermediate/dist_tuto.html) package to
synchronize gradients and buffers.

The tutorial can be found [here](https://pytorch.org/tutorials/intermediate/ddp_tutorial.html).

To use distributed data parallelism on ZIH systems please make sure the `--ntasks-per-node`
parameter is equal to the number of GPUs you use per node.
Also, it can be useful to increase `memory/cpu` parameters if you run larger models.
Memory can be set up to:

- `--mem=250G` and `--cpus-per-task=7` for the `ml` partition.
- `--mem=60G` and `--cpus-per-task=6` for the `gpu2` partition.

Keep in mind that only one memory parameter (`--mem-per-cpu=<MB>` or `--mem=<MB>`) can be specified

## External Distribution

### Horovod

[Horovod](https://github.com/horovod/horovod) is the open source distributed training framework
for TensorFlow, Keras and PyTorch.
It is supposed to make it easy to develop distributed deep learning projects and speed them up.
Horovod scales well to a large number of nodes and has a strong focus on efficient training on
GPUs.

#### Why use Horovod?

Horovod allows you to easily take a single-GPU TensorFlow and PyTorch program and successfully
train it on many GPUs!
In some cases, the MPI model is much more straightforward and requires far less code changes than
the distributed code from TensorFlow for instance, with parameter servers.
Horovod uses MPI and NCCL which gives in some cases better results than
pure TensorFlow and PyTorch.

#### Horovod as a module

Horovod is available as a module with **TensorFlow** or **PyTorch** for
**all** module environments.
Please check the [software module list](modules.md) for the current version of the software.
Horovod can be loaded like other software on ZIH system:

```console
marie@compute$ module spider Horovod           # Check available modules
------------------------------------------------------------------------------------------------
  Horovod:
------------------------------------------------------------------------------------------------
    Description:
      Horovod is a distributed training framework for TensorFlow.

     Versions:
        Horovod/0.18.2-fosscuda-2019b-TensorFlow-2.0.0-Python-3.7.4
        Horovod/0.19.5-fosscuda-2019b-TensorFlow-2.2.0-Python-3.7.4
        Horovod/0.21.1-TensorFlow-2.4.1
[...]
marie@compute$ module load Horovod/0.19.5-fosscuda-2019b-TensorFlow-2.2.0-Python-3.7.4  
```

Or if you want to use Horovod on the partition `alpha` you can load it with the dependencies:

```bash
marie@alpha$ module spider Horovod                         #Check available modules
marie@alpha$ module load modenv/hiera  GCC/10.2.0  CUDA/11.1.1  OpenMPI/4.0.5 Horovod/0.21.1-TensorFlow-2.4.1
```

#### Horovod installation

However if it is necessary to use another version of Horovod it is possible to install it manually.
For that you need to create a [virtual environment](python_virtual_environments.md) and load the
dependencies (e.g. MPI).
Installing TensorFlow can take a few hours and is not recommended.

##### Install Horovod for TensorFlow with python and pip

This example shows the installation of Horovod for TensorFlow.
Adapt as required and refer to the [Horovod documentation](https://horovod.readthedocs.io/en/stable/install_include.html)
for details.

```console
marie@alpha$ HOROVOD_GPU_OPERATIONS=NCCL HOROVOD_WITH_TENSORFLOW=1 pip install --no-cache-dir horovod\[tensorflow\]
[...]
marie@alpha$ horovodrun --check-build
```

If you want to use OpenMPI then specify `HOROVOD_GPU_ALLREDUCE=MPI`.
To have better performance it is recommended to use NCCL instead of OpenMPI.

##### Verify that Horovod works

```python
import torch                                     #import pytorch
import horovod.torch as hvd                      #import horovod
hvd.init()                                       #initialize horovod
hvd.size()
hvd.rank()
print('Hello from:', hvd.rank())
```

#### Example

Follow the steps in the examples described
[here](https://github.com/horovod/horovod/tree/master/examples) to parallelize your code.
In Horovod each GPU gets pinned to a process.
You can easily start your job with the following bash script with four processes on two nodes:

```bash
#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=2
#SBATCH --gres=gpu:2
#SBATCH --partition=ml
#SBATCH --mem=250G
#SBATCH --time=01:00:00
#SBATCH --output=run_horovod.out

module load modenv/ml
module load Horovod/0.19.5-fosscuda-2019b-TensorFlow-2.2.0-Python-3.7.4

srun python <your_program.py>
```

Do not forget to specify the total number of tasks `--ntasks` and the number of tasks per node
`--ntasks-per-node` which must match the number of GPUs per node.
