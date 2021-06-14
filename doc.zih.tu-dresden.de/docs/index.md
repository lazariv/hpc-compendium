# ZIH HPC Compendium

Dear HPC users,

due to restrictions coming from data security and software incompatibilities the old
"HPC Compendium" is now reachable only from inside TU Dresden campus (or via VPN).

Internal users should be redirected automatically to the
[internal IP address](http://141.76.17.11/hpc-wiki/bin/view/Compendium).

We apologize for this severe action, but we are in the middle of the preparation for a wiki
relaunch, so we do not want to redirect resources to fix technical/security issues for a system
that will last only a few weeks.

Thank you for your understanding,

your HPC Support Team ZIH

## NGS ZIH HPC Compendium

Dear visitor,

this is a proposal for the next generation of technical documentation for the HPC systems and
services at ZIH / TU Dresden.

### Status

The project (repository and the documentation) is a mock-up of the proposed technical workflow as
well as restructured content and topics.

### What is new?

The desire for a new technical documentation is driven by two major aspects:

1. Clear and user-oriented structure of the content
1. Usage of modern tools for technical documentation

The HPC Compendium provided knowledge and help for many years. It grew with every new hardware
installation and ZIH stuff tried its best to keep it up to date. But, to be honest, it has become
quite messy, and housekeeping it is a nightmare.

The new structure is designed with the schedule for an HPC project in mind. This will ease the start
for new HPC users, as well speedup searching information w.r.t. a specific topic for advanced users.

From a technical point, our new documentation system is highly inspired by [OLFC User
Documentation](https://docs.olcf.ornl.gov/) as well as [NERSC Technical
Documentation](https://nersc.gitlab.io/).
We decided against a classical wiki software. Instead, we write the documentation in markdown and
make use of the static site generator [mkdocs](https://www.mkdocs.org/) to create static html files
from this markdown files. All configuration, layout and content files are managed within a git
repository. The generated static html files, i.e, the documentation you are now reading, is deployed
to a web server.

The workflow is flexible, allows a high level of automation, and is quite easy to maintain.

### Mock-Up

This mock-up makes use of the two GitLab features [GitLab Runner](https://docs.gitlab.com/runner/)
and [GitLab Pages](https://docs.gitlab.com/ee/user/project/pages/).
Using GitLab Pages static websites can be directly published from a repository in GitLab. GitLab
Runner is an application that works with GitLab CI/CD to run jobs in a pipeline. The CI/CD pipeline
for this very project is to generate the static html using `mkdocs` and deploy them at GitLab Pages.

### Contribute

Contributions are highly welcome. Please refere to
[README.md](https://gitlab.hrz.tu-chemnitz.de/zih/hpc-compendium/hpc-compendium/-/blob/main/doc.zih.tu-dresden.de/README.md)
file of this project.
