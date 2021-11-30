This page is intended to provide the most important parts of starting to work on the ZIH High Performance Computing (HPC) system.
When you are new to HPC, start with the introductory article about HPC at [https://hpc-wiki.info/hpc/Getting_Started](https://hpc-wiki.info/hpc/Getting_Started).

# Before You Start

The ZIH HPC system is a linux system (same as most HPC systems), some basic linux knowledge is therefore needed at certain points. 
Users who are [new to linux can find here](../link/to/page_with_most_important_commands) a collection of the most important linux commands needed on the ZIH HPC system.

To work on the ZIH HPC system and to follow the iinstructions on this page as well as other Compendium pages, it is important to be familiar with the [basic terminology](https://hpc-wiki.info/hpc/HPC-Dictionary) such as 
[ssh](https://hpc-wiki.info/hpc/SSH), [cluster](https://hpc-wiki.info/hpc/HPC-Dictionary#Cluster), [login node](https://hpc-wiki.info/hpc/HPC-Dictionary#Login_Node), [compute node](https://hpc-wiki.info/hpc/HPC-Dictionary#Backend_Node), [local and shared file system](https://hpc-wiki.info/hpc/HPC-Dictionary#File_System), [command line (cli) or shell](https://hpc-wiki.info/hpc/Shell).

Thrughout this example we use `marie@login` as an indication of working on the ZIH HPC command line and `marie@local` as working on your own local machine's command line. 

# Application for login and resources

To use the ZIH HPC system, an ZIH HPC login is needed, which is different from the ZIH login (which members of the TU Dresden have), but has the same credentials. 

To work on the ZIH HPC system, there are two possibilities: 

* create a [new project](https://doc.zih.tu-dresden.de/application/project_request_form/)
* join an existing project: e.g. new researchers in an existing project, teaching purposes. The details will be provided to you by the project admin. 

This is because the system is structured by these HPC projects. An HPC project on the ZIH HPC system includes:

* project directory
* project group
* project members (at least admin and manager)
* resource quotas for compute time (CPU/GPU hours) and storage

# Accessing the ZIH HPC system

There are different ways to access the ZIH HPC system. Depending on the user's needs and previous knowledge, these are the different possiblities: 

1. JupyterHub (**recommended**): browser based approach, easiest way for beginners (more info [here](https://doc.zih.tu-dresden.de/access/jupyterhub/)) 
2. ssh connection (command line/terminal/console): "classical" approach,  command line knowledge neccesary (more info [here](https://doc.zih.tu-dresden.de/access/ssh_login/))
3. Desktop Visualisaiton, Graphical User Interfaces (GUIs) and similar: e.g. Ansys, Vampir.

## 1.  JupyterHub
Access JupyterHub here [https://taurus.hrsk.tu-dresden.de/jupyter](). Start by clicking on the `Start my server` button and you will see two Spawner Options, `Simple` and `Advanced`. More information [here](https://doc.zih.tu-dresden.de/access/jupyterhub/).

#### Simple
The `Simple` view offers a limited selection of parameters to choose from. It is aimed towards simple projects and beginner users. For a simple start, the parameters are pre-chosen, therefore you can just click `Spawn`:
![Simple form](doc.zih.tu-dresden.de/docs/access/misc/simple_form.png)
 You will be working in your `/home/` directory as opposed to a specific workspace (see *Data: Management and Transfer* section below for more details). You will see:
 
 <div align="center">
`Your server is starting up. 
 You will be redirected automatically when it's ready for you.`
</div>


Once it loads, you will see the possibility between opening a `Notebook`, `Console` or `Other`. See [here](https://doc.zih.tu-dresden.de/access/jupyterhub/) for more information. 
 
 Once you are done with your work on the ZIH HPC system for the day, stop the session by logging out through by clicking `File` and then `Log Out`.
 
#### Advanced
If you are more advanced and would like to have more choice in the parameters, see `Advanced` view. Here you can choose the partition you want to work on, preload modules (see section *2. Software: Environment* below), select which workspace (see *Data: Management and Transfer* section below) you will be working in, etc.:
![Advanced form](doc.zih.tu-dresden.de/docs/access/misc/advanced_form.png)

Once you are done with your work for the day, stop the session by logging out through by clicking `File` and then `Log Out`.

## 2. ssh Connection (Command  Line)


##### [Before 1<sup>st</sup> connection](https://doc.zih.tu-dresden.de/access/ssh_login/)
We suggest creating an SSH key pair on your local machine. Open the command line and type in the following (`marie` is you in this schenario):

```console
marie@local$ makdir -p ~/.ssh  
marie@local$ ssh-keygen -t ed25519 -f ~7.ssh/id_ed25519
Generating passphrase (empty for no passphrase):
Enter same passphrase again:
[...]
```
Type in a passphrase for the protection of your key. The passphrase should be **non-empty**. Copy the public key to the ZIH system and replace `marie` with your ZIH login: 

```console
marie@local$ ssh-copy-id -i ~/.ssh/id_ed25519.pub marie@taurus.hrsk.tu-dresden.de
The authenticity of host 'taurus.hrsk.tu-dresden.de (141.30.73.104)' can't be established.
RSA key fingerprint is SHA256:HjpVeymTpk0rqoc8Yvyc8d9KXQ/p2K0R8TJ27aFnIL8.
Are you sure you want to continue connecting (yes/no)?
```
##### First and Subsequent Connections
```console
marie$local$ ssh marie@taurus.hrsk.tu-dresden.de
```

---
###### Interactive vs Batch Job Running 
Now you will need to choose between running a job [interactively](https://doc.zih.tu-dresden.de/jobs_and_resources/slurm/#interactive-jobs)(real time execution) or choosing to submit a [batch job](https://doc.zih.tu-dresden.de/jobs_and_resources/slurm/#batch-jobs)(later, scheduled execution). For beginners, we highly advise to run the job interactively.

To do so, use the `srun` command:

```console
marie$local$ srun [options] <command>
```
Here, some of the options can be the partition you would like to work on, `partition`, the number of tasks `ntasks`, number of CPUs per task `cpus-per-task`, the amount of time you would like to keep this interactive session open `time`, memory per CPU `mem-per-cpu` and others. See [here](https://doc.zih.tu-dresden.de/jobs_and_resources/slurm/#interactive-jobs) for more info. 

```console
marie$local$ srun --pty --ntasks=1 --cpus-per-task=4 --time=1:00:00 --mem-per-cpu=1700 bash -l
```
You can also choose to work on a specific [partition](https://doc.zih.tu-dresden.de/jobs_and_resources/hardware_overview/)


Now, you can start interactive work with e.g. 4 cores

## 3. Graphical Applications and GUIs

See [here](https://doc.zih.tu-dresden.de/software/virtual_desktops/) for more details.

# Running a Job: Structure of HPC projects

When starting a project, please have in mind some basics of research data mangagment to easier publish and archive a project according to the [FAIR principles](https://www.go-fair.org/fair-principles/).

One important aspect for HPC projects is a collaborative working style (research groups, student groups for teaching purposes). Thus, granting appropriate file permissions and creating a unified and consistent software environment for multiple users is essential.
This aspect is considered for all the following recommendations.

HPC projects can be broken down into two core parts:

1. Data: input data, source code, scripts, ouptut data, calculation results, logfiles
2. Software  

## 1. Data: Management and Transfer

There are different areas for storing your data on the ZIH HPC system, called [Filesystems](https://doc.zih.tu-dresden.de/data_lifecycle/file_systems/). You will need to create a [workspace](https://doc.zih.tu-dresden.de/data_lifecycle/workspaces/) for your data (see example below) on one of these Filesystems. Otherwise your data will be automatically stored on your `/home/` directory which has limited capacity.

Every filesystem has its own properties (available space/capacity, storage time limit, permission rights). Therefore, choose the one that fits your project best. To start we recommend **Lustre - scratch**:

----
**Example: Creating a Workspace on Scratch**

```console
marie@login$ ws_allocate -F scratch -r 7 -m marie.testuser@tu-dresden.de test-workspace 90
Info: creating workspace.
/scratch/ws/marie-test-workspace
remaining extensions  : 10
remaining time in days: 90
```

As you can see, this takes the form:

```console
marie@login$ ws_allocate -F filesystem [options] workspace_name duration

Options:
  -h [ --help]               produce help message
  -V [ --version ]           show version
  -d [ --duration ] arg (=1) duration in days
  -n [ --name ] arg          workspace name
  -F [ --filesystem ] arg    filesystem
  -r [ --reminder ] arg      reminder to be sent n days before expiration
  -m [ --mailaddress ] arg   mailaddress to send reminder to (works only with tu-dresden.de mails)
  -x [ --extension ]         extend workspace
  -u [ --username ] arg      username
  -g [ --group ]             group workspace
  -c [ --comment ] arg       comment
```

----


See [workspaces](https://doc.zih.tu-dresden.de/data_lifecycle/workspaces/) for more details.

Transferring data to, from and within the ZIH HPC system is realized by the following approaches, depending on the data volume: 

##### 1. Small data volume (only a few megabytes): Using `scp`, `wget`, or `cp` in the commandline of your local machine 

__*Example on how to move files from local macine to the ZIH HPC system*__

1. Linux
```console
marie$local$ scp /home/marie/Documents/example1.R marie@taurusexport.hrsk.tu-dresden.de:/scratch/ws/0/your_workspace/
Password:
example1.R                                                     100%  312    32.2KB/s   00:00`` 
```

As you can see, this takes the form:
```console
marie$local$ scp File_directory_on_local_machine/file_name HPC_user_name@taurusexport.hrsk.tu-dresden.de:/your_workspace_directory/
Password:
example1.R                                                     100%  312    32.2KB/s   00:00`` 
```

__*Example on how to move files to the local macine from the ZIH HPC system*__

```console
marie$local$ scp marie@taurusexport.hrsk.tu-dresden.de:/scratch/ws/0/your_workspace/results home/marie/Documents/
```

2.  More so for Linux-based systems, *SSHFS* (a command-line tool for safely mounting a remote folder from a server to a local machine) can be used to mount user home, project home or workspace within the local folder structure. Data can be transferred directly with drag and drop in your local file explorer. Moreover, this approach makes it possible to edit files with your common editors and tools on the local machine.


3.  Windows users can apply the step-by=step procedure as indicated [here] (../../data_transfer/export_nodes/#access-from-windows).


##### Medium and high data volume (hundreds of megabytes up to gigabytes and beyond): using data mover `dtcp`, `dtls`, `dtmv`, `dtrm`, `dtrsync`, `dttar`, and `dtwget` (details [can be found here](../data_transfer/datamover.md))

__* Example on how to move data within the ZIH HPC system *__
On the ZIH HPC command line, moving data from `/scratch/ws/0/your_workspace` to some other location (in this example we choose the `/projects` filesystem):

```console
marie@login$ dtcp -r /scratch/ws/0/your_workspace/ /projects/p_marie/.
```

-----

For more information on how to move files of different sizes from the local machine to the ZIH HPC system, within the ZIH HPC system, how to archive them, what to avoid and other information, see [here](https://hpc-wiki.zih.tu-dresden.de/data_transfer/datamover/). 

!!! caution "Permission rights are crucial in a collaborative setting"

	By default workspaces are accessible only for the user who created the workspace.
	Files created by a user in the project directory have read-only access for other group members by default.
	Therefore, the correct file permissions must be configured (using `chmod` and `chgrp`) for all files in the project home and the workspaces that should be fully accessible (read, write, execute) to your collaborator group.
	A first overview on users and permissions in linux can be found [here](https://hpc-wiki.info/hpc/Introduction_to_Linux_in_HPC/Users_and_permissions).

!!! note

	If you are planning to move terabytes or even more from an outside machine into the ZIH system, please contact the ZIH HPC support in advance.


## 2. Software: environment

Now that you have your data on the ZIH HPC system or know where you will store the results data, you would like to start running your job. 




For this you will be using some form of Software. There are different options to work with software on the ZIH HPC system: **modules**, **JupyterHub** and **containers** (more info [here](https://hpc-wiki.zih.tu-dresden.de/software/overview/).  
Please note that different partitions might have available different versions of the same software. 

**Examples**
For checking available modules: 
* over all module environments (here we ): 
```console 
marie@login$ module spider python 
python:
----------------------------------------------------------------------------
     Versions:
        python/3.3.0
		...
        python/3.4.3-scipy
        python/3.6-anaconda4.4.0
     Other possible modules matches:
        Biopython  Boost.Python  GitPython  IPython  Python  PythonAnaconda  ...

----------------------------------------------------------------------------
  To find other possible module matches execute:

      $ module -r spider '.*python.*'

----------------------------------------------------------------------------
  For detailed information about a specific "python" package (including how to load the modules) use the module's full name.
  Note that names that have a trailing (E) are extensions provided by other modules.
  For example:

     $ module spider python/3.6-anaconda4.4.0
----------------------------------------------------------------------------
```
Here we see the list of verions of Python that are available. To load a specific version (in the example below we choose `python/3.3.0`), check what modules you need to load before loading it:
```console 
marie@login$ module spider python/3.3.0 #check
marie@login$ module load modenv/classic #load preprequisites
marie@login$ module load python/3.3.0 #load version of interest
```

* within module environment only: 
```console 
module avail python 
```

If there are not all needed sofware packages available in the module system it is possible to install most packages by the user (see [here](https://doc.zih.tu-dresden.de/software/custom_easy_build_environment/) for more details. 
Depending on the software there might be different possiblities. 

There might be cases where root privileges are needed for installation. 

??? hint "Special hints on different software"
	
	Special hints on different software can be found for [Python](), [R](), ...

??? hint "Hint on Python packages"

	The usage of virtual environments and, therefore, the usage of workspaces is recommended, especially for Python.
	Please check out the module system, even for specific Python packages, e.g. tqdm, torchvision, tensorboard, etc. to get a better idea of what is available to you.
	the Python (and other) package ecosystem is very heterogeneous and dynamic, with, often, daily updates. 
	The central update cycle for software on the ZIH HPC system occurs approximately every six months.

