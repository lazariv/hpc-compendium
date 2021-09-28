# Contribution Guide

In the following, it is outlined how to contribute to the
[HPC documentation](https://doc.zih.tu-dresden.de/) of
[TU Dresden/ZIH](https://tu-dresden.de/zih/) and
which rules should be followed when adding to this project. Although, this document might seem very
long describing complex steps, contributing is quite easy - trust us.

## Contribute via Issue

Users can contribute to the documentation via the
[issue tracking system](https://gitlab.hrz.tu-chemnitz.de/zih/hpc-compendium/hpc-compendium/-/issues).
For that, open an issue to report typos and missing documentation or request for more precise
wording etc.  ZIH staff will get in touch with you to resolve the issue and improve the
documentation.

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
~ git@gitlab.hrz.tu-chemnitz.de:LOGIN/hpc-compendium.git

# HTTP based method
~ https://gitlab.hrz.tu-chemnitz.de/LOGIN/hpc-compendium.git
```

#### Install Dependencies

**TODO:** Description

```Shell Session
~ cd hpc-compendium/doc.zih.tu-dresden.de
~ pip install -r requirements.txt
```

**TODO:** virtual environment
**TODO:** What we need for markdownlinter and checks?

<!--- All branches are protected, i.e., only ZIH staff can create branches and push to them --->

## Contribute via Web IDE

GitLab offers a rich and versatile web interface to work with repositories. To fix typos and edit
source files, just select the file of interest and click the `Edit` button. A text and commit
editor are invoked: Do your changes, add a meaningful commit message and commit the changes.

The more sophisticated integrated Web IDE is reached from the top level menu of the repository or
by selecting any source file.

Other git services might have an equivalent web interface to interact with the repository. Please
refer to the corresponding documentation for further information.

<!--This option of contributing is only available for users of-->
<!--[gitlab.hrz.tu-chemnitz.de](https://gitlab.hrz.tu-chemnitz.de). Furthermore, -->

## Contribute via Local Clone

### mkdocs Rocks

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
~ mkdocs serve - Start the live-reloading docs server.
~ mkdocs build - Build the documentation site.
```

#### Preview Using mkdocs

Invoke`mkdocs serve`to build and preview the documentation. The documentation is automatically
rerendered and reloaded if the system detects updates (great!). By default, the builtin web server
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

#### Preview Using mkdocs With Dockerfile

You can also use `docker` to build a container from the `Dockerfile`, if you are familiar with it.
This may take a while, as mkdocs and other necessary software needs to be downloaded.
Building a container with the documentation inside could be done with the following steps:

```Bash
cd /PATH/TO/hpc-compendium
docker build -t hpc-compendium .
```

If you want to see how it looks in your browser, you can use shell commands to serve
the documentation:

```Bash
docker run --name=hpc-compendium -p 8000:8000 --rm -it -w /docs --mount src="$(pwd)"/doc.zih.tu-dresden.de,target=/docs,type=bind hpc-compendium bash -c "mkdocs build --verbose && mkdocs serve -a 0.0.0.0:8000"
```

You can view the documentation via [http://localhost:8000](http://localhost:8000) in your browser, now.

If that does not work, check if you can get the URL for your browser's address
bar from a different terminal window:

```Bash
echo http://$(docker inspect -f "{{.NetworkSettings.IPAddress}}" $(docker ps -qf "name=hpc-compendium")):8000
```

The running container automatically takes care of file changes and rebuilds the
documentation.  If you want to check whether the markdown files are formatted
properly, use the following command:

```Bash
docker run --name=hpc-compendium --rm -it -w /docs/doc.zih.tu-dresden.de --mount src="$(pwd)",target=/docs,type=bind hpc-compendium markdownlint docs
```

To check whether there are links that point to a wrong target, use
(this may take a while and gives a lot of output because it runs over all files):

```Bash
docker run --name=hpc-compendium --rm -it -w /docs --mount src="$(pwd)"/doc.zih.tu-dresden.de,target=/docs,type=bind hpc-compendium bash -c "find docs -type f -name '*.md' | xargs -L1 markdown-link-check"
```

To check a single file, e. g. `doc.zih.tu-dresden.de/docs/software/big_data_frameworks.md`, use:

```Bash
docker run --name=hpc-compendium --rm -it -w /docs --mount src="$(pwd)"/doc.zih.tu-dresden.de,target=/docs,type=bind hpc-compendium markdown-link-check docs/software/big_data_frameworks.md
```

For spell-checking a single file, use:

```Bash
docker run --name=hpc-compendium --rm -it -w /docs --mount src="$(pwd)",target=/docs,type=bind hpc-compendium ./doc.zih.tu-dresden.de/util/check-spelling.sh <file>
```

For spell-checking all files, use:

```Bash
docker run --name=hpc-compendium --rm -it -w /docs --mount src="$(pwd)",target=/docs,type=bind hpc-compendium ./doc.zih.tu-dresden.de/util/check-spelling.sh
```

This outputs all words of all files that are unknown to the spell checker.
To let the spell checker "know" a word, append it to
`doc.zih.tu-dresden.de/wordlist.aspell`.

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

### Git Workflow

It is crucial to keep your branch synchronized with the upstream repository when you are working
locally on the documentation. At first, you should add a remote pointing to the official
documentation.

```Shell Session
~ git remote add upstream-zih git@gitlab.hrz.tu-chemnitz.de:zih/hpc-compendium/hpc-compendium.git
```

Now, you have two remotes, namely *origin* and *upstream-zih*. The remote *origin* points to your fork,
whereas *upstream-zih* points to the original documentation repository at GitLab Chemnitz.

```Shell Session
$ git remote -v
origin  git@gitlab.hrz.tu-chemnitz.de:LOGIN/hpc-compendium.git (fetch)
origin  git@gitlab.hrz.tu-chemnitz.de:LOGIN/hpc-compendium.git (push)
upstream-zih  git@gitlab.hrz.tu-chemnitz.de:zih/hpc-compendium/hpc-compendium.git (fetch)
upstream-zih  git@gitlab.hrz.tu-chemnitz.de:zih/hpc-compendium/hpc-compendium.git (push)
```

Next, you should synchronize your `main` branch with the upstream.

```Shell Session
~ git checkout main
~ git pull upstream main
```

At this point, your `main` branch is up-to-date with the original documentation of HPC compendium.

<!--To push your sync changes to your fork you can do the following:-->
<!--git push origin main-->

#### Making Changes and Merge Requests

It is good git-practise to only use the `main` branch for synchronization with the upstream, not for
changes, as outlined in the previous subsection. In order to commit to this documentation, create a
new branch (a so-called feature branch) basing on the `main` branch and commit your changes to it.

```Shell Session
~ git checkout main
~ git checkout -b <FEATUREBRANCH>
# Edit file1, file2 etc.
~ git add <file1> <file2>
~ git commit -m <COMMIT MESSAGE>
~ git push origin <FEATUREBRANCH>
```

The last command pushes the changes to your remote at branch `FEATUREBRANCH`. Now, it is time to
incorporate the changes and improvements into the HPC Compendium. For this, create a
[merge request](https://gitlab.hrz.tu-chemnitz.de/zih/hpc-compendium/hpc-compendium/-/merge_requests/new)
to the `main` branch.

### Important Branches

There are two important branches in this repository:

- Preview:
  - Branch containing recent changes which will be soon merged to main branch (protected
    branch)
  - Served at [todo url](todo url) from TUD VPN
- Main: Branch which is deployed at [doc.zih.tu-dresden.de](doc.zih.tu-dresden.de) holding the
    current documentation (protected branch)

If you are totally sure about your commit (e.g., fix a typo), it is only the following steps:

  1. Synchronize branches
  1. Edit the markdown file of interest
  1. Commit change
  1. Push commit to your fork and probably new branch
  1. Pose Merge Request

## Checks

We have several checks on the markdown sources to ensure for a consistent and high quality of the
documentation. These checks are run within the CI/CD pipeline and changes are only deployed to the
HPC compendium, if the checks are passed. Thus, we **highly recommend** running the checks locally
before committing and posing a merge request.

* Markdown linter
* Check internal and external links
* Check code and command examples

### Markdown Linter

The [markdown linter client](https://github.com/igorshubovych/markdownlint-cli) helps to keep the
markdown source code clean and consistent.

Installation

```Shell Session
~ [sudo] npm [-g]  install markdownlint-cli
```

The configuration is stored in `.markdownlintrc`.
The tool `markdownlint` can be run in dry or fix mode.
The *dry* mode (default) only outputs findings, whereas in *fix* mode it resolves basic
errors directly in the markdown files.

```Shell Session
~ cd doc.zih.tu-dresden.de/
~ markdownlint [--fix] docs/index.md
docs/index.md:8:131 MD013/line-length Line length [Expected: 130; Actual: 138]
```

Before committing, invoke the script `util/lint-changes.sh` which calls the markdownlint tool for all
(git-)changed markdown files.

```Shell Session
~ sh util/lint-changes.sh
hpc-compendium-2.0-gitlab-tudzih git:(master) ✗ sh util/lint-changes.sh
README.md:6 MD012/no-multiple-blanks Multiple consecutive blank lines [Expected: 1; Actual: 2]
README.md:7 MD012/no-multiple-blanks Multiple consecutive blank lines [Expected: 1; Actual: 3]
README.md:21 MD012/no-multiple-blanks Multiple consecutive blank lines [Expected: 1; Actual: 2]
README.md:22 MD022/blanks-around-headings/blanks-around-headers Headings should be surrounded by blank lines [Expected: 1; Actual: 0; Below] [Context: "### Why is this not at gitlab.hrz.tu-chemnitz.de?"]
[8< 8<]
```

### Check Links

No one likes dead links. Therefore, we check the internal and external links within the markdown
source files. For that, the script `util/check-links.sh` and the tool
[markdown-link-check](https://github.com/tcort/markdown-link-check) can be used.

The tool `markdown-link-check` checks links within a certain file (or using some shell magic for all
markdown files, as depicted below). On the other hand, the script `util/check-links.sh` checks only
links for files in the repository, which are gifferent (gifferent is a word composition from *git*
and *different to main branch*).

#### Markdown-link-check

Installation (see [official documentation](https://github.com/tcort/markdown-link-check#installation))

```Shell Session
~ [sudo] npm [-g] install markdown-link-check
```

Run check

```Shell Session
~ cd doc.zih.tu-dresden.de/
~ markdown-link-check docs/jobs/Slurm.md

FILE: docs/jobs/Slurm.md
[✖] Slurmgenerator
[✖] Compendium.RunningNxGpuAppsInOneJob
[✓] https://slurm.schedmd.com/sbatch.html
[✖] BindingAndDistributionOfTasks
[✓] http://slurm.schedmd.com/hdf5_profile_user_guide.html
[✓] http://slurm.schedmd.com/sh5util.html
[✓] mailto:hpcsupport@zih.tu-dresden.de
[✓] http://slurm.schedmd.com/
[✓] http://www.schedmd.com/slurmdocs/rosetta.html

9 links checked.

ERROR: 3 dead links found!
[✖] Slurmgenerator → Status: 400
[✖] Compendium.RunningNxGpuAppsInOneJob → Status: 400
[✖] BindingAndDistributionOfTasks → Status: 400
```

In this example, all external links are fine, but three links to internal documents need to be
fixed.

To check the links within all markdown files in one sweep, some shell magic is necessary

```Shell Session
~ cd doc.zih.tu-dresden.de/
~ find . -name \*.md -exec markdown-link-check {} \;
```

#### Check-links.sh

The script `util/check-links.sh` checks links for all gifferent files, i.e., markdown files which
are part of the repository and different to the `main` branch. Use this script before committing your
changes to make sure your commit passes the CI/CD pipeline.

### Check Code and Commands

The script `xyz.sh` checks if the code chunks are runnable on a login node.
It is invoked as follows ...

**TODO:** Implement [Issue #9](#9)

### Check Pages Structure

The script `util/check-no-floating.sh` first checks the hierarchy depth of the pages structure and
the second check tests if every markdown file is included in the navigation section of the
`mkdocs.yaml` file.

The script is invoked and reports as follows

```Shell Session
~ sh doc.zih.tu-dresden.de/util/check-no-floating.sh doc.zih.tu-dresden.de
HardwareTaurus.md is not included in nav
BigDataFrameworksApacheSparkApacheFlinkApacheHadoop.md is not included in nav
pika.md is not included in nav
specific_software.md is not included in nav
```

## Content Rules

**Remark:** Avoid using tabs both in markdown files and in `mkdocs.yaml`. Type spaces instead.

### New Page and Pages Structure

The pages structure is defined in the configuration file [mkdocs.yaml](doc.zih.tu-dresden.de/mkdocs.yml).

```Shell Session
docs/
  - Home: index.md
  - Application for HPC Login: application.md
  - Request for Resources: req_resources.md
  - Access to the Cluster: access.md
  - Available Software and Usage:
    - Overview: software/overview.md
  ...
```

To add a new page to the documentation follow these two steps:

1. Create a new markdown file under `docs/subdir/file_name.md` and put the documentation inside. The
   sub directory and file name should follow the pattern `fancy_title_and_more.md`.
1. Add `subdir/file_name.md` to the configuration file `mkdocs.yml` by updating the navigation
   section.

Make sure that the new page **is not floating**, i.e., it can be reached directly from the documentation
structure.

### Markdown

1. Please keep things simple, i.e., avoid using fancy markdown dialects.
    * [Cheat Sheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
    * [Style Guide](https://github.com/google/styleguide/blob/gh-pages/docguide/style.md)

1. Do not add large binary files or high resolution images to the repository. See this valuable
   document for [image optimization](https://web.dev/fast/#optimize-your-images).

1. [Admonitions](https://squidfunk.github.io/mkdocs-material/reference/admonitions/) may be
actively used, especially for longer code examples, warnings, tips, important information that
should be highlighted, etc. Code examples, longer than half screen height should collapsed
(and indented):

??? example
    ```Bash
    [...]
    # very long example here
    [...]
    ```

### Writing Style

**TODO** Guide [Issue #14](#14)

* Capitalize headings, e.g. *Exclusive Reservation of Hardware*

### Spelling and Technical Wording

To provide a consistent and high quality documentation, and help users to find the right pages,
there is a list of conventions w.r.t. spelling and technical wording.

* Language settings: en_us
* `I/O` not `IO`
* `Slurm` not `SLURM`
* `Filesystem` not `file system`
* `ZIH system` and `ZIH systems` not `Taurus`, `HRSKII`, `our HPC systems` etc.
* `Workspace` not `work space`
* avoid term `HPC-DA`

### Code Blocks and Command Prompts

Showing commands and sample output is an important part of all technical documentation. To make
things as clear for readers as possible and provide a consistent documentation, some rules have to
be followed.

1. Use ticks to mark code blocks and commands, not italic font.
1. Specify language for code blocks ([see below](#code-blocks-and-syntax-highlighting)).
1. All code blocks and commands should be runnable from a login node or a node within a specific
   partition (e.g., `ml`).
1. It should be clear from the prompt, where the command is run (e.g. local machine, login node or
   specific partition).

#### Prompts

We follow this rules regarding prompts:

| Host/Partition         | Prompt           |
|------------------------|------------------|
| Login nodes            | `marie@login$`   |
| Arbitrary compute node | `marie@compute$` |
| `haswell` partition    | `marie@haswell$` |
| `ml` partition         | `marie@ml$`      |
| `alpha` partition      | `marie@alpha$`   |
| `alpha` partition      | `marie@alpha$`   |
| `romeo` partition      | `marie@romeo$`   |
| `julia` partition      | `marie@julia$`   |
| Localhost              | `marie@local$`   |

*Remarks:*

* **Always use a prompt**, even there is no output provided for the shown command.
* All code blocks should use long parameter names (e.g. Slurm parameters), if available.
* All code blocks which specify some general command templates, e.g. containing `<` and `>`
  (see [Placeholders](#mark-placeholders)), should use `bash` for the code block. Additionally,
  an example invocation, perhaps with output, should be given with the normal `console` code block.
  See also [Code Block description below](#code-blocks-and-syntax-highlighting).
* Using some magic, the prompt as well as the output is identified and will not be copied!
* Stick to the [generic user name](#data-privacy-and-generic-user-name) `marie`.

#### Code Blocks and Syntax Highlighting

This project makes use of the extension
[pymdownx.highlight](https://squidfunk.github.io/mkdocs-material/reference/code-blocks/) for syntax
highlighting.  There is a complete list of supported
[language short codes](https://pygments.org/docs/lexers/).

For consistency, use the following short codes within this project:

With the exception of command templates, use `console` for shell session and console:

```` markdown
```console
marie@login$ ls
foo
bar
```
````

Make sure that shell session and console code blocks are executable on the login nodes of HPC system.

Command templates use [Placeholders](#mark-placeholders) to mark replaceable code parts. Command
templates should give a general idea of invocation and thus, do not contain any output. Use a
`bash` code block followed by an invocation example (with `console`):

```` markdown
```bash
marie@local$ ssh -NL <local port>:<compute node>:<remote port> <zih login>@tauruslogin.hrsk.tu-dresden.de
```

```console
marie@local$ ssh -NL 5901:172.24.146.46:5901 marie@tauruslogin.hrsk.tu-dresden.de
```
````

Also use `bash` for shell scripts such as jobfiles:

```` markdown
```bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=01:00:00
#SBATCH --output=slurm-%j.out

module load foss

srun a.out
```
````

!!! important

    Use long parameter names where possible to ease understanding.

`python` for Python source code:

```` markdown
```python
from time import gmtime, strftime
print(strftime("%Y-%m-%d %H:%M:%S", gmtime()))
```
````

`pycon` for Python console:

```` markdown
```pycon
>>> from time import gmtime, strftime
>>> print(strftime("%Y-%m-%d %H:%M:%S", gmtime()))
2021-08-03 07:20:33
```
````

Line numbers can be added via

```` markdown
```bash linenums="1"
#!/bin/bash

#SBATCH -N 1
#SBATCH -n 23
#SBATCH -t 02:10:00

srun a.out
```
````

_Result_:

![lines](misc/lines.png)

Specific Lines can be highlighted by using

```` markdown
```bash hl_lines="2 3"
#!/bin/bash

#SBATCH -N 1
#SBATCH -n 23
#SBATCH -t 02:10:00

srun a.out
```
````

_Result_:

![lines](misc/highlight_lines.png)

### Data Privacy and Generic User Name

Where possible, replace login, project name and other private data with clearly arbitrary placeholders.
E.g., use the generic login `marie` and the corresponding project name `p_marie`.

```console
marie@login$ ls -l
drwxr-xr-x   3 marie p_marie      4096 Jan 24  2020 code
drwxr-xr-x   3 marie p_marie      4096 Feb 12  2020 data
-rw-rw----   1 marie p_marie      4096 Jan 24  2020 readme.md
```

### Mark Omissions

If showing only a snippet of a long output, omissions are marked with `[...]`.

### Mark Placeholders

Stick to the Unix rules on optional and required arguments, and selection of item sets:

* `<required argument or value>`
* `[optional argument or value]`
* `{choice1|choice2|choice3}`

## Graphics and Attachments

All graphics and attachments are saved within `misc` directory of the respective sub directory in
`docs`.

The syntax to insert a graphic or attachment into a page is

```Bash
![PuTTY: Switch on X11](misc/putty2.jpg)
{: align="center"}
```

The attribute `align` is optional. By default, graphics are left aligned. **Note:** It is crucial to
have `{: align="center"}` on a new line.
