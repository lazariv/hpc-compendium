# lo2s - Lightweight Node-Level Performance Monitoring

`lo2s` creates parallel OTF2 traces with a focus on both application and system view.
The traces can contain any of the following information:

* From running threads
    * Calling context samples based on instruction overflows
    * The calling context samples are annotated with the disassembled assembler instruction string
    * The frame pointer-based call-path for each calling context sample
    * Per-thread performance counter readings
    * Which thread was scheduled on which CPU at what time
* From the system
    * Metrics from tracepoints (e.g., the selected C-state or P-state)
    * The node-level system tree (CPUs (HW-threads), cores, packages)
    * CPU power measurements (x86_energy)
    * Microarchitecture specific metrics (x86_adapt, per package or core)
    * Arbitrary metrics through plugins (Score-P compatible)

In general, `lo2s` operates either in **process monitoring** or **system monitoring** mode.

With **process monitoring**, all information is grouped by each thread of a monitored process
group - it shows you *on which CPU is each monitored thread running*. `lo2s` either acts as a
prefix command to run the process (and also tracks its children) or `lo2s` attaches to a running
process.

In the **system monitoring** mode, information is grouped by logical CPU - it shows you
*which thread was running on a given CPU*. Metrics are also shown per CPU.

In both modes, `lo2s` always groups system-level metrics (e.g., tracepoints) by their respective
system hardware component.

## Usage

Only the basic usage is shown in this Wiki. For a more detailed explanation, refer to the
[Lo2s website](https://github.com/tud-zih-energy/lo2s).

Before using `lo2s`, set up the correct environment with

```console
marie@login$ module load lo2s
```

As `lo2s` is built upon [perf](perf_tools.md), its usage and limitations are very similar to that.
In particular, you can use `lo2s` as a prefix command just like `perf`. Even some of the command
line arguments are inspired by `perf`. The main difference to `perf` is that `lo2s` will output
a [Vampir trace](vampir.md), which allows a full-blown performance analysis almost like
[Score-P](scorep.md).

To record the behavior of an application, prefix the application run with `lo2s`. We recommend
using the double dash `--` to prevent mixing command line arguments between `lo2s` and the user
application. In the following example, we run `lo2s` on the application `sleep 2`.

```console
marie@compute$ lo2s --no-kernel -- sleep 2
[ lo2s: sleep 2  (0), 1 threads, 0.014082s CPU, 2.03315s total ]
[ lo2s: 5 wakeups, wrote 2.48 KiB lo2s_trace_2021-10-12T12-39-06 ]
```

This will record the application in the `process monitoring mode`. This means, the applications
process, its forked processes, and threads are recorded and can be analyzed using Vampir.
The main view will represent each process and thread over time. There will be a metric "CPU"
indicating for each process, on which CPU it was executed during the runtime.

## Required Permissions

By design, `lo2s` almost exclusively utilizes Linux Kernel facilities such as perf and tracepoints
to perform the application measurements. For security reasons, these facilities require special
permissions, in particular `perf_event_paranoid` and read permissions to the `debugfs` under
`/sys/kernel/debug`.

Luckily, for the `process monitoring mode` the default settings allow you to run `lo2s` just fine.
All you need to do is pass the `--no-kernel` parameter like in the example above.

For the `system monitoring mode` you can get the required permission with the Slurm parameter
`--exclusive`. (Note: Regardless of the actual requested processes per node, you will accrue
cpu-hours as if you had reserved all cores on the node.)

## Memory Requirements

When requesting memory for your jobs, you need to take into account that `lo2s` needs a substantial
amount of memory for its operation. Unfortunately, the amount of memory depends on the application.
The amount mainly scales with the number of processes spawned by the traced application. For each
processes, there is a fixed-sized buffer. This should be fine for a typical HPC application, but
can lead to extreme cases there the buffers are orders of magnitude larger than the resulting trace.
For instance, recording a CMake run, which spawns hundreds of processes, each running only for
a few milliseconds, leaving each buffer almost empty. Still, the buffers needs to be allocated
and thus require a lot of memory.

Given such a case, we recommend to use the `system monitoring mode` instead, as the memory in this
mode scales with the number of logical CPUs instead of the number of processes.

## Advanced Topic: System Monitoring

The `system monitoring mode` gives a different view. As the name implies, the focus isn't on processes
anymore, but the system as a whole. In particular, a trace recorded in this mode will show a timeline
for each logical CPU of the system. To enable this mode, you need to pass `-a` parameter.

```console
marie@compute$ lo2s -a
^C[ lo2s (system mode): monitored processes: 0, 0.136623s CPU, 13.7872s total ]
[ lo2s (system mode): 36 wakeups, wrote 301.39 KiB lo2s_trace_2021-11-01T09-44-31 ]
```

Note: As you can read in the above example, `lo2s` monitored zero processes even though it was run
in the `system monitoring mode`. Certainly, there are more than none processes running on a system.
However, as the user accounts on our HPC systems are limited to only see their own processes and `lo2s`
records in the scope of the user, it will only see the users own processes. Hence, in the example
above, there are no other processes running.

When using the `system monitoring mode` without passing a program, `lo2s` will run indefinitely.
You can stop the measurement by sending `lo2s` a `SIGINT` signal or hit `ctrl+C`. However, if you pass
a program, `lo2s` will start that program and run the measurement until the started process finishes.
Of course, the process and any of its child processes and threads will be visible in the resulting trace.

```console
marie@compute$ lo2s -a -- sleep 10
[ lo2s (system mode): sleep 10  (0), 1 threads, monitored processes: 1, 0.133598s CPU, 10.3996s total ]
[ lo2s (system mode): 39 wakeups, wrote 280.39 KiB lo2s_trace_2021-11-01T09-55-04 ]
```

Like in the `process monitoring mode`, `lo2s` can also sample instructions in the system monitoring mode.
You can enable the instruction sampling by passing the parameter `--instruction-sampling` to `lo2s`.

```console
marie@compute$ lo2s -a --instruction-sampling -- make -j
[ lo2s (system mode): make -j  (0), 268 threads, monitored processes: 286, 258.789s CPU, 445.076s total ]
[ lo2s (system mode): 3815 wakeups, wrote 39.24 MiB lo2s_trace_2021-10-29T15-08-44 ]
```

## Advanced Topic: Metric Plugins

`Lo2s` is compatible with [Score-P](scorep.md) metric plugins, but only a subset will work.
In particular, `lo2s` only supports asynchronous plugins with the per host or once scope.
You can find a large set of plugins in the [Score-P Organization on GitHub](https://github.com/score-p).

To activate plugins, you can use the same environment variables as with Score-P, or with `LO2S` as
prefix:

  - LO2S_METRIC_PLUGINS
  - LO2S_METRIC_PLUGIN
  - LO2S_METRIC_PLUGIN_PLUGIN
