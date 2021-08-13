# Nanoscale Modeling Tools

|                           |                                   |            |
|---------------------------|-----------------------------------|------------|
|                           | **Taurus**                        | **module** |
| **[ABINIT](#ABINIT)**     | 7.21, 8.2.3, 8.6.3                | abinit     |
| **[CP2K](#CP2K)**         | 2.3, 2.4, 2.6, 3.0, 4.1, 5.1, 6.1 | cp2k       |
| **[CPMD](#CPMD)**         |                                   | \-         |
| **[Gamess US](#gamess)**  | 2013                              | gamess     |
| **[Gaussian](#Gaussian)** | g03e01, g09, g09b01, g16          | gaussian   |
| **[GROMACS](#GROMACS)**   | 4.6.5, 4.6.7,5.1, 5.1.4, 2018.2   | gromacs    |
| **[LAMMPS](#lammps)**     | 2014, 2015, 2016, 2018            | lammps     |
| **[NAMD](#NAMD)**         | 2.10, 2.12                        | namd       |
| **[ORCA](#ORCA)**         | 3.0.3, 4.0, 4.0.1                 | orca       |
| **[Siesta](#Siesta)**     | 3.2, 4.0, 4.1                     | siesta     |
| **[VASP](#VASP)**         | 5.3, 5.4.1, 5.4.4                 | vasp       |

## ABINIT

[ABINIT](http://www.abinit.org) is a package whose main program allows one to find the total energy,
charge density and electronic structure of systems made of electrons and nuclei (molecules and
periodic solids) within Density Functional Theory (DFT), using pseudopotentials and a planewave
basis. ABINIT also includes options to optimize the geometry according to the DFT forces and
stresses, or to perform molecular dynamics simulations using these forces, or to generate dynamical
matrices, Born effective charges, and dielectric tensors. Excited states can be computed within the
Time-Dependent Density Functional Theory (for molecules), or within Many-Body Perturbation Theory
(the GW approximation).

Available ABINIT packages can be listed and loaded with the following commands:  
```console
marie@login$ module avail ABINIT
---------------------------- /sw/modules/scs5/chem -----------------------------
   ABINIT/8.6.3-intel-2018a         Wannier90/2.0.1.1-foss-2018b-abinit
   ABINIT/8.10.3-intel-2018b        Wannier90/2.0.1.1-intel-2018b-abinit
   ABINIT/9.2.1-intel-2020a  (D)

marie@login$ module load ABINIT
Module ABINIT/9.2.1-intel-2020a and 16 dependencies loaded.
```

## CP2K

[CP2K](http://cp2k.berlios.de/) performs atomistic and molecular simulations of solid state, liquid,
molecular and biological systems. It provides a general framework for different methods such as e.g.
density functional theory (DFT) using a mixed Gaussian and plane waves approach (GPW), and classical
pair and many-body potentials.

Available CP2K packages can be listed and loaded with the following commands:  
```console
marie@login$ module avail CP2K
---------------------------- /sw/modules/scs5/chem -----------------------------
   CP2K/5.1-intel-2018a          CP2K/6.1-intel-2018a-spglib
   CP2K/6.1-foss-2019a-spglib    CP2K/6.1-intel-2018a        (D)
   CP2K/6.1-foss-2019a
[...]
marie@login$ module load CP2K
Module CP2K/6.1-intel-2018a and 25 dependencies loaded.
```

## CPMD

The CPMD code is a plane wave/pseudopotential implementation of Density Functional Theory,
particularly designed for ab-initio molecular dynamics. For examples and documentations see
[CPMD homepage](https://www.lcrc.anl.gov/for-users/software/available-software/cpmd/).

CPMD is currently not installed as a module. 
Please, contact hpcsupport@zih.tu-dresden.de if you need assitance.

## GAMESS

GAMESS is an ab-initio quantum mechanics program, which provides many methods for computation of the
properties of molecular systems using standard quantum chemical methods. For a detailed description,
please look at the [GAMESS home page](https://www.msg.chem.iastate.edu/gamess/index.html).

Available GAMESS packages can be listed and loaded with the following commands:  
```console
marie@login$ module load modenv/classic
[...]
marie@login$:~> module avail gamess
----------------------- /sw/modules/taurus/applications ------------------------
   gamess/2013
[...]
marie@login$ module load gamess
Start gamess like this:
 rungms.slurm <inputfile> [scratch_path]
Module gamess/2013 and 2 dependencies loaded.
```

For runs with Slurm, please use a script like this:
```Bash
#!/bin/bash
#SBATCH -t 120
#SBATCH -n 8
#SBATCH --ntasks-per-node=2
## you have to make sure that on each node runs an even number of tasks !!
#SBATCH --mem-per-cpu=1900

module load modenv/classic
module load gamess
rungms.slurm cTT_M_025.inp /scratch/ws/0/marie-gamess
#                          the third parameter is the location of your scratch directory
```

*GAMESS should be cited as:* M.W.Schmidt, K.K.Baldridge, J.A.Boatz, S.T.Elbert, M.S.Gordon,
J.H.Jensen, S.Koseki, N.Matsunaga, K.A.Nguyen, S.J.Su, T.L.Windus, M.Dupuis, J.A.Montgomery,
J.Comput.Chem. 14, 1347-1363(1993).

## Gaussian

Starting from the basic laws of quantum mechanics, [Gaussian](http://www.gaussian.com) predicts the
energies, molecular structures, and vibrational frequencies of molecular systems, along with
numerous molecular properties derived from these basic computation types. It can be used to study
molecules and reactions under a wide range of conditions, including both stable species and
compounds which are difficult or impossible to observe experimentally such as short-lived
intermediates and transition structures.

With `module load gaussian` (or `gaussian/g09`) a number of environment variables are set according
to the needs of Gaussian. Please, set the directory for temporary data (GAUSS_SCRDIR) manually to
somewhere below `/scratch` (you get the path, when you generated a workspace for your
calculation).

This is a small example, kindly provide by Arno Schneeweis (Inst. fr Angewandte Physik). You need a
batch file - for example called "mybatch.sh" with the following content:

```Bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4    # this number of CPU's has to match with the %nproc in the inputfile
#SBATCH --mem=4000
#SBATCH --time=00:10:00        # hh:mm:ss
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=vorname.nachname@tu-dresden.de
#SBATCH -A ...your_projectname...

####
make available the access to Gaussian 16
module load modenv/classic
module load gaussian/g16_avx2
export GAUSS_SCRDIR=...path_to_the_Workspace_that_you_generated_before...
g16 < my_input.com > my_output.out
```

*As example the input for gaussian could be this my_input.com:*

```Bash
%mem=4GB
%nproc=4

#P B3LYP/6-31G* opt

Toluol

0 1
C    1.108640   0.464239  -0.122043
C    1.643340  -0.780361   0.210457
C    0.794940  -1.850561   0.494257
C   -0.588060  -1.676061   0.445657
C   -1.122760  -0.431461   0.113257
C   -0.274360   0.638739  -0.170643
C   -0.848171   1.974558  -0.527484
H    1.777668   1.308198  -0.345947
H    2.734028  -0.917929   0.248871
H    1.216572  -2.832148   0.756392
H   -1.257085  -2.520043   0.669489
H   -2.213449  -0.293864   0.074993
H   -1.959605   1.917127  -0.513867
H   -0.507352   2.733596   0.211754
H   -0.504347   2.265972  -1.545144
```

You have to start the job with command:

```Batch
sbatch mybatch.sh
```

## GROMACS

GROMACS is a versatile package to perform molecular dynamics, i.e.  simulate the Newtonian equations
of motion for systems with hundreds to millions of particles. It is primarily designed for
biochemical molecules like proteins, lipids and nucleic acids that have a lot of complicated bonded
interactions, but since GROMACS is extremely fast at calculating the nonbonded interactions (that
usually dominate simulations) many groups are also using it for research on non-biological systems,
e.g. polymers.

For documentations see [Gromacs homepage](http://www.gromacs.org/).

## LAMMPS

[LAMMPS](http://lammps.sandia.gov) is a classical molecular dynamics code that models an ensemble of
particles in a liquid, solid, or gaseous state. It can model atomic, polymeric, biological,
metallic, granular, and coarse-grained systems using a variety of force fields and boundary
conditions. For examples of LAMMPS simulations, documentations, and more visit
[LAMMPS sites](http://lammps.sandia.gov).

## NAMD

[NAMD](http://www.ks.uiuc.edu/Research/namd) is a parallel molecular dynamics code designed for
high-performance simulation of large biomolecular systems.

The current version in modenv/scs5 can be started with `srun` as usual.

Note that the old version from modenv/classic does not use MPI but rather uses Infiniband directly.
Therefore, you cannot not use srun/mpirun to spawn the processes but have to use the supplied
"charmrun" command instead. Also, since this is batch system agnostic, it has no possiblity of
knowing which nodes are reserved for it use, so if you want it to run on more than node, you have to
create a hostlist file and feed it to charmrun via the parameter "++nodelist". Otherwise, all
processes will be launched on the same node (localhost) and the other nodes remain unused.

You can use the following snippet in your batch file to create a hostlist file:

```Bash
export NODELISTFILE="/tmp/slurm.nodelist.$SLURM_JOB_ID"
for LINE in `scontrol show hostname $SLURM_JOB_NODELIST` ; do
  echo "host $LINE" >> $NODELISTFILE ;
done

# launch NAMD processes. Note that the environment variable $SLURM_NTASKS is only available if you have
# used the -n|--ntasks parameter. Otherwise, you have to specify the number of processes manually, e.g. +p64
charmrun +p$SLURM_NTASKS ++nodelist $NODELISTFILE $NAMD inputfile.namd

# clean up afterwards:
test -f $NODELISTFILE && rm -f $NODELISTFILE
```

The current version 2.7b1 of NAMD runs much faster than 2.6. - Especially on the SGI Altix. Since
the parallel performance strongly depends on the size of the given problem one cannot give a general
advice for the optimum number of CPUs to use. (Please check this by running NAMD with your molecules
and just a few time steps.)

Any published work which utilizes NAMD shall include the following reference:

*James C. Phillips, Rosemary Braun, Wei Wang, James Gumbart, Emad Tajkhorshid, Elizabeth Villa, Christophe
Chipot, Robert D.  Skeel, Laxmikant Kale, and Klaus Schulten. Scalable molecular dynamics with NAMD.
Journal of Computational Chemistry, 26:1781-1802, 2005.*

Electronic documents will include a direct link to the official NAMD page at
http://www.ks.uiuc.edu/Research/namd

## ORCA

ORCA is a flexible, efficient and easy-to-use general purpose tool for quantum chemistry with
specific emphasis on spectroscopic properties of open-shell molecules. It features a wide variety of
standard quantum chemical methods ranging from semiempirical methods to DFT to single- and
multireference correlated ab initio methods. It can also treat environmental and relativistic
effects.

To run Orca jobs in parallel, you have to specify the number of processes in your input file (here
for example 16 processes):

```Bash
%pal nprocs 16 end
```

Note that Orca does the MPI process spawning itself, so you may not use "srun" to launch it in your
batch file. Just set --ntasks to the same number as in your input file and call the "orca"
executable directly.  For parallel runs, it must be called with the full path:

```Bash
#!/bin/bash #SBATCH --ntasks=16 #SBATCH --nodes=1 #SBATCH --mem-per-cpu=2000M

$ORCA_ROOT/orca example.inp
```

## Siesta

Siesta (Spanish Initiative for Electronic Simulations with Thousands of Atoms) is both a method and
its computer program implementation, to perform electronic structure calculations and ab initio
molecular dynamics simulations of molecules and solids. <http://www.uam.es/siesta>

In any paper or other academic publication containing results wholly or partially derived from the
results of use of the SIESTA package, the following papers must be cited in the normal manner: 1
"Self-consistent order-N density-functional calculations for very large systems", P.  Ordejon, E.
Artacho and J. M. Soler, Phys. Rev. B (Rapid Comm.) 53, R10441-10443 (1996). 1 "The SIESTA method
for ab initio order-N materials simulation" J. M. Soler, E. Artacho, J. D. Gale, A. Garcia, J.
Junquera, P. Ordejon, and D. Sanchez-Portal, J. Phys.: Condens. Matt.  14, 2745-2779 (2002).

## VASP

"VAMP/VASP is a package for performing ab-initio quantum-mechanical molecular dynamics (MD) using
pseudopotentials and a plane wave basis set." [VASP](https://www.vasp.at). It is installed on mars.
If you are interested in using VASP on ZIH machines, please contact [Dr. Ulf
Markwardt](http://tu-dresden.de/die_tu_dresden/zentrale_einrichtungen/zih/wir_ueber_uns/mitarbeiter/markwardt).
