# Permanent File Systems

## Global /home File System

Each user has 50 GB in a `/home` directory independent of the granted capacity for the project.
Hints for the usage of the global home directory:

- If you need distinct `.bashrc` files for each machine, you should
  create separate files for them, named `.bashrc_<machine_name>`
- If you use various machines frequently, it might be useful to set
  the environment variable HISTFILE in `.bashrc_deimos` and
  `.bashrc_mars` to `$HOME/.bash_history_<machine_name>`. Setting
  HISTSIZE and HISTFILESIZE to 10000 helps as well.
- Further, you may use private module files to simplify the process of
  loading the right installation directories, see
  **todo link: private modules - AnchorPrivateModule**.

## Global /projects File System

For project data, we have a global project directory, that allows better collaboration between the
members of an HPC project. However, for compute nodes /projects is mounted as read-only, because it
is not a filesystem for parallel I/O. See below and also check the
**todo link: HPC introduction - %PUBURL%/Compendium/WebHome/HPC-Introduction.pdf** for more details.

## Backup and Snapshots of the File System

- Backup is **only** available in the `/home` and the `/projects` file systems!
- Files are backed up using snapshots of the NFS server and can be restored by the user
- A changed file can always be recovered as it was at the time of the snapshot
- Snapshots are taken:
  - From Monday through Saturday between 06:00 and 18:00 every two hours and kept for one day
    (7 snapshots)
  - From Monday through Saturday at 23:30 and kept for two weeks (12 snapshots)
  - Every Sunday st 23:45 and kept for 26 weeks
- To restore a previous version of a file:
  - Go into the directory of the file you want to restore
  - Run `cd .snapshot` (this subdirectory exists in every directory on the `/home` file system
    although it is not visible with `ls -a`)
  - In the .snapshot-directory are all available snapshots listed
  - Just `cd` into the directory of the point in time you wish to restore and copy the file you
    wish to restore to where you want it
  - **Attention** The `.snapshot` directory is not only hidden from normal view (`ls -a`), it is
    also embedded in a different directory structure. An `ls ../..` will not list the directory
    where you came from. Thus, we recommend to copy the file from the location where it
    originally resided:
    `pwd /home/username/directory_a % cp .snapshot/timestamp/lostfile lostfile.backup`
- `/home` and `/projects/` are definitely NOT made as a work directory:
  since all files are kept in the snapshots and in the backup tapes over a long time, they
  - Senseless fill the disks and
  - Prevent the backup process by their sheer number and volume from working efficiently.

## Group Quotas for the File System

The quotas of the home file system are meant to help the users to keep in touch with their data.
Especially in HPC, it happens that millions of temporary files are created within hours. This is the
main reason for performance degradation of the file system. If a project exceeds its quota (total
size OR total number of files) it cannot submit jobs into the batch system. The following commands
can be used for monitoring:

- `showquota` shows your projects' usage of the file system.
- `quota -s -f /home` shows the user's usage of the file system.

In case a project is above it's limits please ...

- Remove core dumps, temporary data
- Talk with your colleagues to identify the hotspots,
- Check your workflow and use /tmp or the scratch file systems for temporary files
- *Systematically* handle your important data:
  - For later use (weeks...months) at the HPC systems, build tar
    archives with meaningful names or IDs and store e.g. them in an
    [archive](intermediate_archive.md).
  - Refer to the hints for [long term preservation for research data](preservation_research_data.md)
  