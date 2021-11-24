# Computational Fluid Dynamics (CFD)

The following CFD applications are available on our system:

|               | **Module** |
|---------------|------------|
| **OpenFOAM**  | openfoam   |
| **CFX**       | ansys      |
| **Fluent**    | ansys      |
| **ICEM CFD**  | ansys      |
| **STAR-CCM+** | star       |

## OpenFOAM

The OpenFOAM (Open Field Operation and Manipulation) CFD Toolbox can simulate anything from complex
fluid flows involving chemical reactions, turbulence and heat transfer, to solid dynamics,
electromagnetics and the pricing of financial options. OpenFOAM is developed primarily by
[OpenCFD Ltd](https://www.openfoam.com) and is freely available and open-source,
licensed under the GNU General Public License.

The command `module spider OpenFOAM` provides the list of installed OpenFOAM versions. In order to
use OpenFOAM, it is mandatory to set the environment by sourcing the `bashrc` (for users running
bash or ksh) or `cshrc` (for users running tcsh or csh) provided by OpenFOAM:

```console
marie@login$ module load OpenFOAM/VERSION
marie@login$ source $FOAM_BASH
marie@login$ # source $FOAM_CSH
```

???+ example "Example for OpenFOAM job script:"
    ```bash
    #!/bin/bash
    #SBATCH --time=12:00:00     # walltime
    #SBATCH --ntasks=60         # number of processor cores (i.e. tasks)
    #SBATCH --mem-per-cpu=500M  # memory per CPU core
    #SBATCH -job-name="Test"    # job name
    #SBATCH --mail-user=marie@tu-dresden.de  # email address (only tu-dresden)
    #SBATCH --mail-type=ALL

    OUTFILE="Output"
    module load OpenFOAM
    source $FOAM_BASH
    cd /scratch/ws/1/marie-example-workspace  # work directory using workspace
    srun pimpleFoam -parallel > "$OUTFILE"
    ```

## Ansys CFX

Ansys CFX is a powerful finite-volume-based program package for modeling general fluid flow in
complex geometries. The main components of the CFX package are the flow solver cfx5solve, the
geometry and mesh generator cfx5pre, and the post-processor cfx5post.

???+ example "Example for CFX job script:"
    ```bash
    #!/bin/bash
    #SBATCH --time=12:00                                       # walltime
    #SBATCH --ntasks=4                                         # number of processor cores (i.e. tasks)
    #SBATCH --mem-per-cpu=1900M                                # memory per CPU core
    #SBATCH --mail-user=marie@tu-dresden.de                    # email address (only tu-dresden)
    #SBATCH --mail-type=ALL

    module load ANSYS
    cd /scratch/ws/1/marie-example-workspace                   # work directory using workspace
    cfx-parallel.sh -double -def StaticMixer.def
    ```

## Ansys Fluent

???+ example "Fluent needs the host names and can be run in parallel like this:"
    ```bash
    #!/bin/bash
    #SBATCH --time=12:00                        # walltime
    #SBATCH --ntasks=4                          # number of processor cores (i.e. tasks)
    #SBATCH --mem-per-cpu=1900M                 # memory per CPU core
    #SBATCH --mail-user=marie@tu-dresden.de     # email address (only tu-dresden)
    #SBATCH --mail-type=ALL
    module load ANSYS

    nodeset -e $SLURM_JOB_NODELIST | xargs -n1 > hostsfile_job_$SLURM_JOBID.txt

    fluent 2ddp -t$SLURM_NTASKS -g -mpi=intel -pinfiniband -cnf=hostsfile_job_$SLURM_JOBID.txt < input.in
    ```

To use fluent interactively, please try:

```console
marie@login$ module load ANSYS/19.2
marie@login$ srun --nodes=1 --cpus-per-task=4 --time=1:00:00 --pty --x11=first bash
marie@login$ fluent &
```

## STAR-CCM+

!!! note
    You have to use your own license in order to run STAR-CCM+ on ZIH systems, so you have to specify
    the parameters `-licpath` and `-podkey`, see the example below.

Our installation provides a script `create_rankfile -f CCM` that generates a host list from the
Slurm job environment that can be passed to `starccm+`, enabling it to run across multiple nodes.

???+ example
    ```bash
    #!/bin/bash
    #SBATCH --time=12:00                        # walltime
    #SBATCH --ntasks=32                         # number of processor cores (i.e. tasks)
    #SBATCH --mem-per-cpu=2500M                 # memory per CPU core
    #SBATCH --mail-user=marie@tu-dresden.de     # email address (only tu-dresden)
    #SBATCH --mail-type=ALL

    module load STAR-CCM+

    LICPATH="port@host"
    PODKEY="your podkey"
    INPUT_FILE="your_simulation.sim"
    starccm+ -collab -rsh ssh -cpubind off -np $SLURM_NTASKS -on $(/sw/taurus/tools/slurmtools/default/bin/create_rankfile -f CCM) -batch -power -licpath $LICPATH -podkey $PODKEY $INPUT_FILE
    ```
