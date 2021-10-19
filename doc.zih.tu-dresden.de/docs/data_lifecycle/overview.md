# Data Life Cycle Management

Correct organization of the structure of an HPC project is a straightforward way to the efficient
work of the whole team. There have to be rules and regulations that every member should follow. The
uniformity of the project can be achieved by taking into account and setting up correctly

* the same **set of software** (modules, compiler, packages, libraries, etc),
* a defined **data life cycle management** including the same **data storage** or set of them,
* and **access rights** to project data.

The used set of software within an HPC project can be management with environments on different
levels either defined by [modules](../software/modules.md), [containers](../software/containers.md)
or by [Python virtual environments](../software/python_virtual_environments.md).
In the following, a brief overview on relevant topics w.r.t. data life cycle management is provided.

## Data Storage and Management

The main concept of working with data on ZIH systems bases on [Workspaces](workspaces.md). Use it
properly:

* use a `/home` directory for the limited amount of personal data, simple examples and the results
  of calculations. The home directory is not a working directory! However, `/home` filesystem is
  [backed up](#backup) using snapshots;
* use `workspaces` as a place for working data (i.e. data sets); Recommendations of choosing the
  correct storage system for workspace presented below.

### Taxonomy of Filesystems

It is important to design your data workflow according to characteristics, like I/O footprint
(bandwidth/IOPS) of the application, size of the data, (number of files,) and duration of the
storage to efficiently use the provided storage and filesystems.
The page [filesystems](file_systems.md) holds a comprehensive documentation on the different
filesystems.

!!! hint "Recommendations to choose of storage system"

    * For data that seldom changes but consumes a lot of space, the
      [warm_archive](file_systems.md#warm_archive) can be used.
      (Note that this is mounted **read-only** on the compute nodes).
    * For a series of calculations that works on the same data please use a `scratch` based
      [workspace](workspaces.md).
    * **SSD**, in its turn, is the fastest available filesystem made only for large parallel
      applications running with millions of small I/O (input, output operations).
    * If the batch job needs a directory for temporary data then **SSD** is a good choice as well.
      The data can be deleted afterwards.

Keep in mind that every workspace has a storage duration. Thus, be careful with the expire date
otherwise it could vanish. The core data of your project should be [backed up](#backup) and the most
important data should be [archived](preservation_research_data.md).

### Backup

The backup is a crucial part of any project. Organize it at the beginning of the project. The
backup mechanism on ZIH systems covers **only** the `/home` and `/projects` filesystems. Backed up
files can be restored directly by users, see [Snapshots](permanent.md#snapshots).

!!! warning

    If you accidentally delete your data in the "no backup" filesystems it **can not be restored**!

### Folder Structure and Organizing Data

Organizing of living data using the filesystem helps for consistency of the
project. We recommend following the rules for your work regarding:

* Organizing the data: Never change the original data; Automatize the organizing the data; Clearly
  separate intermediate and final output in the filenames; Carry identifier and original name
  along in your analysis pipeline; Make outputs clearly identifiable; Document your analysis
  steps.
* Naming Data: Keep short, but meaningful names; Keep standard file endings; File names
  don’t replace documentation and metadata; Use standards of your discipline; Make rules for your
  project, document and keep them (See the [README recommendations](#readme-recommendation) below)

This is the example of an organization (hierarchical) for the folder structure. Use it as a visual
illustration of the above:

![Organizing_Data-using_file_systems.png](misc/Organizing_Data-using_file_systems.png)
{: align="center"}

Keep in mind the [input-process-output pattern](https://en.wikipedia.org/wiki/IPO_model#Programming)
for the folder structure within your projects.

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

## Access Rights

The concept of **permissions** and **ownership** is crucial in Linux. See the
[slides of HPC introduction](../misc/HPC-Introduction.pdf) for understanding of the main concept.
Standard Linux changing permission command (i.e `chmod`) valid for ZIH systems as well. The
**group** access level contains members of your project group. Be careful with 'write' permission
and never allow to change the original data.
