# PAPI Library

Related work:

* [PAPI documentation](http://icl.cs.utk.edu/projects/papi/wiki/Main_Page)
* [Intel 64 and IA-32 Architectures Software Developers Manual (Per thread/per core PMCs)]
  (http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-system-programming-manual-325384.pdf)

Additional sources for **Haswell** Processors: [Intel Xeon Processor E5-2600 v3 Product Family Uncore
Performance Monitoring Guide (Uncore PMCs) - Download link]
(http://www.intel.com/content/www/us/en/processors/xeon/xeon-e5-v3-uncore-performance-monitoring.html)

## Introduction

PAPI enables users and developers to monitor how their code performs on a specific architecture. To
do so, they can register events that are counted by the hardware in performance monitoring counters
(PMCs). These counters relate to a specific hardware unit, for example a processor core. Intel
Processors used on taurus support eight PMCs per processor core. As the partitions on taurus are run
with HyperThreading Technology (HTT) enabled, each CPU can use four of these. In addition to the
**four core PMCs**, Intel processors also support **a number of uncore PMCs** for non-core
resources. (see the uncore manuals listed in top of this documentation).

## Usage

[Score-P](scorep.md) supports per-core PMCs. To include uncore PMCs into Score-P traces use the
software module **scorep-uncore/2016-03-29**on the Haswell partition. If you do so, disable
profiling to include the uncore measurements. This metric plugin is available at
[github](https://github.com/score-p/scorep_plugin_uncore/).

If you want to use PAPI directly in your software, load the latest papi module, which establishes
the environment variables **PAPI_INC**, **PAPI_LIB**, and **PAPI_ROOT**. Have a look at the
[PAPI documentation](http://icl.cs.utk.edu/projects/papi/wiki/Main_Page) for details on the usage.

## Related Software

* [Score-P](scorep.md)
* [Linux Perf Tools](perf_tools.md)

If you just need a short summary of your job, you might want to have a look at
[perf stat](perf_tools.md).
