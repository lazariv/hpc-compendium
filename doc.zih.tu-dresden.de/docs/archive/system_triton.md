# IBM-iDataPlex Cluster Trition

!!! warning

    **This page is deprecated! Trition is a former system!**

Trition is a cluster based on quadcore Intel Xeon CPUs. The nodes are operated
by the Linux operating system SuSE SLES 11. Currently, the following
hardware is installed:

| Component | Count |
|-----------|-------|
|CPUs |Intel quadcore E5530 |
|RAM per core |6 GB |
|Number of cores |512 |
|total peak performance |4.9 TFLOPS |
|dual nodes |64 |

The jobs for the compute nodes are scheduled by the [LoadLeveler](load_leveler.md) batch system from
the login node triton.hrsk.tu-dresden.de .

## CPU

The cluster is based on dual-core Intel Xeon E5530 processor. One core
has the following basic properties:

| Component | Count |
|-----------|-------|
|CPUs |Intel quadcore E5530 |
|clock rate |2.4 GHz |
|Cores |4 |
|Threads |8 |
|Intel Smart Cache |8MB |
|Intel QPI Speed |5.86 GT/s |
|Max TDP |80 W |

### Software

| Compilers                       |        Version |
|:--------------------------------|---------------:|
| Intel (C, C++, Fortran)         |       11.1.069 |
| GNU                             |          4.3.2 |
| **Libraries**                   |                |
| MKL                             |       11.0.069 |
| IPP                             |       11.0.069 |
| TBB                             |       11.0.069 |
| FFTW                            |   2.1.5, 3.2.2 |
| hypre                           |         2.6.0b |
| **Applications**                |                |
| Ansys                           |           12.1 |
| Comsol                          | 3.4, 3.5, 3.5a |
| CP2K                            |        2010may |
| Gaussian                        |            g09 |
| GnuPlot                         |          4.4.0 |
| Gromacs                         |          4.0.7 |
| LAMMPS                          |        2010may |
| NAMD                            |          2.7b1 |
| QuantumEspresso                 |          4.1.3 |
| **Tools**                       |                |
| [Totalview Debugger] **todo** debuggers |            8.8 |
