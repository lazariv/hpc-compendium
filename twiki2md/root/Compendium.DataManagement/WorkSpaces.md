# Workspaces



Storage systems come with different flavours in terms of

-   size
-   streaming bandwidth
-   IOPS rate

With a limited price one cannot have all in one. That is the reason why
our fast parallel file systems have restrictions wrt. age of files (see
[TermsOfUse](TermsOfUse)). The mechanism of workspaces enables users to
better manage the data life cycle of their HPC data. Workspaces are
primarily login-related. The tool concept of "workspaces" is common in a
large number of HPC centers. The idea is to request for a workspace
directory in a certain storage system - connected with an expiry date.
After a grace period the data is deleted automatically. The **maximum**
lifetime of a workspace depends on the storage system and is listed
below:

-   ssd: 1 day default, 30 days maximum,
-   beegfs_global0: 1 day default, 30 days maximum,
-   scratch: 1 day default, 100 days maximum,
-   warm_archive: 1 day default, 1 year maximum.

All workspaces can be extended twice (update: 10 times in scratch now).
There is no problem to use the fastest file systems we have, but keep
track on your data and move it to a cheaper system once you have done
your computations.

## Workspace commands

To list all available workspaces use:

    mark@tauruslogin6:~&gt; mark@tauruslogin5:~&gt; ws_find -l<br />Available filesystems:<br />scratch<br />warm_archive<br />ssd<br />beegfs_global0

To create a workspace, specify a unique name and its life time like
this:

    mark@tauruslogin6:~> ws_allocate -F scratch SPECint 50
    Info: creating workspace.
    /scratch/ws/mark-SPECint
    remaining extensions  : 10
    remaining time in days: 50

**Important:** You can (and should) also add your email address and a
relative date for notification:

    mark@tauruslogin6:~&gt; ws_allocate -F scratch -r 7 -m name.lastname@tu-dresden.de SPECint 50

\<verbatim><mark@tauruslogin6>:\~\> ws_allocate: \[options\]
workspace_name duration Options: -h \[ --help \] produce help message -V
\[ --version \] show version -d \[ --duration \] arg (=1) duration in
days -n \[ --name \] arg workspace name -F \[ --filesystem \] arg
filesystem -r \[ --reminder \] arg reminder to be sent n days before
expiration -m \[ --mailaddress \] arg mailaddress to send reminder to
(works only with tu-dresden.de addresses) -x \[ --extension \] extend
workspace -u \[ --username \] arg username -g \[ --group \] group
workspace -c \[ --comment \] arg comment\</verbatim>

The maximum duration depends on the storage system:

\<table border="2" cellpadding="2" cellspacing="2"> \<tbody> \<tr> \<td
style="padding-left: 30px;">**Storage system ( use with parameter -F )
\<br />**\</td> \<td style="padding-left: 30px;"> **Duration** \</td>
\<td style="padding-left: 30px;">**Remarks\<br />**\</td> \</tr> \<tr
style="padding-left: 30px;"> \<td style="padding-left: 30px;">ssd\</td>
\<td style="padding-left: 30px;">30 days\</td> \<td style="padding-left:
30px;">High-IOPS file system (/lustre/ssd) on SSDs.\</td> \</tr> \<tr
style="padding-left: 30px;"> \<td style="padding-left:
30px;">beegfs\</td> \<td style="padding-left: 30px;">30 days\</td> \<td
style="padding-left: 30px;">High-IOPS file system (/lustre/ssd)
onNVMes.\</td> \</tr> \<tr style="padding-left: 30px;"> \<td
style="padding-left: 30px;">scratch\</td> \<td style="padding-left:
30px;">100 days\</td> \<td style="padding-left: 30px;">Scratch file
system (/scratch) with high streaming bandwidth, based on spinning
disks.\</td> \</tr> \<tr style="padding-left: 30px;"> \<td
style="padding-left: 30px;">warm_archive\</td> \<td style="padding-left:
30px;">1 year\</td> \<td style="padding-left: 30px;">Capacity file
system based on spinning disks.\</td> \</tr> \</tbody> \</table> A
workspace can be extended twice. With this command, a *new* duration for
the workspace is set (*not cumulative*):

    mark@tauruslogin6:~> ws_extend -F scratch SPECint 100
    Info: extending workspace.
    /scratch/ws/mark-SPECint
    remaining extensions  : 1
    remaining time in days: 100

For email notification, you can either use the option `-m` in the
`ws_allocate` command line or use `ws_send_ical` to get an entry in your
calendar. (%RED%This works only with \<span>tu-dresden.de
\</span>addresses<span class="twiki-macro ENDCOLOR"></span>. Please
configure email redirection if you want to use another address.)

    mark@tauruslogin6:~> ws_send_ical -m ulf.markwardt@tu-dresden.de -F scratch SPECint

You can easily get an overview of your currently used workspaces with
**`ws_list`**.

    mark@tauruslogin6:~> ws_list
    id: benchmark_storage
         workspace directory  : /warm_archive/ws/mark-benchmark_storage
         remaining time       : 364 days 23 hours
         creation time        : Thu Jul  4 13:40:31 2019
         expiration date      : Fri Jul  3 13:40:30 2020
         filesystem name      : warm_archive
         available extensions : 2
    id: SPECint
         workspace directory  : /scratch/ws/mark-SPECint
         remaining time       : 99 days 23 hours
         creation time        : Thu Jul  4 13:36:51 2019
         expiration date      : Sat Oct 12 13:36:51 2019
         filesystem name      : scratch
         available extensions : 1

With\<span> **\<span>ws_release -F \<file system> \<workspace
name>\</span>**\</span>, you can delete your workspace.

### Restoring expired workspaces

**At expiration time** (or when you manually release your workspace),
your workspace will be moved to a special, hidden directory. For a month
(in \_warm*archive*: 2 months), you can still restore your data into a
valid workspace. For that, use

    mark@tauruslogin6:~> ws_restore -l -F scratch

to get a list of your expired workspaces, and then restore them like
that into an existing, active workspace **newws**:

    mark@tauruslogin6:~> ws_restore -F scratch myuser-myws-1234567 newws

**NOTE**: the expired workspace has to be specified using the full name
as listed by `ws_restore -l`, including username prefix and timestamp
suffix (otherwise, it cannot be uniquely identified). \<br />The target
workspace, on the other hand, must be given with just its short name as
listed by `ws_list`, without the username prefix.

### Linking workspaces in home

It might be valuable to have links to personal workspaces within a
certain directory, e.g., the user home directory. The command
\`ws_register DIR\` will create and manage links to all personal
workspaces within in the directory \`DIR\`. Calling this command will do
the following:

-   The directory \`DIR\` will be created if necessary
-   Links to all personal workspaces will be managed:
    -   Creates links to all available workspaces if not already present
    -   Removes links to released workspaces \<p> \</p> \<p> \</p> \<p>
        \</p> \<p> \</p> \<p> \</p> \<p> \</p> \<p> \</p> \<p> \</p>
        \<p> \</p> \<p> \</p> \<p> \</p> \<p> \</p> \<p> \</p> \<p>
        \</p> \<p> \</p>

**Remark:** An automatic update of the workspace links can be invoked by
putting the command \`ws_register DIR\` in the user's personal shell
configuration file (e.g., .bashrc, .zshrc).

## How to Use Workspaces

We see three typical use cases for the use of workspaces:

### Per-Job-Storage

A batch job needs a directory for temporary data. This can be deleted
afterwards.

Here an example for the use with Gaussian:

    #!/bin/bash
    #SBATCH --partition=haswell
    #SBATCH --time=96:00:00
    #SBATCH --nodes=1
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=24

    module load modenv/classic
    module load gaussian

    COMPUTE_DIR=gaussian_$SLURM_JOB_ID
    export GAUSS_SCRDIR=$(ws_allocate -F ssd $COMPUTE_DIR 7)
    echo $GAUSS_SCRDIR

    srun g16 inputfile.gjf logfile.log

    test -d $GAUSS_SCRDIR && rm -rf $GAUSS_SCRDIR/*
    ws_release -F ssd $COMPUTE_DIR

In a similar manner, other jobs can make use of temporary workspaces.

### Data for a Campaign

For a series of calculations that works on the same data, you could
allocate a workspace in the scratch for e.g. 100 days:

    mark@tauruslogin6:~> ws_allocate -F scratch my_scratchdata 100
    Info: creating workspace.
    /scratch/ws/mark-my_scratchdata
    remaining extensions  : 2
    remaining time in days: 99

If you want to share it with your project group, set the correct access
attributes, eg.

    mark@tauruslogin6:~&gt; chmod g+wrx /scratch/ws/mark-my_scratchdata

And verify it with:

    mark@tauruslogin6:~&gt; ls -la /scratch/ws/mark-my_scratchdata <br />total 8<br />drwxrwx--- 2 mark    hpcsupport 4096 Jul 10 09:03 .<br />drwxr-xr-x 5 operator adm       4096 Jul 10 09:01 ..

### Mid-Term Storage

For data that seldomly changes but consumes a lot of space, the warm
archive can be used. \<br />Note that this is **mounted read-only**on
the compute nodes, so you cannot use it as a work directory for your
jobs!

    mark@tauruslogin6:~> ws_allocate -F warm_archive my_inputdata 365
    /warm_archive/ws/mark-my_inputdata
    remaining extensions  : 2
    remaining time in days: 365

**Attention:** The warm archive is not built for billions of files.
There is a quota active of 100.000 files per group. Maybe you might want
to tar your data. To see your active quota use:

    mark@tauruslogin6:~> qinfo quota /warm_archive/ws/
    Consuming Entity                              Type                Limit   Current Usage  
    GROUP: hpcsupport                             LOGICAL_DISK_SPACE  100 TB  51 GB (0%)     
    GROUP: hpcsupport                             FILE_COUNT          100000  4 (0%)         
    GROUP: swtest                                 LOGICAL_DISK_SPACE  100 TB  5 GB (0%)      
    GROUP: swtest                                 FILE_COUNT          100000  38459 (38%)    
    TENANT: 8a2373d6-7aaf-4df3-86f5-a201281afdbb  LOGICAL_DISK_SPACE  5 PB    1 TB (0%)    

Note that the workspaces reside under the mountpoint `/warm_archive/ws/`
and not \<span>/warm_archive\</span>anymore.

### Troubleshooting

If you are getting the error:

    Error: could not create workspace directory!

you should check the \<span>"locale" \</span>setting of your ssh client.
Some clients (e.g. the one from MacOSX) set values that are not valid on
Taurus. You should overwrite LC_CTYPE and set it to a valid locale value
like:

    export LC_CTYPE=de_DE.UTF-8

A list of valid locales can be retrieved via \<br />

    locale -a

Please use only UTF8 (or plain) settings. Avoid "iso" codepages!
