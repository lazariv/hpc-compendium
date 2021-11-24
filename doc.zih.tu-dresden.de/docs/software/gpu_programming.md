# GPU Programming

## Directive Based GPU Programming

Directives are special compiler commands in your C/C++ or Fortran source code. They tell the
compiler how to parallelize and offload work to a GPU. This section explains how to use this
technique.

### OpenACC

[OpenACC](http://www.openacc-standard.org) is a directive based GPU programming model. It currently
only supports NVIDIA GPUs as a target.

Please use the following information as a start on OpenACC:

Introduction

OpenACC can be used with the PGI and CAPS compilers. For PGI please be sure to load version 13.4 or
newer for full support for the NVIDIA Tesla K20x GPUs at ZIH.

#### Using OpenACC with PGI compilers

* For compilation, please add the compiler flag `-acc` to enable OpenACC interpreting by the
  compiler;
* `-Minfo` tells you what the compiler is actually doing to your code;
* If you only want to use the created binary at ZIH resources, please also add `-ta=nvidia:keple`;
* OpenACC Tutorial: intro1.pdf, intro2.pdf.

### HMPP

HMPP is available from the CAPS compilers.

## Native GPU Programming

### CUDA

Native [CUDA](http://www.nvidia.com/cuda) programs can sometimes offer a better performance. Please
use the following slides as an introduction:

* Introduction to CUDA;
* Advanced Tuning for NVIDIA Kepler GPUs.

In order to compile an application with CUDA use the `nvcc` compiler command.
