# PAPI

## Introduction

The **P**erformance **A**pplication **P**rogramming **I**nterface (PAPI) provides tool designers and application engineers with a consistent interface and methodology for the use of low-level performance counter hardware found across the entire compute system (i.e. CPUs, GPUs, on/off-chip memory, interconnects, I/O system, energy/power, etc.). PAPI enables users to see, in near real time, the relations between software performance and hardware events across the entire computer system.

Only the basic usage is shown in this wiki. For a comprehensive PAPI user manual refer to the
[PAPI wiki website](https://bitbucket.org/icl/papi/wiki/Home).


## PAPI Counter Interfaces

To collect performance events, PAPI provides two APIs, the high-level and low-level API.

### High Level API
The high-level API provides the ability to record performance events inside instrumented regions of serial, multi-processing (MPI, SHMEM) and thread (OpenMP, Pthreads) parallel applications. It is designed for simplicity, not flexibility. For more details click [here](https://bitbucket.org/icl/papi/wiki/PAPI-HL.md).


The following code example shows the use of the high-level API by marking a code section.

#### C:
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

#### Fortran:
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
	      
	     

Events to be recorded are determined via the environment variable **PAPI_EVENTS** that lists comma separated events for any component (see example below). The output is generated in the current directory by default. However, it is recommended to specify an output directory for larger measurements, especially for MPI applications via environment variable **PAPI\_OUTPUT\_DIRECTORY**.

Example for setting performance events and output directory:

	export PAPI_EVENTS="PAPI_TOT_INS,PAPI_TOT_CYC"
	export PAPI_OUTPUT_DIRECTORY="scratch/measurement"

This will generate a directory called "papi_hl_output" in "scratch/measurement" that contains one or more output files in JSON format.

### Low Level API
The low-level API (Application Programming Interface) manages hardware events in user-defined groups called Event Sets. It is meant for experienced application programmers and tool developers wanting fine-grained measurement and control of the PAPI interface. It provides access to both PAPI preset and native events, and supports all installed components. For more details on the Low Level API, click [here](https://bitbucket.org/icl/papi/wiki/PAPI-LL.md).


## Usage on Taurus

Before you start a PAPI measurement, check which events are available on the desired architecture.
For this purpose PAPI offers the tools `papi_avail` and `papi_native_avail`.
If you want to measure multiple events, please check which events can be measured concurrently using the tool `papi_event_chooser`.
For more details on the PAPI tools click [here](https://bitbucket.org/icl/papi/wiki/PAPI-Overview.md#markdown-header-papi-utilities).

**The PAPI tools must be run on the compute node, using an interactive shell or job.**

Example of how to determine the events on the `romeo` partition from the login node:

	module load PAPI
	salloc -A <project> --partition=romeo
	...
	srun papi_avail
	srun papi_native_avail
	...
	Ctrl+C

Instrument your application with either the high-level or low-level API. Load the PAPI module and compile your application against PAPI.

Example:

	module load PAPI
	gcc app.c -o app -lpapi
	./app
	
**Hint**: The PAPI modules on Taurus are only installed with the default `perf_event` component.
If you want to measure e.g. GPU events, you have to install your own PAPI.
Instructions on how to download and install PAPI can be found [here](https://bitbucket.org/icl/papi/wiki/Downloading-and-Installing-PAPI.md). To install PAPI with additional components, you have to specify them during configure, for details click [here](https://bitbucket.org/icl/papi/wiki/PAPI-Overview.md#markdown-header-components).

