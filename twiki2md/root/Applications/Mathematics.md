# Mathematics Applications

 The following applications are
installed at ZIH:

|                 |           |            |            |             |
|-----------------|-----------|------------|------------|-------------|
|                 | **Venus** | **Triton** | **Taurus** | **module**  |
| **Mathematica** |           |            | x          | Mathematica |
| **Matlab**      |           | x          | x          | MATLAB      |
| **Octave**      |           |            |            |             |
| **R**           |           | x          | x          | r           |

*Please do not run expensive interactive sessions on the login nodes.
Instead, use* `srun --pty ...` *to let the batch system place it on a
compute node.*

## Mathematica

Mathematica is a general computing environment, organizing many
algorithmic, visualization, and user interface capabilities within a
document-like user interface paradigm.

To remotely use the graphical frontend one has to add the Mathematica
fonts to the local fontmanager.

For a Linux workstation:

    scp -r taurus.hrsk.tu-dresden.de:/sw/global/applications/mathematica/10.0/SystemFiles/Fonts/Type1/ ~/.fonts
    xset fp+ ~/.fonts/Type1

For a Windows workstation:  
You have to add additional mathematica fonts at your local PC. At the
end of this webpage you can find an archive with these fonts (.zip)  
  
If you use **Xming** as X-server at your PC (see also our Information
about Remote access from Windos to Linux):  
1 Create a new folder "Mathematica" in the diretory "fonts" of the
installation directory of Xming. (mostly: C:\\Programme\\Xming\\fonts\\)
1 Extract the fonts archive into this new directory "Mathematica".  
In result you should have 2 directories "DBF" and "Type1".  
1 Add the path to these font files into the file "font-dirs".  
You can find it in C:\\Programme\\Xming\\.  

          # font-dirs
          # comma-separated list of directories to add to the default font path
          # defaults are built-ins, misc, TTF, Type1, 75dpi, 100dpi
          # also allows entries on individual lines
          C:\Programme\Xming\fonts\dejavu,C:\Programme\Xming\fonts\cyrillic
          C:\Programme\Xming\fonts\Mathematica\DBF
          C:\Programme\Xming\fonts\Mathematica\Type1
          C:\WINDOWS\Fonts

  

**Mathematica and SLURM:** \<br />Please use the Batchsystem SLURM for
running calculations. This is a small example for a batch script, that
you should prepair and start with command \<br />sbatch
\<scriptname>\<br />File "mathtest.m" is your input script, that
includes the calculation statements for mathematica. File
"mathtest.output" will collect the results of your calculation.

    #!/bin/bash  <br />#SBATCH --output=mathtest.out <br />#SBATCH --error=mathtest.err <br />#SBATCH --time=00:05:00 <br />#SBATCH --ntasks=1 <br /><br />module load Mathematica <br />math -run &lt; mathtest.m &gt; mathtest.output

(also
<https://rcc.uchicago.edu/docs/software/environments/mathematica/index.html>)

**%RED%NOTE:%ENDCOLOR%** Mathematica licenses are limited. There exist
two types, MathKernel and SubMathKernel licenses. Every sequential job
you start will consume a MathKernel license of which we only have 39. We
do have, however, 312 SubMathKernel licenses, so please, don't start
many sequential jobs but try to parallelize your calculation, utilizing
multiple Sub MathKernel licenses per job, in order to achieve a more
reasonable license usage.

  

## Matlab

MATLAB is a numerical computing environment and programming language.
Created by The MathWorks, MATLAB allows easy matrix manipulation,
plotting of functions and data, implementation of algorithms, creation
of user interfaces, and interfacing with programs in other languages.
Although it specializes in numerical computing, an optional toolbox
interfaces with the Maple symbolic engine, allowing it to be part of a
full computer algebra system.

Running MATLAB via the batch system could look like this (for 456 MB RAM
per core and 12 cores reserved). Please adapt this to your needs!

-   SLURM (taurus, venus):

<!-- -->

       module load MATLAB<br />   srun -t 8:00 -c 12 --mem-per-cpu=456 --pty --x11=first bash<br />   matlab

With following command you can see a list of installed software - also
the different versions of matlab.

       module avail

Please choose one of these, then load the chosen software with the
command:

       module load MATLAB/version

Or use:

       module load MATLAB

(then you will get the most recent Matlab version. [Refer to the modules
section for details.](RuntimeEnvironment#Modules))

### matlab interactive

\* if X-server is running and you logged in at the HPC systems, you
should allocate a CPU for your work with command \<pre> srun --pty
--x11=first bash \</pre>

-   now you can call "matlab" (you have 8h time to work with the
    matlab-GUI)

### matlab with script

-   you have to start matlab-calculation as a Batch-Job via command

<!-- -->

         srun --pty matlab -nodisplay -r basename_of_your_matlab_script #NOTE: you must omit the file extension ".m" here, because -r expects a matlab command or function call, not a file-name.

**%RED%NOTE:%ENDCOLOR%** while running your calculations as a script
this way is possible, it is generally frowned upon, because you are
occupying Matlab licenses for the entire duration of your calculation
when doing so. Since the available licenses are limited, it is highly
recommended you first compile your script via the Matlab Compiler (mcc)
before running it for a longer period of time on our systems. That way,
you only need to check-out a license during compile time (which is
relatively short) and can run as many instances of your calculation as
you'd like, since it does not need a license during runtime when
compiled to a binary.

You can find detailled documentation on the Matlab compiler at
Mathworks: <https://de.mathworks.com/help/compiler/>

### using the matlab compiler (mcc)

-   compile your .m script to a binary: \<pre>mcc -m
    name_of_your_matlab_script.m -o compiled_executable -R -nodisplay -R
    -nosplash\</pre>

This will also generate a wrapper script called
run_compiled_executable.sh which sets the required library path
environment variables in order to make this work. It expects the path to
the Matlab installation as an argument, you can use the environment
variable $EBROOTMATLAB as set by the module file for that.

-   then run the binary via the wrapper script in a job (just a simple
    example, you should be using an [sbatch
    script](Compendium.Slurm#Job_Submission) for that): \<pre>srun
    ./run_compiled_executable.sh $EBROOTMATLAB\</pre>

### matlab parallel (with 'local' configuration)

-   If you want to run your code in parallel, please request as many
    cores as you need!
-   start a batch job with the number N of processes
-   example for N= 4: \<pre> srun -c 4 --pty --x11=first bash\</pre>
-   run Matlab with the GUI or the CLI or with a script
-   inside use \<pre>matlabpool open 4\</pre> to start parallel
    processing

<!-- -->

-   example for 1000\*1000 matrixmutliplication

<!-- -->

         R = distributed.rand(1000);
         D = R * R

-   to close parallel task:

<!-- -->

         matlabpool close

### matlab parallel (with parfor)

-   start a batch job with the number N of processes (e.g. N=12)
-   inside use \<pre>matlabpool open N\</pre> or
    \<pre>matlabpool(N)\</pre> to start parallel processing. It will use
    the 'local' configuration by default.
-   Use 'parfor' for a parallel loop, where the **independent** loop
    iterations are processed by N threads
-   Example:

<!-- -->

            parfor i = 1:3
                c(:,i) = eig(rand(1000));
            end

-   see also \<pre>help parfor\</pre>

## Octave

GNU Octave is a high-level language, primarily intended for numerical
computations. It provides a convenient command line interface for
solving linear and nonlinear problems numerically, and for performing
other numerical experiments using a language that is mostly compatible
with Matlab. It may also be used as a batch-oriented language.

-   [Mathematica-Fonts.zip](%ATTACHURL%/Mathematica-Fonts.zip):
    Mathematica-Fonts
