# Typical project schedule



## \<span style="font-size: 1em;">0. Application for HPC login\</span>

In order to use the HPC systems installed at ZIH, a project application
form has to be filled in. The HPC project manager should hold a
professorship (university) or head a research group. You may also apply
for the "Schnupperaccount" (trial account) for one year. Check the
[Access](Access) page for details.

## \<span style="font-size: 1em;">1. Request for resources\</span>

Important note: Taurus is based on the Linux system. Thus for the
effective work, you should have to know how to work with
[Linux](https://en.wikipedia.org/wiki/Linux) based systems and [Linux
Shell](https://ubuntu.com/tutorials/command-line-for-beginners#1-overview).
Beginners can find a lot of different tutorials on the internet, [for
example](https://swcarpentry.github.io/shell-novice/).

### \<span style="font-size: 1em;">1.1 How do I determine the required CPU / GPU hours?\</span>

Taurus is focused on data-intensive computing. The cluster is oriented
on the work with the high parallel code. Please keep it in mind for the
transfer sequential code from a local machine. So far you will have
execution time for the sequential program it is reasonable to use
[Amdahl's law](https://en.wikipedia.org/wiki/Amdahl%27s_law) to roughly
predict execution time in parallel. Think in advance about the
parallelization strategy for your project.

### \<span style="font-size: 1em;">1.2 What software do I need? What is already available (in the correct version)?\</span>

The good practice for the HPC clusters is use software and packages
where parallelization is possible. The open-source software is more
preferable than proprietary. However, the majority of popular
programming languages, scientific applications, software, packages
available or could be installed on Taurus in different ways. First of
all, check the [Software module list](SoftwareModulesList). There are
two different software environments: **scs5** (the regular one) and
**ml** (environment for the Machine Learning partition). Keep in mind
that Taurus has a Linux based operating system.

## 2. Access to the cluster

### SSH access

%RED%Important note:%ENDCOLOR%\<span style="font-size: 1em;"> ssh to
Taurus is only possible from \</span> **inside** \<span
style="font-size: 1em;"> TU Dresden Campus. Users from outside should
use \</span> **VPN** \<span style="font-size: 1em;"> (see \</span>\<a
href="<https://tu-dresden.de/zih/dienste/service-katalog/arbeitsumgebung/zugang_datennetz/vpn>"
target="\_top">here\</a>\<span style="font-size: 1em;">).\</span>

The recommended way to connect to the HPC login servers directly via
ssh:

    ssh &lt;zih-login&gt;@taurus.hrsk.tu-dresden.de

Please put this command in the terminal and replace \<zih-login> with
your login that you received during the access procedure. Accept the
host verifying and enter your password. You will be loaded by login
nodes in your Taurus home directory.

This method requires two conditions: Linux OS, workstation within the
campus network. For other options and details check the \<a href="Login"
target="\_blank">Login page\</a>.

Useful links: [Access](Access), [Project Request
Form](ProjectRequestForm), [Terms Of Use](TermsOfUse)

## 3. Available software, use of the software

According to 1.2, first of all, check the [Software module
list](SoftwareModulesList). Keep in mind that there are two different
environments: **scs5** (for the x86 architecture) and **ml**
(environment for the Machine Learning partition based on the Power9
architecture).

\<span style="font-size: 1em;">Work with the software on Taurus could be
started only after allocating the resources by \</span> [batch
systems](BatchSystems)\<span style="font-size: 1em;">. By default, you
are in the login nodes. They are not specified for the work, only for
the login. Allocating resources will be done by batch system \</span>
[SLURM](Slurm).

There are a lot of different possibilities to work with software on
Taurus:

**a.** **Modules**

\<span style="font-size: 1em;">The easiest way to start working with
software is using the \</span>\<a
href="RuntimeEnvironment#Module_Environments" target="\_blank">Modules
system\</a>\<span style="font-size: 1em;">. Modules are a way to use
frameworks, compilers, loader, libraries, and utilities. The module is a
user interface that provides utilities for the dynamic modification of a
user's module environment without manual modifications. You could use
them for **srun**, bath jobs (**sbatch**) and the Jupyterhub.\</span>

**b. JupyterNotebook**

The Jupyter Notebook is an open-source web application that allows
creating documents containing live code, equations, visualizations, and
narrative text. \<span style="font-size: 1em;">There is \</span>\<a
href="JupyterHub" target="\_self">jupyterhub\</a>\<span
style="font-size: 1em;"> on Taurus, where you can simply run your
Jupyter notebook on HPC nodes using modules, preloaded or custom virtual
environments. Moreover, you can run a [manually created remote jupyter
server](DeepLearning#Jupyter_notebook) for more specific cases.\</span>

**c.** **Containers**

\<span style="font-size: 1em;">Some tasks require using containers. It
can be done on Taurus by [Singularity](https://sylabs.io/). Details
could be found in the [following
chapter](TypicalProjectSchedule#Use_of_containers).\</span>

Useful links: [Libraries](Libraries), [Deep Learning](DeepLearning),
[Jupyter Hub](JupyterHub), [Big Data
Frameworks](BigDataFrameworks:ApacheSparkApacheFlinkApacheHadoop),
[R](DataAnalyticsWithR), [Applications for various fields of
science](Applications)

## 4. Create a project structure. Data management

Correct organisation of the project structure is a straightforward way
to the efficient work of the whole team. There have to be rules and
regulations for working with the project that every member should
follow. \<span style="font-size: 1em;">The uniformity of the project
could be achieved by using for each member of a team: the same **data
storage** or set of them, the same **set of software** (packages,
libraries etc), **access rights** to project data should be taken into
account and set up correctly. \</span>

### 4.1 Data storage and management

#### 4.1.1 Taxonomy of file systems

\<span style="font-size: 1em;">As soon as you have access to Taurus you
have to manage your data. The main [concept](HPCStorageConcept2019) of
working with data on Taurus is using [Workspaces](WorkSpaces). Use it
properly:\</span>

-   use a `/home` directory for the limited amount of personal data,
    simple examples and the results of calculations. The home directory
    is not a working directory! However, \<span
    class="WYSIWYG_TT">/home\</span> file system is backed up using
    snapshots;
-   use **workspace** as a place for working data (i.e. datasets);
    Recommendations of choosing the correct storage system for workspace
    presented below.

**Recommendations to choose of storage system:**\<span
style`"font-size: 1em;">For data that seldomly changes but consumes a lot of space, the </span> ==warm_archive=`
\<span style="font-size: 1em;"> can be used. (Note that this is
\</span>mounted** read-only**\<span style="font-size: 1em;">on the
compute nodes). For a series of calculations that works on the same data
please use a \</span> **scratch**\<span style="font-size: 1em;">based
workspace. \</span> **SSD** \<span style="font-size: 1em;">, in its
turn, is the fastest available file system made only for large parallel
applications running with millions of small I/O (input, output
operations).\</span>\<span style="font-size: 1em;"> If the batch job
needs a directory for temporary data then
\</span>**\<span>SSD\</span>**\<span style="font-size: 1em;"> is a good
choice as well. The data can be deleted afterwards.\</span>

Note: Keep in mind that every working space has a storage duration (
i.e. ssd - 30 days). Thus be careful with the expire date otherwise it
could vanish. The core data of your project should be [backed
up](FileSystems#Backup_and_snapshots_of_the_file_system) and
[archived](PreservationResearchData)(for the most
[important](https://www.dcc.ac.uk/guidance/how-guides/five-steps-decide-what-data-keep)
data).

#### \<span style="font-size: 1em;">4.1.2 Backup \</span>

\<span
style`"font-size: 1em;">The backup is a crucial part of any project. Organize it at the beginning of the project. If you will lose/delete your data in the "no back up" file systems it can not be restored! The b</span><span style="font-size: 13px;">ackup on Taurus is </span><b style="font-size: 1em;">only </b><span style="font-size: 13px;">available in the </span> =/home`
\<span style`"font-size: 13px;"> and the </span> =/projects` \<span
style="font-size: 13px;"> file systems! Backed up files could be
restored by the user. Details could be found
[here](FileSystems#Backup_and_snapshots_of_the_file_system).\</span>

#### 4.1.3 Folder structure and organizing data

\<span style="font-size: 1em;">Organizing of living data using the file
system helps for consistency and structuredness of the project.
\</span>\<span style="font-size: 1em;">We recommend following the rules
for your work regarding:\</span>

-   Organizing the data: Never change the original data; Automatize the
    organizing the data; Clearly separate intermediate and final output
    in the filenames; Carry identifier and original name along in your
    analysis pipeline; Make outputs clearly identifiable; Document your
    analysis steps.
-   Naming Data: Keep s\<span style="font-size: 1em;">hort, but
    meaningful names; \</span>\<span style="font-size: 1em;">Keep
    standard file endings; File names dont replace documentation and
    metadata; Use standards of your discipline; \</span>\<span
    style="font-size: 1em;">Make rules for your project, document and
    keep them (See the \</span> [README
    recommendations](TypicalProjectSchedule#README_recommendation)
    below)

\<span style="font-size: 1em;">This is the example of an organisation
(hierarchical) for the folder structure. Use it as a visual illustration
of the above:\</span>

\<img align="justify" alt="Organizing_Data-using_file_systems.png"
height="161" src="%ATTACHURL%/Organizing_Data-using_file_systems.png"
title="Organizing_Data-using_file_systems.png" width="300" />

Keep in mind [input-process-output
pattern](https://en.wikipedia.org/wiki/IPO_model#Programming) for the
work with folder structure.

#### 4.1.4 README recommendation

In general, [README](https://en.wikipedia.org/wiki/README) is just
simple general information of software/project that exists in the same
directory/repository of the project. README is used to explain the
details project and the **structure** of the project/folder in a short
way. We recommend using readme as for entire project as for every
important folder in the project.

Example of the structure for the README:\<br />\<span style="font-size:
1em;">Think first: What is calculated why? (Description); \</span>\<span
style="font-size: 1em;">What is expected? (software and version)\<br
/>\</span>\<span style="font-size: 1em;">Example text file\<br
/>\</span>\<span style="font-size: 1em;"> Title:\<br />\</span>\<span
style="font-size: 1em;"> User:\<br />\</span>\<span style="font-size:
1em;"> Date:\<br />\</span>\<span style="font-size: 1em;">
Description:\<br />\</span>\<span style="font-size: 1em;"> software:\<br
/>\</span>\<span style="font-size: 1em;"> version:\</span>

#### 4.1.5 Metadata

Another important aspect is the
[Metadata](http://dublincore.org/resources/metadata-basics/). It is
sufficient to use
[Metadata](PreservationResearchData#Why_should_I_add_Meta_45Data_to_my_data_63)
for your project on Taurus. [Metadata
standards](https://en.wikipedia.org/wiki/Metadata_standard) will help to
do it easier (i.e. [Dublin core](https://dublincore.org/),
[OME](https://www.openmicroscopy.org/))

#### 4.1.6 Data hygiene

Don't forget about data hygiene: Classify your current data into
critical (need it now), necessary (need it later) or unnecessary
(redundant, trivial or obsolete); Track and classify data throughout its
lifecycle (from creation, storage and use to sharing, archiving and
destruction); Erase the data you dont need throughout its lifecycle.

### \<span style="font-size: 1em;">4.2 Software packages\</span>

As was written before the module concept is the basic concept for using
software on Taurus. Uniformity of the project has to be achieved by
using the same set of software on different levels. It could be done by
using environments. There are two types of environments should be
distinguished: runtime environment (the project level, use scripts to
load [modules](RuntimeEnvironment)), Python virtual environment. The
concept of the environment will give an opportunity to use the same
version of the software on every level of the project for every project
member.

#### Private individual and project modules files

[Private individual and project module
files](RuntimeEnvironment#Private_Project_Module_Files)\<span
style="font-size: 1em;"> will be discussed in [chapter
](TypicalProjectSchedule#A_7._Use_of_specific_software_40packages_44_libraries_44_etc_41)\</span>
[7](TypicalProjectSchedule#A_7._Use_of_specific_software_40packages_44_libraries_44_etc_41)\<span
style="font-size: 1em;">. Project modules list is a powerful instrument
for effective teamwork.\</span>

#### Python virtual environment

If you are working with the Python then it is crucial to use the virtual
environment on Taurus. The main purpose of Python virtual environments
(don't mess with the software environment for modules) is to create an
isolated environment for Python projects (self-contained directory tree
that contains a Python installation for a particular version of Python,
plus a number of additional packages).

**Vitualenv (venv)** is a standard Python tool to create isolated Python
environments. We recommend using venv to work with Tensorflow and
Pytorch on Taurus. It has been integrated into the standard library
under the \<a href="<https://docs.python.org/3/library/venv.html>"
target="\_blank">venv module\</a>. **Conda** is the second way to use a
virtual environment on the Taurus. \<a
href="<https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html>"
target="\_blank">Conda\</a> is an open-source package management system
and environment management system from the Anaconda.

[Detailed information](Python#Virtual_environment) about using the
virtual environment.

### \<span style="font-size: 1em;">4.3 Application software availability\</span>

Software created for the purpose of the project should be available for
all members of the group. The instruction of how to use the software:
installation of packages, compilation etc should be documented and gives
the opportunity to comfort efficient and safe work.

### 4.4 Access rights

The concept of **permissions** and **ownership** is crucial in Linux.
See the
[HPC-introduction](%PUBURL%/Compendium/WebHome/HPC-Introduction.pdf?t=1602081321)
slides for the understanding of the main concept. Standard Linux
changing permission command(i.e `chmod`) valid for Taurus as well. The
**group** access level contains members of your project group. Be
careful with 'write' permission and never allow to change the original
data.

Useful links: [Data Management](DataManagement), [File
Systems](FileSystems), [Get Started with HPC-DA](GetStartedWithHPCDA),
[Project Management](ProjectManagement), [Preservation research
data](PreservationResearchData)

## 5. Data moving

### 5.1 Moving data to/from the HPC machines

To copy data to/from the HPC machines, the Taurus [export
nodes](ExportNodes) should be used as a preferred way. There are three
possibilities to exchanging data between your local machine (lm) and the
HPC machines (hm):\<span> **SCP, RSYNC, SFTP**. \</span>\<span
style`"font-size: 1em;">Type following commands in the terminal of the local machine. The </span> ==SCP=`
\<span style="font-size: 1em;"> command was used for the following
example.\</span>

#### Copy data from lm to hm

    scp &lt;file&gt; &lt;zih-user&gt;@taurusexport.hrsk.tu-dresden.de:&lt;target-location&gt;                  #Copy file from your local machine. For example: scp helloworld.txt mustermann@taurusexport.hrsk.tu-dresden.de:/scratch/ws/mastermann-Macine_learning_project/

    scp -r &lt;directory&gt; &lt;zih-user&gt;@taurusexport.hrsk.tu-dresden.de:&lt;target-location&gt;          #Copy directory from your local machine.

#### Copy data from hm to lm

    scp &lt;zih-user&gt;@taurusexport.hrsk.tu-dresden.de:&lt;file&gt; &lt;target-location&gt;                  #Copy file. For example: scp mustermann@taurusexport.hrsk.tu-dresden.de:/scratch/ws/mastermann-Macine_learning_project/helloworld.txt /home/mustermann/Downloads

    scp -r &lt;zih-user&gt;@taurusexport.hrsk.tu-dresden.de:&lt;directory&gt; &lt;target-location&gt;          #Copy directory

### 5.2 Moving data inside the HPC machines. Datamover

The best way to transfer data inside the Taurus is the \<a
href="DataMover" target="\_blank">datamover\</a>. It is the special data
transfer machine provides the best data speed. To load, move, copy etc.
files from one file system to another file system, you have to use
commands with **dt** prefix, such as: **\<span>dtcp, dtwget, dtmv, dtrm,
dtrsync, dttar, dtls. \</span>**\<span style="font-size: 1em;">These
commands submit a job to the data transfer machines that execute the
selected command. Except for the '\</span>\<span style="font-size:
1em;">dt'\</span>\<span style="font-size: 1em;"> prefix, their syntax is
the same as the shell command without the '\</span>\<span
style="font-size: 1em;">dt\</span>\<span style="font-size:
1em;">'\</span>**.**

Keep in mind: The warm_archive is not writable for jobs. However, you
can store the data in the warm archive with the datamover.

Useful links: [Data Mover](DataMover), [Export Nodes](ExportNodes)

## 6. Use of hardware

To run the software, do some calculations or compile your code compute
nodes have to be used. Login nodes which are using for login can not be
used for your computations. Submit your tasks (by using
[jobs](https://en.wikipedia.org/wiki/Job_(computing))) to compute nodes.
The [SLURM](Slurm) (scheduler to handle your jobs) is using on Taurus
for this purposes. [HPC
Introduction](%PUBURL%/Compendium/WebHome/HPC-Introduction.pdf) is a
good resource to get started with it.

### 6.1 What do I need a CPU or GPU?

The main difference between CPU and GPU architecture is that a CPU is
designed to handle a wide range of tasks quickly, but are limited in the
concurrency of tasks that can be running. While GPUs can process data
much faster than a CPU due to massive parallelism (but the amount of
data which single GPU's core can handle is small), GPUs are not as
versatile as CPUs.

### 6.2 Selection of suitable hardware

Available [hardware](HardwareTaurus): Normal compute nodes (Haswell\[
[64,128,256](SystemTaurus#Run_45time_and_Memory_Limits)\], Broadwell,
[Rome](RomeNodes)), Large [SMP nodes](SDFlex), Accelerator(GPU) nodes:
(gpu2 partition, [ml partition](Power9)).

The exact partition could be specified by `-p` flag with the srun
command or in your batch job.

Majority of the basic task could be done on the conventional nodes like
a Haswell. SLURM will automatically select a suitable partition
depending on your memory and --gres (gpu) requirements. If you do not
specify the partition most likely you will be addressed to the Haswell
partition (1328 nodes in total).

#### Parallel jobs:

**MPI jobs**: For MPI jobs typically allocates one core per task.
Several nodes could be allocated if it is necessary. SLURM will
automatically find suitable hardware. Normal compute nodes are perfect
for this task.

**OpenMP jobs**: An SMP-parallel job can only run **within a node**, so
it is necessary to include the options **-N 1** and **-n 1**. Using
--cpus-per-task N SLURM will start one task and you will have N CPUs.
The maximum number of processors for an SMP-parallel program is 896 on
Taurus ( [SMP](SDFlex) island).

**GPUs** partitions are best suited for **repetitive** and
**highly-parallel** computing tasks. If you have a task with potential
[data
parallelism](https://en.wikipedia.org/wiki/Data_parallelism#:~:text=Data%20parallelism%20is%20parallelization%20across,on%20each%20element%20in%20parallel.)
most likely that you need the GPUs. Beyond video rendering, GPUs excel
in tasks such as machine learning, financial simulations and risk
modelling. Use the gpu2 and ml partition only if you need GPUs!
Otherwise using the x86 partitions (e.g Haswell) most likely would be
more beneficial.

**Interactive jobs**: SLURM can forward your X11 credentials to the
first (or even all) node for a job with the --x11 option. To use an
interactive job you have to specify -X flag for the ssh login.

### 6.3 Interactive vs. sbatch

However, using srun directly on the shell will lead to blocking and
launch an interactive job. Apart from short test runs, it is
**recommended to launch your jobs into the background by using batch
jobs**. For that, you can conveniently put the parameters directly into
the job file which you can submit using `sbatch` \[options\] \<job
file>.

### 6.4 Processing of data for input and output

Pre-processing and post-processing of the data is a crucial part for the
majority of data-dependent projects. The quality of this work influence
on the computations. However, pre- and post-processing in many cases can
be done completely or partially on a local pc and then
[transferred](TypicalProjectSchedule#A_5._Data_moving) to the Taurus.
Please use Taurus for the computation-intensive tasks.

Useful links: [Batch Systems](BatchSystems), [Hardware
Taurus](HardwareTaurus), [HPC-DA](HPCDA), [Slurm](Slurm)

## 7. Use of specific software (packages, libraries, etc)

### 7.1 Modular system

The modular concept is the easiest way to work with the software on
Taurus. It allows to user to switch between different versions of
installed programs and provides utilities for the dynamic modification
of a user's environment. The information can be found
[here](RuntimeEnvironment#Modules).

#### Private project and user modules files

[Private project module
files](RuntimeEnvironment#Private_Project_Module_Files)\<span
style="font-size: 1em;"> allow you to load your group-wide installed
software into your environment and to handle different versions. It
allows creating your own software environment for the project. You can
create a list of modules that will be loaded for every member of the
team. It gives opportunity on unifying work of the team and defines the
reproducibility of results. Private modules can be loaded like other
modules with \</span>\<span class="WYSIWYG_TT">module load\</span>\<span
style="font-size: 1em;">.\</span>

[Private user module
files](RuntimeEnvironment#Private_User_Module_Files) allow you to load
your own installed software into your environment. It works in the same
manner as to project modules but for your private use.

### 7.2 Use of containers

[Containerization](https://www.ibm.com/cloud/learn/containerization)
encapsulating or packaging up software code and all its dependencies to
run uniformly and consistently on any infrastructure. On Taurus
[Singularity](https://sylabs.io/) used as a standard container solution.
Singularity enables users to have full control of their environment.
This means that you dont have to ask an HPC support to install anything
for you - you can put it in a Singularity container and run! As opposed
to Docker (the most famous container solution), Singularity is much more
suited to being used in an HPC environment and more efficient in many
cases. Docker containers can easily be used in Singularity. Information
about the use of Singularity on Taurus can be found [here](Container).

\<span style="font-size: 1em;">In some cases using Singularity requires
a Linux machine with root privileges (e.g. using the ml partition), the
same architecture and a compatible kernel. For many reasons, users on
Taurus cannot be granted root permissions. A solution is a Virtual
Machine (VM) on the ml partition which allows users to gain root
permissions in an isolated environment. There are two main options on
how to work with VM on Taurus:\<br />\</span>\<span style="font-size:
1em;">1. \</span> [VM tools](VMTools)\<span style="font-size: 1em;">.
Automative algorithms for using virtual machines;\<br />\</span>\<span
style="font-size: 1em;">2. \</span> [Manual method](Cloud)\<span
style="font-size: 1em;">. It required more operations but gives you more
flexibility and reliability.\<br />\</span>\<span style="font-size:
1em;">Additional Information: Examples of the definition for the
Singularity container (\</span>
[here](SingularityExampleDefinitions)\<span style="font-size: 1em;">)
and some hints (\</span> [here](SingularityRecipeHints)\<span
style="font-size: 1em;">).\</span>

Useful links: [Containers](Container), [Custom EasyBuild
Environment](CustomEasyBuildEnvironment), [Cloud](Cloud)

## 8. Structuring experiments

-   \<p>Input data\</p>
-   \<p>Calculation results\</p>
-   \<p>Log files\</p>
-   \<p>Submission scripts (examples / code for survival)\</p>

## What if everything didn't help?

### Create a ticket: how do I do that?

The best way to ask about the help is to create a ticket. In order to do
that you have to write a message to the <hpcsupport@zih.tu-dresden.de>
with a detailed description of your problem. If it possible please add
logs, used environment and write a minimal executable example for the
purpose to recreate the error or issue.

### \<span style="font-size: 1em;">Communication with HPC support\</span>

There is the HPC support team who is responsible for the support of HPC
users and stable work of the cluster. You could find the
[details](https://tu-dresden.de/zih/hochleistungsrechnen/support) in the
right part of any page of the compendium. However, please, before the
contact with the HPC support team check the documentation carefully
(starting points: [ main page](WebHome), [HPC-DA](HPCDA)), use a
[search](WebSearch) and then create a ticket. The ticket is a preferred
way to solve the issue, but in some terminable cases, you can call to
ask for help.

Useful link: [Further Documentation](FurtherDocumentation)

\<span style="font-size: 1em;">-- Main.AndreiPolitov -
2020-09-14\</span>
