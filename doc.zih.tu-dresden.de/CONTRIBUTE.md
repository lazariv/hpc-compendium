# Contribution Guide

In the following, it is outlined how to contribute to the HPC documentation of
[TU Dresden/ZIH](https://tu-dresden.de/zih/) and which rules should be followed when adding to this
project. Although, this document might seem very long describing complex steps, contributing is
quite easy - trust us.

Steps:

* Synchronize local clone of the repository
* Edit files, make changes
* Run checks locally
* Commit changes to foreign remote and branch BXZ
* Create merge request
* CD/CI pipline starts:
  * Run checks
  * Build documentation
* If CD/CI succeeds, ZIH staff will review the changes and push them to main branch

## Contribute via Issue
Users can contribute to the documentation via the
[issue tracking system](https://gitlab.hrz.tu-chemnitz.de/zih/hpc-compendium/hpc-compendium/-/issues).
Open an issue to report typos and missing documentation or request for more precise wording etc.
ZIH staff will get in touch with you to resolve the issue and improve the documentation.

**Reminder:** Non-documentation issues and requests need to be send as ticket to
[hpcsupport@zih.tu-dresden.de](mailto:hpcsupport@zih.tu-dresden.de).


## Preparation
Contributions can be done via editing the repository through GitLab's web interface or following
the git-based workflow. Both ways are described in the following.

### Fork and Clone Repository

All contributing starts with forking the repository to either
[gitlab.hrz.tu-chemnitz.de](https://gitlab.hrz.tu-chemnitz.de) or any other
git service, e.g., [gitlab.com](https://www.gitlab.com), [github.com](https://www.github.com) or
your personal preference.
Now, create a local clone of your fork

```Shell Session
# SSH based method
git@gitlab.hrz.tu-chemnitz.de:LOGIN/hpc-compendium.git

# HTTP based method
https://gitlab.hrz.tu-chemnitz.de/LOGIN/hpc-compendium.git
```

#### Install Dependencies

TODO: Describtion

```Shell Session
cd hpc-compendium/doc.zih.tu-dresden.de
pip install -r requirements.txt
```

TODO: virtual environment
TODO: What we need for markdownlinter and co checks?

<!--- All branches are protected, i.e., only ZIH staff can create branches and push to them --->


## Contribute via Web IDE

GitLab offers a rich and versatile web interface to work with repositories. To fix typos and edit
source files, just select the file of interest and click the `Edit` button. A text and commit
editor are invoked: Do your changes, add a meaningful commit message and commit the changes.

The more sophisticated integrated Web IDE is reached from the top level menu of the repository or
by selecting any source file.

Other git services might have an aquivivalent web interface to interact with the repository. Please
refer to the corresponding documentation for further information.


<!--This option of contributing is only available for users of-->
<!--[gitlab.hrz.tu-chemnitz.de](https://gitlab.hrz.tu-chemnitz.de). Furthermore, -->


## Contribute via Local Clone

We highly recommend running the checks before committing and posing a merge request.

### mkdocs rocks

As mentioned, this documentation bases on markdown files which are translated into static html files
using the tool [mkdocs](https://www.mkdocs.org/). All markdown source files are located in the
`docs` subfolder. The file `mkdocs.yml` is the single configuration file for the project from layout
up to document structure and extensions.
The navigation section `nav` in `mkdocs.yml` specifies the order, titles and nesting of the
documentation pages.

In principle, `mkdocs` is not mandatory on the local system to contribute to the project. But it
also provides a builtin development server that allows to serve the documentation, i.e. it can
preview the updated documentation locally before committing the changes to the repository.


To make use of `mkdocs`, it is necessary to have two commands in mind
```
mkdocs new [dir-name] - Create a new project.
mkdocs serve - Start the live-reloading docs server.
mkdocs build - Build the documentation site.
mkdocs help - Print this help message.
```

Two? Yes, the `new` command can be ignored, because the project is already started. Furthermore,
`--help` is a de-facto standard switch for a command line tool to provide help.

#### Preview using mkdocs

Invoke`mkdocs serve`to build and preview the documentation. The documentation is automatically
rerenderd and reloaded if the system detects updates (great!). By default, the builtin web server
hosts the documentation at `http://127.0.0.1:8000`.

```Shell Session
~ cd /PATH/TO/hpc-compendium/doc.zih.tu-dresden.de
~ mkdocs serve
INFO    -  Building documentation...
INFO    -  Cleaning site directory
INFO    -  Documentation built in 0.08 seconds
[I 210127 13:33:30 server:335] Serving on http://127.0.0.1:8000
INFO    -  Serving on http://127.0.0.1:8000
[I 210127 13:33:30 handlers:62] Start watching changes
INFO    -  Start watching changes
```

Open `http://127.0.0.1:8000` with a web browser to preview the local copy of the documentation.

#### Build Static Documentation

To build the documentation, invoke `mkdocs build`. This will create a new directory named `public`
which holds the generated static html/jss/css files. This command is used to build the documentation
within the CI/CD pipeline. Thus, it should exit without error.

```Shell Session
~ cd /PATH/TO/hpc-compendium/doc.zih.tu-dresden.de
~ mkdocs build
INFO    -  Cleaning site directory
INFO    -  Building documentation to directory: /PATH/to/hpc-compendium.git/doc.zih.tu-dresden.de/public
INFO    -  Documentation built in 0.09 seconds
```

## Git Workflow
It's important to keep your main branch in sync with upstream when you are working on documentation locally. To get started you will need to do the following:

    Add a remote upstream to point to upstream repository

git remote add upstream git@gitlab.com:NERSC/nersc.gitlab.io.git

You should see two remote endpoints, origin points to your fork and upstream at main repo.

$ git remote -v
origin	git@gitlab.com:<username>/nersc.gitlab.io.git (fetch)
origin	git@gitlab.com:<username>/nersc.gitlab.io.git (push)
upstream	git@gitlab.com:NERSC/nersc.gitlab.io.git (fetch)
upstream	git@gitlab.com:NERSC/nersc.gitlab.io.git (push)

    Checkout main and sync main branch locally from upstream endpoint

git checkout main
git pull upstream main

To push your sync changes to your fork you can do the following:

git push origin main

!!! note Please don't use your main branch to make any changes, this branch is used to sync changes from upstream because all merge requests get pushed to main branch. Instead, create a feature branch from main as follows:
Typical workflow

The user workflow can be described in the following steps assuming you are using upstream repo. Please make sure you sync your main branch prior to creating a branch from main.

git checkout main
git checkout -b <BRANCH>
git add <file1> <file2>
git commit -m <COMMIT MESSAGE>
git push origin <BRANCH>

Next create a merge request to the main branch with your newly created branch. Please make sure the markdownlint check and continuous integration checks have passed for your merge request.

* It is possible the GitLab shared runners will fail for an opaque
  reason (e.g. issues with the cloud provider where they are hosted).
  Hitting the **Retry** button may resolve this problem.



##

If you are totally sure about your commit (e.g., fix a typo), it is only the following steps:

  1. Synchronize branches
  1. Edit the markdown file of interest
  1. Commit change
  1. Push commit to your fork and probaly new branch
  1. Pose Merge Request


### Checks

Several checks are invoked to ensure for a consistent and high quality documentation:

* Markdown linter
* Links
* Code and command examples

TODO:  Describe


### Markdown Linter

The [markdown linter client](https://github.com/igorshubovych/markdownlint-cli) should be invoked to
help keep the markdown source code clean and consistent.

```shell
npm install markdownlint-cli
```

```shell
markdownlint docs/index.md
docs/index.md:8:131 MD013/line-length Line length [Expected: 130; Actual: 138]
```

configuration file: `.markdownlint.json`

Before committing, invoke the script `util/lint-changes.sh` which calls the markdownlint tool for all
(git-)changed markdown files

```shell
sh util/lint-changes.sh
hpc-compendium-2.0-gitlab-tudzih git:(master) ✗ sh util/lint-changes.sh
README.md:6 MD012/no-multiple-blanks Multiple consecutive blank lines [Expected: 1; Actual: 2]
README.md:7 MD012/no-multiple-blanks Multiple consecutive blank lines [Expected: 1; Actual: 3]
README.md:21 MD012/no-multiple-blanks Multiple consecutive blank lines [Expected: 1; Actual: 2]
README.md:22 MD022/blanks-around-headings/blanks-around-headers Headings should be surrounded by blank lines [Expected: 1; Actual: 0; Below] [Context: "### Why is this not at gitlab.hrz.tu-chemnitz.de?"]
[8< 8<]
```

#### Fix Markdown

The markdownlint-cli tool can also be used to fix markdown source file.
```shell
markdownlint --fix [--config .markdownlint.json] docs/index.md
```

## Check Links

We can use `util/check-links.sh` or [markdown-link-check](https://github.com/tcort/markdown-link-check)

```shell
npm i -D markdown-link-check
[8< 8<]
./node_modules/markdown-link-check/markdown-link-check docs/index.md

FILE: docs/index.md
[✖] google.de

1 links checked.

ERROR: 1 dead links found!
[✖] google.de → Status: 400
```




## Content Rules

### Add a New Page

All `mkdocs` project follow this structure:

```Bash
mkdocs.yml    # The configuration file.
docs/
    index.md  # The documentation homepage.
    ...       # Other markdown pages, images and other files.
```

To add a new page to the documentation follow these two steps:

1. Create new markdown file under `docs/SUBDIR/NEW.md` and put the documentation inside
1. Add `SUBDIR/NEW.md` to the configuration file `mkdocs.yml` by updating the navigation section

Make sure that the new page is not floating, i.e., it can be reached directly from the documentation
structure.

### Markdown
TODO: What dialect we are using?


### Writing Style

### Spelling and Technical Wording

* Language settings: en_us
* I/O not IO
* Slurm not SLURM
* Filesystem not file system

### Command Prompts

Showing commands and sample output is a important part of the documentation. Thus, some rules should
be followed.

1. Prompts: It should be clear from the prompt, where the command is run (e.g. Taurus, specific partition or local machine).

   * Taurus / HPC systems of TUD in general: `taurus$`
   * Specific kind of node or partition: `tauruslogin$`, `taurus-ml$` `taurus-rome$`etc.
     * TODO: Remove prefix `taurus`?
   * Local machine: `localhost$`

1. Use generic user name, e.g. `zwulf`:
```shell
taurus$ ls -l
drwxr-xr-x   3 zwulf p_zwulf      4096 Jan 24  2020 code
drwxr-xr-x   3 zwulf p_zwulf      4096 Feb 12  2020 data
-rw-rw----   1 zwulf p_zwulf      4096 Jan 24  2020 readme.md
```

1. Schere: If showing only a snippet of a long output, omissions are marked with
  * `8< 8<`
  * `[snip]`
  * `[...]`
  * TODO: Choose one.

### Code Blocks

All code blocks should be runnable from a login node.








