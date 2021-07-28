# Data Life Cycle Management

Correct organization of the structure of an HPC project is a straightforward way to the efficient
work of the whole team. There have to be rules and regulations that every member should follow. The
uniformity of the project can be achieved by taking into account and setting up correctly

  * the same **set of software** (modules, compiler, packages, libraries, etc),
  * a defined **data life cycle management** including the same **data storage** or set of them,
  * and **access rights** to project data.

The used set of software within an HPC project can be management with environments on different
levels either defined by [modules](../software/modules.md), [containers](../software/containers.md)
or by [Python virtual environments](../software/python.md).
In the following, a brief overview on relevant topics w.r.t. data life cycle management is provided.

## Data Storage and Management

The main concept of working with data on ZIH systems bases on [Workspaces](workspaces.md). Use it
properly:

  * use a `/home` directory for the limited amount of personal data, simple examples and the results
    of calculations. The home directory is not a working directory! However, `/home` file system is
    [backed up](#backup) using snapshots;
  * use `workspaces` as a place for working data (i.e. datasets); Recommendations of choosing the
    correct storage system for workspace presented below.

### Taxonomy of File Systems

It is important to design your data workflow according to characteristics, like I/O footprint
(bandwidth/IOPS) of the application, size of the data, (number of files,) and duration of the
storage to efficiently use the provided storage and file systems.
The page [file systems](file_systems.md) holds a comprehensive documentation on the different file
systems.
<!--In general, the mechanisms of
so-called--> <!--[Workspaces](workspaces.md) are compulsory for all HPC users to store data for a
defined duration ---> <!--depending on the requirements and the storage system this time span might
range from days to a few--> <!--years.-->
<!--- [HPC file systems](file_systems.md)-->
<!--- [Intermediate Archive](intermediate_archive.md)-->
<!--- [Special data containers] **todo** Special data containers (was no valid link in old compendium)-->
<!--- [Move data between file systems](../data_transfer/data_mover.md)-->
<!--- [Move data to/from ZIH's file systems](../data_transfer/export_nodes.md)-->
<!--- [Longterm Preservation for ResearchData](preservation_research_data.md)-->

!!! hint "Recommendations to choose of storage system"

    * For data that seldomly changes but consumes a lot of space, the
      [warm_archive](file_systems.md#warm_archive) can be used.
      (Note that this is mounted **read-only** on the compute nodes).
    * For a series of calculations that works on the same data please use a `scratch` based [workspace](workspaces.md).
    * **SSD**, in its turn, is the fastest available file system made only for large parallel
      applications running with millions of small I/O (input, output operations).
    * If the batch job needs a directory for temporary data then **SSD** is a good choice as well.
      The data can be deleted afterwards.

Keep in mind that every workspace has a storage duration. Thus, be careful with the expire date
otherwise it could vanish. The core data of your project should be [backed up](#backup) and
[archived]**todo link** (for the most [important]**todo link** data).

### Backup

The backup is a crucial part of any project. Organize it at the beginning of the project. The
backup mechanism on ZIH systems covers **only** the `/home` and `/projects` file systems. Backed up
files can be restored directly by the users. Details can be found
[here](file_systems.md#backup-and-snapshots-of-the-file-system).

!!! warning

    If you accidentally delete your data in the "no backup" file systems it **can not be restored**!

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

![Organizing_Data-using_file_systems.png](misc/Organizing_Data-using_file_systems.png)
{: align="center"}

Keep in mind the [input-process-output pattern](https://en.wikipedia.org/wiki/IPO_model#Programming) for
the folder structure within your projects.

#### README Recommendation

In general, a [README](https://en.wikipedia.org/wiki/README) file provides a brief and general
information on the software or project. A `README` file is used to explain the purpose of the
project and the **structure** of the project in a short way. We recommend providing a `README` file
for entire project as well as for every important folder in the project.

Example of the structure for the README: Think first: What is calculated why? (Description); What is
expected? (software and version)

!!! example "README"

    ```Bash
    Title:
    User:
    Date:
    Description:
    Software:
    Version:
    Repo URL:
    ```

### Metadata

Another important aspect is the Metadata. It is sufficient to use
[Metadata](preservation_research_data.md#what-are-meta-data) for your HPC project. Metadata
standards, i.e., 
[Dublin core](http://dublincore.org/resources/metadata-basics/),
[OME](https://www.openmicroscopy.org/),
will help to do it easier. 

### Data Hygiene

Don't forget about data hygiene: Classify your current data into critical (need it now), necessary
(need it later) or unnecessary (redundant, trivial or obsolete); Track and classify data throughout
its life cycle (from creation, storage and use to sharing, archiving and destruction); Erase the data
you don’t need throughout its life cycle.

<!--## Software Packages-->

<!--As was written before the module concept is the basic concept for using software on Taurus.-->
<!--Uniformity of the project has to be achieved by using the same set of software on different levels.-->
<!--It could be done by using environments. There are two types of environments should be distinguished:-->
<!--runtime environment (the project level, use scripts to load [modules]**todo link**), Python virtual-->
<!--environment.  The concept of the environment will give an opportunity to use the same version of the-->
<!--software on every level of the project for every project member.-->

<!--### Private Individual and Project Modules Files-->

<!--[Private individual and project module files]**todo link** will be discussed in [chapter 7]**todo-->
<!--link**. Project modules list is a powerful instrument for effective teamwork.-->

<!--### Python Virtual Environment-->

<!--If you are working with the Python then it is crucial to use the virtual environment on Taurus. The-->
<!--main purpose of Python virtual environments (don't mess with the software environment for modules)-->
<!--is to create an isolated environment for Python projects (self-contained directory tree that-->
<!--contains a Python installation for a particular version of Python, plus a number of additional-->
<!--packages).-->

<!--**Vitualenv (venv)** is a standard Python tool to create isolated Python environments. We-->
<!--recommend using venv to work with Tensorflow and Pytorch on Taurus. It has been integrated into the-->
<!--standard library under the [venv module]**todo link**. **Conda** is the second way to use a virtual-->
<!--environment on the Taurus. Conda is an open-source package management system and environment-->
<!--management system from the Anaconda.-->

<!--[Detailed information]**todo link** about using the virtual environment.-->

<!--## Application Software Availability-->

<!--Software created for the purpose of the project should be available for all members of the group.-->
<!--The instruction of how to use the software: installation of packages, compilation etc should be-->
<!--documented and gives the opportunity to comfort efficient and safe work.-->

## Access rights

The concept of **permissions** and **ownership** is crucial in Linux. See the
[HPC-introduction]**todo link** slides for the understanding of the main concept. Standard Linux
changing permission command (i.e `chmod`) valid for Taurus as well. The **group** access level
contains members of your project group. Be careful with 'write' permission and never allow to change
the original data.

Useful links: [Data Management]**todo link**, [File Systems]**todo link**, [Get Started with
HPC-DA]**todo link**, [Project Management]**todo link**, [Preservation research data[**todo link**
