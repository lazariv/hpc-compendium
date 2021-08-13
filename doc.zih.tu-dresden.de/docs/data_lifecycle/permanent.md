# Permanent File Systems

Do not use permanent file systems as work directories:

- Even temporary files are kept in the snapshots and in the backup tapes over a long time,
senseless filling the disks,
- By the sheer number and volume of work files they may keep the backup from working efficiently.

## Global /home File System

Each user has 50 GB in a `/home` directory independent of the granted capacity for the project.
This file system is mounted with read-write permissions on all HPC systems.

Hints for the usage of the global home directory:

- If you need distinct `.bashrc` files for each machine, you should
  create separate files for them, named `.bashrc_<machine_name>`

If a user exceeds her/his quota (total size OR total number of files) she/he cannot
submit jobs into the batch system. Running jobs are not affected.

!!! note

     We have no feasible way to get the contribution of
     a single user to a project's disk usage.

## Global /projects File System

For project data, we have a global project directory, that allows better collaboration between the
members of an HPC project.
Typically, all members of the project have read/write access to that directory.
It can only be written to on the login and export nodes.

!!! note

   On compute nodes, /projects is mounted as read-only, because it must not be used as
   work directory and heavy I/O.

## Snapshots

A changed file can always be recovered as it was at the time of the snapshot.
These snapshots are taken (subject to changes):

- from Monday through Saturday between 06:00 and 18:00 every two hours and kept for one day
  (7 snapshots)
- from Monday through Saturday at 23:30 and kept for two weeks (12 snapshots)
- every Sunday st 23:45 and kept for 26 weeks.

To restore a previous version of a file:

- Go into the directory of the file you want to restore
- Run `cd .snapshot` (this subdirectory exists in every directory on the `/home` file system
  although it is not visible with `ls -a`).
- In the .snapshot-directory are all available snapshots listed.
- Just `cd` into the directory of the point in time you wish to restore and copy the file you
  wish to restore to where you want it.

!!! note

    The `.snapshot` directory is embedded in a different directory structure. An `ls ../..` will not show the directory
    where you came from. Thus, for your `cp`, you should *use an absolute path* as destination.

## Backup

Just for the eventuality of a major file system crash we keep tape-based backups of our
permanent file systems for 180 days.

## Quotas

The quotas of the permanent file system are meant to help the users to keep in touch with their data.
Especially in HPC, it happens that millions of temporary files are created within hours. This is the
main reason for performance degradation of the file system.

!!! note

    If a quota is exceeded - project or home - (total size OR total number of files) 
    job submission is forbidden. Running jobs are not affected. 

The following commands can be used for monitoring:

- `showquota` shows your projects' usage of the file system.
- `quota -s -f /home` shows the user's usage of the file system.

In case a quota is above it's limits:

  - Remove core dumps and temporary data
  - Talk with your colleagues to identify the hotspots,
  - Check your workflow and use /tmp or the scratch file systems for temporary files
  - *Systematically* handle your important data:
    - For later use (weeks...months) at the HPC systems, build and zip tar
      archives with meaningful names or IDs and store e.g. them in a workspace in the
      [warm archive](warm_archive.md) or an [archive](intermediate_archive.md).
    - Refer to the hints for [long term preservation for research data](preservation_research_data.md)
