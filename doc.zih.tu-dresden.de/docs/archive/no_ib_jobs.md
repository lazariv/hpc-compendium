# Jobs without Infiniband

!!! warning

    This page is outdated.

!!! note

    - These hints are meant only for the downtime of the IB fabric or
    parts of it. Do not use this setup in a normal, healthy system!
    - This setup must not run by jobs producing large amounts of output
    data!
    - MPI jobs over multiple nodes can not run.
    - Jobs using /scratch or /lustre/ssd can not run.\<hr />

At the moment when parts of the IB stop we will start batch system plugins to parse for this batch
system option: `--comment=NO_IB`. Jobs with this option set can run on nodes without
Infiniband access if (and only if) they have set the `--tmp`-option as well:

*From the Slurm documentation:*

>`--tmp` = Specify a minimum amount of temporary disk space per node.
>Default units are megabytes unless the SchedulerParameters configuration
>parameter includes the "default_gbytes" option for gigabytes. Different
>units can be specified using the suffix \[K\|M\|G\|T\]. This option
>applies to job allocations.

Keep in mind: Since the scratch filesystem are not available and the
project filesystem is read-only mounted at the compute nodes you have
to work in /tmp.

A simple job script should do this:

- create a temporary directory on the compute node in `/tmp` and go
  there
- start the application (under /sw/ or /projects/)using input data
  from somewhere in the project filesystem
- archive and transfer the results to some global location

```Bash
#SBATCH --comment=NO_IB
#SBATCH --tmp 2G
MYTEMP=/tmp/$JOBID
mkdir $MYTEMP;
cd $MYTEMP
<path_to_binary>/myapp < <path_to_input_data> > ./$JOBID_out
# tar if it makes sense!
rsync -a $MYTEMP taurusexport3:<path_to_output_data>/
rm -rf $MYTEMP
```
