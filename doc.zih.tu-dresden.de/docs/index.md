# ZIH HPC Compendium
<!--Pre-installed [software environments](../software/overview.md) allow for a quick start. To access-->
<!--our HPC resources, a short [project application](../application/overview.md) is required.-->

Dear HPC users,

due to restrictions coming from data security and software incompatibilities the old
"HPC Compendium" is now reachable only from inside TU Dresden campus (or via VPN).

Internal users should be redirected automatically.

We apologize for this severe action, but we are in the middle of the preparation for a wiki
relaunch, so we do not want to redirect resources to fix technical/security issues for a system
that will last only a few weeks.

Thank you for your understanding,

your HPC Support Team ZIH

## What is new?

The desire for a new technical documentation is driven by two major aspects:

1. Clear and user-oriented structure of the content
1. Usage of modern tools for technical documentation

The HPC Compendium provided knowledge and help for many years. It grew with every new hardware
installation and ZIH stuff tried its best to keep it up to date. But, to be honest, it has become
quite messy, and housekeeping it was a nightmare.

The new structure is designed with the schedule for an HPC project in mind. This will ease the start
for new HPC users, as well speedup searching information w.r.t. a specific topic for advanced users.

We decided against a classical wiki software. Instead, we write the documentation in markdown and
make use of the static site generator [mkdocs](https://www.mkdocs.org/) to create static html files
from this markdown files. All configuration, layout and content files are managed within a git
repository. The generated static html files, i.e, the documentation you are now reading, is deployed
to a web server.

The workflow is flexible, allows a high level of automation, and is quite easy to maintain.

From a technical point, our new documentation system is highly inspired by
[OLFC User Documentation](https://docs.olcf.ornl.gov/) as well as
[NERSC Technical Documentation](https://nersc.gitlab.io/).

## Contribute

Contributions are highly welcome. Please refere to
[README.md](https://gitlab.hrz.tu-chemnitz.de/zih/hpc-compendium/hpc-compendium/-/blob/main/doc.zih.tu-dresden.de/README.md)
file of this project.
