# Contribution Guide

In the following, it is outlined how to contribute to the HPC documentation of TU Dresden and which
rules should be followed when adding to this project.

## Setup
todo

## Git Workflow
todo

##


## Content Rules

### Markdown
todo

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
