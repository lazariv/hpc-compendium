# Create a project structure. Data management

Correct organisation of the project structure is a straightforward way to the efficient work of the
whole team. There have to be rules and regulations for working with the project that every member
should follow. The uniformity of the project could be achieved by using for each member of a team:
the same **data storage** or set of them, the same **set of software** (packages, libraries etc),
**access rights** to project data should be taken into account and set up correctly.

## Data Storage and Management

### Taxonomy of File Systems

As soon as you have access to Taurus you have to manage your data. The main concept of
working with data on Taurus bases on [Workspaces](workspaces.md). Use it properly:

  * use a **/home** directory for the limited amount of personal data, simple examples and the results
    of calculations. The home directory is not a working directory! However, /home file system is
    backed up using snapshots;
  * use **workspace** as a place for working data (i.e. datasets); Recommendations of choosing the
    correct storage system for workspace presented below.

**Recommendations to choose of storage system:** For data that seldomly changes but consumes a lot
of space, the **warm_archive** can be used. (Note that this is mounted **read-only** on the compute
nodes). For a series of calculations that works on the same data please use a **scratch** based
workspace. **SSD**, in its turn, is the fastest available file system made only for large parallel
applications running with millions of small I/O (input, output operations). If the batch job needs a
directory for temporary data then **SSD** is a good choice as well. The data can be deleted
afterwards.

*Note:* Keep in mind that every working space has a storage duration (i.e. ssd - 30 days). Thus be
careful with the expire date otherwise it could vanish. The core data of your project should be
[backed up]**todo link** and [archived]**todo link**(for the most [important]**todo link** data).

### Backup

The backup is a crucial part of any project. Organize it at the beginning of the project. If you
will lose/delete your data in the "no back up" file systems it can not be restored! The backup on
Taurus is **only** available in the **/home** and the **/projects** file systems! Backed up files
could be restored by the user. Details could be found [here]**todo link**.

### Folder Structure and Organizing Data

Organizing of living data using the file system helps for consistency and structuredness of the
project. We recommend following the rules for your work regarding:

  * Organizing the data: Never change the original data; Automatize the organizing the data; Clearly
    separate intermediate and final output in the filenames; Carry identifier and original name
    along in your analysis pipeline; Make outputs clearly identifiable; Document your analysis
    steps.
  * Naming Data: Keep short, but meaningful names; Keep standard file endings; File names
    don’t replace documentation and metadata; Use standards of your discipline; Make rules for your
    project, document and keep them (See the [README recommendations]**todo link** below)

This is the example of an organisation (hierarchical) for the folder structure. Use it as a visual
illustration of the above:

**todo** Insert grapic *Organizing_Data-using_file_systems.png*

Keep in mind [input-process-output pattern]**todo link** for the work with folder structure.

### README Recommendation

<<<<<<< HEAD
In general, [README]**todo link** is just simple general information of software/project that exists
in the same directory/repository of the project. README is used to explain the details project and
the **structure** of the project/folder in a short way. We recommend using readme as for entire
project as for every important folder in the project.
=======
In general, [README]**todo link** is just simple general information of software/project that exists in the
same directory/repository of the project. README is used to explain the details project and the
**structure** of the project/folder in a short way. We recommend using readme as for entire project as
for every important folder in the project.
>>>>>>> issue#6

Example of the structure for the README:
Think first: What is calculated why? (Description); What is
expected? (software and version)

Example text file

```Bash
Title:
User: Date:
Description:
Software:
Version:
```

### Metadata

<<<<<<< HEAD
Another important aspect is the [Metadata]**todo link**. It is sufficient to use [Metadata]**todo
link** for your project on Taurus. [Metadata standards]**todo link** will help to do it easier (i.e.
[Dublin core]**todo link**, [OME]**todo link**)
=======
Another important aspect is the [Metadata]**todo link**. It is sufficient to use [Metadata]**todo link** for your
project on Taurus. [Metadata standards]**todo link** will help to do it easier (i.e. [Dublin core]**todo link**,
[OME]**todo link**)
>>>>>>> issue#6

### Data Hygiene

Don't forget about data hygiene: Classify your current data into critical (need it now), necessary
(need it later) or unnecessary (redundant, trivial or obsolete); Track and classify data throughout
its lifecycle (from creation, storage and use to sharing, archiving and destruction); Erase the data
you don’t need throughout its lifecycle.

## Software Packages

As was written before the module concept is the basic concept for using software on Taurus.
Uniformity of the project has to be achieved by using the same set of software on different levels.
It could be done by using environments. There are two types of environments should be distinguished:
runtime environment (the project level, use scripts to load [modules]**todo link**), Python virtual
environment.  The concept of the environment will give an opportunity to use the same version of the
software on every level of the project for every project member.

### Private individual and project modules files

<<<<<<< HEAD
[Private individual and project module files]**todo link** will be discussed in [chapter 7]**todo
link**. Project modules list is a powerful instrument for effective teamwork.
=======
[Private individual and project module files]**todo link** will be discussed in [chapter 7]**todo link**. Project
modules list is a powerful instrument for effective teamwork.
>>>>>>> issue#6

### Python virtual environment

If you are working with the Python then it is crucial to use the virtual environment on Taurus. The
main purpose of Python virtual environments (don't mess with the software environment for modules)
is to create an isolated environment for Python projects (self-contained directory tree that
contains a Python installation for a particular version of Python, plus a number of additional
packages).

**Vitualenv (venv)** is a standard Python tool to create isolated Python environments. We
recommend using venv to work with Tensorflow and Pytorch on Taurus. It has been integrated into the
standard library under the [venv module]**todo link**. **Conda** is the second way to use a virtual
environment on the Taurus. Conda is an open-source package management system and environment
management system from the Anaconda.

[Detailed information]**todo link** about using the virtual environment.

## Application Software Availability

Software created for the purpose of the project should be available for all members of the group.
The instruction of how to use the software: installation of packages, compilation etc should be
documented and gives the opportunity to comfort efficient and safe work.

## Access rights

The concept of **permissions** and **ownership** is crucial in Linux. See the
<<<<<<< HEAD
[HPC-introduction]**todo link** slides for the understanding of the main concept. Standard Linux
changing permission command (i.e `chmod`) valid for Taurus as well. The **group** access level
contains members of your project group. Be careful with 'write' permission and never allow to change
the original data.

Useful links: [Data Management]**todo link**, [File Systems]**todo link**, [Get Started with
HPC-DA]**todo link**, [Project Management]**todo link**, [Preservation research data[**todo link**
=======
[HPC-introduction]**todo link** slides for the understanding of the main concept. Standard Linux changing
permission command (i.e `chmod`) valid for Taurus as well. The **group** access level contains
members of your project group. Be careful with 'write' permission and never allow to change the
original data.

Useful links: [Data Management]**todo link**, [File Systems]**todo link**, [Get Started with HPC-DA]**todo link**,
[Project Management]**todo link**, [Preservation research data[**todo link**
>>>>>>> issue#6
