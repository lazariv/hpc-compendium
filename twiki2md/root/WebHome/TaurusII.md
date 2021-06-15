# Taurus phase II - user testing

With the installation of the second phase of Taurus we now have the full
capacity of the system. Until the merger in September, both phases work
like isolated HPC systems. Both machines share their accounting data, so
that all projects can seamlessly migrate to the new system.

In September we will shut down the phase 1 nodes, their hardware will be
updated, and they will be merged with phase 2.

Basic information for Taurus, phase 2:

-   Please use the login nodes\<span class="WYSIWYG_TT">
    tauruslogin\[3-5\].hrsk.tu-dresden.de\</span> for the new system.
-   We have mounted the same file systems like on our other HPC systems:
    -   /home/
    -   /projects/
    -   /sw
    -   Taurus phase 2 has it's own /scratch file system (capacity 2.5
        PB).
-   All nodes have 24 cores.
-   Memory capacity is 64/128/256 GB per node. The batch system handles
    your requests like in phase 1. We have other memory-per-core limits!
-   Our 64 GPU nodes now have 2 cards with 2 GPUs, each.

For more details, please refer to our updated
[documentation](SystemTaurus).

Thank you for testing the system with us!

Ulf Markwardt
