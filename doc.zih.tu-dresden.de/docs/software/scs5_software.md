# SCS5 Migration Hints

Bull's new cluster software is called SCS 5 (*Super Computing Suite*).
Here are the major changes from the user's perspective:

| software                        | old    | new      |
|:--------------------------------|:-------|:---------|
| Red Hat Enterprise Linux (RHEL) | 6.x    | 7.x      |
| Linux kernel                    | 2.26   | 3.10     |
| glibc                           | 2.12   | 2.17     |
| Infiniband stack                | OpenIB | Mellanox |
| Lustre client                   | 2.5    | 2.10     |

## Host Keys

Due to the new operating system, the host keys of the login nodes have also changed. If you have
logged into tauruslogin6 before and still have the old one saved in your `known_hosts` file, just
remove it and accept the new one after comparing its fingerprint with those listed under
[Login](../access/key_fingerprints.md).

## Using Software Modules

Starting with SCS5, we only provide
[Lmod](../software/modules.md#lmod-an-alternative-module-implementation) as the
environment module tool of choice.

As usual, you can get a list of the available software modules via:

```Bash
module available
# or short:
ml av
```

There is a special module that is always loaded (sticky) called
**modenv**. It determines the module environment you can see.

|                |                                                 |         |
|----------------|-------------------------------------------------|---------|
| modenv/scs5    | SCS5 software                                   | default |
| modenv/ml      | software for data analytics (partition ml)      |         |
| modenv/classic | Manually built pre-SCS5 (AE4.0) software        | hidden  |

The old modules (pre-SCS5) are still available after loading the
corresponding **modenv** version (**classic**), however, due to changes
in the libraries of the operating system, it is not guaranteed that they
still work under SCS5. That's why those modenv versions are hidden.

Example:

```Bash
$ ml modenv/classic ansys/19.0

The following have been reloaded with a version change:
  1) modenv/scs5 => modenv/classic

Module ansys/19.0 loaded.
```

**modenv/scs5** will be loaded by default and contains all the software
that was built especially for SCS5.

### Which modules should I use?

If possible, please use the modules from **modenv/scs5**. In case there is a certain software
missing, you can write an [email to hpcsupport](mailto:hpcsupport@zih.tu-dresden.de) and we will try
to install the latest version of this particular software for you.

However, if you still need *older* versions of some software, you have to resort to using the
modules in the old module environment (**modenv/classic** most probably). We won't keep those around
forever though, so in the long-term, it is advisable to migrate your workflow to up-to-date versions
of the software used.

### Compilers, MPI-Libraries and Toolchains

Since we are mainly using EasyBuild to install software now, we are following their
[toolchain schemes](http://easybuild.readthedocs.io/en/latest/Common-toolchains.html).

We mostly install software using the "intel" toolchain, because in most cases, the resulting code
performs best on our Intel-based architectures. There are alternatives like GCC (foss), PGI or
Clang/LLVM though.

Generally speaking, the toolchains in this new environment are separated into more parts (modules)
than you will be used to, coming from modenv/classic. A full toolchain, like "intel", "foss" or
"iomkl" consists of several sub-modules making up the layers of

- compilers
- MPI library
- math library (providing BLAS/LAPACK/FFT routines etc.)

For instance, the "intel" toolchain has the following structure:

|              |            |
|--------------|------------|
| toolchain    | intel      |
| compilers    | icc, ifort |
| mpi library  | impi       |
| math library | imkl       |

On the other hand, the "foss" toolchain looks like this:

|                |                     |
|----------------|---------------------|
| toolchain      | foss                |
| compilers      | GCC (gcc, gfortran) |
| mpi library    | OpenMPI             |
| math libraries | OpenBLAS, FFTW      |

If you want to combine the Intel compilers and MKL with OpenMPI, you'd have to use the "iomkl"
toolchain:

|              |            |
|--------------|------------|
| toolchain    | iomkl      |
| compilers    | icc, ifort |
| mpi library  | OpenMPI    |
| math library | imkl       |

There are also subtoolchains that skip a layer or two, e.g. "iccifort" only consists of the
respective compilers, same as "GCC". Then there is "iompi" that includes Intel compilers+OpenMPI but
no math library, etc.

#### What is this "GCCcore" I keep seeing and how does it relate to "GCC"?

GCCcore includes only the compilers/standard libraries of the GNU compiler collection but without
"binutils". It is used as a dependency for many modules without getting in the way, e.g. the Intel
compilers also rely on libstdc++ from GCC, but you don't want to load two compiler modules at the
same time, so "intel" also depends on "GCCcore". You can think of it as more of a runtime dependency
rather than a full-fledged compiler toolchain. If you want to compile your own code with the GNU
compilers, you have to load the module: "**GCC"** instead, "GCCcore" won't be enough.

There are [ongoing discussions](https://github.com/easybuilders/easybuild-easyconfigs/issues/6366)
in the EasyBuild community to maybe change this in the future in order to avoid the potential
confusion this GCCcore module brings with it.

#### I have been using "bullxmpi" so far, where can I find it?

bullxmpi was more or less a rebranded OpenMPI 1.6 with some additions from Bull. It is not supported
anymore and Bull has abandoned it in favor of a standard OpenMPI 2.0.2 build as their default in
SCS5. You should migrate your code to our OpenMPI module or maybe even try Intel MPI instead.

#### Where have the analysis tools from Intel Parallel Studio XE gone?

Since "intel" is only a toolchain module now, it does not include the entire Parallel Studio
anymore. Tools like the Intel Advisor, Inspector, Trace Analyzer or VTune Amplifier are available as
separate modules now:

| product               | module    |
|:----------------------|:----------|
| Intel Advisor         | Advisor   |
| Intel Inspector       | Inspector |
| Intel Trace Analyzer  | itac      |
| Intel VTune Amplifier | VTune     |
