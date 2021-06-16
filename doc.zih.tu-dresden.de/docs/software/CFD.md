# Computational Fluid Dynamics (CFD)

|               |            |           |            |
|---------------|------------|-----------|------------|
|               | **Taurus** | **Venus** | **Module** |
| **OpenFOAM**  | x          |           | openfoam   |
| **CFX**       | x          | x         | ansys      |
| **Fluent**    | x          | x         | ansys      |
| **ICEM CFD**  | x          | x         | ansys      |
| **STAR-CCM+** | x          |           | star       |

## OpenFOAM

The OpenFOAM (Open Field Operation and Manipulation) CFD Toolbox can
simulate anything from complex fluid flows involving chemical reactions,
turbulence and heat transfer, to solid dynamics, electromagnetics and
the pricing of financial options. OpenFOAM is produced by
[Ltd](http://www.opencfd.co.uk/openfoam/%5BOpenCFD) and is freely
available and open source, licensed under the GNU General Public
Licence.

The command "module spider OpenFOAM" provides the list of installed
OpenFOAM versions. In order to use OpenFOAM, it is mandatory to set the
environment by sourcing the \`bashrc\` (for users running bash or ksh)
or \`cshrc\` `(for users running tcsh` or `csh)` provided by OpenFOAM:

    module load OpenFOAM/VERSION
    source $FOAM_BASH
    # source $FOAM_CSH 

Example for OpenFOAM job script:

    #!/bin/bash <br />#SBATCH --time=12:00:00                            # walltime <br />#SBATCH --ntasks=60                                # number of processor cores (i.e. tasks) <br />#SBATCH --mem-per-cpu=500M                         # memory per CPU core <br />#SBATCH -J "Test"                                  # job name <br />#SBATCH --mail-user=mustermann@tu-dresden.de       # email address (only tu-dresden)<br />#SBATCH --mail-type=ALL <br />OUTFILE="Output"<br /><br />module load OpenFOAM<br />source $FOAM_BASH<br /><br />cd /scratch/&lt;YOURUSERNAME&gt;                    # work directory in /scratch...!<br />srun pimpleFoam -parallel &gt; "$OUTFILE" 

## Ansys CFX

Ansys CFX is a powerful finite-volume-based program package for modeling
general fluid flow in complex geometries. The main components of the CFX
package are the flow solver cfx5solve, the geometry and mesh generator
cfx5pre, and the post-processor cfx5post.

Example for CFX job script:

    #!/bin/bash<br />#SBATCH --time=12:00                                       # walltime<br />#SBATCH --ntasks=4                                         # number of processor cores (i.e. tasks)<br />#SBATCH --mem-per-cpu=1900M                                # memory per CPU core<br />#SBATCH --mail-user=.......@tu-dresden.de                  # email address (only tu-dresden)<br />#SBATCH --mail-type=ALL<br />module load ANSYS<br />cd /scratch/&lt;YOURUSERNAME&gt;                                 # work directory in /scratch...!<br />cfx-parallel.sh -double -def StaticMixer.def<br /> 

## Ansys Fluent

Fluent need the hostnames and can be run in parallel like this:

    #!/bin/bash
    #SBATCH --time=12:00                                       # walltime
    #SBATCH --ntasks=4                                         # number of processor cores (i.e. tasks)
    #SBATCH --mem-per-cpu=1900M                                # memory per CPU core
    #SBATCH --mail-user=.......@tu-dresden.de                  # email address (only tu-dresden)
    #SBATCH --mail-type=ALL
    module load ANSYS

    nodeset -e $SLURM_JOB_NODELIST | xargs -n1 > hostsfile_job_$SLURM_JOBID.txt

    fluent 2ddp -t$SLURM_NTASKS -g -mpi=intel -pinfiniband -cnf=hostsfile_job_$SLURM_JOBID.txt < input.in

To use fluent interactive please try

module load ANSYS/19.2\<br />srun -N 1 --cpus-per-task=4 --time=1:00:00
--pty --x11=first bash\<br /> fluent&\<br />\<br />

## STAR-CCM+

Note: you have to use your own license in order to run STAR-CCM+ on
Taurus, so you have to specify the parameters -licpath and -podkey, see
the example below.

Our installation provides a script `create_rankfile -f CCM` that
generates a hostlist from the SLURM job environment that can be passed
to starccm+ enabling it to run across multiple nodes.

    #!/bin/bash
    #SBATCH --time=12:00                                       # walltime
    #SBATCH --ntasks=32                                         # number of processor cores (i.e. tasks)
    #SBATCH --mem-per-cpu=2500M                                # memory per CPU core
    #SBATCH --mail-user=.......@tu-dresden.de                  # email address (only tu-dresden)
    #SBATCH --mail-type=ALL

    module load STAR-CCM+

    LICPATH="port@host"
    PODKEY="your podkey"
    INPUT_FILE="your_simulation.sim"

    starccm+ -collab -rsh ssh -cpubind off -np $SLURM_NTASKS -on $(/sw/taurus/tools/slurmtools/default/bin/create_rankfile -f CCM) -batch -power -licpath $LICPATH -podkey $PODKEY $INPUT_FILE
