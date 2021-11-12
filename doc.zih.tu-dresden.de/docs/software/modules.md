# Modules

Usage of software on HPC systems is managed by a **modules system**.

!!! note "Module"

    A module is a user interface that provides utilities for the dynamic modification of a user's
    environment, e.g. prepending paths to:

    * `PATH`
    * `LD_LIBRARY_PATH`
    * `MANPATH`
    * and more

    to help you to access compilers, loader, libraries and utilities.

    By using modules, you can smoothly switch between different versions of
    installed software packages and libraries.

## Module Commands

Using modules is quite straightforward and the following table lists the basic commands.

| Command                       | Description                                                      |
|:------------------------------|:-----------------------------------------------------------------|
| `module help`                 | Show all module options                                          |
| `module list`                 | List active modules in the user environment                      |
| `module purge`                | Remove modules from the user environment                         |
| `module avail [modname]`      | List all available modules                                       |
| `module spider [modname]`     | Search for modules across all environments                       |
| `module load <modname>`       | Load module `modname` in the user environment                    |
| `module unload <modname>`     | Remove module `modname` from the user environment                |
| `module switch <mod1> <mod2>` | Replace module `mod1` with module `mod2`                         |

Module files are ordered by their topic on ZIH systems. By default, with `module avail` you will
see all topics and their available module files. If you just wish to see the installed versions of a
certain module, you can use `module avail softwarename` and it will display the available versions of
`softwarename` only.

### Examples

???+ example "Finding available software"

    This examples illustrates the usage of the command `module avail` to search for available Matlab
    installations.

    ```console
    marie@compute$ module avail matlab

    ------------------------------ /sw/modules/scs5/math ------------------------------
       MATLAB/2017a    MATLAB/2018b    MATLAB/2020a
       MATLAB/2018a    MATLAB/2019b    MATLAB/2021a (D)

      Wo:
       D:  Standard Modul.

    Verwenden Sie "module spider" um alle verfügbaren Module anzuzeigen.
    Verwenden Sie "module keyword key1 key2 ...", um alle verfügbaren Module
    anzuzeigen, die mindestens eines der Schlüsselworte enthält.
    ```

???+ example "Loading and removing modules"

    A particular module or several modules are loaded into your environment using the `module load`
    command. The counter part to remove a module or several modules is `module unload`.

    ```console
    marie@compute$ module load Python/3.8.6
    Module Python/3.8.6-GCCcore-10.2.0 and 11 dependencies loaded.
    ```

???+ example "Removing all modules"

    To remove all loaded modules from your environment with one keystroke, invoke

    ```console
    marie@compute$ module purge
    Die folgenden Module wurden nicht entladen:
      (Benutzen Sie "module --force purge" um alle Module zu entladen):

      1) modenv/scs5
    Module Python/3.8.6-GCCcore-10.2.0 and 11 dependencies unloaded.
    ```

### Front-End ml

There is a front end for the module command, which helps you to type less. It is `ml`.
 Any module command can be given after `ml`:

| ml Command        | module Command                            |
|:------------------|:------------------------------------------|
| `ml`              | `module list`                             |
| `ml foo bar`      | `module load foo bar`                     |
| `ml -foo -bar baz`| `module unload foo bar; module load baz`  |
| `ml purge`        | `module purge`                            |
| `ml show foo`     | `module show foo`                         |

???+ example "Usage of front-end ml"

    ```console
    marie@compute$ ml +Python/3.8.6
    Module Python/3.8.6-GCCcore-10.2.0 and 11 dependencies loaded.
    marie@compute$ ml

    Derzeit geladene Module:
      1) modenv/scs5                  (S)   5) bzip2/1.0.8-GCCcore-10.2.0       9) SQLite/3.33.0-GCCcore-10.2.0  13) Python/3.8.6-GCCcore-10.2.0
      2) GCCcore/10.2.0                     6) ncurses/6.2-GCCcore-10.2.0      10) XZ/5.2.5-GCCcore-10.2.0
      3) zlib/1.2.11-GCCcore-10.2.0         7) libreadline/8.0-GCCcore-10.2.0  11) GMP/6.2.0-GCCcore-10.2.0
      4) binutils/2.35-GCCcore-10.2.0       8) Tcl/8.6.10-GCCcore-10.2.0       12) libffi/3.3-GCCcore-10.2.0

      Wo:
       S:  Das Modul ist angeheftet. Verwenden Sie "--force", um das Modul zu entladen.

    marie@compute$ ml -Python/3.8.6 +ANSYS/2020R2
    Module Python/3.8.6-GCCcore-10.2.0 and 11 dependencies unloaded.
    Module ANSYS/2020R2 loaded.
    ```

## Module Environments

On ZIH systems, there exist different **module environments**, each containing a set of software modules.
They are activated via the meta module `modenv` which has different versions, one of which is loaded
by default. You can switch between them by simply loading the desired modenv-version, e.g.

```console
marie@compute$ module load modenv/ml
```

### modenv/scs5 (default)

* SCS5 software
* usually optimized for Intel processors (Partitions: `haswell`, `broadwell`, `gpu2`, `julia`)

### modenv/ml

* data analytics software (for use on the partition ml)
* necessary to run most software on the partition ml
(The instruction set [Power ISA](https://en.wikipedia.org/wiki/Power_ISA#Power_ISA_v.3.0)
is different from the usual x86 instruction set.
Thus the 'machine code' of other modenvs breaks).

### modenv/hiera

* uses a hierarchical module load scheme
* optimized software for AMD processors (Partitions: romeo, alpha)

### modenv/classic

* deprecated, old software. Is not being curated.
* may break due to library inconsistencies with the operating system.
* please don't use software from that modenv

### Searching for Software

The command `module spider <modname>` allows searching for a specific software across all modenv
environments. It will also display information on how to load a particular module when giving a precise
module (with version) as the parameter.

??? example

    ```console
    marie@login$ module spider p7zip

    ----------------------------------------------------------------------------------------------------------------------------------------------------------
      p7zip:
    ----------------------------------------------------------------------------------------------------------------------------------------------------------
        Beschreibung:
          p7zip is a quick port of 7z.exe and 7za.exe (command line version of 7zip) for Unix. 7-Zip is a file archiver with highest compression ratio.

         Versionen:
            p7zip/9.38.1
            p7zip/17.03-GCCcore-10.2.0
            p7zip/17.03

    ----------------------------------------------------------------------------------------------------------------------------------------------------------
      Um detaillierte Informationen über ein bestimmtes "p7zip"-Modul zu erhalten (auch wie das Modul zu laden ist), verwenden sie den vollständigen Namen des Moduls.
      Zum Beispiel:
        $ module spider p7zip/17.03
    ----------------------------------------------------------------------------------------------------------------------------------------------------------
    ```

## Per-Architecture Builds

Since we have a heterogeneous cluster, we do individual builds of some of the software for each
architecture present. This ensures that, no matter what partition the software runs on, a build
optimized for the host architecture is used automatically.
For that purpose we have created symbolic links on the compute nodes,
at the system path `/sw/installed`.

However, not every module will be available for each node type or partition. Especially when
introducing new hardware to the cluster, we do not want to rebuild all of the older module versions
and in some cases cannot fall-back to a more generic build either. That's why we provide the script:
`ml_arch_avail` that displays the availability of modules for the different node architectures.

### Example Invocation of ml_arch_avail

```console
marie@compute$ ml_arch_avail TensorFlow/2.4.1
TensorFlow/2.4.1: haswell, rome
TensorFlow/2.4.1: haswell, rome
```

The command shows all modules that match on `TensorFlow/2.4.1`, and their respective availability.
Note that this will not work for meta-modules that do not have an installation directory
(like some tool chain modules).

## Advanced Usage

### Writing own Modules

For writing your own Modulefiles please have a look at the [Guide for writing project and private Modulefiles](private_modules.md).

### How does `module` work?

In the Linux-shell, there is a variable called `PATH`. It contains several paths, like
`PATH=/usr/bin/:/bin/`. This is used to find programs. If you enter `ls`, it will first
look if the file `/usr/bin/ls` is there, and then, if it is not, look at `/bin/ls`. The
first file it finds will be executed.

There are several different variables that do the same thing for different software.
For example, in python, the shell variable `PYTHONPATH`. When python `import`s a module,
it looks in the `PYTHONPATH` the same way as the shell looks in `PATH`.

`module load TensorFlow` is a shell function that runs:

```
module () {
	eval `$LMOD_CMD sh "$@"`
}
```

Let's dissect this from inside out. It's a shell function that runs `$LMOD_CMD sh "$@"`.
`LMOD_CMD` is a variable that contains the path of the LMOD-Script, i.e. `/usr/share/lmod/lmod/libexec/lmod`.
So it runs `/usr/share/lmod/lmod/libexec/lmod sh "load Tensorflow"`. This, when executed without the eval,
gives us the following stdout:

```
MODULEPATH=/sw/modules/scs5/classic:/sw/modules/scs5/vis:/sw/modules/scs5/tools:/sw/modules/scs5/toolchain:/sw/modules/scs5/system:/sw/modules/scs5/phys:/sw/modules/scs5/perf:/sw/modules/scs5/numlib:/sw/modules/scs5/mpi:/sw/modules/scs5/math:/sw/modules/scs5/lib:/sw/modules/scs5/lang:/sw/modules/scs5/geo:/sw/modules/scs5/devel:/sw/modules/scs5/debugger:/sw/modules/scs5/data:/sw/modules/scs5/compiler:/sw/modules/scs5/chem:/sw/modules/scs5/cae:/sw/modules/scs5/bio:/sw/modules/scs5/base:/sw/modules/taurus/environment;
export MODULEPATH;
_ModuleTable001_=X01vZHVsZVRhYmxlXz17WyJNVHZlcnNpb24iXT0zLFsiY19yZWJ1aWxkVGltZSJdPTg2NDAwMDAsWyJjX3Nob3J0VGltZSJdPWZhbHNlLGRlcHRoVD17fSxmYW1pbHk9e30sbVQ9e21vZGVudj17WyJmbiJdPSIvc3cvbW9kdWxlcy90YXVydXMvZW52aXJvbm1lbnQvbW9kZW52L3NjczUubHVhIixbImZ1bGxOYW1lIl09Im1vZGVudi9zY3M1IixbImxvYWRPcmRlciJdPTEscHJvcFQ9e2xtb2Q9e1sic3RpY2t5Il09MSx9LH0sWyJzdGFja0RlcHRoIl09MCxbInN0YXR1cyJdPSJhY3RpdmUiLFsidXNlck5hbWUiXT0ibW9kZW52L3NjczUiLH0sfSxtcGF0aEE9eyIvc3cvbW9kdWxlcy9zY3M1L2NsYXNzaWMiLCIvc3cvbW9kdWxlcy9zY3M1L3ZpcyIsIi9zdy9tb2R1bGVzL3NjczUv;
export _ModuleTable001_;
_ModuleTable002_=dG9vbHMiLCIvc3cvbW9kdWxlcy9zY3M1L3Rvb2xjaGFpbiIsIi9zdy9tb2R1bGVzL3NjczUvc3lzdGVtIiwiL3N3L21vZHVsZXMvc2NzNS9waHlzIiwiL3N3L21vZHVsZXMvc2NzNS9wZXJmIiwiL3N3L21vZHVsZXMvc2NzNS9udW1saWIiLCIvc3cvbW9kdWxlcy9zY3M1L21waSIsIi9zdy9tb2R1bGVzL3NjczUvbWF0aCIsIi9zdy9tb2R1bGVzL3NjczUvbGliIiwiL3N3L21vZHVsZXMvc2NzNS9sYW5nIiwiL3N3L21vZHVsZXMvc2NzNS9nZW8iLCIvc3cvbW9kdWxlcy9zY3M1L2RldmVsIiwiL3N3L21vZHVsZXMvc2NzNS9kZWJ1Z2dlciIsIi9zdy9tb2R1bGVzL3NjczUvZGF0YSIsIi9zdy9tb2R1bGVzL3NjczUvY29tcGlsZXIiLCIvc3cvbW9kdWxlcy9zY3M1L2NoZW0iLCIv;
export _ModuleTable002_;
_ModuleTable003_=c3cvbW9kdWxlcy9zY3M1L2NhZSIsIi9zdy9tb2R1bGVzL3NjczUvYmlvIiwiL3N3L21vZHVsZXMvc2NzNS9iYXNlIiwiL3N3L21vZHVsZXMvdGF1cnVzL2Vudmlyb25tZW50Iix9LFsic3lzdGVtQmFzZU1QQVRIIl09Ii9zdy9tb2R1bGVzL3RhdXJ1cy9lbnZpcm9ubWVudCIsfQ==;
export _ModuleTable003_;
_ModuleTable_Sz_=3;
export _ModuleTable_Sz_;
```

These are declarations for shell-variables. Some of them in plain text (like `MODULEPATH`, and some in base64, like `_ModuleTable001_`.

The variable `_ModuleTable_Sz_` contains the index of the highest `_ModuleTable00x`-variable, so that lmod knows how many of them it should
look at to figure out the current lmod status.

When we concatenate all the base64-strings and decode them to ASCII, we get:

```
_ModuleTable_={["MTversion"]=3,["c_rebuildTime"]=8640000,["c_shortTime"]=false,depthT={},family={},mT={modenv={["fn"]="/sw/modules/taurus/environment/modenv/scs5.lua",["fullName"]="modenv/scs5",["loadOrder"]=1,propT={lmod={["sticky"]=1,},},["stackDepth"]=0,["status"]="active",["userName"]="modenv/scs5",},},mpathA={"/sw/modules/scs5/classic","/sw/modules/scs5/vis","/sw/modules/scs5/tools","/sw/modules/scs5/toolchain","/sw/modules/scs5/system","/sw/modules/scs5/phys","/sw/modules/scs5/perf","/sw/modules/scs5/numlib","/sw/modules/scs5/mpi","/sw/modules/scs5/math","/sw/modules/scs5/lib","/sw/modules/scs5/lang","/sw/modules/scs5/geo","/sw/modules/scs5/devel","/sw/modules/scs5/debugger","/sw/modules/scs5/data","/sw/modules/scs5/compiler","/sw/modules/scs5/chem","/sw/modules/scs5/cae","/sw/modules/scs5/bio","/sw/modules/scs5/base","/sw/modules/taurus/environment",},["systemBaseMPATH"]="/sw/modules/taurus/environment",}
```

Which is basically this, but more condensed:

```
"_ModuleTable_="{
   [
      "MTversion"
   ]=3,
   [
      "c_rebuildTime"
   ]=8640000,
   [
      "c_shortTime"
   ]"=false",
   "depthT="{

   },
   "family="{

   },
   "mT="{
      "modenv="{
         [
            "fn"
         ]"=""/sw/modules/taurus/environment/modenv/scs5.lua",
         [
            "fullName"
         ]"=""modenv/scs5",
         [
            "loadOrder"
         ]=1,
         "propT="{
            "lmod="{
               [
                  "sticky"
               ]=1
            }
         },
         [
            "stackDepth"
         ]=0,
         [
            "status"
         ]"=""active",
         [
            "userName"
         ]"=""modenv/scs5"
      }
   },
   "mpathA="{
      "/sw/modules/scs5/classic",
      "/sw/modules/scs5/vis",
      "/sw/modules/scs5/tools",
      "/sw/modules/scs5/toolchain",
      "/sw/modules/scs5/system",
      "/sw/modules/scs5/phys",
      "/sw/modules/scs5/perf",
      "/sw/modules/scs5/numlib",
      "/sw/modules/scs5/mpi",
      "/sw/modules/scs5/math",
      "/sw/modules/scs5/lib",
      "/sw/modules/scs5/lang",
      "/sw/modules/scs5/geo",
      "/sw/modules/scs5/devel",
      "/sw/modules/scs5/debugger",
      "/sw/modules/scs5/data",
      "/sw/modules/scs5/compiler",
      "/sw/modules/scs5/chem",
      "/sw/modules/scs5/cae",
      "/sw/modules/scs5/bio",
      "/sw/modules/scs5/base",
      "/sw/modules/taurus/environment"
   },
   [
      "systemBaseMPATH"
   ]"=""/sw/modules/taurus/environment"
}
```

This contains information about all the currently loaded modules, so that lmod can, when we load or unload a module,
do it properly, inlcuding all dependencies and so on. When neccessary, lmod also sets other variables, like `PYTHONPATH`,
so that programs know where to look for files.

Because programs can only alter the shell-variables for themselves and their children, but not their parents, a trick is
used. The long string that lmod outputs to stdout is caught with \`\` in the shell to an anonymous variable that is then `eval`ed.

This way, these variables get into the main shell process and may be used by programs following the `module load`.

### Using `module` information in Scripts

`module` and `ml` offer the `-t` switch for several commands, e.g. `ml -t list`. This way, the
output of them is nicer to parse for scripts.

For example, `ml -t spider TensorFlow` lists all the TensorFlow versions that are available under
the current environment:

```
TensorFlow/1.8.0-foss-2018a-Python-3.6.4-CUDA-9.2.88
TensorFlow/1.10.0-fosscuda-2018b-Python-3.6.6
TensorFlow/1.14.0-PythonAnaconda-3.6
TensorFlow/1.15.0-fosscuda-2019b-Python-3.7.4
TensorFlow/2.0.0-foss-2019a-Python-3.7.2
TensorFlow/2.0.0-fosscuda-2019b-Python-3.7.4
TensorFlow/2.0.0-PythonAnaconda-3.7
TensorFlow/2.1.0-fosscuda-2019b-Python-3.7.4
TensorFlow/2.2.0-fosscuda-2019b-Python-3.7.4
TensorFlow/2.3.1-fosscuda-2019b-Python-3.7.4
TensorFlow/2.4.1-foss-2020b
TensorFlow/2.4.1
```

This can be used for several purposes, e.g. shell-completion for ZSH. This small example, when put
into `~/.zshrc`, will offer auto-completion for the command `ml`.

```
function _ml {
    ML_COMMANDS=(
        '-t:Show computer parsable output'
        'unload:Unload a Module'
        'spider:Search for a module'
        'avail:Show available modules'
        'list:List loaded modules'
    )
    ML_COMMANDS_STR=$(printf "\n'%s'" "${ML_COMMANDS[@]}")
    eval "_describe 'command' \"($ML_COMMANDS_STR)\""
    _values -s ' ' 'flags' $(ml -t avail | sed -e 's#/$##' | tr '\n' ' ')
}

compdef _ml "ml"
```

If you type `ml tensor<TAB>`, you will get all available models to tab through that contain
"tensor" and are available under the current `modenv`:

```
marie@login$ ml tensor<TAB>
TensorFlow                                            TensorFlow/1.8.0-foss-2018a-Python-3.6.4-CUDA-9.2.88  TensorFlow/2.1.0-fosscuda-2019b-Python-3.7.4
TensorFlow/1.10.0-fosscuda-2018b-Python-3.6.6         TensorFlow/2.0.0-foss-2019a-Python-3.7.2              TensorFlow/2.3.1-fosscuda-2019b-Python-3.7.4
TensorFlow/1.15.0-fosscuda-2019b-Python-3.7.4         TensorFlow/2.0.0-fosscuda-2019b-Python-3.7.4          TensorFlow/2.4.1-foss-2020b
```

## Troubleshooting

### When I log in, the wrong modules are loaded by default

Reset your currently loaded modules with `module purge`
(or `module purge --force` if you also want to unload your basic `modenv` module).
Then run `module save` to overwrite the
list of modules you load by default when logging in.

### I can't load module TensorFlow

Check the dependencies by e.g. calling `module spider TensorFlow/2.4.1`
it will list a number of modules that need to be loaded
before the TensorFlow module can be loaded.

??? example "Loading the dependencies"

    ```console
    marie@compute$ module load TensorFlow/2.4.1
    Lmod hat den folgenden Fehler erkannt:  Diese Module existieren, aber
    können nicht wie gewünscht geladen werden: "TensorFlow/2.4.1"
       Versuchen Sie: "module spider TensorFlow/2.4.1" um anzuzeigen, wie die Module
    geladen werden.


    marie@compute$ module spider TensorFlow/2.4.1

    ----------------------------------------------------------------------------------
      TensorFlow: TensorFlow/2.4.1
    ----------------------------------------------------------------------------------
        Beschreibung:
          An open-source software library for Machine Intelligence


        Sie müssen alle Module in einer der nachfolgenden Zeilen laden bevor Sie das Modul "TensorFlow/2.4.1" laden können.

          modenv/hiera  GCC/10.2.0  CUDA/11.1.1  OpenMPI/4.0.5
         This extension is provided by the following modules. To access the extension you must load one of the following modules. Note that any module names in parentheses show the module location in the software hierarchy.


           TensorFlow/2.4.1 (modenv/hiera GCC/10.2.0 CUDA/11.1.1 OpenMPI/4.0.5)


        This module provides the following extensions:

           absl-py/0.10.0 (E), astunparse/1.6.3 (E), cachetools/4.2.0 (E), dill/0.3.3 (E), gast/0.3.3 (E), google-auth-oauthlib/0.4.2 (E), google-auth/1.24.0 (E), google-pasta/0.2.0 (E), grpcio/1.32.0 (E), gviz-api/1.9.0 (E), h5py/2.10.0 (E), Keras-Preprocessing/1.1.2 (E), Markdown/3.3.3 (E), oauthlib/3.1.0 (E), opt-einsum/3.3.0 (E), portpicker/1.3.1 (E), pyasn1-modules/0.2.8 (E), requests-oauthlib/1.3.0 (E), rsa/4.7 (E), tblib/1.7.0 (E), tensorboard-plugin-profile/2.4.0 (E), tensorboard-plugin-wit/1.8.0 (E), tensorboard/2.4.1 (E), tensorflow-estimator/2.4.0 (E), TensorFlow/2.4.1 (E), termcolor/1.1.0 (E), Werkzeug/1.0.1 (E), wrapt/1.12.1 (E)

        Help:
          Description
          ===========
          An open-source software library for Machine Intelligence


          More information
          ================
           - Homepage: https://www.tensorflow.org/


          Included extensions
          ===================
          absl-py-0.10.0, astunparse-1.6.3, cachetools-4.2.0, dill-0.3.3, gast-0.3.3,
          google-auth-1.24.0, google-auth-oauthlib-0.4.2, google-pasta-0.2.0,
          grpcio-1.32.0, gviz-api-1.9.0, h5py-2.10.0, Keras-Preprocessing-1.1.2,
          Markdown-3.3.3, oauthlib-3.1.0, opt-einsum-3.3.0, portpicker-1.3.1,
          pyasn1-modules-0.2.8, requests-oauthlib-1.3.0, rsa-4.7, tblib-1.7.0,
          tensorboard-2.4.1, tensorboard-plugin-profile-2.4.0, tensorboard-plugin-
          wit-1.8.0, TensorFlow-2.4.1, tensorflow-estimator-2.4.0, termcolor-1.1.0,
          Werkzeug-1.0.1, wrapt-1.12.1


    Names marked by a trailing (E) are extensions provided by another module.



    marie@compute$ ml +modenv/hiera  +GCC/10.2.0  +CUDA/11.1.1 +OpenMPI/4.0.5 +TensorFlow/2.4.1

    Die folgenden Module wurden in einer anderen Version erneut geladen:
      1) GCC/7.3.0-2.30 => GCC/10.2.0        3) binutils/2.30-GCCcore-7.3.0 => binutils/2.35
      2) GCCcore/7.3.0 => GCCcore/10.2.0     4) modenv/scs5 => modenv/hiera

    Module GCCcore/7.3.0, binutils/2.30-GCCcore-7.3.0, GCC/7.3.0-2.30, GCC/7.3.0-2.30 and 3 dependencies unloaded.
    Module GCCcore/7.3.0, GCC/7.3.0-2.30, GCC/10.2.0, CUDA/11.1.1, OpenMPI/4.0.5, TensorFlow/2.4.1 and 50 dependencies loaded.
    marie@compute$ module list

    Derzeit geladene Module:
      1) modenv/hiera               (S)  28) Tcl/8.6.10
      2) GCCcore/10.2.0                  29) SQLite/3.33.0
      3) zlib/1.2.11                     30) GMP/6.2.0
      4) binutils/2.35                   31) libffi/3.3
      5) GCC/10.2.0                      32) Python/3.8.6
      6) CUDAcore/11.1.1                 33) pybind11/2.6.0
      7) CUDA/11.1.1                     34) SciPy-bundle/2020.11
      8) numactl/2.0.13                  35) Szip/2.1.1
      9) XZ/5.2.5                        36) HDF5/1.10.7
     10) libxml2/2.9.10                  37) cURL/7.72.0
     11) libpciaccess/0.16               38) double-conversion/3.1.5
     12) hwloc/2.2.0                     39) flatbuffers/1.12.0
     13) libevent/2.1.12                 40) giflib/5.2.1
     14) Check/0.15.2                    41) ICU/67.1
     15) GDRCopy/2.1-CUDA-11.1.1         42) JsonCpp/1.9.4
     16) UCX/1.9.0-CUDA-11.1.1           43) NASM/2.15.05
     17) libfabric/1.11.0                44) libjpeg-turbo/2.0.5
     18) PMIx/3.1.5                      45) LMDB/0.9.24
     19) OpenMPI/4.0.5                   46) nsync/1.24.0
     20) OpenBLAS/0.3.12                 47) PCRE/8.44
     21) FFTW/3.3.8                      48) protobuf/3.14.0
     22) ScaLAPACK/2.1.0                 49) protobuf-python/3.14.0
     23) cuDNN/8.0.4.30-CUDA-11.1.1      50) flatbuffers-python/1.12
     24) NCCL/2.8.3-CUDA-11.1.1          51) typing-extensions/3.7.4.3
     25) bzip2/1.0.8                     52) libpng/1.6.37
     26) ncurses/6.2                     53) snappy/1.1.8
     27) libreadline/8.0                 54) TensorFlow/2.4.1

      Wo:
       S:  Das Modul ist angeheftet. Verwenden Sie "--force", um das Modul zu entladen.
    ```
