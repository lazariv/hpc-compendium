# Libraries

The following libraries are available on our platforms:

|           |                       |                 |            |
|-----------|-----------------------|-----------------|------------|
|           | **Taurus**            | **Venus**       | **module** |
| **Boost** | 1.49, 1.5\[4-9\], 160 | 1.49, 1.51,1.54 | boost      |
| **MKL**   | 2013, 2015            | 2013            | mkl        |
| **FFTW**  | 3.3.4                 |                 | fftw       |

## The Boost Library

Boost provides free peer-reviewed portable C++ source libraries, ranging
from multithread and MPI support to regular expression and numeric
funtions. See at <http://www.boost.org> for detailed documentation.

## BLAS/LAPACK

### Example

    program ExampleProgram

    external dgesv
    integer:: n, m, c, d, e, Z(2)                           !parameter definition
    double precision:: A(2,2), B(2)

    n=2; m=1; c=2; d=2;

    A(1,1) = 1.0; A(1,2) = 2.0;                           !parameter setting
    A(2,1) = 3.0; A(2,2) = 4.0;

    B(1) = 14.0; B(2) = 32.0;

    Call dgesv(n,m,A,c,Z,B,d,e);                        !call the subroutine

    write(*,*) "Solution ", B(1), " ", B(2)             !display on desktop

    end program ExampleProgram

### Math Kernel Library (MKL)

The Intel Math Kernel Library is a collection of basic linear algebra
subroutines (BLAS) and fast fourier transformations (FFT). It contains
routines for:

-   Solvers such as linear algebra package (LAPACK) and BLAS
-   Eigenvector/eigenvalue solvers (BLAS, LAPACK)
-   PDEs, signal processing, seismic, solid-state physics (FFTs)
-   General scientific, financial - vector transcendental functions,
    vector markup language (XML)

More speciﬁcally it contains the following components:

-   BLAS:
    -   Level 1 BLAS: vector-vector operations, 48 functions
    -   Level 2 BLAS: matrix-vector operations, 66 functions
    -   Level 3 BLAS: matrix-matrix operations, 30 functions
-   LAPACK (linear algebra package), solvers and eigensolvers, hundreds
    of routines, more than 1000 user callable routines
-   FFTs (fast Fourier transform): one and two dimensional, with and
    without frequency ordering (bit reversal). There are wrapper
    functions to provide an interface to use MKL instead of FFTW.
-   VML (vector math library), set of vectorized transcendental
    functions
-   Parallel Sparse Direct Linear Solver (Pardiso)

Please note: MKL comes in an OpenMP-parallel version. If you want to use
it, make sure you know how to place your jobs. {{ In \[c't 18, 2010\],
Andreas Stiller proposes the usage of `GOMP_CPU_AFFINITY` to allow the
mapping of AMD cores. KMP_AFFINITY works only for Intel processors. }}

#### Linking with the MKL

For linker flag combinations, Intel provides the MKL Link Line Advisor
at
<http://software.intel.com/en-us/articles/intel-mkl-link-line-advisor/>
(please make sure that JavaScript is enabled for this page).

Can be compiled with MKL 11 like this

    ifort -I$MKL_INC -L$MKL_LIB -lmkl_core -lm -lmkl_gf_ilp64 -lmkl_lapack example.f90

#### Linking with the MKL at VENUS

Please follow the infomation at website \<br />
<http://hpcsoftware.ncsa.illinois.edu/Software/user/show_all.php?deploy_id=951&view=NCSA>

    icc -O1 -I/sw/global/compilers/intel/2013/mkl//include -lmpi -mkl -lmkl_scalapack_lp64 -lmkl_blacs_sgimpt_lp64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core example.c

#### 

## FFTW

FFTW is a C subroutine library for computing the discrete Fourier
transform (DFT) in one or more dimensions, of arbitrary input size, and
of both real and complex data (as well as of even/odd data, i.e. the
discrete cosine/sine transforms or DCT/DST). Before using this library,
please check out the functions of vendor speciﬁc libraries ACML and/or
MKL.
