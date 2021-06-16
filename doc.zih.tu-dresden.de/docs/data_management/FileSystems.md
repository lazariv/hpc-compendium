File systems



## Permanent file systems

### Global /home file system

Each user has 50 GB in his /home directory independent of the granted
capacity for the project. Hints for the usage of the global home
directory:

-   If you need distinct `.bashrc` files for each machine, you should
    create separate files for them, named `.bashrc_<machine_name>`
-   If you use various machines frequently, it might be useful to set
    the environment variable HISTFILE in `.bashrc_deimos` and
    `.bashrc_mars` to `$HOME/.bash_history_<machine_name>`. Setting
    HISTSIZE and HISTFILESIZE to 10000 helps as well.
-   Further, you may use private module files to simplify the process of
    loading the right installation directories, see [private
    modules](#AnchorPrivateModule).

### Global /projects file system

For project data, we have a global project directory, that allows better
collaboration between the members of an HPC project. However, for
compute nodes /projects is mounted as read-only, because it is not a
filesystem for parallel I/O. See below and also check the [HPC
introduction](%PUBURL%/Compendium/WebHome/HPC-Introduction.pdf) for more
details.

#AnchorBackup

### Backup and snapshots of the file system

-   Backup is **only** available in the `/home` and the `/projects` file
    systems!
-   Files are backed up using snapshots of the NFS server and can be
    restored by the user
-   A changed file can always be recovered as it was at the time of the
    snapshot
-   Snapshots are taken:
    -   from Monday through Saturday between 06:00 and 18:00 every two
        hours and kept for one day (7 snapshots)
    -   from Monday through Saturday at 23:30 and kept for two weeks (12
        snapshots)
    -   every Sunday st 23:45 and kept for 26 weeks
-   to restore a previous version of a file:
    -   go into the directory of the file you want to restore
    -   run `cd .snapshot` (this subdirectory exists in every directory
        on the /home file system although it is not visible with
        `ls -a`)
    -   in the .snapshot-directory are all available snapshots listed
    -   just `cd` into the directory of the point in time you wish to
        restore and copy the file you wish to restore to where you want
        it
    -   \*Attention\* The .snapshot directory is not only hidden from
        normal view (`ls -a`), it is also embedded in a different
        directory structure. An \<span class="WYSIWYG_TT">ls
        ../..\</span>will not list the directory where you came from.
        Thus, we recommend to copy the file from the location where it
        originally resided: \<pre>% pwd /home/username/directory_a % cp
        .snapshot/timestamp/lostfile lostfile.backup \</pre>
-   /home and /projects/ are definitely NOT made as a work directory:
    since all files are kept in the snapshots and in the backup tapes
    over a long time, they
    -   senseless fill the disks and
    -   prevent the backup process by their sheer number and volume from
        working efficiently.

#AnchorQuota

### Group quotas for the file system

The quotas of the home file system are meant to help the users to keep
in touch with their data. Especially in HPC, it happens that millions of
temporary files are created within hours. This is the main reason for
performance degradation of the file system. If a project exceeds its
quota (total size OR total number of files) it cannot submit jobs into
the batch system. The following commands can be used for monitoring:

-   `showquota` shows your projects' usage of the file system.
-   `quota -s -f /home` shows the user's usage of the file system.

In case a project is above it's limits please...

-   remove core dumps, temporary data
-   talk with your colleagues to identify the hotspots,
-   check your workflow and use /tmp or the scratch file systems for
    temporary files
-   *systematically*handle your important data:
    -   For later use (weeks...months) at the HPC systems, build tar
        archives with meaningful names or IDs and store e.g. them in an
        [archive](IntermediateArchive).
    -   refer to the hints for [long term preservation for research
        data](PreservationResearchData).

## Work directories

| File system | Usable directory  | Capacity | Availability | Backup | Remarks                                                                                                                                                         |
|:------------|:------------------|:---------|:-------------|:-------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Lustre`    | `/scratch/`       | 4 PB     | global       | No     | Only accessible via [workspaces](WorkSpaces). Not made for billions of files!                                                                                   |
| `Lustre`    | `/lustre/ssd`     | 40 TB    | global       | No     | Only accessible via [workspaces](WorkSpaces). For small I/O operations                                                                                          |
| `BeeGFS`    | `/beegfs/global0` | 232 TB   | global       | No     | Only accessible via [workspaces](WorkSpaces). Fastest available file system, only for large parallel applications running with millions of small I/O operations |
| `ext4`      | `/tmp`            | 95.0 GB  | local        | No     | is cleaned up after the job automatically                                                                                                                       |

### Large files in /scratch

The data containers in Lustre are called object storage targets (OST).
The capacity of one OST is about 21 TB. All files are striped over a
certain number of these OSTs. For small and medium files, the default
number is 2. As soon as a file grows above \~1 TB it makes sense to
spread it over a higher number of OSTs, eg. 16. Once the file system is
used \> 75%, the average space per OST is only 5 GB. So, it is essential
to split your larger files so that the chunks can be saved!

Lets assume you have a dierctory where you tar your results, eg.
`/scratch/mark/tar` . Now, simply set the stripe count to a higher
number in this directory with:

    lfs setstripe -c 20  /scratch/ws/mark-stripe20/tar

%RED%Note:<span class="twiki-macro ENDCOLOR"></span> This does not
affect existing files. But all files that **will be created** in this
directory will be distributed over 20 OSTs.

## Warm archive

## 

## Recommendations for file system usage

To work as efficient as possible, consider the following points

-   Save source code etc. in `/home` or /projects/...
-   Store checkpoints and other temporary data in `/scratch/ws/...`
-   Compilation in `/dev/shm` or `/tmp`

Getting high I/O-bandwitdh

-   Use many clients
-   Use many processes (writing in the same file at the same time is
    possible)
-   Use large I/O transfer blocks

## Cheat Sheet for debugging file system issues

Every Taurus-User should normaly be able to perform the following
commands to get some intel about theire data.

### General

For the first view, you can easily use the "df-command".

    df

Alternativly you can use the "findmnt"-command, which is also able to
perform an "df" by adding the "-D"-parameter.

    findmnt -D

Optional you can use the "-t"-parameter to specify the fs-type or the
"-o"-parameter to alter the output.

We do **not recommend** the usage of the "du"-command for this purpose.
It is able to cause issues for other users, while reading data from the
filesystem.

### Lustre file system

These commands work for /scratch and /ssd.

#### Listing disk usages per OST and MDT

    lfs quota -h -u username /path/to/my/data

It is possible to display the usage on each OST by adding the
"-v"-parameter.

#### Listing space usage per OST and MDT

    lfs df -h /path/to/my/data

#### Listing inode usage for an specific path

    lfs df -i /path/to/my/data

#### Listing OSTs

    lfs osts /path/to/my/data

#### View striping information

    lfs getstripe myfile
    lfs getstripe -d mydirectory

The "-d"-parameter will also display striping for all files in the
directory

### BeeGFS

Commands to work with the BeeGFS file system.

#### Capacity and file system health

View storage and inode capacity and utilization for metadata and storage
targets.

    beegfs-df -p /beegfs/global0

The "-p" parameter needs to be the mountpoint of the file system and is
mandatory.

List storage and inode capacity, reachability and consistency
information of each storage target.

    beegfs-ctl --listtargets --nodetype=storage --spaceinfo --longnodes --state --mount=/beegfs/global0

To check the capacity of the metadata server just toggle the
"--nodetype" argument.

     beegfs-ctl --listtargets --nodetype=meta --spaceinfo --longnodes --state --mount=/beegfs/global0

#### Striping

View the stripe information of a given file on the file system and shows
on which storage target the file is stored.

    beegfs-ctl --getentryinfo /beegfs/global0/my-workspace/myfile --mount=/beegfs/global0

Set the stripe pattern for an directory. In BeeGFS the stripe pattern
will be inherited form a directory to its children.

    beegfs-ctl --setpattern --chunksize=1m --numtargets=16 /beegfs/global0/my-workspace/ --mount=/beegfs/global0

This will set the stripe pattern for "/beegfs/global0/path/to/mydir/" to
a chunksize of 1M distributed over 16 storage targets.

Find files located on certain server or targets. The following command
searches all files that are stored on the storage targets with id 4 or
30 und my-workspace directory.

    beegfs-ctl --find /beegfs/global0/my-workspace/ --targetid=4 --targetid=30 --mount=/beegfs/global0

#### Network

View the network addresses of the file system servers.

    beegfs-ctl --listnodes --nodetype=meta --nicdetails --mount=/beegfs/global0
    beegfs-ctl --listnodes --nodetype=storage --nicdetails --mount=/beegfs/global0
    beegfs-ctl --listnodes --nodetype=client --nicdetails --mount=/beegfs/global0

Display connections the client is actually using

    beegfs-net

Display possible connectivity of the services

    beegfs-check-servers -p /beegfs/global0