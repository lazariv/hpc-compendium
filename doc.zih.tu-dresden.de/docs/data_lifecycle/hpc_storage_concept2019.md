# HPC Storage Changes 2019

## Hardware changes require new approach**

\<font face="Open Sans, sans-serif">At the moment we are preparing to
remove our old hardware from 2013. This comes with a shrinking of our
/scratch from 5 to 4 PB. At the same time we have now our "warm archive"
operational for HPC with a capacity of 5 PB for now. \</font>

\<font face="Open Sans, sans-serif">The tool concept of "workspaces" is
common in a large number of HPC centers. The idea is to allocate a
workspace directory in a certain storage system - connected with an
expiry date. After a grace period the data is deleted automatically. The
validity of a workspace can be extended twice. \</font>

## \<font face="Open Sans, sans-serif"> **How to use workspaces?** \</font>

\<font face="Open Sans, sans-serif">We have prepared a few examples at
<https://doc.zih.tu-dresden.de/hpc-wiki/bin/view/Compendium/WorkSpaces>\</font>

-   \<p>\<font face="Open Sans, sans-serif">For transient data, allocate
    a workspace, run your job, remove data, and release the workspace
    from with\</font>\<font face="Open Sans, sans-serif">i\</font>\<font
    face="Open Sans, sans-serif">n your job file.\</font>\</p>
-   \<p>\<font face="Open Sans, sans-serif">If you are working on a set
    of data for weeks you might use workspaces in scratch and share them
    with your groups by setting the file access attributes.\</font>\</p>
-   \<p>\<font face="Open Sans, sans-serif">For \</font>\<font
    face="Open Sans, sans-serif">mid-term storage (max 3 years), use our
    "warm archive" which is large but slow. It is available read-only on
    the compute hosts and read-write an login and export nodes. To move
    in your data, you might want to use the
    [datamover nodes](../data_transfer/data_mover.md).\</font>\</p>

## \<font face="Open Sans, sans-serif">Moving Data from /scratch and /lustre/ssd to your workspaces\</font>

We are now mounting /lustre/ssd and /scratch read-only on the compute
nodes. As soon as the non-workspace /scratch directories are mounted
read-only on the login nodes as well, you won't be able to remove your
old data from there in the usual way. So you will have to use the
DataMover commands and ideally just move your data to your prepared
workspace:

```Shell Session
dtmv /scratch/p_myproject/some_data /scratch/ws/myuser-mynewworkspace
#or:
dtmv /scratch/p_myproject/some_data /warm_archive/ws/myuser-mynewworkspace
```

Obsolete data can also be deleted like this:

```Shell Session
dtrm -rf /scratch/p_myproject/some_old_data
```

**%RED%At the end of the year we will delete all data on /scratch and
/lsuter/ssd outside the workspaces.%ENDCOLOR%**

## Data life cycle management

\<font face="Open Sans, sans-serif">Please be aware: \</font>\<font
face="Open Sans, sans-serif">Data in workspaces will be deleted
automatically after the grace period.\</font>\<font face="Open Sans,
sans-serif"> This is especially true for the warm archive. If you want
to keep your data for a longer time please use our options for
[long-term storage](preservation_research_data.md).\</font>

\<font face="Open Sans, sans-serif">To \</font>\<font face="Open Sans,
sans-serif">help you with that, you can attach your email address for
notification or simply create an ICAL entry for your calendar
(tu-dresden.de mailboxes only). \</font>
