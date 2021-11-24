# PAPI Library

## Introduction

The **P**erformance **A**pplication **P**rogramming **I**nterface (PAPI) provides tool designers and
application engineers with a consistent interface and methodology for the use of low-level
performance counter hardware found across the entire compute system (i.e. CPUs, GPUs, on/off-chip
memory, interconnects, I/O system, energy/power, etc.). PAPI enables users to see, in near real
time, the relations between software performance and hardware events across the entire computer
system.

Only the basic usage is outlined in this compendium. For a comprehensive PAPI user manual please
refer to the [PAPI wiki website](https://bitbucket.org/icl/papi/wiki/Home).

## PAPI Counter Interfaces

To collect performance events, PAPI provides two APIs, the *high-level* and *low-level* API.

### High-Level API

The high-level API provides the ability to record performance events inside instrumented regions of
serial, multi-processing (MPI, SHMEM) and thread (OpenMP, Pthreads) parallel applications. It is
designed for simplicity, not flexibility. More details can be found in the
[PAPI wiki High-Level API description](https://bitbucket.org/icl/papi/wiki/PAPI-HL.md).

The following code example shows the use of the high-level API by marking a code section.

??? example "C"

    ```C
    #include "papi.h"

    int main()
    {
        int retval;

        retval = PAPI_hl_region_begin("computation");
        if ( retval != PAPI_OK )
            handle_error(1);

        /* Do some computation here */

        retval = PAPI_hl_region_end("computation");
        if ( retval != PAPI_OK )
            handle_error(1);
    }
    ```

??? example "Fortran"

    ```fortran
    #include "fpapi.h"

    program main
    integer retval

    call PAPIf_hl_region_begin("computation", retval)
    if ( retval .NE. PAPI_OK ) then
       write (*,*) "PAPIf_hl_region_begin failed!"
    end if

    !do some computation here

    call PAPIf_hl_region_end("computation", retval)
    if ( retval .NE. PAPI_OK ) then
       write (*,*) "PAPIf_hl_region_end failed!"
    end if

    end program main
    ```

Events to be recorded are determined via the environment variable `PAPI_EVENTS` that lists comma
separated events for any component (see example below). The output is generated in the current
directory by default. However, it is recommended to specify an output directory for larger
measurements, especially for MPI applications via environment variable `PAPI_OUTPUT_DIRECTORY`.

!!! example "Setting performance events and output directory"

    ```bash
    export PAPI_EVENTS="PAPI_TOT_INS,PAPI_TOT_CYC"
    export PAPI_OUTPUT_DIRECTORY="/scratch/measurement"
    ```

This will generate a directory called `papi_hl_output` in `scratch/measurement` that contains one or
more output files in JSON format.

### Low-Level API

The low-level API manages hardware events in user-defined groups called Event Sets. It is meant for
experienced application programmers and tool developers wanting fine-grained measurement and
control of the PAPI interface. It provides access to both PAPI preset and native events, and
supports all installed components. The PAPI wiki contains also a page with more details on the
[low-level API](https://bitbucket.org/icl/papi/wiki/PAPI-LL.md).

## Usage on ZIH Systems

Before you start a PAPI measurement, check which events are available on the desired architecture.
For this purpose, PAPI offers the tools `papi_avail` and `papi_native_avail`. If you want to measure
multiple events, please check which events can be measured concurrently using the tool
`papi_event_chooser`. The PAPI wiki contains more details on
[the PAPI tools](https://bitbucket.org/icl/papi/wiki/PAPI-Overview.md#markdown-header-papi-utilities).

!!! hint

    The PAPI tools must be run on the compute node, using an interactive shell or job.

!!! example "Example: Determine the events on the partition `romeo` from a login node"

    ```console
    marie@login$ module load PAPI
    marie@login$ salloc -A <project> --partition=romeo
    [...]
    marie@login$ srun papi_avail
    marie@login$ srun papi_native_avail
    [...]
    # Exit with Ctrl+D
    ```

Instrument your application with either the high-level or low-level API. Load the PAPI module and
compile your application against the  PAPI library.

!!! example

    ```console
    marie@login$ module load PAPI
    marie@login$ gcc app.c -o app -lpapi
    marie@login$ salloc -A <project> --partition=romeo
    marie@login$ srun ./app
    [...]
    # Exit with Ctrl+D
    ```

!!! hint

    The PAPI modules on ZIH systems are only installed with the default `perf_event` component. If you
    want to measure, e.g., GPU events, you have to install your own PAPI. Please see the
    [external instructions on how to download and install PAPI](https://bitbucket.org/icl/papi/wiki/Downloading-and-Installing-PAPI.md).
    To install PAPI with additional components, you have to specify them during configure as
    described for the [Installation of Components](https://bitbucket.org/icl/papi/wiki/PAPI-Overview.md#markdown-header-components).
