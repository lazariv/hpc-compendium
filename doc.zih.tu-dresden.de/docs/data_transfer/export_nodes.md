# Move data to/from ZIH's File Systems

## Export Nodes

To copy large data to/from the HPC machines, the Taurus export nodes should be used. While it is
possible to transfer small files directly via the login nodes, they are not intended to be used that
way and there exists a CPU time limit on the login nodes, killing each process that takes up too
much CPU time, which also affects file-copy processes if the copied files are very large. The export
nodes have a better uplink (10GBit/s) and are generally the preferred way to transfer your data.
Note that you cannot log in via ssh to the export nodes, but only use scp, rsync or sftp on them.

They are reachable under the hostname: **taurusexport.hrsk.tu-dresden.de** (or
taurusexport3.hrsk.tu-dresden.de, taurusexport4.hrsk.tu-dresden.de).

## Access from Linux Machine

There are three possibilities to exchange data between your local machine (lm) and the hpc machines
(hm), which are explained in the following abstract in more detail.

### SCP

Type following commands in the terminal when you are in the directory of
the local machine.

#### Copy data from lm to hm

```Bash
# Copy file
scp <file> <zih-user>@<machine>:<target-location>
# Copy directory
scp -r <directory> <zih-user>@<machine>:<target-location>
```

#### Copy data from hm to lm

```Bash
# Copy file
scp <zih-user>@<machine>:<file> <target-location>
# Copy directory
scp -r <zih-user>@<machine>:<directory> <target-location>
```

Example:

```Bash
scp helloworld.txt mustermann@taurusexport.hrsk.tu-dresden.de:~/.
```

Additional information: <http://www.computerhope.com/unix/scp.htm>

### SFTP

Is a virtual command line, which you could access with the following
line:

```Bash
# Enter virtual command line
sftp <zih-user>@<machine>
# Exit virtual command line
sftp> exit 
# or
sftp> <Ctrl+D>
```

After that you have access to the filesystem on the hpc machine and you
can use the same commands as on your local machine, e.g. ls, cd, pwd and
many more. If you would access to your local machine from this virtual
command line, then you have to put the letter l (local machine) before
the command, e.g. lls, lcd or lpwd.

#### Copy data from lm to hm

```Bash
# Copy file
sftp> put <file>
# Copy directory
sftp> put -r <directory>
```

#### Copy data from hm to lm

```Bash
# Copy file
sftp> get <file>
# Copy directory
sftp> get -r <directory>
```

Example:

```Bash
sftp> get helloworld.txt
```

Additional information: http://www.computerhope.com/unix/sftp.htm

### RSYNC

Type following commands in the terminal when you are in the directory of
the local machine.

#### Copy data from lm to hm

```Bash
# Copy file
rsync <file> <zih-user>@<machine>:<target-location>
# Copy directory
rsync -r <directory> <zih-user>@<machine>:<target-location>
```

#### Copy data from hm to lm

```Bash
# Copy file
rsync <zih-user>@<machine>:<file> <target-location>
# Copy directory
rsync -r <zih-user>@<machine>:<directory> <target-location>
```

Example:

```Bash
rsync helloworld.txt mustermann@taurusexport.hrsk.tu-dresden.de:~/.
```

Additional information: http://www.computerhope.com/unix/rsync.htm

## Access from Windows machine

First you have to install [WinSCP](http://winscp.net/eng/download.php).

Then you have to execute the WinSCP application and configure some
option as described below.

<span class="twiki-macro IMAGE" size="600">WinSCP_001_new.PNG</span>

<span class="twiki-macro IMAGE" size="600">WinSCP_002_new.PNG</span>

<span class="twiki-macro IMAGE" size="600">WinSCP_003_new.PNG</span>

<span class="twiki-macro IMAGE" size="600">WinSCP_004_new.PNG</span>

After your connection succeeded, you can copy files from your local
machine to the hpc machine and the other way around.

<span class="twiki-macro IMAGE" size="600">WinSCP_005_new.PNG</span>
