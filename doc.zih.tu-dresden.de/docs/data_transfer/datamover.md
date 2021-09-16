# Transferring Files Between ZIH Systems

With the **datamover**, we provide a special data transfer machine for transferring data with best
trasnfer speed between the filesystems of ZIH systems. The datamover machine is not accessible
through SSH as it is dedicated to data transfers. To move or copy files from one filesystem to
another filesystem, you have to use the following commands:

- `dtcp`, `dtls`, `dtmv`, `dtrm`, `dtrsync`, `dttar`, and `dtwget`

These commands submit a [batch job](jobs_and_resources/slurm.md) to the data transfer machines
performing the selected command. Except the following options their syntax is the very same as the
wellknown shell commands without the prefix *dt*.

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

| ZIH system         | Local directory    | Directory on data transfer machine |
|:-------------------|:-------------------|:-----------------------------------|
| Taurus             | `/scratch/ws`      | `/scratch/ws`                      |
|                    | `/ssd/ws`          | `/ssd/ws`                          |
|                    | `/warm_archive/ws` | `/warm_archive/ws`                 |
|                    | `/home`            | `/home`                            |
|                    | `/projects`        | `/projects`                        |
| **Archive**        |                    | `/archiv`                          |
| **Group Storages** |                    | `/grp/\<group storage>`            |

## How to copy your data from an old scratch (Atlas, Triton, Venus) to our new scratch (Taurus)

You can use our tool called Datamover to copy your data from A to B.

    dtcp -r /scratch/<project or user>/<directory> /projects/<project or user>/<directory> # or
    dtrsync -a /scratch/<project or user>/<directory> /lustre/ssd/<project or user>/<directory>

Options for dtrsync:

    -a, --archive               archive mode; equals -rlptgoD (no -H,-A,-X)

    -r, --recursive             recurse into directories
    -l, --links                 copy symlinks as symlinks
    -p, --perms                 preserve permissions
    -t, --times                 preserve modification times
    -g, --group                 preserve group
    -o, --owner                 preserve owner (super-user only)
    -D                          same as --devices --specials

Example:

    dtcp -r /scratch/rotscher/results /luste/ssd/rotscher/ # or
    new: dtrsync -a /scratch/rotscher/results /home/rotscher/results

## Examples on how to use data transfer commands:

Copying data from Taurus' /scratch to Taurus' /projects

    % dtcp -r /scratch/jurenz/results/ /home/jurenz/

Moving data from Venus' /sratch to Taurus' /luste/ssd

    % dtmv /scratch/jurenz/results/ /lustre/ssd/jurenz/results

TGZ data from Taurus' /scratch to the Archive

    % dttar -czf /archiv/jurenz/taurus_results_20140523.tgz /scratch/jurenz/results

**%RED%Note:<span class="twiki-macro ENDCOLOR"></span>**Please do not
generate files in the archive much larger that 500 GB.

!!! hint

    The [warm archive](../data_lifecycle/warm_archive.md)) is not writable from within batch jobs.
    However, you can store the data in the warm archive with the datamover.
