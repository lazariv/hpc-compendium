# Getting started

This page is intended to provide the most important parts of working on a high performance computing (HPC) system.
When you are new to HPC start with the introductory article about HPC at [https://hpc-wiki.info/hpc/Getting_Started](https://hpc-wiki.info/hpc/Getting_Started).
In the following it is assumed that you are familiar already with the most basic terminology as 
[ssh](https://hpc-wiki.info/hpc/SSH)
[cluster]()
[login node]()
[compute node]()
[local and shared file system](https://hpc-wiki.info/hpc/HPC-Dictionary#File_System)
[command line (cli) or shell]()

# Application for login and resources

For using the ZIH system an HPC login is needed.
Members of the TU Dresden only have a ZIH login but not an HPC login. 
The HPC login has the same credentials as the ZIH login. 

Working on the ZIH system is structured by so called HPC projects.
To an HPC project on the ZIH system includes

* project directory
* project group
* project members (at least admin and manager??)
* resource quotas for compute time (CPU/GPU hours) and storage
 
There are different possibilities to work with HPC: 

* create a new project
* join an existing project: e.g. new researchers in an existing project, teaching purposes

# Accessing the ZIH system

There are different ways to access the ZIH system. 
Depending on the user's needs and pre-knowledge the different possiblities are more or less appropriate. 

* JupyterHub: browser based approach, most easiest way for beginners
* desktop visualization (?): esp. in case of using GUI-based software (e.g. Ansys?)
* ssh connection: "classical" approach, command line (cli) knowledge is neccesary


# Structuring HPC projects

Typically, HPC projects consist of the following parts (at least some of them):

* Input data, source code and scripts
* Software  
* ouptut data and calculation results
* log files
* metadata 
* backup
* archiving

A further aspect is a collaborative working style (research groups, teaching purposes). 
Thus, creating a unified and consistent experiment environment for multiple users is essential. 
This is considered for all the following recommendations. 

# Data management and data transfer

There are different areas for storing data on the ZIH system.
Every area has its own properties referring 

* available space for storing data
* life time 
* permission rights
* accessability from compute nodes

In general, it is recommended to use workspaces for all your data as 

* Input data
* source code
* Calculation results
* Log files
* Submission scripts (examples / code for survival)
 
Please consider the different properties (lifetime, accessability) between the types of workspace (warm archive, scratch, ssd).
Overall, a good starting point is using a scratch workspace (see an [example here](../workspaces/#allocate-a-workspace).

Transferring data to, from and within the ZIH system is realized by the following approaches: 

* small data volume (only a few megabytes): 
	+ using scp, wget, cp on a login node
	+ Windows users can apply programs as [described here](../../data_transfer/export_nodes/#access-from-windows).
	+ esp. on linux-based systems sshfs can be used to mount user home, project home or workspace within the local folder structure. Data can be transferred directly with drag and drop in your local file exploreer. Moreover, this approach makes it possible to edit files with your common editors and tools on the local machine.
* medium and high data volume (dozens of megabytes up to gigabytes): using data mover dtcp, dtls, dtmv, dtrm, dtrsync, dttar, and dtwget (see []())

!!! caution "Permission rights are crucial in a collaborative setting"

	By default workspaces are accessible only for the user who created the workspace.
	Files created by a user in the project directory have read-only access for other group members by default.
	Therefore, the correct file permissions must be configured (using chmod and chgrp) for all files in the project home and the workspaces that should be fully accessible to your collaborators (read, write, execute).

!!! hint 

	If you are planning to move terabytes or even more from outside onto the ZIH system please contact HPC support before.


# Software environment

Software that is available in the module system can be checked at [??](??). 
Please note that different partitions might have available different software. 
For checking available modules: 

* over all module environments: module spider python 
* module load modenv/sc5, module load modenv/ml, module load modenv/hiera
* within module environment only: module avail python 

If there are not all needed sofware packages available in the module system it is possible to install most packages by the user. 
Depending on the software there might be different possiblities. 

??? hint "Special hints on different software"
	
	Special hints on different software can be found for [Python](), [R](), ...

??? hint "Hint on Python packages"

	Esp. for Python the usage of virtual environments is recommended, also use the workspaces therefore. 
	Please check out the module system as well even for single Python packages, e.g. tqdm, torchvision, tensorboard, ...
	Have in mind that (not only) the Python package ecosystem is very heterogeneous and dynamic with even daily updates. 
	The central update cycle for software on an HPC system is in an order of approximately six months.

