# Nanoscale Modeling Tools

## ABINIT

[ABINIT](http://www.abinit.org) is a package whose main program allows one to find the total energy,
charge density and electronic structure of systems made of electrons and nuclei (molecules and
periodic solids) within Density Functional Theory (DFT), using pseudopotentials and a planewave
basis. ABINIT also includes options to optimize the geometry according to the DFT forces and
stresses, or to perform molecular dynamics simulations using these forces, or to generate dynamical
matrices, Born effective charges, and dielectric tensors. Excited states can be computed within the
Time-Dependent Density Functional Theory (for molecules), or within Many-Body Perturbation Theory
(the GW approximation).

ABINIT is available as [modules](modules.md). Installed versions can be listed and loaded with the
following commands

```console
marie@login$ module avail ABINIT
---------------------------- /sw/modules/scs5/chem -----------------------------
   ABINIT/8.6.3-intel-2018a         Wannier90/2.0.1.1-foss-2018b-abinit
   ABINIT/8.10.3-intel-2018b        Wannier90/2.0.1.1-intel-2018b-abinit
   ABINIT/9.2.1-intel-2020a  (D)
[...]
marie@login$ module load ABINIT
Module ABINIT/9.2.1-intel-2020a and 16 dependencies loaded.
```

## CP2K

[CP2K](http://cp2k.berlios.de/) performs atomistic and molecular simulations of solid state, liquid,
molecular and biological systems. It provides a general framework for different methods such as e.g.
density functional theory (DFT) using a mixed Gaussian and plane waves approach (GPW), and classical
pair and many-body potentials.

CP2K is available as [modules](modules.md). Available packages can be listed and loaded with the
following commands:

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
particularly designed for ab-initio molecular dynamics. For examples and documentations, see
[CPMD homepage](https://www.lcrc.anl.gov/for-users/software/available-software/cpmd/).

CPMD is currently not installed as a module.
Please, contact [hpcsupport@zih.tu-dresden.de](mailto:hpcsupport@zih.tu-dresden.de) if you need assistance.

## GAMESS

GAMESS is an ab-initio quantum mechanics program, which provides many methods for computation of the
properties of molecular systems using standard quantum chemical methods. For a detailed description,
please look at the [GAMESS home page](https://www.msg.chem.iastate.edu/gamess/index.html).

GAMESS is available as [modules](modules.md) within the classic environment. Available packages can
be listed and loaded with the following commands:

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

For runs with [Slurm](../jobs_and_resources/slurm.md), please use a script like this:

```Bash
#!/bin/bash
#SBATCH -t 120
#SBATCH -n 8
#SBATCH --ntasks-per-node=2
## you have to make sure that an even number of tasks runs on each node !!
#SBATCH --mem-per-cpu=1900

module load modenv/classic
module load gamess
rungms.slurm cTT_M_025.inp /scratch/ws/0/marie-gamess
#                          the third parameter is the location of your scratch directory
```

*GAMESS should be cited as:* "General Atomic and Molecular Electronic Structure System",
M.W.Schmidt, K.K.Baldridge, J.A.Boatz, S.T.Elbert, M.S.Gordon, J.H.Jensen, S.Koseki, N.Matsunaga,
K.A.Nguyen, S.J.Su, T.L.Windus, M.Dupuis, J.A.Montgomery, J.Comput.Chem. 14, 1347-1363(1993).

## Gaussian

Starting from the basic laws of quantum mechanics, [Gaussian](http://www.gaussian.com) predicts the
energies, molecular structures, and vibrational frequencies of molecular systems, along with
numerous molecular properties derived from these basic computation types. It can be used to study
molecules and reactions under a wide range of conditions, including both stable species and
compounds which are difficult or impossible to observe experimentally such as short-lived
intermediates and transition structures.

Gaussian is currently not installed as a module. Please, contact
[hpcsupport@zih.tu-dresden.de](mailto:hpcsupport@zih.tu-dresden.de) if you need assistance.

## GROMACS

GROMACS is a versatile package to perform molecular dynamics, i.e. simulate the Newtonian equations
of motion for systems with hundreds to millions of particles. It is primarily designed for
biochemical molecules like proteins, lipids and nucleic acids that have a lot of complicated bonded
interactions, but since GROMACS is extremely fast at calculating the nonbonded interactions (that
usually dominate simulations), many groups are also using it for research on non-biological systems,
e.g., polymers. For documentations see [Gromacs homepage](https://www.gromacs.org/).

GROMACSS is available as [modules](modules.md). Available packages can be listed and loaded with the
following commands:

```console
marie@login$:~> module avail GROMACS
----------------------------- /sw/modules/scs5/bio -----------------------------
   GROMACS/2018.2-foss-2018a-CUDA-9.2.88    GROMACS/2019.4-fosscuda-2019a
   GROMACS/2018.2-intel-2018a               GROMACS/2020-fosscuda-2019b   (D)
[...]
marie@login$ module load GROMACS
Module GROMACS/2020-fosscuda-2019b and 17 dependencies loaded.
```

## LAMMPS

[LAMMPS](https://www.lammps.org) is a classical molecular dynamics code that models an ensemble of
particles in a liquid, solid, or gaseous state. It can model atomic, polymeric, biological,
metallic, granular, and coarse-grained systems using a variety of force fields and boundary
conditions. For examples of LAMMPS simulations, documentations, and more visit
[LAMMPS sites](https://www.lammps.org).

LAMMPS is available as [modules](modules.md). Available packages can be listed and loaded with the
following commands:

```console
marie@login$:~> module avail LAMMPS
---------------------------- /sw/modules/scs5/chem -----------------------------
   LAMMPS/3Mar2020-foss-2020a-Python-3.8.2-kokkos
   LAMMPS/3Mar2020-intel-2020a-Python-3.8.2-kokkos
   LAMMPS/7Aug19-foss-2019a-Python-2.7.15
   LAMMPS/12Dec2018-foss-2019a                     (D)
   LAMMPS/20180316-foss-2018a-Python-3.6.4
[...]
marie@login$ module load LAMMPS
[...]
Module LAMMPS/12Dec2018-foss-2019a and 33 dependencies loaded.
```

## NAMD

[NAMD](https://www.ks.uiuc.edu/Research/namd) is a parallel molecular dynamics code designed for
high-performance simulation of large biomolecular systems.

NAMD can be started as parallel program with `srun`. Since
the parallel performance strongly depends on the size of the given problem, one cannot give a general
advice for the optimum number of CPUs to use. (Please check this by running NAMD with your molecules
and just a few time steps.)

NAND is available as [modules](modules.md). Available packages can be listed and loaded with the
following commands:

```console
marie@login$:~> module avail NAMD
---------------------------- /sw/modules/scs5/chem -----------------------------
   NAMD/2.12-intel-2018a-mpi
[...]
marie@login$ module load NAMD
[...]
Module NAMD/2.12-intel-2018a-mpi and 12 dependencies loaded.
```

Any published work which utilizes NAMD shall include the following reference:

*James C. Phillips, Rosemary Braun, Wei Wang, James Gumbart, Emad Tajkhorshid, Elizabeth Villa, Christophe
Chipot, Robert D.  Skeel, Laxmikant Kale, and Klaus Schulten. Scalable molecular dynamics with NAMD.
Journal of Computational Chemistry, 26:1781-1802, 2005.*

Electronic documents will include a direct link to the [official NAMD page](https://www.ks.uiuc.edu/Research/namd)

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

Note, that Orca spawns MPI processes itself, so you must not use `srun` to launch it in your batch
file. Just set `--ntasks` to the same number as in your input file and call the `orca` executable
directly.  For parallel runs, it must be called with the full path:

```Bash
#!/bin/bash
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=2000M

$ORCA_ROOT/orca example.inp
```

ORCA is available as [modules](modules.md). Available packages can be listed and loaded with the
following commands:

```console
marie@login$:~> module avail ORCA
---------------------------- /sw/modules/scs5/chem -----------------------------
   ORCA/4.1.1-OpenMPI-2.1.5    ORCA/4.2.1-gompi-2019b (D)
[...]
marie@login$ module load ORCA
[...]
Module ORCA/4.2.1-gompi-2019b and 11 dependencies loaded.
```

## Siesta

[Siesta](https://siesta-project.org/siesta) (Spanish Initiative for Electronic Simulations with
Thousands of Atoms) is both a method and its computer program implementation,
to perform electronic structure calculations and ab initio
molecular dynamics simulations of molecules and solids.

Siesta is available as [modules](modules.md). Available packages can be listed and loaded with the
following commands:

```console
marie@login$:~> module avail Siesta
---------------------------- /sw/modules/scs5/phys -----------------------------
   Siesta/4.1-b3-intel-2018a    Siesta/4.1-b4-intel-2019b

---------------------------- /sw/modules/scs5/chem -----------------------------
   Siesta/4.1-MaX-1.0-intel-2019b (D)
[...]
marie@login$ module load Siesta
[...]
Module Siesta/4.1-MaX-1.0-intel-2019b and 26 dependencies loaded.
```

In any paper or other academic publication containing results wholly or partially derived from the
results of use of the SIESTA package, the following papers must be cited in the normal manner:

1. "Self-consistent order-N density-functional calculations for very large systems",
P.  Ordejon, E. Artacho and J. M. Soler, Phys. Rev. B (Rapid Comm.) 53, R10441-10443 (1996).
1. "The SIESTA method for ab initio order-N materials simulation", J. M. Soler, E. Artacho,
J. D. Gale, A. Garcia, J. Junquera, P. Ordejon, and D. Sanchez-Portal, J. Phys.: Condens. Matt. 14,
2745-2779 (2002).

## VASP

> VAMP/VASP is a package for performing ab-initio quantum-mechanical molecular dynamics (MD) using
> pseudopotentials and a plane wave basis set. (see [VASP](https://www.vasp.at)).

VASP is available as [modules](modules.md). Available packages can be listed and loaded with the
following commands:

```console
marie@login$:~> module avail VASP
---------------------------- /sw/modules/scs5/phys -----------------------------
   VASP/5.4.4-intel-2018a-optics    VASP/5.4.4-intel-2019b (L,D)
   VASP/5.4.4-intel-2018a
[...]
marie@login$ module load VASP
[...]
Module VASP/5.4.4-intel-2019b loaded.
```
