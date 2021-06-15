## Node features for selective job submission

The nodes in our HPC system are becoming more diverse in multiple
aspects: hardware, mounted storage, software. The system administrators
can decribe the set of properties and it is up to the user to specify
her/his requirements. These features should be thought of as changing
over time (e.g. a file system get stuck on a certain node).

A feature can be used with the Slurm option `--constrain` or `-C` like
"\<span>srun -C fs_lustre_scratch2 ...\</span>" with `srun` or `sbatch`.
Combinations like\<span class="WYSIWYG_TT">
--constraint="fs_beegfs_global0&DA"\</span> are allowed. For a detailed
description of the possible constraints, please refer to the Slurm
documentation (<https://slurm.schedmd.com/srun.html>).

**Remark:** A feature is checked only for scheduling. Running jobs are
not affected by changing features.

### Available features on Taurus

| feature | description                                                              |
|:--------|:-------------------------------------------------------------------------|
| DA      | subset of Haswell nodes with a high bandwidth to NVMe storage (island 6) |

#### File system features

A feature \<span class="WYSIWYG_TT">fs\_\* \</span>is active if a
certain file system is mounted and available on a node. Access to these
file systems are tested every few minutes on each node and the Slurm
features set accordingly.

| feature            | description                                                          |
|:-------------------|:---------------------------------------------------------------------|
| fs_lustre_scratch2 | /scratch mounted read-write (the OS mount point is /lustre/scratch2) |
| fs_lustre_ssd      | /lustre/ssd mounted read-write                                       |
| fs_warm_archive_ws | /warm_archive/ws mounted read-only                                   |
| fs_beegfs_global0  | /beegfs/global0 mounted read-write                                   |

For certain projects, specific file systems are provided. For those,
additional features are available, like `fs_beegfs_<projectname>`.
