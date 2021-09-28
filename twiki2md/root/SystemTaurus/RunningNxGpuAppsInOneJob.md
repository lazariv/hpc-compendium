# Running Multiple GPU Applications Simultaneously in a Batch Job

Keywords: slurm, job, gpu, multiple, instances, application, program,
background, parallel, serial, concurrently, simultaneously

## Objective

Our starting point is a (serial) program that needs a single GPU and
four CPU cores to perform its task (e.g. TensorFlow). The following
batch script shows how to run such a job on the Taurus partition called
"ml".

    #!/bin/bash
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=4
    #SBATCH --gres=gpu:1
    #SBATCH --gpus-per-task=1
    #SBATCH --time=01:00:00
    #SBATCH --mem-per-cpu=1443
    #SBATCH --partition=ml

    srun some-gpu-application

When srun is used within a submission script, it inherits parameters
from sbatch, including --ntasks=1, --cpus-per-task=4, etc. So we
actually implicitly run the following

    srun --ntasks=1 --cpus-per-task=4 ... --partition=ml some-gpu-application

Now, our goal is to run four instances of this program concurrently in a
**single** batch script. Of course we could also start the above script
multiple times with sbatch, but this is not what we want to do here.

## Solution

In order to run multiple programs concurrently in a single batch
script/allocation we have to do three things:

1\. Allocate enough resources to accommodate multiple instances of our
program. This can be achieved with an appropriate batch script header
(see below).

2\. Start job steps with srun as background processes. This is achieved
by adding an ampersand at the end of the srun command

3\. Make sure that each background process gets its private resources.
We need to set the resource fraction needed for a single run in the
corresponding srun command. The total aggregated resources of all job
steps must fit in the allocation specified in the batch script header.
Additionally, the option --exclusive is needed to make sure that each
job step is provided with its private set of CPU and GPU resources.

The following example shows how four independent instances of the same
program can be run concurrently from a single batch script. Each
instance (task) is equipped with 4 CPUs (cores) and one GPU.

    #!/bin/bash
    #SBATCH --ntasks=4
    #SBATCH --cpus-per-task=4
    #SBATCH --gres=gpu:4
    #SBATCH --gpus-per-task=1
    #SBATCH --time=01:00:00
    #SBATCH --mem-per-cpu=1443
    #SBATCH --partition=ml

    srun --exclusive --gres=gpu:1 --ntasks=1 --cpus-per-task=4 --gpus-per-task=1 --mem-per-cpu=1443 some-gpu-application &
    srun --exclusive --gres=gpu:1 --ntasks=1 --cpus-per-task=4 --gpus-per-task=1 --mem-per-cpu=1443 some-gpu-application &
    srun --exclusive --gres=gpu:1 --ntasks=1 --cpus-per-task=4 --gpus-per-task=1 --mem-per-cpu=1443 some-gpu-application &
    srun --exclusive --gres=gpu:1 --ntasks=1 --cpus-per-task=4 --gpus-per-task=1 --mem-per-cpu=1443 some-gpu-application &

    echo "Waiting for all job steps to complete..."
    wait
    echo "All jobs completed!"

In practice it is possible to leave out resource options in srun that do
not differ from the ones inherited from the surrounding sbatch context.
The following line would be sufficient to do the job in this example:

    srun --exclusive --gres=gpu:1 --ntasks=1 some-gpu-application &

Yet, it adds some extra safety to leave them in, enabling the SLURM
scheduler to complain if not enough resources in total were specified in
the header of the batch script.

-- Main.HolgerBrunst - 2021-04-16
