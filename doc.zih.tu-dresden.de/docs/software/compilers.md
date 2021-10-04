# Compilers

The following compilers are available on the ZIH system:

|                      | GNU Compiler Collection | Intel Compiler | PGI Compiler (Nvidia HPC SDK) |
|----------------------|-----------|------------|-------------|
| Further information  | [GCC website](https://gcc.gnu.org/) | [C/C++](https://software.intel.com/en-us/c-compilers), [Fortran](https://software.intel.com/en-us/fortran-compilers) | [PGI website](https://www.pgroup.com) |
| Module name          | GNU        | intel     | PGI         |
| C Compiler           | `gcc`      | `icc`     | `pgcc`      |
| C++ Compiler         | `g++`      | `icpc`    | `pgc++`     |
| Fortran Compiler     | `gfortran` | `ifort`   | `pgfortran` |

For an overview of the installed compiler versions, please use `module spider <module name>`
on the ZIH systems.

All compilers support various language standards, at least up to ISO C11, ISO C++ 2014, and Fortran 2003.
Please check the man pages to verify that your code can be compiled.

Please note that the linking of C++ files normally requires the C++ version of the compiler to link
the correct libraries.

## Compiler Flags

Common options are:

- `-g` to include information required for debugging
- `-pg` to generate gprof-like sample-based profiling information during the run
- `-O0`, `-O1`, `-O2`, `-O3` to customize the optimization level from
  no (`-O0`) to aggressive (`-O3`) optimization
- `-I` to set search path for header files
- `-L` to set search path for libraries

Please note that aggressive optimization allows deviation from the strict IEEE arithmetic.
Since the performance impact of options like `-fp-model strict` is very hard you
have to balance speed and desired accuracy of your application yourself.

The user benefits from the (nearly) same set of compiler flags for optimization for the C, C++, and
Fortran-compilers.
In the following table, only a couple of important compiler-dependent options are listed.
For more detailed information about these and further flags, the user should refer to the man
pages or use the option `--help` to list all options of the compiler.

| GCC | Intel | PGI | Description |
|----------------------|--------------|-------------|-------------------------------------------------------------------------------------|
| `-fopenmp`           | `-fopenmp`    | `-mp`       | turn on OpenMP support |
| `-std=c99`, `-std=c++11`, `-std=f2018`   | `-std=c99`, `-std=c++11`, `-std18`       | `-c99`, `--c++11`, n/a  | set language standard, for example C99, C++11, Fortran 2018 |
| `-mieee-fp` `-frounding-math`  | `-fp-model precise` or `-fp-model strict`        | `-Kieee`    | limit floating-point optimizations and maintain declared precision |
| `-ffast-math`        | `-mp1` or `-fp-model fast`  | `-Mfprelaxed`  | allow floating-point optimizations, may violate IEEE conformance |
| `-Ofast`             | `-fast`      | `-fast`     | Maximize performance, implies a couple of other flags                               |
| `-fsignaling-nans` `-fno-trapping-math` | C/C++: `-fpe-trap`, Fortran: `-fpe-all` | `-Ktrap` | controls the behavior when floating-point exceptions occur   |
| `-mavx` `-msse4.2`   | `-mavx` `-msse4.2`   | `-fastsse`  | "generally optimal flags" for supporting SSE instructions                           |
| `-flto`              | `-ipo`       | `-Mipa`     | interprocedural / link-time optimization (across source files)                                         |
| `-floop-parallelize-all -ftree-parallelize-loops=<numthreads>` | `-parallel`  | `-Mconcur`  | auto-parallelizer                                                                   |
| `-fprofile-generate` | `-prof-gen`  | `-Mpfi`     | create instrumented code to generate profile in file                                |
| `-fprofile-use`      | `-prof-use`  | `-Mpfo`     | use profile data for optimization      |

!!! note

    We can not generally give advice as to which option should be used. To gain maximum performance
    please test the compilers and a few combinations of optimization flags. In case of doubt, you
    can also contact [HPC support](../support/support.md) and ask the staff for help.

### Architecture-specific Optimizations

Different architectures of CPUs feature different vector extensions (like SSE4.2 and AVX)
to accelerate computations.
The following matrix shows proper compiler flags for the architectures at the ZIH:

| Architecture       | GCC                  | Intel                | PGI |
|--------------------|----------------------|----------------------|-----|
| Intel Haswell      | `-march=haswell`     | `-march=haswell`     | `-tp=haswell` |
| AMD Rome           | `-march=znver2`      | `-march=core-avx2`   | `-tp=zen` |
| Intel Cascade Lake | `-march=cascadelake` | `-march=cascadelake` | `-tp=skylake` |
| Host's architecture  | `-march=native`      | `-xHost`             | |

To build an executable for different node types (e.g. Cascade Lake with AVX512 and
Haswell without AVX512) the option `-march=haswell -axcascadelake` (for Intel compilers)
uses vector extension up to AVX2 as default path and runs along a different execution
path if AVX512 is available.
This increases the size of the program code (might result in
poorer L1 instruction cache hits) but enables to run the same program on
different hardware types.
