# Checkpoint/Restart

At some point, every HPC system fails, e.g., a compute node or the network might crash causing
running jobs to crash, too. In order to prevent starting your crashed experiments and simulations
from the very beginning, you should be familiar with the concept of checkpointing.

!!! note

    Checkpointing saves the state of a running process to a checkpointing image file. Using this
    file, the process can later be continued (restarted) from where it left off.

Another motivation is to use checkpoint/restart to split long running jobs into several shorter
ones. This might improve the overall job throughput, since shorter jobs can "fill holes" in the job
queue.
Here is an extreme example from literature for the waste of large computing resources due to missing
checkpoints:

!!! cite "Adams, D. The Hitchhikers Guide Through the Galaxy"

    Earth was a supercomputer constructed to find the question to the answer to the Life, the Universe,
    and Everything by a race of hyper-intelligent pan-dimensional beings. Unfortunately 10 million years
    later, and five minutes before the program had run to completion, the Earth was destroyed by
    Vogons.

If you wish to do checkpointing, your first step should always be to check if your application
already has such capabilities built-in, as that is the most stable and safe way of doing it.
Applications that are known to have some sort of **native checkpointing** include:

Abaqus, Amber, Gaussian, GROMACS, LAMMPS, NAMD, NWChem, Quantum Espresso, STAR-CCM+, VASP

In case your program does not natively support checkpointing, there are attempts at creating generic
checkpoint/restart solutions that should work application-agnostic. One such project which we
recommend is [Distributed Multi-Threaded Check-Pointing](http://dmtcp.sourceforge.net) (DMTCP).

DMTCP is available on ZIH systems after having loaded the `dmtcp` module

```console
marie@login$ module load DMTCP
```

While our batch system [Slurm](slurm.md) also provides a checkpointing interface to the user,
unfortunately, it does not yet support DMTCP at this time. However, there are ongoing efforts of
writing a Slurm plugin that hopefully will change this in the near future. We will update this
documentation as soon as it becomes available.

In order to help with setting up checkpointing for your jobs, we have written a few scripts that
make it easier to utilize DMTCP together with Slurm.

## Using w.r.t. Chain Jobs

For long-running jobs that you wish to split into multiple shorter jobs
([chain jobs](../jobs_and_resources/slurm.md#chain-jobs)), thereby enabling the job scheduler to
fill the cluster much more efficiently and also providing some level of fault-tolerance, we have
written a script that automatically creates a number of jobs for your desired runtime and adds the
checkpoint/restart bits transparently to your batch script. You just have to specify the targeted
total runtime of your calculation and the interval in which you wish to do checkpoints. The latter
(plus the time it takes to write the checkpoint) will then be the runtime of the individual jobs.
This should be targeted at below 24 hours in order to be able to run on all
[partitions haswell64](../jobs_and_resources/partitions_and_limits.md#runtime-limits). For
increased fault-tolerance, it can be chosen even shorter.

To use it, first add a `dmtcp_launch` before your application call in your batch script. In the case
of MPI applications, you have to add the parameters `--ib --rm` and put it between `srun` and your
application call, e.g.:

```bash
srun dmtcp_launch --ib --rm ./my-mpi-application
```

!!! note

    We have successfully tested checkpointing MPI applications with
    the latest `Intel MPI` (module: intelmpi/2018.0.128). While it might
    work with other MPI libraries, too, we have no experience in this
    regard, so you should always try it out before using it for your
    productive jobs.

Then just substitute your usual `sbatch` call with `dmtcp_sbatch` and be sure to specify the `-t`
and `-i` parameters (don't forget you need to have loaded the `dmtcp` module).

```console
marie@login$ dmtcp_sbatch --time 2-00:00:00 --interval 28000,800 my_batchfile.sh
```

With `-t, --time` you set the total runtime of your calculations. This will be replaced in the batch
script in order to shorten your individual jobs.

The parameter `-i, --interval` sets the time in seconds for your checkpoint intervals. It can
optionally include a timeout for writing out the checkpoint files, separated from the interval time
via comma (defaults to 10 minutes).

In the above example, there will be 6 jobs each running 8 hours, so
about 2 days in total.

!!! Hints

    - If you see your first job running into the time limit, that probably
    means the timeout for writing out checkpoint files does not suffice
    and should be increased. Our tests have shown that it takes
    approximately 5 minutes to write out the memory content of a fully
    utilized 64GB haswell node, so you should choose at least 10 minutes
    there (better err on the side of caution). Your mileage may vary,
    depending on how much memory your application uses. If your memory
    content is rather incompressible, it might be a good idea to disable
    the checkpoint file compression by setting: `export DMTCP_GZIP=0`
    - Note that all jobs the script deems necessary for your chosen
    time limit/interval values are submitted right when first calling the
    script. If your applications take considerably less time than what
    you specified, some of the individual jobs will be unnecessary. As
    soon as one job does not find a checkpoint to resume from, it will
    cancel all subsequent jobs for you.
    - See `dmtcp_sbatch -h` for a list of available parameters and more help

What happens in your work directory?

- The script will create subdirectories named `ckpt_<jobid>` for each
  individual job it puts into the queue
- It will also create modified versions of your batch script, one for
  the first job (`ckpt_launch.job`), one for the middle parts
  (`ckpt_rstr.job`) and one for the final job (`cpkt_rstr_last.job`)
- Inside the `ckpt_*` directories you will also find a file
  (`job_ids`) containing all job ids that are related to this job
  chain

If you wish to restart manually from one of your checkpoints (e.g., if something went wrong in your
later jobs or the jobs vanished from the queue for some reason), you have to call `dmtcp_sbatch`
with the `-r, --resume` parameter, specifying a `cpkt_` directory to resume from.  Then it will use
the same parameters as in the initial run of this job chain. If you wish to adjust the time limit,
for instance, because you realized that your original limit was too short, just use the `-t, --time`
parameter again on resume.

## Using DMTCP Manually

If for some reason our automatic chain job script is not suitable for your use case, you could also
just use DMTCP on its own. In the following we will give you step-by-step instructions on how to
checkpoint your job manually:

* Load the DMTCP module: `module load dmtcp`
* DMTCP usually runs an additional process that
manages the creation of checkpoints and such, the so-called `coordinator`. It must be started in
your batch script before the actual start of your application. To help you with this process, we
have created a bash function called `start_coordinator` that is available after sourcing
`$DMTCP_ROOT/bin/bash` in your script. The coordinator can take a handful of parameters, see `man
dmtcp_coordinator`. Via `-i` you can specify an interval (in seconds) in which checkpoint files are
to be created automatically. With `--exit-after-ckpt` the application will be terminated after the
first checkpoint has been created, which can be useful if you wish to implement some sort of job
chaining on your own.
* In front of your program call, you have to add the wrapper
script `dmtcp_launch`.  This will create a checkpoint automatically after 40 seconds and then
terminate your application and with it the job. If the job runs into its time limit (here: 60
seconds), the time to write out the checkpoint was probably not long enough. If all went well, you
should find `cpkt` files in your work directory together with a script called
`./dmtcp_restart_script.sh` that can be used to resume from the checkpoint.

???+ example

    ```bash
    #/bin/bash
    #SBATCH --time=00:01:00
    #SBATCH --cpus-per-task=8
    #SBATCH --mem-per-cpu=1500

    source $DMTCP_ROOT/bin/bash start_coordinator -i 40 --exit-after-ckpt

    dmtcp_launch ./my-application #for sequential/multithreaded applications
    #or: srun dmtcp_launch --ib --rm ./my-mpi-application #for MPI
    applications
    ```

* To restart your application, you need another batch file
(similar to the one above) where once again you first have to start the
DMTCP coordinator. The requested resources should match those of your
original job. If you do not wish to create another checkpoint in your
restarted run again, you can omit the `-i` and `--exit-after-ckpt`
parameters this time. Afterwards, the application must be run using the
restart script, specifying the host and port of the coordinator (they
have been exported by the start_coordinator function).

???+ example

    ```bash
    #/bin/bash
    #SBATCH --time=00:01:00
    #SBATCH --cpus-per-task=8
    #SBATCH --mem-per-cpu=1500

    source $DMTCP_ROOT/bin/bash start_coordinator -i 40 --exit-after-ckpt

    ./dmtcp_restart_script.sh -h $DMTCP_COORD_HOST -p
    $DMTCP_COORD_PORT
    ```
