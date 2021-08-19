# Distributed TensorFlow

TODO
 
# Distributed Pytorch

**hint: just copied some old content as starting point**

## Using Multiple GPUs with PyTorch

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

## Distributed data-parallel

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
