# Energy Measurement Infrastructure

All nodes of the HPC machine Taurus are equipped with power
instrumentation that allow the recording and accounting of power
dissipation and energy consumption data. The data is made available
through several different interfaces, which will be described below.

## System Description

The Taurus system is split into two phases. While both phases are
equipped with energy-instrumented nodes, the instrumentation
significantly differs in the number of instrumented nodes and their
spatial and temporal granularity.

### Phase 1

In phase one, the 270 Sandy Bridge nodes are equipped with node-level
power instrumentation that is stored in the Dataheap infrastructure at a
rate of 1Sa/s and further the energy consumption of a job is available
in SLURM (see below).

### Phase 2

In phase two, all of the 1456 Haswell DLC nodes are equipped with power
instrumentation. In addition to the access methods of phase one, users
will also be able to access the measurements through a C API to get the
full temporal and spatial resolution, as outlined below:

-   ** Blade:**1 kSa/s for the whole node, includes both sockets, DRAM,
    SSD, and other on-board consumers. Since the system is directly
    water cooled, no cooling components are included in the blade
    consumption.
-   **Voltage regulators (VR):** 100 Sa/s for each of the six VR
    measurement points, one for each socket and four for eight DRAM
    lanes (two lanes bundled).

The GPU blades of each Phase as well as the Phase I Westmere partition
also have 1 Sa/s power instrumentation but have a lower accuracy.

HDEEM is now generally available on all nodes in the "haswell"
partition.

## Summary of Measurement Interfaces

| Interface                                  | Sensors         | Rate                            | Phase I | Phase II Haswell |
|:-------------------------------------------|:----------------|:--------------------------------|:--------|:-----------------|
| Dataheap (C, Python, VampirTrace, Score-P) | Blade, (CPU)    | 1 Sa/s                          | yes     | yes              |
| HDEEM\* (C, Score-P)                       | Blade, CPU, DDR | 1 kSa/s (Blade), 100 Sa/s (VRs) | no      | yes              |
| HDEEM Command Line Interface               | Blade, CPU, DDR | 1 kSa/s (Blade), 100 Sa/s (VR)  | no      | yes              |
| SLURM Accounting (sacct)                   | Blade           | Per Job Energy                  | yes     | yes              |
| SLURM Profiling (hdf5)                     | Blade           | up to 1 Sa/s                    | yes     | yes              |

Note: Please specify `-p haswell --exclusive` along with your job
request if you wish to use hdeem.

## Accuracy

HDEEM measurements have an accuracy of 2 % for Blade (node)
measurements, and 5 % for voltage regulator (CPU, DDR) measurements.

## Command Line Interface

The HDEEM infrastructure can be controlled through command line tools
that are made available by loading the **hdeem** module. They are
commonly used on the node under test to start, stop, and query the
measurement device.

-   **startHdeem**: Start a measurement. After the command succeeds, the
    measurement data with the 1000 / 100 Sa/s described above will be
    recorded on the Board Management Controller (BMC), which is capable
    of storing up to 8h of measurement data.
-   **stopHdeem**: Stop a measurement. No further data is recorded and
    the previously recorded data remains available on the BMC.
-   **printHdeem**: Read the data from the BMC. By default, the data is
    written into a CSV file, whose name can be controlled using the
    **-o** argument.
-   **checkHdeem**: Print the status of the measurement device.
-   **clearHdeem**: Reset and clear the measurement device. No further
    data can be read from the device after this command is executed
    before a new measurement is started.

## Integration in Application Performance Traces

The per-node power consumption data can be included as metrics in
application traces by using the provided metric plugins for Score-P (and
VampirTrace). The plugins are provided as modules and set all necessary
environment variables that are required to record data for all nodes
that are part of the current job.

For 1 Sa/s Blade values (Dataheap):

-   [Score-P](ScoreP): use the module **`scorep-dataheap`**
-   [VampirTrace](VampirTrace): use the module
    **vampirtrace-plugins/power-1.1**

For 1000 Sa/s (Blade) and 100 Sa/s (CPU{0,1}, DDR{AB,CD,EF,GH}):

-   [Score-P](ScoreP): use the module **\<span
    class="WYSIWYG_TT">scorep-hdeem\</span>**\<br />Note: %ENDCOLOR%This
    module requires a recent version of "scorep/sync-...". Please use
    the latest that fits your compiler & MPI version.**\<br />**
-   [VampirTrace](VampirTrace): not supported

By default, the modules are set up to record the power data for the
nodes they are used on. For further information on how to change this
behavior, please use module show on the respective module.

    # Example usage with gcc
    % module load scorep/trunk-2016-03-17-gcc-xmpi-cuda7.5
    % module load scorep-dataheap
    % scorep gcc application.c -o application
    % srun ./application

Once the application is finished, a trace will be available that allows
you to correlate application functions with the component power
consumption of the parallel application. Note: For energy measurements,
only tracing is supported in Score-P/VampirTrace. The modules therefore
disables profiling and enables tracing, please use [Vampir](Vampir) to
view the trace.

\<img alt="demoHdeem_high_low_vampir_3.png" height="262"
src="%ATTACHURL%/demoHdeem_high_low_vampir_3.png" width="695" />

%RED%Note<span class="twiki-macro ENDCOLOR"></span>: the power
measurement modules **`scorep-dataheap`** and **`scorep-hdeem`** are
dynamic and only need to be loaded during execution. However,
**`scorep-hdeem`** does require the application to be linked with a
certain version of Score-P.

By default,** `scorep-dataheap`**records all sensors that are available.
Currently this is the total node consumption and for Phase II the CPUs.
**`scorep-hdeem`** also records all available sensors (node, 2x CPU, 4x
DDR) by default. You can change the selected sensors by setting the
environment variables:

    # For HDEEM
    % export SCOREP_METRIC_HDEEM_PLUGIN=Blade,CPU*
    # For Dataheap
    % export SCOREP_METRIC_DATAHEAP_PLUGIN=localhost/watts

For more information on how to use Score-P, please refer to the
[respective documentation](ScoreP).

## Access Using Slurm Tools

[Slurm](Slurm) maintains its own database of job information, including
energy data. There are two main ways of accessing this data, which are
described below.

### Post-Mortem Per-Job Accounting

This is the easiest way of accessing information about the energy
consumed by a job and its job steps. The Slurm tool `sacct` allows users
to query post-mortem energy data for any past job or job step by adding
the field `ConsumedEnergy` to the `--format` parameter:

    $&gt; sacct --format="jobid,jobname,ntasks,submit,start,end,ConsumedEnergy,nodelist,state" -j 3967027
           JobID    JobName   NTasks              Submit               Start                 End ConsumedEnergy        NodeList      State 
    ------------ ---------- -------- ------------------- ------------------- ------------------- -------------- --------------- ---------- 
    3967027            bash          2014-01-07T12:25:42 2014-01-07T12:25:52 2014-01-07T12:41:20                    taurusi1159  COMPLETED 
    3967027.0         sleep        1 2014-01-07T12:26:07 2014-01-07T12:26:07 2014-01-07T12:26:18              0     taurusi1159  COMPLETED 
    3967027.1         sleep        1 2014-01-07T12:29:06 2014-01-07T12:29:06 2014-01-07T12:29:16          1.67K     taurusi1159  COMPLETED 
    3967027.2         sleep        1 2014-01-07T12:33:25 2014-01-07T12:33:25 2014-01-07T12:33:36          1.84K     taurusi1159  COMPLETED 
    3967027.3         sleep        1 2014-01-07T12:34:06 2014-01-07T12:34:06 2014-01-07T12:34:11          1.09K     taurusi1159  COMPLETED 
    3967027.4         sleep        1 2014-01-07T12:38:03 2014-01-07T12:38:03 2014-01-07T12:39:44         18.93K     taurusi1159  COMPLETED  

The job consisted of 5 job steps, each executing a sleep of a different
length. Note that the ConsumedEnergy metric is only applicable to
exclusive jobs.

### 

### Slurm Energy Profiling

The `srun` tool offers several options for profiling job steps by adding
the `--profile` parameter. Possible profiling options are `All`,
`Energy`, `Task`, `Lustre`, and `Network`. In all cases, the profiling
information is stored in an hdf5 file that can be inspected using
available hdf5 tools, e.g., `h5dump`. The files are stored under
`/scratch/profiling/` for each job, job step, and node. A description of
the data fields in the file can be found
[here](http://slurm.schedmd.com/hdf5_profile_user_guide.html#HDF5). In
general, the data files contain samples of the current **power**
consumption on a per-second basis:

    $&gt; srun -p sandy --acctg-freq=2,energy=1 --profile=energy  sleep 10 
    srun: job 3967674 queued and waiting for resources
    srun: job 3967674 has been allocated resources
    $&gt; h5dump /scratch/profiling/jschuch/3967674_0_taurusi1073.h5
    [...]
                   DATASET "Energy_0000000002 Data" {
                      DATATYPE  H5T_COMPOUND {
                         H5T_STRING {
                            STRSIZE 24;
                            STRPAD H5T_STR_NULLTERM;
                            CSET H5T_CSET_ASCII;
                            CTYPE H5T_C_S1;
                         } "Date_Time";
                         H5T_STD_U64LE "Time";
                         H5T_STD_U64LE "Power";
                         H5T_STD_U64LE "CPU_Frequency";
                      }
                      DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
                      DATA {
                      (0): {
                            "",
                            1389097545,  # timestamp
                            174,         # power value
                            1
                         }
                      }
                   }

## 

## Using the HDEEM C API

Note: Please specify -p haswell --exclusive along with your job request
if you wish to use hdeem.

Please download the offical documentation at \<font face="Calibri"
size="2"> [\<font
color="#0563C1">\<u>http://www.bull.com/download-hdeem-library-reference-guide\</u>\</font>](http://www.bull.com/download-hdeem-library-reference-guide)\</font>

The HDEEM headers and sample code are made available via the hdeem
module. To find the location of the hdeem installation use

    % module show hdeem
    ------------------------------------------------------------------- 
    /sw/modules/taurus/libraries/hdeem/2.1.9ms: 

    conflict         hdeem  
    module-whatis    Load hdeem version 2.1.9ms  
    prepend-path     PATH /sw/taurus/libraries/hdeem/2.1.9ms/include  
    setenv           HDEEM_ROOT /sw/taurus/libraries/hdeem/2.1.9ms 
    -------------------------------------------------------------------

You can find an example of how to use the API under
\<span>$HDEEM_ROOT/sample.\</span>

## Access Using the Dataheap Infrastructure

In addition to the energy accounting data that is stored by Slurm, this
information is also written into our local data storage and analysis
infrastructure called
[Dataheap](http://tu-dresden.de/die_tu_dresden/zentrale_einrichtungen/zih/forschung/projekte/dataheap/).
From there, the data can be used in various ways, such as including it
into application performance trace data or querying through a Python
interface.

The Dataheap infrastructure is designed to store various types of
time-based samples from different data sources. In the case of the
energy measurements on Taurus, the data is stored as a timeline of power
values which allows the reconstruction of the power and energy
consumption over time. The timestamps are stored as UNIX timestamps with
a millisecond granularity. The data is stored for each node in the form
of `nodename/watts`, e.g., `taurusi1073/watts`. Further metrics might
already be available or might be added in the future for which
information is available upon request.

**Note**: The dataheap infrastructure can only be accessed from inside
the university campus network.

### Using the Python Interface

The module `dataheap/1.0` provides a Python module that can be used to
query the data in the Dataheap for personalized data analysis. The
following is an example of how to use the interface:

    import time
    import os
    from dhRequest import dhClient

    # Connect to the dataheap manager
    dhc = dhClient()
    dhc.connect(os.environ['DATAHEAP_MANAGER_ADDR'], int(os.environ['DATAHEAP_MANAGER_PORT']))

    # take timestamps
    tbegin = dhc.getTimeStamp() 
    # workload
    os.system("srun -n 6 a.out")
    tend   = dhc.getTimeStamp()

    # wait for the data to get to the
    # dataheap
    time.sleep(5)

    # replace this with name of the node the job ran on
    # Note: use multiple requests if the job used multiple nodes
    countername = "taurusi1159/watts"

    # query the dataheap
    integral = dhc.storageRequest("INTEGRAL(%d,%d,\"%s\", 0)"%(tbegin, tend, countername))
    # Remember: timestamps are stored in millisecond UNIX timestamps
    energy   = integral/1000

    print energy

    timeline = dhc.storageRequest("TIMELINE(%d,%d,\"%s\", 0)"%(tbegin, tend, countername))

    # output a list of all timestamp/power-value pairs
    print timeline

## More information and Citing

More information can be found in the paper \<a
href="<http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=7016382>"
title="HDEEM Paper E2SC 2014">HDEEM: high definition energy efficiency
monitoring\</a> by Hackenberg et al. Please cite this paper if you are
using HDEEM for your scientific work.
