# Quotas for the home file system

The quotas of the home file system are meant to help the users to keep in touch with their data.
Especially in HPC, millions of temporary files can be created within hours. We have identified this
as a main reason for performance degradation of the HOME file system. To stay in operation with out
HPC systems we regrettably have to fall back to this unpopular technique.

Based on a balance between the allotted disk space and the usage over the time, reasonable quotas
(mostly above current used space) for the projects have been defined. The will be activated by the
end of April 2012.

If a project exceeds its quota (total size OR total number of files) it cannot submit jobs into the
batch system. Running jobs are not affected.  The following commands can be used for monitoring:

-   `quota -s -g` shows the file system usage of all groups the user is
    a member of.
-   `showquota` displays a more convenient output. Use `showquota -h` to
    read about its usage. It is not yet available on all machines but we
    are working on it.

**Please mark:** We have no quotas for the single accounts, but for the
project as a whole. There is no feasible way to get the contribution of
a single user to a project's disk usage.

## Alternatives

In case a project is above its limits, please

-   remove core dumps, temporary data,
-   talk with your colleagues to identify the hotspots,
-   check your workflow and use /fastfs for temporary files,
-   *systematically* handle your important data:
    -   for later use (weeks...months) at the HPC systems, build tar
        archives with meaningful names or IDs and store them in the
        [DMF system](#AnchorDataMigration). Avoid using this system
        (`/hpc_fastfs`) for files < 1 MB!
    -   refer to the hints for
        [long term preservation for research data](../data_management/PreservationResearchData.md).

## No Alternatives

The current situation is this:

-   `/home` provides about 50 TB of disk space for all systems. Rapidly
    changing files (temporary data) decrease the size of usable disk
    space since we keep all files in multiple snapshots for 26 weeks. If
    the *number* of files comes into the range of a million the backup
    has problems handling them.
-   The work file system for the clusters is `/fastfs`. Here, we have 60
    TB disk space (without backup). This is the file system of choice
    for temporary data.
-   About 180 projects have to share our resources, so it makes no sense
    at all to simply move the data from `/home` to `/fastfs` or to
    `/hpc_fastfs`.

In case of problems don't hesitate to ask for support.
