# Introduction

`perf` consists of two parts: the kernel space implementation and the userland tools. This wiki
entry focusses on the latter. These tools are installed on ZIH systems, and others and provides
support for sampling applications and reading performance counters.

## Configuration

Admins can change the behaviour of the perf tools kernel part via the
following interfaces

|                                             |                                                                                                                                   |
|---------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| File Name                                   | Description                                                                                                                       |
| `/proc/sys/kernel/perf_event_max_sample_rate` | describes the maximal sample rate for perf record and native access. This is used to limit the performance influence of sampling. |
| `/proc/sys/kernel/perf_event_mlock_kb`        | defines the number of pages that can be used for sampling via perf record or the native interface                                 |
| `/proc/sys/kernel/perf_event_paranoid`        | defines access rights:                                                                                                            |
|                                             | -1 - Not paranoid at all                                                                                                          |
|                                             | 0 - Disallow raw tracepoint access for unpriv                                                                                     |
|                                             | 1 - Disallow cpu events for unpriv                                                                                                |
|                                             | 2 - Disallow kernel profiling for unpriv                                                                                          |
| `/proc/sys/kernel/kptr_restrict`              | Defines whether the kernel address maps are restricted                                                                            |

## Perf Stat

`perf stat` provides a general performance statistic for a program. You
can attach to a running (own) process, monitor a new process or monitor
the whole system. The latter is only available for root user, as the
performance data can provide hints on the internals of the application.

### For Users

Run `perf stat <Your application>`. This will provide you with a general
overview on some counters.

```Bash
Performance counter stats for 'ls':=
          2,524235 task-clock                #    0,352 CPUs utilized
                15 context-switches          #    0,006 M/sec
                 0 CPU-migrations            #    0,000 M/sec
               292 page-faults               #    0,116 M/sec
         6.431.241 cycles                    #    2,548 GHz
         3.537.620 stalled-cycles-frontend   #   55,01% frontend cycles idle
         2.634.293 stalled-cycles-backend    #   40,96% backend  cycles idle
         6.157.440 instructions              #    0,96  insns per cycle
                                             #    0,57  stalled cycles per insn
         1.248.527 branches                  #  494,616 M/sec
            34.044 branch-misses             #    2,73% of all branches
       0,007167707 seconds time elapsed
```

- Generally speaking **task clock** tells you how parallel your job
  has been/how many cpus were used.
- **[Context switches](http://en.wikipedia.org/wiki/Context_switch)**
  are an information about how the scheduler treated the application.  Also interrupts cause context
  switches. Lower is better.
- **CPU migrations** are an information on whether the scheduler moved
  the application between cores. Lower is better. Please pin your programs to CPUs to avoid
  migrations. This can be done with environment variables for OpenMP and MPI, with `likwid-pin`,
  `numactl` and `taskset`.
- [Page faults](http://en.wikipedia.org/wiki/Page_fault) describe
  how well the Translation Lookaside Buffers fit for the program.  Lower is better.
- **Cycles** tells you how many CPU cycles have been spent in
  executing the program. The normalized value tells you the actual average frequency of the CPU(s)
  running the application.
- **stalled-cycles-...** tell you how well the processor can execute
  your code. Every stall cycle is a waste of CPU time and energy. The reason for such stalls can be
  numerous. It can be wrong branch predictions, cache misses, occupation of CPU resources by long
  running instructions and so on. If these stall cycles are to high you might want to review your
  code.
- The normalized **instructions** number tells you how well your code
  is running. More is better. Current x86 CPUs can run 3 to 5 instructions per cycle, depending on
  the instruction mix. A count of less then 1 is not favorable. In such a case you might want to
  review your code.
- **branches** and **branch-misses** tell you how many jumps and loops
  are performed in your code. Correctly [predicted](http://en.wikipedia.org/wiki/Branch_prediction)
  branches should not hurt your performance, **branch-misses** on the other hand hurt your
  performance very badly and lead to stall cycles.
- Other events can be passed with the `-e` flag. For a full list of
  predefined events run `perf list`
- PAPI runs on top of the same infrastructure as `perf stat`, so you
  might want to use their meaningful event names. Otherwise you can use raw events, listed in the
  processor manuals.

### For Admins

Administrators can run a system wide performance statistic, e.g., with `perf stat -a sleep 1` which
measures the performance counters for the whole computing node over one second.

## Perf Record

`perf record` provides the possibility to sample an application or a system. You can find
performance issues and hot parts of your code. By default perf record samples your program at a 4000
Hz. It records CPU, Instruction Pointer and, if you specify it, the call chain. If your code runs
long (or often) enough, you can find hot spots in your application and external libraries. Use
**perf report** to evaluate the result. You should have debug symbols available, otherwise you won't
be able to see the name of the functions that are responsible for your load. You can pass one or
multiple events to define the **sampling event**.

**What is a sampling event?** Sampling reads values at a specific sampling frequency. This
frequency is usually static and given in Hz, so you have for example 4000 events per second and a
sampling frequency of 4000 Hz and a sampling rate of 250 microseconds. With the sampling event, the
concept of a static sampling frequency in time is somewhat redefined. Instead of a constant factor
in time (sampling rate) you define a constant factor in events. So instead of a sampling rate of 250
microseconds, you have a sampling rate of 10,000 floating point operations.

**Why would you need sampling events?** Passing an event allows you to find the functions
that produce cache misses, floating point operations, ... Again, you can use events defined in `perf
list` and raw events.

Use the `-g` flag to receive a call graph.

### For Users

Just run `perf record ./myapp` or attach to a running process.

#### Using Perf with MPI

Perf can also be used to record data for indivdual MPI processes. This requires a wrapper script
(`perfwrapper`) with the following content. Also make sure that the wrapper script is executable
(`chmod +x`).

```Bash
#!/bin/bash
perf record -o perf.data.$SLURM_JOB_ID.$SLURM_PROCID $@
```

To start the MPI program type `srun ./perfwrapper ./myapp` on your command line. The result will be
n independent perf.data files that can be analyzed individually with perf report.

### For Admins

This tool is very effective, if you want to help users find performance problems and hot-spots in
their code but also helps to find OS daemons that disturb such applications. You would start `perf
record -a -g` to monitor the whole node.

## Perf Report

`perf report` is a command line UI for evaluating the results from perf record. It creates something
like a profile from the recorded samplings.  These profiles show you what the most used have been.
If you added a callchain, it also gives you a callchain profile.\<br /> \*Disclaimer: Sampling is
not an appropriate way to gain exact numbers. So this is merely a rough overview and not guaranteed
to be absolutely correct.\*\<span style="font-size: 1em;"> \</span>

### On ZIH systems

On ZIH systems, users are not allowed to see the kernel functions. If you have multiple events
defined, then the first thing you select in `perf report` is the type of event. Press right

```Bash
Available samples
96 cycles
11 cache-misse
```

**Hints:**

* The more samples you have, the more exact is the profile. 96 or
11 samples is not enough by far.
* Repeat the measurement and set `-F 50000` to increase the sampling frequency.
* The higher the frequency, the higher the influence on the measurement.

If you'd select cycles, you would get such a screen:

```Bash
Events: 96  cycles
+  49,13%  test_gcc_perf  test_gcc_perf      [.] main.omp_fn.0
+  34,48%  test_gcc_perf  test_gcc_perf      [.]
+   6,92%  test_gcc_perf  test_gcc_perf      [.] omp_get_thread_num@plt
+   5,20%  test_gcc_perf  libgomp.so.1.0.0   [.] omp_get_thread_num
+   2,25%  test_gcc_perf  test_gcc_perf      [.] main.omp_fn.1
+   2,02%  test_gcc_perf  [kernel.kallsyms]  [k] 0xffffffff8102e9ea
```

Increased sample frequency:

```Bash
Events: 7K cycles
+  42,61%  test_gcc_perf  test_gcc_perf      [.] p
+  40,28%  test_gcc_perf  test_gcc_perf      [.] main.omp_fn.0
+   6,07%  test_gcc_perf  test_gcc_perf      [.] omp_get_thread_num@plt
+   5,95%  test_gcc_perf  libgomp.so.1.0.0   [.] omp_get_thread_num
+   4,14%  test_gcc_perf  test_gcc_perf      [.] main.omp_fn.1
+   0,69%  test_gcc_perf  [kernel.kallsyms]  [k] 0xffffffff8102e9ea
+   0,04%  test_gcc_perf  ld-2.12.so         [.] check_match.12442
+   0,03%  test_gcc_perf  libc-2.12.so       [.] printf
+   0,03%  test_gcc_perf  libc-2.12.so       [.] vfprintf
+   0,03%  test_gcc_perf  libc-2.12.so       [.] __strchrnul
+   0,03%  test_gcc_perf  libc-2.12.so       [.] _dl_addr
+   0,02%  test_gcc_perf  ld-2.12.so         [.] do_lookup_x
+   0,01%  test_gcc_perf  libc-2.12.so       [.] _int_malloc
+   0,01%  test_gcc_perf  libc-2.12.so       [.] free
+   0,01%  test_gcc_perf  libc-2.12.so       [.] __sigprocmask
+   0,01%  test_gcc_perf  libgomp.so.1.0.0   [.] 0x87de
+   0,01%  test_gcc_perf  libc-2.12.so       [.] __sleep
+   0,01%  test_gcc_perf  ld-2.12.so         [.] _dl_check_map_versions
+   0,01%  test_gcc_perf  ld-2.12.so         [.] local_strdup
+   0,00%  test_gcc_perf  libc-2.12.so       [.] __execvpe
```

Now you select the most often sampled function and zoom into it by pressing right. If debug symbols
are not available, perf report will show which assembly instruction is hit most often when sampling.
If debug symbols are available, it will also show you the source code lines for these assembly
instructions. You can also go back and check which instruction caused the cache misses or whatever
event you were passing to perf record.

## Perf Script

If you need a trace of the sampled data, you can use `perf script` command, which by default prints
all samples to stdout. You can use various interfaces (e.g., python) to process such a trace.

## Perf Top

`perf top` is only available for admins, as long as the paranoid flag is not changed (see
configuration).

It behaves like the `top` command, but gives you not only an overview of the processes and the time
they are consuming but also on the functions that are processed by these.
