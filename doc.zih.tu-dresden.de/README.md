# Proposal for Next Generation of ZIH HPC Compendium

The project (repository and the documentation) is a mock-up of the proposed technical workflow as
well as restructured content and topics.

## Setup

We decided against a classical wiki software. Instead, we want to make use of the static site
generator [mkdocs](https://www.mkdocs.org/). It creates static html files from markdown files. All
(configuration, layout and content) files will be managed within a git repository. The generated
static html files, i.e, the documentation, is deployed to a web server.

This mock-up makes use of the two GitLab features [GitLab Runner](https://docs.gitlab.com/runner/)
and [GitLab Pages](https://docs.gitlab.com/ee/user/project/pages/).
Using GitLab Pages static websites can be directly published from a repository in GitLab. GitLab
Runner is an application that works with GitLab CI/CD to run jobs in a pipeline. The CI/CD pipeline
for this very project is to generate the static html using `mkdocs` and deploy them at GitLab Pages.

### Why is this not at gitlab.hrz.tu-chemnitz.de?

Both features, GitLab Pages and GitLab Runner, are currently not available at
gitlab.hrz.tu-chemnitz.de

If this project exceeds the mock-up phase, the Git hosting service should be discussed. But for now,
it is quite comfortable to use the infrastructure at gitlab.com

## Contribute

### Workflow

1. Install `mkdocs` on your local system, see https://www.mkdocs.org/
1. Clone this repository into local working copy
1. Work: add or update content, improve layout, etc.
1. Preview documentation (on local system) using `mkdocs serve`
1. Commit and push to repository

`mkdocs` is required to generate the documentation (static html files) from the markdown sources.
But it also has a builtin development server that allows to serve the documentation. The builtin
server can be used to preview the updated documentation locally before committing the changes to the
repository.

In principle, `mkdocs` is not mandatory on the local system to contribute to the project. If you are
totally sure about your commit (e.g., fix a typo), it is only the following three steps: edit the
markdown file, commit change, push commit to the repository.
To be honest, even a local checkout is not mandatory since GitLab has a quite good builtin IDE
allowing to edit the sources in the web browser.

### Update, Build and Serve Documentation

All `mkdocs` project follow this structure:

```
mkdocs.yml    # The configuration file.
docs/
    index.md  # The documentation homepage.
    ...       # Other markdown pages, images and other files.

```

All markdown source files are contained in the `docs` folder. The file `mkdocs.yml` is the single
configuration file for the project from layout up to document structure and extensions.

The navigation section `nav` in `mkdocs.yml` specifies the order, titles and nesting of the
documentation pages.  To add a new page to the documentation follow these two steps:

1. Create new markdown file under `docs/<NEW>.md` and write the documentation
1. Add `<NEW.md>` to the configuration file `mkdocs.yml` by updating the navigation section

There are three `mkdocs` commands you should be familiar with:

```
mkdocs new [dir-name] - Create a new project.
mkdocs serve - Start the live-reloading docs server.
mkdocs build - Build the documentation site.
mkdocs help - Print this help message.
```

Three? Yes, the `new` command can be ignored, because the project is already started.

Invoke`mkdocs serve` to build and preview the documentation. The documentation is automatically
reloaded if the system detects updates (great!). By default, the builtin web server hosts the
documentation at `http://127.0.0.1:8000`.

```
~ mkdocs serve
INFO    -  Building documentation...
INFO    -  Cleaning site directory
INFO    -  Documentation built in 0.08 seconds
[I 210127 13:33:30 server:335] Serving on http://127.0.0.1:8000
INFO    -  Serving on http://127.0.0.1:8000
[I 210127 13:33:30 handlers:62] Start watching changes
INFO    -  Start watching changes
```

To build the documentation, invoke `mkdocs build`. This will create a new directory named `public`
which holds the generated static html files.
This command is used to build the documentation within the CI/CD pipeline. Thus, it should exit
without error.

```
~ mkdocs build
INFO    -  Cleaning site directory
INFO    -  Building documentation to directory: /PATH/hpc-compendium-2.0/public
INFO    -  Documentation built in 0.09 seconds
```

### GitLab Runner and CI/CD

The GitLab Runner periodically connects to the repository. If there is a new commit, the CI/CD is
invoked: build the documentation and deploy to Gitlab Pages.

Currently, all users can push directly to branch master.

## Outlook and Todos

### Layout

* Create a nice layout
* Should the wiki be layouted in TUD CD?
* Rules regarding contribution
* Rules regarding layouting

### Setup of Infrastructure

If the proposed setup of the infrastructure is accepted, there are some follow-up questions.

1. Repository
    * Where should the repository be hosted?
    * Possibilities: gitlab.chemnitz, github.com, gitlab.com, self hosted GitLab
    * In context of NHR, is gitlab.chemnitz possible?
1. Hosting provider
    * Possibilities: gitlab/github pages, VM with a running web server
1. Who can push to branch master? What are the git workflow for HPC admins, ZIH stuff, HPC users etc.?

## ToDos

* Do's and Dont's per topic/section (aka. no gos)
* Führerschein
