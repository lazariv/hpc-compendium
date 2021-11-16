# Contributing Using a Local Clone and a Docker Container

## Git Procedure

Please follow this standard Git procedure for working with a local clone:

1. Change to a local (unencrypted) filesystem. (We have seen problems running the container on an
ecryptfs filesystem. So you might want to use e.g. `/tmp` as the start directory.)
1. Create a new directory, e.g. with `mkdir hpc-wiki`
1. Change into the new directory, e.g. `cd hpc-wiki`
1. Clone the Git repository:
`git clone git@gitlab.hrz.tu-chemnitz.de:zih/hpcsupport/hpc-compendium.git .` (don't forget the
dot)
1. Create a new feature branch for you to work in. Ideally, name it like the file you want to
modify or the issue you want to work on, e.g.: `git checkout -b issue-174`. (If you are uncertain
about the name of a file, please look into `mkdocs.yaml`.)
1. Improve the documentation with your preferred editor, i.e. add new files and correct mistakes.
automatically by our CI pipeline.
1. Use `git add <FILE>` to select your improvements for the next commit.
1. Commit the changes with `git commit -m "<DESCRIPTION>"`. The description should be a meaningful
description of your changes. If you work on an issue, please also add "Closes 174" (for issue 174).
1. Push the local changes to the GitLab server, e.g. with `git push origin issue-174`.
1. As an output you get a link to create a merge request against the preview branch.
1. When the merge request is created, a continuous integration (CI) pipeline automatically checks
your contributions.

You can find the details and commands to preview your changes and apply checks in the next section.

## Preparation

Assuming you already have a working Docker installation and have cloned the repository as mentioned
above, a few more steps are necessary.

* a working Docker installation
* all necessary access/execution rights
* a local clone of the repository in the directory `./hpc-wiki`

Build the docker image. This might take a bit longer, but you have to
run it only once in a while.

```bash
cd hpc-wiki
docker build -t hpc-compendium .
```

## Working with the Docker Container

Here is a suggestion of a workflow which might be suitable for you.

### Start the Local Web Server

The command(s) to start the dockerized web server is this:

```bash
docker run --name=hpc-compendium -p 8000:8000 --rm -w /docs --mount src="$(pwd)"/doc.zih.tu-dresden.de,target=/docs,type=bind hpc-compendium bash -c "mkdocs build && mkdocs serve -a 0.0.0.0:8000"
```

You can view the documentation via `http://localhost:8000` in your browser, now.

!!! note

    You can keep the local web server running in this shell to always have the opportunity to see
    the result of your changes in the browser. Simply open another terminal window for other
    commands.

You can now update the contents in you preferred editor. The running container automatically takes
care of file changes and rebuilds the documentation whenever you save a file.

With the details described below, it will then be easy to follow the guidelines for local
correctness checks before submitting your changes and requesting the merge.

### Run the Proposed Checks Inside Container

In our continuous integration (CI) pipeline, a merge request triggers the automated check of

* correct links,
* correct spelling,
* correct text format.

If one of them fails, the merge request will not be accepted. To prevent this, you can run these
checks locally and adapt your files accordingly.

To avoid a lot of retyping, use the following in your shell:

```bash
alias wiki="docker run --name=hpc-compendium --rm -it -w /docs --mount src=$PWD/doc.zih.tu-dresden.de,target=/docs,type=bind hpc-compendium bash -c"
```

You are now ready to use the different checks, however we suggest to try the pre-commit hook.

#### Pre-commit Git Hook

We recommend to automatically run checks whenever you try to commit a change. In this case, failing
checks prevent commits (unless you use option `--no-verify`). This can be accomplished by adding a
pre-commit hook to your local clone of the repository. The following code snippet shows how to do
that:

```bash
cp doc.zih.tu-dresden.de/util/pre-commit .git/hooks/
```

!!! note
    The pre-commit hook only works, if you can use docker without using `sudo`. If this is not
    already the case, use the command `adduser $USER docker` to enable docker commands without
    `sudo` for the current user. Restart the docker daemons afterwards.

Read on if you want to run a specific check.

#### Linter

If you want to check whether the markdown files are formatted properly, use the following command:

```bash
wiki 'markdownlint docs'
```

#### Spell Checker

For spell-checking a single file, , e.g.
`doc.zih.tu-dresden.de/docs/software/big_data_frameworks_spark.md`, use:

```bash
wiki 'util/check-spelling.sh docs/software/big_data_frameworks_spark.md'
```

For spell-checking all files, use:

```bash
wiki 'find docs -type f -name "*.md" | xargs -L1 util/check-spelling.sh'
```

This outputs all words of all files that are unknown to the spell checker.
To let the spell checker "know" a word, append it to
`doc.zih.tu-dresden.de/wordlist.aspell`.

#### Link Checker

To check a single file, e.g.
`doc.zih.tu-dresden.de/docs/software/big_data_frameworks_spark.md`, use:

```bash
wiki 'markdown-link-check docs/software/big_data_frameworks_spark.md'
```

To check whether there are links that point to a wrong target, use
(this may take a while and gives a lot of output because it runs over all files):

```bash
wiki 'find docs -type f -name "*.md" | xargs -L1 markdown-link-check'
```
