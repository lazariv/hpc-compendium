# Batch System on the Windows HPC Server

!!! warning

    This page is deprecated. The Windwos HPC Server is a former system.

The graphical user interface to the Windows batch system is the *HPC Job Manager*. You can find this
resource under *Start -> Programs -> Microsoft HPC Pack -> HPC Job Manager*.

## Job Submission

To create a new job click at one of the job dialog items in the *Actions* submenu *Job Submission*
and specify your job requirements in the job dialog.

It is advisable to give your job an unique name for distinguishing
reasons during the job monitoring phase.

### Job Types

- **Job**: The Job is the convenient way to create a batch job where
  you want to specify all job requirements in detail. It is also
  possible to create a job that consists of multiple task. If you have
  dependencies between your tasks, e.g. task b should only be started
  if task a has finished you can specify these dependencies in the
  submenu item task list in the job dialog.
- **Single-Task Job**: The Single-Task Job is the easiest way to
  create a batch job that consists only of one task. In addition you
  can specify the number of cores that should be used, the working
  directory and job input and output files.
- **Parametric Sweep Job**: The Parametric Sweep Job allows the user
  to create a sweep job where the tasks only differ in one input
  parameter. For this parameter the user can specify the start, end
  and the increment value. With this description the job will consists
  of (end-start)/increment individual task, which will be placed on
  all free cores of the cluster.

### Working Directories

- `C:\htitan\<LoginName>`
- `C:\titan\HOME_(TITAN)\<LoginName>`
- `\\titan\hpcms-files\HOME_(TITAN)\<LoginName>`
- `\\hpcms\hpcms-files\HOME_(TITAN)\<LoginName>`
- `Z:\HOME_(TITAN)\<LoginName>` (only available at login node)

### Job Queues

The queues are named job templates and can be chosen in the job submission dialog.

### Titan

At the moment there are two queues both without a runtime and/or core limitation.

| Batch Queue    | Admitted Users   | Available CPUs    | Default Runtime | Max. Runtime |
|:---------------|:-----------------|:------------------|:----------------|:-------------|
| `Default`      | `all`            | `min. 1, max. 64` | `none`          | `none`       |
| `VampirServer` | `selected users` | `min. 1, max. 72` | `none`          | `none`       |

### Job Monitoring

The status of the jobs is visible via the Job Management submenu. Via the context menu more detailed
information of a job is available.
