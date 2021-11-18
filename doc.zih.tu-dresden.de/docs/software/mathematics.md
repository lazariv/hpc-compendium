# Mathematics Applications

!!! cite "Galileo Galilei"

    Nature is written in mathematical language.

<!--*Please do not run expensive interactive sessions on the login nodes.  Instead, use* `srun --pty-->
<!--...` *to let the batch system place it on a compute node.*-->

## Mathematica

Mathematica is a general computing environment, organizing many algorithmic, visualization, and user
interface capabilities within a document-like user interface paradigm.

### Fonts

To remotely use the graphical front-end, you have to add the Mathematica fonts to the local
font manager.

#### Linux Workstation

You need to copy the fonts from ZIH systems to your local system and expand the font path

```console
marie@local$ scp -r taurus.hrsk.tu-dresden.de:/sw/global/applications/mathematica/10.0/SystemFiles/Fonts/Type1/ ~/.fonts
marie@local$ xset fp+ ~/.fonts/Type1
```

#### Windows Workstation

You have to add additional Mathematica fonts at your local PC
[download fonts archive](misc/Mathematica-Fonts.zip).

If you use **Xming** as X-server at your PC (refer to
[remote access from Windows](../access/ssh_login.md), follow these steps:

1. Create a new folder `Mathematica` in the directory `fonts` of the installation directory of Xming
   (mostly: `C:\\Programme\\Xming\\fonts\\`)
1. Extract the fonts archive into this new directory `Mathematica`.  In result you should have the
   two directories `DBF` and `Type1`.
1. Add the path to these font files into the file `font-dirs`.  You can find it in
   `C:\\Programme\\Xming\\`.

```shell-session
# font-dirs
# comma-separated list of directories to add to the default font path
# defaults are built-ins, misc, TTF, Type1, 75dpi, 100dpi
# also allows entries on individual lines
C:\Programme\Xming\fonts\dejavu,C:\Programme\Xming\fonts\cyrillic
C:\Programme\Xming\fonts\Mathematica\DBF
C:\Programme\Xming\fonts\Mathematica\Type1
C:\WINDOWS\Fonts
```

### Mathematica and Slurm

Please use the batch system Slurm for running calculations. This is a small example for a batch
script, that you should prepare and start with the command `sbatch <scriptname>`. The File
`mathtest.m` is your input script that includes the calculation statements for Mathematica. The file
`mathtest.output` will hold the results of your calculations.

```bash
#!/bin/bash
#SBATCH --output=mathtest.out
#SBATCH --error=mathtest.err
#SBATCH --time=00:05:00
#SBATCH --ntasks=1

module load Mathematica
math -run < mathtest.m > mathtest.output
```

(also [Link](https://rcc.uchicago.edu/docs/software/environments/mathematica/index.html)).

!!! note

    Mathematica licenses are limited.

There exist two types, MathKernel and SubMathKernel licenses. Every sequential job you start will
consume a MathKernel license of which we only have 39. We do have, however, 312 SubMathKernel
licenses, so please, don't start many sequential jobs but try to parallelize your calculation,
utilizing multiple SubMathKernel licenses per job, in order to achieve a more reasonable license
usage.

## MATLAB

[MATLAB](https://de.mathworks.com/products/matlab.html) is a numerical computing environment and
programming language. Created by The MathWorks, MATLAB allows easy matrix manipulation, plotting of
functions and data, implementation of algorithms, creation of user interfaces, and interfacing with
programs in other languages.  Although it specializes in numerical computing, an optional toolbox
interfaces with the Maple symbolic engine, allowing it to be part of a full computer algebra system.

Running MATLAB via the batch system could look like this (for 456 MB RAM per core and 12 cores
reserved). Please adapt this to your needs!

```console
marie@login$ module load MATLAB
marie@login$ srun --time=8:00 --cpus-per-task=12 --mem-per-cpu=456 --pty --x11=first bash
marie@compute$ matlab
```

With following command you can see a list of installed software - also
the different versions of matlab.

```console
marie@login$ module avail
```

Please choose one of these, then load the chosen software with the command:

```bash
marie@login$ module load MATLAB/<version>
```

Or use:

```console
marie@login$ module load MATLAB
```

(then you will get the most recent Matlab version.
[Refer to the modules section for details.](../software/modules.md#modules))

### Interactive

If X-server is running and you logged in at ZIH systems, you should allocate a CPU for your work
with command

```console
marie@login$ srun --pty --x11=first bash
```

- now you can call "matlab" (you have 8h time to work with the matlab-GUI)

### Non-interactive

Using Scripts

You have to start matlab-calculation as a Batch-Job via command

```console
marie@login$ srun --pty matlab -nodisplay -r basename_of_your_matlab_script
# NOTE: you must omit the file extension ".m" here, because -r expects a matlab command or function call, not a file-name.
```

!!! info "License occupying"

    While running your calculations as a script this way is possible, it is generally frowned upon,
    because you are occupying Matlab licenses for the entire duration of your calculation when doing so.
    Since the available licenses are limited, it is highly recommended you first compile your script via
    the Matlab Compiler (`mcc`) before running it for a longer period of time on our systems.  That way,
    you only need to check-out a license during compile time (which is relatively short) and can run as
    many instances of your calculation as you'd like, since it does not need a license during runtime
    when compiled to a binary.

You can find detailed documentation on the Matlab compiler at
[MathWorks' help pages](https://de.mathworks.com/help/compiler/).

### Using the MATLAB Compiler

Compile your `.m` script into a binary:

```bash
marie@login$ mcc -m name_of_your_matlab_script.m -o compiled_executable -R -nodisplay -R -nosplash
```

This will also generate a wrapper script called `run_compiled_executable.sh` which sets the required
library path environment variables in order to make this work. It expects the path to the MATLAB
installation as an argument, you can use the environment variable `$EBROOTMATLAB` as set by the
module file for that.

Then run the binary via the wrapper script in a job (just a simple example, you should be using an
[sbatch script](../jobs_and_resources/slurm.md#job-submission) for that)

```bash
marie@login$ srun ./run_compiled_executable.sh $EBROOTMATLAB
```

### Parallel MATLAB

#### With 'local' Configuration

- If you want to run your code in parallel, please request as many cores as you need!
- Start a batch job with the number `N` of processes, e.g., `srun --cpus-per-task=4 --pty
  --x11=first bash -l`
- Run Matlab with the GUI or the CLI or with a script
- Inside Matlab use `matlabpool open 4` to start parallel processing

!!! example "Example for 1000*1000 matrix-matrix multiplication"

    ```bash
    R = distributed.rand(1000);
    D = R * R
    ```

- Close parallel task using `matlabpool close`

#### With parfor

- Start a batch job with the number `N` of processes (,e.g., `N=12`)
- Inside use `matlabpool open N` or `matlabpool(N)` to start parallel processing. It will use
  the 'local' configuration by default.
- Use `parfor` for a parallel loop, where the **independent** loop iterations are processed by `N`
  threads

!!! example

    ```bash
    parfor i = 1:3
        c(:,i) = eig(rand(1000));
    end
    ```

Please refer to the documentation `help parfor` for further information.

## Octave

GNU [Octave](https://www.gnu.org/software/octave/index) is a high-level language, primarily intended
for numerical computations. It provides a convenient command line interface for solving linear and
nonlinear problems numerically, and for performing other numerical experiments using a language that
is mostly compatible with Matlab. It may also be used as a batch-oriented language.
