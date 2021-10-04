# Transferring Files Between ZIH Systems

With the **datamover**, we provide a special data transfer machine for transferring data with best
transfer speed between the filesystems of ZIH systems. The datamover machine is not accessible
through SSH as it is dedicated to data transfers. To move or copy files from one filesystem to
another filesystem, you have to use the following commands:

- `dtcp`, `dtls`, `dtmv`, `dtrm`, `dtrsync`, `dttar`, and `dtwget`

These commands submit a [batch job](../jobs_and_resources/slurm.md) to the data transfer machines
performing the selected command. Except the following options their syntax is the very same as the
well-known shell commands without the prefix *dt*.

| Additional Option   | Description                                                                   |
|---------------------|-------------------------------------------------------------------------------|
| `--account=ACCOUNT` | Assign data transfer job to specified account.                                |
| `--blocking       ` | Do not return until the data transfer job is complete. (default for `dtls`)   |
| `--time=TIME      ` | Job time limit (default: 18 h).                                               |

## Managing Transfer Jobs

There are the commands `dtinfo`, `dtqueue`, `dtq`, and `dtcancel` to manage your transfer commands
and jobs.

* `dtinfo` shows information about the nodes of the data transfer machine (like `sinfo`).
* `dtqueue` and `dtq` show all your data transfer jobs (like `squeue -u $USER`).
* `dtcancel` signals data transfer jobs (like `scancel`).

To identify the mount points of the different filesystems on the data transfer machine, use
`dtinfo`. It shows an output like this:

| ZIH system         | Local directory      | Directory on data transfer machine |
|:-------------------|:---------------------|:-----------------------------------|
| Taurus             | `/scratch/ws`        | `/scratch/ws`                      |
|                    | `/ssd/ws`            | `/ssd/ws`                          |
|                    | `/beegfs/global0/ws` | `/beegfs/global0/ws`               |
|                    | `/warm_archive/ws`   | `/warm_archive/ws`                 |
|                    | `/home`              | `/home`                            |
|                    | `/projects`          | `/projects`                        |
| **Archive**        |                      | `/archive`                         |
| **Group storage**  |                      | `/grp/<group storage>`             |

## Usage of Datamover

!!! example "Copying data from `/beegfs/global0` to `/projects` filesystem."

    ``` console
    marie@login$ dtcp -r /beegfs/global0/ws/marie-workdata/results /projects/p_marie/.
    ```

!!! example "Moving data from `/beegfs/global0` to `/warm_archive` filesystem."

    ``` console
    marie@login$ dtmv /beegfs/global0/ws/marie-workdata/results /warm_archive/ws/marie-archive/.
    ```

!!! example "Archive data from `/beegfs/global0` to `/archiv` filesystem."

    ``` console
    marie@login$ dttar -czf /archiv/p_marie/results.tgz /beegfs/global0/ws/marie-workdata/results
    ```

!!! warning
    Do not generate files in the `/archiv` filesystem much larger that 500 GB!

!!! note
    The [warm archive](../data_lifecycle/warm_archive.md) and the `projects` filesystem are not
    writable from within batch jobs.
    However, you can store the data in the `warm_archive` using the datamover.
