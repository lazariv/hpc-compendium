# Contributing Using a Local Clone and a Docker Container

see also: [https://gitlab.hrz.tu-chemnitz.de/zih/hpcsupport/hpc-compendium/-/blob/preview/doc.zih.tu-dresden.de/README.md]

## Prerequisites

Assuming you understand in principle how to work with our git. Now you need:

* a system with running Docker installation
* all necessary access/execution rights
* a local clone of the repository in the directory `./hpc-compendium`

Remark: This does not work in a ecryptfs file system. So you might
want to use `/tmp` as root directory.

## Preparation

Build the docker image. This might take a bit longer, but you have to
run it only once in a while (when we have changed the Dockerfile).

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

(Remember to keep the local web server running in the other shell.)
First, change to the `hpc-compendium` directory and set the environment
variable DC to save a lot of keystrokes :-)

```Bash
export DC='docker exec -it hpc-compendium bash -c '
```

and use it like this...

#### Linter

If you want to check whether the markdown files are formatted
properly, use the following command:

```Bash
$DC 'markdownlint docs'
```

#### Link Checker

To check a single file, e.g.
`doc.zih.tu-dresden.de/docs/software/big_data_frameworks.md`, use:

```Bash
$DC 'markdown-link-check docs/software/big_data_frameworks.md'
```

To check whether there are links that point to a wrong target, use
(this may take a while and gives a lot of output because it runs over all files):

```Bash
$DC "find docs -type f -name '*.md' | xargs -L1 markdown-link-check"
```

#### Spell Checker

For spell-checking a single file, , e.g.
`doc.zih.tu-dresden.de/docs/software/big_data_frameworks.md`, use:

```$DC "./util/check-spelling.sh docs/software/big_data_frameworks.md"
```

For spell-checking all files, use:

```Bash
$DC ./util/check-spelling.sh
```

This outputs all words of all files that are unknown to the spell checker.
To let the spell checker "know" a word, append it to
`doc.zih.tu-dresden.de/wordlist.aspell`.
