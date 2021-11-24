# Performance Analysis of HPC Applications with PIKA

PIKA is a hardware performance monitoring stack to identify inefficient HPC jobs. Users of ZIH
systems have the possibility to visualize and analyze the efficiency of their jobs via the
[PIKA web interface](https://selfservice.zih.tu-dresden.de/l/index.php/hpcportal/jobmonitoring/z../jobs_and_resources).

!!! hint

    To understand this small guide, it is recommended to open the
    [web interface](https://selfservice.zih.tu-dresden.de/l/index.php/hpcportal/jobmonitoring/z../jobs_and_resources)
    in a separate window. Furthermore, at least one real HPC job should have been submitted.

## Overview

PIKA consists of several components and tools. It uses the collection daemon collectd, InfluxDB to
store time-series data and MariaDB to store job metadata. Furthermore, it provides a powerful
[web interface](https://selfservice.zih.tu-dresden.de/l/index.php/hpcportal/jobmonitoring/z../jobs_and_resources)
for the visualization and analysis of job performance data.

## Table View and Job Search

The analysis of HPC jobs in PIKA is designed as a top-down approach. Starting from the table view,
users can either analyze running or completed jobs. They can navigate from groups of jobs with the
same name to the metadata of an individual job and finally investigate the job’s runtime metrics in
a timeline view.

To find jobs with specific properties, the table can be sorted by any column, e.g., by consumed CPU
hours to find jobs where an optimization has a large impact on the system utilization. Additionally,
there is a filter mask to find jobs that match several properties. When a job has been selected, the
timeline view opens.

## Timeline Visualization

PIKA provides timeline charts to visualize the resource utilization of a job over time. After a job
is completed, timeline charts can help to identify periods of inefficient resource usage. However,
they are also suitable for the live assessment of performance during the job’s runtime. In case of
unexpected performance behavior, users can cancel the job, thus avoiding long execution with subpar
performance.

PIKA provides the following runtime metrics:

|Metric| Hardware Unit|
|---|---|
|CPU Usage|CPU core|
|IPC (instructions per cycle)|CPU core|
|FLOPS (normalized to single precision) |CPU core|
|Main Memory Bandwidth|CPU socket|
|CPU Power|CPU socket|
|Main Memory Utilization|node|
|I/O Bandwidth (local, Lustre) |node|
|I/O Metadata (local, Lustre) |node|
|GPU Usage|GPU device|
|GPU Memory Utilization|GPU device|
|GPU Power Consumption|GPU device|
|GPU Temperature|GPU device|

Each monitored metric is represented by a timeline, whereby metrics with the same unit and data
source are displayed in a common chart, e.g., different Lustre metadata operations.  Each metric is
measured with a certain granularity concerning the hardware, e.g. per hardware thread, per CPU
socket or per node.

!!! hint

    Be aware that CPU socket or node metrics can share the resources of other jobs running on the
    same CPU socket or node. This can result e.g., in cache perturbation and thus a sub-optimal
    performance.  To get valid performance data for those metrics, it is recommended to submit an
    exclusive job!

!!! note

    To reduce the amount of recorded data, PIKA summarizes per hardware thread metrics to the
    corresponding physical core. In terms of simultaneous multithreading (SMT), PIKA only provides
    performance data per physical core.

The following table explains different timeline visualization modes.
By default, each timeline shows the average value over all hardware units (HUs) per measured interval.

|Visualization Mode| Description|
|---|---|
|Maximum |maximal value across all HUs per measured interval|
|Mean|mean value across all HUs per measured interval|
|Minimum |minimal value across all HUs per measured interval|
|Mean + Standard Deviation|mean value across all HUs including standard deviation per measured interval|
|Best|best average HU over time|
|Lowest|lowest average HU over time|

The visualization modes *Maximum*, *Mean*, and *Minimum* reveal the range in the utilization of
individual HUs per measured interval. A high deviation of the extrema from the mean value is a
reason for further investigation, since not all HUs are equally utilized.

To identify imbalances between HUs over time, the visualization modes *Best* and *Lowest* are a
first indicator how much the HUs differ in terms of resource usage. The timelines *Best* and
*Lowest* show the recorded performance data of the best/lowest average HU over time.

## Footprint Visualization

Complementary to the timeline visualization of one specific job, statistics on metadata and
footprints over multiple jobs or a group of jobs with the same name can be displayed with the
footprint view.  The performance footprint is a set of summarized run-time metrics that is generated
from the time series data for each job.  To limit the jobs displayed, a time period can be
specified.

To analyze the footprints of a larger number of jobs, a visualization with histograms and scatter
plots can be used. PIKA uses histograms to illustrate the number of jobs that fit into a category or
bin. For job states and job tags there is a fixed number of categories or values. For other
footprint metrics PIKA uses a binning with a user-configurable bin size, since the value range
usually contains an unlimited number of values.  A scatter plot enables the combined view of two
footprint metrics (except for job states and job tags), which is particularly useful for
investigating their correlation.

## Hints

If users wish to perform their own measurement of performance counters using performance tools other
than PIKA, it is recommended to disable PIKA monitoring. This can be done using the following Slurm
flags in the job script:

```Bash
#SBATCH --exclusive
#SBATCH --comment=no_monitoring
```

**Note:** Disabling PIKA monitoring is possible only for exclusive jobs!

## Known Issues

The PIKA metric FLOPS is not supported by the Intel Haswell cpu architecture.
However, PIKA provides this metric to show the computational intensity.
**Do not rely on FLOPS on Haswell!** We use the event `AVX_INSTS_CALC` which counts the `insertf128`
instruction.
