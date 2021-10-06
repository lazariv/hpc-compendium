# ZIH HPC Documentation

This repository contains the documentation of the HPC systems and services provided at
[TU Dresden/ZIH](https://tu-dresden.de/zih/).

## Setup

We decided against a classical wiki software. Instead, we make use of the static site generator
[mkdocs](https://www.mkdocs.org/). It creates static html files from markdown source files. All
(configuration, layout and content) files will be managed within this git repository. The
documentation pages and configuration files are found in the folder `doc.zih.tu-dresden.de`. The
generated static html files, i.e, the documentation, is deployed to a web server. Several checks
within the CI/CD pipeline help to ensure a high quality documentation.

## Reporting Issues

Issues concerning this documentation can reported via the GitLab
[issue tracking system](https://gitlab.hrz.tu-chemnitz.de/zih/hpcsupport/hpc-compendium/-/issues).
Please check for any already existing issue before submitting your issue in order to avoid duplicate
issues.

**Reminder:** Non-documentation issues and requests need to be send as ticket to
[hpcsupport@zih.tu-dresden.de](mailto:hpcsupport@zih.tu-dresden.de).

## Contributing

Contributions from user-side are highly welcome. Please refer to
[Contribution guide](doc.zih.tu-dresden.de/README.md) to get started.

## Licenses

The repository has two licenses:

* All documentation is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
* All software components are licensed under MIT license.
