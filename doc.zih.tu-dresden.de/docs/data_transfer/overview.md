# Transfer of Data

## Moving data to/from the HPC Machines

To copy data to/from the HPC machines, the Taurus export nodes should be used as a preferred way.
There are three possibilities to exchanging data between your local machine (lm) and the HPC
machines (hm): SCP, RSYNC, SFTP. Type following commands in the terminal of the local machine. The
SCP command was used for the following example.  Copy data from lm to hm

```Bash
# Copy file from your local machine. For example: scp helloworld.txt mustermann@taurusexport.hrsk.tu-dresden.de:/scratch/ws/mastermann-Macine_learning_project/
scp <file> <zih-user>@taurusexport.hrsk.tu-dresden.de:<target-location>

scp -r <directory> <zih-user>@taurusexport.hrsk.tu-dresden.de:<target-location>          #Copy directory from your local machine.
```

Copy data from hm to lm

```Bash
# Copy file. For example: scp mustermann@taurusexport.hrsk.tu-dresden.de:/scratch/ws/mastermann-Macine_learning_project/helloworld.txt /home/mustermann/Downloads
scp <zih-user>@taurusexport.hrsk.tu-dresden.de:<file> <target-location>

scp -r <zih-user>@taurusexport.hrsk.tu-dresden.de:<directory> <target-location>          #Copy directory
```

## Moving data inside the HPC machines: Datamover

The best way to transfer data inside the Taurus is the datamover. It is the special data transfer
machine provides the best data speed. To load, move, copy etc. files from one file system to another
file system, you have to use commands with dt prefix, such as: dtcp, dtwget, dtmv, dtrm, dtrsync,
dttar, dtls. These commands submit a job to the data transfer machines that execute the selected
command. Except for the 'dt' prefix, their syntax is the same as the shell command without the 'dt'.

Keep in mind: The warm_archive is not writable for jobs. However, you can store the data in the warm
archive with the datamover.

Useful links: [Data Mover]**todo link**, [Export Nodes]**todo link**
