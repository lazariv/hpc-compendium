# Contribution Guide

In the following, it is outlined how to contribute to the
[HPC documentation](https://doc.zih.tu-dresden.de/) of
[TU Dresden/ZIH](https://tu-dresden.de/zih/) and
which rules should be followed when adding to this project. Although, this document might seem very
long describing complex steps, contributing is quite easy - trust us.

## Contribute via Issue

Users can contribute to the documentation via the
[issue tracking system](https://gitlab.hrz.tu-chemnitz.de/zih/hpcsupport/hpc-compendium/-/issues).
For that, open an issue to report typos and missing documentation or request for more precise
wording etc. ZIH staff will get in touch with you to resolve the issue and improve the
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

See [Installation with Docker](#preview-using-mkdocs-with-dockerfile).

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
Building a container could be done with the following steps:

```Bash
cd /PATH/TO/hpc-compendium
docker build -t hpc-compendium .
```

To avoid a lot of retyping, use the following in your shell:

```bash
alias wiki="docker run --name=hpc-compendium --rm -it -w /docs --mount src=$PWD/doc.zih.tu-dresden.de,target=/docs,type=bind hpc-compendium bash -c"
```

If you want to see how it looks in your browser, you can use shell commands to serve
the documentation:

```Bash
wiki "mkdocs build --verbose && mkdocs serve -a 0.0.0.0:8000"
```

You can view the documentation via `http://localhost:8000` in your browser, now.

If that does not work, check if you can get the URL for your browser's address
bar from a different terminal window:

```Bash
echo http://$(docker inspect -f "{{.NetworkSettings.IPAddress}}" $(docker ps -qf "name=hpc-compendium")):8000
```

The running container automatically takes care of file changes and rebuilds the
documentation. If you want to check whether the markdown files are formatted
properly, use the following command:

```Bash
wiki 'markdownlint docs'
```

To check whether there are links that point to a wrong target, use
(this may take a while and gives a lot of output because it runs over all files):

```Bash
wiki "find docs -type f -name '*.md' | xargs -L1 markdown-link-check"
```

To check a single file, e. g. `doc.zih.tu-dresden.de/docs/software/big_data_frameworks_spark.md`, use:

```Bash
wiki 'markdown-link-check docs/software/big_data_frameworks_spark.md'
```

For spell-checking a single file, use:

```Bash
wiki 'util/check-spelling.sh <file>'
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
~ git remote add upstream-zih git@gitlab.hrz.tu-chemnitz.de:zih/hpcsupport/hpc-compendium.git
```

Now, you have two remotes, namely *origin* and *upstream-zih*. The remote *origin* points to your fork,
whereas *upstream-zih* points to the original documentation repository at GitLab Chemnitz.

```Shell Session
$ git remote -v
origin  git@gitlab.hrz.tu-chemnitz.de:LOGIN/hpc-compendium.git (fetch)
origin  git@gitlab.hrz.tu-chemnitz.de:LOGIN/hpc-compendium.git (push)
upstream-zih  git@gitlab.hrz.tu-chemnitz.de:zih/hpcsupport/hpc-compendium.git (fetch)
upstream-zih  git@gitlab.hrz.tu-chemnitz.de:zih/hpcsupport/hpc-compendium.git (push)
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
[merge request](https://gitlab.hrz.tu-chemnitz.de/zih/hpcsupport/hpc-compendium/-/merge_requests/new)
to the `main` branch.

### Important Branches

There are two important branches in this repository:

- Preview:
  - Branch containing recent changes which will be soon merged to main branch (protected
    branch)
  - Served at [https://doc.zih.tu-dresden.de/preview](https://doc.zih.tu-dresden.de/preview) from
    TUD-ZIH VPN
- Main: Branch which is deployed at [https://doc.zih.tu-dresden.de](https://doc.zih.tu-dresden.de)
    holding the current documentation (protected branch)

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
