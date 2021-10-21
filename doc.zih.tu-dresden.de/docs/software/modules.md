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

## Examples

### Finding available software

    `module avail <modname>`

!!! example "Example usage"

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

### Loading software

    `module load <software/version>`

!!! example "Example usage"

    ```console
    marie@compute$ module load Python/3.8.6
    Module Python/3.8.6-GCCcore-10.2.0 and 11 dependencies loaded.
    ```

??? hint "Being lazy in typing"

    `ml` \
    `ml +<software/version>` \
    `ml -<software/version>`

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

## List of Module Commands

Using modules is quite straightforward and the following table lists the basic commands.

| Command                       | Description                                                      |
|:------------------------------|:-----------------------------------------------------------------|
| `module help`                 | Show all module options                                          |
| `module list`                 | List active modules in the user environment                      |
| `module purge`                | Remove modules from the user environment                         |
| `module avail`                | List all available modules                                       |
| `module spider`               | Search for modules across all environments, can take a parameter |
| `module load <modname>`       | Load module `modname` in the user environment                    |
| `module unload <modname>`     | Remove module `modname` from the user environment                |
| `module switch <mod1> <mod2>` | Replace module `mod1` with module `mod2`                         |

Module files are ordered by their topic on ZIH systems. By default, with `module avail` you will
see all topics and their available module files. If you just wish to see the installed versions of a
certain module, you can use `module avail softwarename` and it will display the available versions of
`softwarename` only.

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
at the system path '/sw/installed'.

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

### Advanced Usage

For writing your own Modulefiles please have a look at the [Guide for writing project and private Modulefiles](private_modules.md).