# Singularity Example Definitions

## Basic example

A usual workflow to create Singularity Definition consists of the
following steps:

-   Start from base image
-   Install dependencies
    -   Package manager
    -   Other sources
-   Build & Install own binaries
-   Provide entrypoints & metadata

An example doing all this:

    Bootstrap: docker
    From: alpine

    %post
      . /.singularity.d/env/10-docker*.sh

      apk add g++ gcc make wget cmake

      wget https://github.com/fmtlib/fmt/archive/5.3.0.tar.gz
      tar -xf 5.3.0.tar.gz
      mkdir build && cd build
      cmake ../fmt-5.3.0 -DFMT_TEST=OFF
      make -j$(nproc) install
      cd ..
      rm -r fmt-5.3.0*

      cat hello.cpp
    #include &lt;fmt/format.h&gt;

    int main(int argc, char** argv){
      if(argc == 1) fmt::print("No arguments passed!\n");
      else fmt::print("Hello {}!\n", argv[1]);
    }
    EOF

      g++ hello.cpp -o hello -lfmt
      mv hello /usr/bin/hello

    %runscript
      hello "$@"

    %labels
      Author Alexander Grund
      Version 1.0.0

    %help
      Display a greeting using the fmt library

      Usage:
        ./hello 

## CUDA + CuDNN + OpenMPI

-   Chosen CUDA version depends on installed driver of host
-   OpenMPI needs PMI for SLURM integration
-   OpenMPI needs CUDA for GPU copy-support
-   OpenMPI needs ibverbs libs for Infiniband
-   openmpi-mca-params.conf required to avoid warnings on fork (OK on
    taurus)
-   Environment variables SLURM_VERSION, OPENMPI_VERSION can be set to
    choose different version when building the container

<!-- -->

    Bootstrap: docker
    From: nvidia/cuda-ppc64le:10.1-cudnn7-devel-ubuntu18.04

    %labels
        Author ZIH
        Requires CUDA driver 418.39+.

    %post
        . /.singularity.d/env/10-docker*.sh

        apt-get update
        apt-get install -y cuda-compat-10.1
        apt-get install -y libibverbs-dev ibverbs-utils
        # Install basic development tools
        apt-get install -y gcc g++ make wget python
        apt-get autoremove; apt-get clean

        cd /tmp

        : ${SLURM_VERSION:=17-02-11-1}
        wget https://github.com/SchedMD/slurm/archive/slurm-${SLURM_VERSION}.tar.gz
        tar -xf slurm-${SLURM_VERSION}.tar.gz
            cd slurm-slurm-${SLURM_VERSION}
            ./configure --prefix=/usr/ --sysconfdir=/etc/slurm --localstatedir=/var --disable-debug
            make -C contribs/pmi2 -j$(nproc) install
        cd ..
        rm -rf slurm-*

        : ${OPENMPI_VERSION:=3.1.4}
        wget https://download.open-mpi.org/release/open-mpi/v${OPENMPI_VERSION%.*}/openmpi-${OPENMPI_VERSION}.tar.gz
        tar -xf openmpi-${OPENMPI_VERSION}.tar.gz
        cd openmpi-${OPENMPI_VERSION}/
        ./configure --prefix=/usr/ --with-pmi --with-verbs --with-cuda
        make -j$(nproc) install
        echo "mpi_warn_on_fork = 0" >> /usr/etc/openmpi-mca-params.conf
        echo "btl_openib_warn_default_gid_prefix = 0" >> /usr/etc/openmpi-mca-params.conf
        cd ..
        rm -rf openmpi-*
