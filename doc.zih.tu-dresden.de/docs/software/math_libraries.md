# Math Libraries

Many software heavily relies on math libraries, e.g., for linear algebra or FFTW calculations.
Writing portable and fast math functions is a really challenging task. You can try it for fun, but you
really should avoid writing you own matrix-matrix multiplication. Thankfully, there are several
high quality math libraries available at ZIH systems.

In the following, a few often-used interfaces/specifications and libraries are described. All
libraries are available as [modules](modules.md).

## BLAS, LAPACK and ScaLAPACK

Over the last decades, the three de-facto standard specifications BLAS, LAPACK and ScaLAPACK for
basic linear algebra routines have been emerged.

The [BLAS](https://www.netlib.org/blas/) (Basic Linear Algebra Subprograms) specification contains routines
for common linear algebra operations such as vector addition, matrix-vector multiplication, and dot
product. BLAS routines can be understood as basic building blocks for advanced numerical algorithms.

The [Linear Algebra PACKage](https://www.netlib.org/lapack/) (LAPACK) provides more
sophisticated numerical algorithms, such as solving linear systems of equations, matrix
factorization, and eigenvalue problems.

<!--With [libFlame](#amd-optimizing-cpu-libraries-aocl) and [MKL](#math-kernel-library-mkl) there are-->
<!--two highly optimised LAPACK implementations aiming for AMD and Intel architecture, respectively.-->

The [Scalable Linear Algebra PACKage](https://www.netlib.org/scalapack) (ScaLAPACK) takes the
idea of high-performance linear algebra routines to parallel distributed memory machines. It offers
functionality to solve dense and banded linear systems, least squares problems, eigenvalue
problems, and singular value problems.

<!--There is also an [optimized implementation](https://developer.amd.com/amd-aocl/scalapack/) addressing-->
<!--AMD architectures.-->

Many concrete implementations, often tuned and optimized for specific hardware architectures, have
been developed over the last decades. The two hardware vendors Intel and AMD each offer their own math
library - [Intel MKL](#math-kernel-library-mkl) and [AOCL](#amd-optimizing-cpu-libraries-aocl).
Both libraries are worth to consider from a users point of view, since they provide extensive math
functionality ranging from BLAS and LAPACK to random number generators and Fast Fourier
Transformation with consistent interfaces and the "promises" to be highly tuned and optimized and
continuously developed further.

- [BLAS reference implementation](https://www.netlib.org/blas/) in Fortran
- [LAPACK reference implementation](https://www.netlib.org/lapack/)
- [ScaLAPACK reference implementation](https://www.netlib.org/scalapack/)
- [OpenBlas](http://www.openblas.net)
- For GPU implementations, refer to the [GPU section](#libraries-for-gpus)

## AMD Optimizing CPU Libraries (AOCL)

[AMD Optimizing CPU Libraries](https://developer.amd.com/amd-aocl/) (AOCL) is a set of numerical
libraries tuned specifically for AMD EPYC processor family. AOCL offers linear algebra libraries
([BLIS](https://developer.amd.com/amd-cpu-libraries/blas-library/),
 [libFLAME](https://developer.amd.com/amd-cpu-libraries/blas-library/#libflame),
 [ScaLAPACK](https://developer.amd.com/amd-aocl/scalapack/),
 [AOCL-Sparse](https://developer.amd.com/amd-aocl/aocl-sparse/),
 [FFTW routines](https://developer.amd.com/amd-aocl/fftw/),
 [AMD Math Library (LibM)](https://developer.amd.com/amd-cpu-libraries/amd-math-library-libm/),
 as well as
 [AMD Random Number Generator Library](https://developer.amd.com/amd-cpu-libraries/rng-library/)
 and
 [AMD Secure RNG Library](https://developer.amd.com/amd-cpu-libraries/rng-library/#securerng).

## Math Kernel Library (MKL)

The
[Intel Math Kernel Library](https://software.intel.com/content/www/us/en/develop/documentation/get-started-with-mkl-for-dpcpp/top.html)
(Intel MKL) provides extensively threaded math routines which are highly optimized for Intel CPUs.
It contains routines for linear algebra, direct and iterative sparse solvers, random number
generators and Fast Fourier Transformation (FFT).

!!! note

    MKL comes in an OpenMP-parallel version. If you want to use it, make sure you know how
    to place your jobs. [^1]
    [^1]: In \[c't 18, 2010\], Andreas Stiller proposes the usage of
    `GOMP_CPU_AFFINITY` to allow the mapping of AMD cores. KMP_AFFINITY works only for Intel processors.

The available MKL modules can be queried as follows

```console
marie@login$ module avail imkl
```

### Linking

For linker flag combinations, we highly recommend the
[MKL Link Line Advisor](http://software.intel.com/en-us/articles/intel-mkl-link-line-advisor/)
(please make sure that JavaScript is enabled for this page).

## Libraries for GPUs

GPU implementations of math functions and routines are often much faster compared to CPU
implementations. This also holds for basic routines from BLAS and LAPACK. You should consider using
GPU implementations in order to obtain better performance.

There are several math libraries for Nvidia GPUs, e.g.

- [cuBLAS](https://docs.nvidia.com/cuda/cublas/index.html)
- [cuSOLVER](https://developer.nvidia.com/cusolver) (reduced set of LAPACK routines)
- [cuSPARSE](https://developer.nvidia.com/cusparse) (sparse matrix library)
- [cuFFT](https://developer.nvidia.com/cufft)

Nvidia provides a
[comprehensive overview and starting point](https://developer.nvidia.com/gpu-accelerated-libraries#linear-algebra).

### MAGMA

The project [Matrix Algebra on GPU and Multicore Architectures](http://icl.cs.utk.edu/magma/) (MAGMA)
aims to develop a dense linear algebra library similar to LAPACK but for heterogeneous/hybrid
architectures, starting with current "Multicore+GPU" systems. `MAGMA` is available at ZIH systems in
different versions. You can list the available modules using

```console
marie@login$ module spider magma
[...]
        magma/2.5.4-fosscuda-2019b
        magma/2.5.4
```

## FFTW

FFTW is a C subroutine library for computing the discrete Fourier transform (DFT) in one or more
dimensions, of arbitrary input size, and of both real and complex data (as well as of even/odd data,
i.e. the discrete cosine/sine transforms or DCT/DST). Before using this library, please check out
the functions of vendor-specific libraries such as [AOCL](#amd-optimizing-cpu-libraries-aocl)
or [Intel MKL](#math-kernel-library-mkl)
