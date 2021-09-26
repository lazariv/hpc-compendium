# Contributing Using a Local Clone and a Docker Container

## Git Procedure

Please follow this standard Git procedure for working with a local clone:

1. Change to a local (unencrypted) filesystem. (We have seen problems running the container
an ecryptfs filesystem. So you might
want to use e.g. `/tmp` as root directory.)
1. Get a clone of the Git: `git clone git@gitlab.hrz.tu-chemnitz.de:zih/hpc-compendium/hpc-compendium.git`
1. Change to the root of the Git colen: `cd hpc-compendium`
1. Create a new feature branch for you to work in. Ideally name it like the file you want
to modify. `git checkout -b <BRANCHNAME>`. (Navigation section can be found in `mkdocs.yaml`.)
1. Add/correct the documentation with your preferred editor.
1. Run the correctness checks until everything is fine. - Incorrect files will be rejected
automatically by our CI pipeline.
1. Commit the changes with `git commit -m "<DESCRIPTION>" <FILE LIST>`. Include a description
of the change and a list of all changed files.
1. Push the local changes to the global feature branch with `git push origin <BRANCHNAME>`.
1. As an output you get a https link. Follow it to create the merge request against the preview branch.

You can find the details and command in the next section.

## Preparation

Assuming you understand in principle how to work with our Git. Now you need:

* a system with running Docker installation
* all necessary access/execution rights
* a local clone of the repository in the directory `./hpc-compendium`

Build the docker image. This might take a bit longer, but you have to
run it only once in a while.

```Bash
cd hpc-compendium
docker build -t hpc-compendium . 
```

## Working with the Docker Container

Here is a suggestion of a workflow which might be suitable for you.

### Start the Local Web Server

The command(s) to start the dockerized web server is this:

```Bash
docker run --name=hpc-compendium -p 8000:8000 --rm -it -w /docs \
  -v /tmp/hpc-compendium/doc.zih.tu-dresden.de:/docs:z hpc-compendium bash \
  -c 'mkdocs build  && mkdocs serve -a 0.0.0.0:8000'
```

To follow its progress let it run in a single shell (terminal window)
and open another one for the other steps.

You can view the documentation via
[http://localhost:8000](http://localhost:8000) in your browser, now.

You can now update the contents in you preferred editor.
The running container automatically takes care of file changes and rebuilds the
documentation.

With the details described below, it will then be easy to follow the guidelines
for local correctness checks before submitting your changes and requesting
the merge.

### Run the Proposed Checks Inside Container

In our continuous integration (CI) pipeline, a merge request triggers the automated check of

* correct links,
* correct spelling,
* correct text format.

If one of them fails the merge request will be recjected. To prevent this you can run these
checks locally and adapt your files accordingly.

!!! note
    Remember to keep the local web server running in the other shell.

First, change to the `hpc-compendium` directory and set the environment
variable DC to save a lot of keystrokes :-)

```Bash
export DC='docker exec -it hpc-compendium bash -c '
```

and use it like this...

#### Link Checker

To check a single file, e.g.
`doc.zih.tu-dresden.de/docs/software/big_data_frameworks.md`, use:

```Bash
$DC 'markdown-link-check docs/software/big_data_frameworks.md'
```

To check whether there are links that point to a wrong target, use
(this may take a while and gives a lot of output because it runs over all files):

```Bash
$DC 'find docs -type f -name "*.md" | xargs -L1 markdown-link-check'
```

#### Spell Checker

For spell-checking a single file, , e.g.
`doc.zih.tu-dresden.de/docs/software/big_data_frameworks.md`, use:

```$DC './util/check-spelling.sh docs/software/big_data_frameworks.md'
```

For spell-checking all files, use:

```Bash
$DC ./util/check-spelling.sh
```

This outputs all words of all files that are unknown to the spell checker.
To let the spell checker "know" a word, append it to
`doc.zih.tu-dresden.de/wordlist.aspell`.

#### Linter

If you want to check whether the markdown files are formatted
properly, use the following command:

```Bash
$DC 'markdownlint docs'
```






