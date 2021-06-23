# FEM Software

For an up-to-date list of the installed software versions on our
cluster, please refer to SoftwareModulesList **TODO LINK** (SoftwareModulesList).

## Abaqus

[ABAQUS](http://www.hks.com) **TODO links to realestate site** is a general-purpose finite-element program
designed for advanced linear and nonlinear engineering analysis
applications with facilities for linking-in user developed material
models, elements, friction laws, etc.

Eike Dohmen (from Inst.f. Leichtbau und Kunststofftechnik) sent us the
attached description of his ABAQUS calculations. Please try to adapt
your calculations in that way.\<br />Eike is normally a Windows-User and
his description contains also some hints for basic Unix commands. (
ABAQUS-SLURM.pdf **TODO LINK** (%ATTACHURL%/ABAQUS-SLURM.pdf) - only in German)

Please note: Abaqus calculations should be started with a batch script.
Please read the information about the Batch System **TODO LINK **  (BatchSystems)
SLURM.

The detailed Abaqus documentation can be found at
abaqus **TODO LINK MISSING** (only accessible from within the
TU Dresden campus net).

**Example - Thanks to Benjamin Groeger, Inst. f. Leichtbau und
Kunststofftechnik) **

1. Prepare an Abaqus input-file (here the input example from Benjamin)

Rot-modell-BenjaminGroeger.inp **TODO LINK**  (%ATTACHURL%/Rot-modell-BenjaminGroeger.inp)

2. Prepare a batch script on taurus like this

```
#!/bin/bash<br>
### Thanks to Benjamin Groeger, Institut fuer Leichtbau und Kunststofftechnik, 38748<br />### runs on taurus and needs ca 20sec with 4cpu<br />### generates files:
###  yyyy.com
###  yyyy.dat
###  yyyy.msg
###  yyyy.odb
###  yyyy.prt
###  yyyy.sim
###  yyyy.sta
#SBATCH --nodes=1  ### with &gt;1 node abaqus needs a nodeliste
#SBATCH --ntasks-per-node=4
#SBATCH --mem=500  ### memory (sum)
#SBATCH --time=00:04:00
### give a name, what ever you want
#SBATCH --job-name=yyyy
### you get emails when the job will finished or failed
### set your right email
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=xxxxx.yyyyyy@mailbox.tu-dresden.de
### set your project
#SBATCH -A p_xxxxxxx
### Abaqus have its own MPI
unset SLURM_GTIDS
### load and start
module load ABAQUS/2019
abaqus interactive input=Rot-modell-BenjaminGroeger.inp job=yyyy cpus=4 mp_mode=mpi

```

3. Start the batch script (name of our script is
"batch-Rot-modell-BenjaminGroeger")

```
sbatch batch-Rot-modell-BenjaminGroeger      --->; you will get a jobnumber = JobID (for example 3130522)
```

4. Control the status of the job

```
squeue -u your_login     -->; in column "ST" (Status) you will find a R=Running or P=Pending (waiting for resources)
```

## ANSYS

ANSYS is a general-purpose finite-element program for engineering
analysis, and includes preprocessing, solution, and post-processing
functions. It is used in a wide range of disciplines for solutions to
mechanical, thermal, and electronic problems. [ANSYS and ANSYS
CFX](http://www.ansys.com) used to be separate packages in the past and
are now combined.

ANSYS, like all other installed software, is organized in so-called
modules **TODO LINK** (RuntimeEnvironment). To list the available versions and load a
particular ANSYS version, type

```
module avail ANSYS
...
module load ANSYS/VERSION
```

In general, HPC-systems are not designed for interactive "GUI-working".
Even so, it is possible to start a ANSYS workbench on Taurus (login
nodes) interactively for short tasks. The second and recommended way is
to use batch files. Both modes are documented in the following.

### Using Workbench Interactively

For fast things, ANSYS workbench can be invoked interactively on the
login nodes of Taurus. X11 forwarding needs to enabled when establishing
the SSH connection. For OpenSSH this option is '-X' and it is valuable
to use compression of all data via '-C'.

```
# Connect to taurus, e.g. ssh -CX
module load ANSYS/VERSION
runwb2
```

If more time is needed, a CPU has to be allocated like this (see topic
batch systems **TODO LINK** (BatchSystems) for further information):

```
module load ANSYS/VERSION  
srun -t 00:30:00 --x11=first [SLURM_OPTIONS] --pty bash
runwb2
```

**Note:** The software NICE Desktop Cloud Visualization (DCV) enables to
remotly access OpenGL-3D-applications running on taurus using its GPUs
(cf. virtual desktops **TODO LINK** (Compendium.VirtualDesktops)). Using ANSYS
together with dcv works as follows:

-   Follow the instructions within virtual
    desktops **TODO LINK** (Compendium.VirtualDesktops)

```
module load ANSYS
```

```
unset SLURM_GTIDS
```

-   Note the hints w.r.t. GPU support on dcv side

```
runwb2
```

### Using Workbench in Batch Mode

The ANSYS workbench (runwb2) can also be used in a batch script to start
calculations (the solver, not GUI) from a workbench project into the
background. To do so, you have to specify the -B parameter (for batch
mode), -F for your project file, and can then either add differerent
commands via -E parameters directly, or specify a workbench script file
containing commands via -R.

**NOTE:** Since the MPI library that ANSYS uses internally (Platform
MPI) has some problems integrating seamlessly with SLURM, you have to
unset the enviroment variable SLURM_GTIDS in your job environment before
running workbench. An example batch script could look like this:

    #!/bin/bash
    #SBATCH --time=0:30:00
    #SBATCH --nodes=1
    #SBATCH --ntasks=2
    #SBATCH --mem-per-cpu=1000M


    unset SLURM_GTIDS         # Odd, but necessary!

    module load ANSYS/VERSION

    runwb2 -B -F Workbench_Taurus.wbpj -E 'Project.Update' -E 'Save(Overwrite=True)'
    #or, if you wish to use a workbench replay file, replace the -E parameters with: -R mysteps.wbjn

### Running Workbench in Parallel

Unfortunately, the number of CPU cores you wish to use cannot simply be
given as a command line parameter to your runwb2 call. Instead, you have
to enter it into an XML file in your home. This setting will then be
used for all your runwb2 jobs. While it is also possible to edit this
setting via the Mechanical GUI, experience shows that this can be
problematic via X-Forwarding and we only managed to use the GUI properly
via DCV **TODO LINK** (DesktopCloudVisualization), so we recommend you simply edit
the XML file directly with a text editor of your choice. It is located
under:

'$HOME/.mw/Application Data/Ansys/v181/SolveHandlers.xml'

(mind the space in there.) You might have to adjust the ANSYS Version
(v181) in the path. In this file, you can find the parameter

    <MaxNumberProcessors>2</MaxNumberProcessors>

that you can simply change to something like 16 oder 24. For now, you
should stay within single-node boundaries, because multi-node
calculations require additional parameters. The number you choose should
match your used --cpus-per-task parameter in your sbatch script.

## COMSOL Multiphysics

"[COMSOL Multiphysics](http://www.comsol.com) (formerly FEMLAB) is a
finite element analysis, solver and Simulation software package for
various physics and engineering applications, especially coupled
phenomena, or multiphysics."
[\[http://en.wikipedia.org/wiki/COMSOL_Multiphysics Wikipedia\]](http://en.wikipedia.org/wiki/COMSOL_Multiphysics Wikipedia)

Comsol may be used remotely on ZIH machines or locally on the desktop,
using ZIH license server.

For using Comsol on ZIH machines, the following operating modes (see
Comsol manual) are recommended:

-   Interactive Client Server Mode

In this mode Comsol runs as server process on the ZIH machine and as
client process on your local workstation. The client process needs a
dummy license for installation, but no license for normal work. Using
this mode is almost undistinguishable from working with a local
installation. It works well with Windows clients. For this operation
mode to work, you must build an SSH tunnel through the firewall of ZIH.
For further information, see the Comsol manual.

Example for starting the server process (4 cores, 10 GB RAM, max. 8
hours running time):

    module load COMSOL
    srun -c4 -t 8:00 --mem-per-cpu=2500 comsol -np 4 server

-   Interactive Job via Batchsystem SLURM

<!-- -->

    module load COMSOL
    srun -n1 -c4 --mem-per-cpu=2500 -t 8:00 --pty --x11=first comsol -np 4

Man sollte noch schauen, ob das Rendering unter Options -> Preferences
-> Graphics and Plot Windows auf Software-Rendering steht - und dann
sollte man campusintern arbeiten knnen.

-   Background Job via Batchsystem SLURM

<!-- -->

    #!/bin/bash
    #SBATCH --time=24:00:00
    #SBATCH --nodes=2
    #SBATCH --ntasks-per-node=2
    #SBATCH --cpus-per-task=12
    #SBATCH --mem-per-cpu=2500

    module load COMSOL
    srun comsol -mpi=intel batch -inputfile ./MyInputFile.mph

Submit via: `sbatch <filename>`

## LS-DYNA

Both, the shared memory version and the distributed memory version (mpp)
are installed on all machines.

To run the MPI version on Taurus or Venus you need a batchfile (sumbmit
with `sbatch <filename>`) like:

    #!/bin/bash
    #SBATCH --time=01:00:00   # walltime
    #SBATCH --ntasks=16   # number of processor cores (i.e. tasks)
    #SBATCH --mem-per-cpu=1900M   # memory per CPU core
    
    module load ls-dyna
    srun mpp-dyna i=neon_refined01_30ms.k memory=120000000
