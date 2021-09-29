# Changes in the CXFS Filesystem

!!! warning

    This page is outdated!

With the ending support from SGI, the CXFS filesystem will be separated from its tape library by
the end of March, 2013.

This filesystem is currently mounted at

* SGI Altix: `/fastfs/`
* Atlas: `/hpc_fastfs/`

We kindly ask our users to remove their large data from the filesystem.
Files worth keeping can be moved

* to the new [Intermediate Archive](../data_lifecycle/intermediate_archive.md) (max storage
    duration: 3 years) - see
    [MigrationHints](#migration-from-cxfs-to-the-intermediate-archive) below,
* or to the [Log-term Archive](../data_lifecycle/preservation_research_data.md) (tagged with
    metadata).

To run the filesystem without support comes with the risk of losing data. So, please store away
your results into the Intermediate Archive. `/fastfs` might on only be used for really temporary
data, since we are not sure if we can fully guarantee the availability and the integrity of this
filesystem, from then on.

With the new HRSK-II system comes a large scratch filesystem with approximately 800 TB disk space.
It will be made available for all running HPC systems in due time.

## Migration from CXFS to the Intermediate Archive

Data worth keeping shall be moved by the users to the directory
`archive_migration`, which can be found in your project's and your
personal `/fastfs` directories:

* `/fastfs/my_login/archive_migration`
* `/fastfs/my_project/archive_migration`

**Attention:** Exclusively use the command `mv`. Do **not** use `cp` or `rsync`, for they will store
a second version of your files in the system.

Please finish this by the end of January. Starting on Feb/18/2013, we will step by step transfer
these directories to the new hardware.
