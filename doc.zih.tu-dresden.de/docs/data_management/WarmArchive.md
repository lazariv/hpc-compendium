# **Warm Archive**

<span class="twiki-macro RED"></span> **This page is under construction.
The functionality is not there, yet.** <span
class="twiki-macro ENDCOLOR"></span>

The warm archive is intended a storage space for the duration of a
running HPC-DA project. It can NOT substitute a long-term archive. It
consists of 20 storage nodes with a net capacity of 10 PB. Within Taurus
(including the HPC-DA nodes), the management software "Quobyte" enables
access via

-   native quobyte client - read-only from compute nodes, read-write
    from login and nvme nodes
-   S3 - read-write from all nodes,
-   Cinder (from OpenStack cluster).

For external access, you can use:

-   S3 to \<bucket>.s3.taurusexport.hrsk.tu-dresden.de
-   or normal file transfer via our taurusexport nodes (see
    DataManagement).

An HPC-DA project can apply for storage space in the warm archive. This
is limited in capacity and duration.

-- Main.UlfMarkwardt - 2019-05-14
