# Check Scripts

Several checks are in place to ensure a high quality and consistent documentation. These checks are
run within the CI/CD pipeline and changes are only deployed to the HPC compendium, if the checks are
passed. Thus, we highly recommend running the checks locally before committing and posing a merge
request.

* Markdown linter
* Check internal and external links
* Check code and command examples
* Check no floating pages and depth of page tree

## Markdown Linter

The [markdown linter client](https://github.com/igorshubovych/markdownlint-cli) helps to keep the
markdown source code clean and consistent.

Installation

```Shell Session
~ npm install markdownlint-cli
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

## Check Links

No one likes dead links. Therefore, we check the internal and external links within the markdown
source files. For that, the script `util/check-links.sh` and/or the tool
[markdown-link-check](https://github.com/tcort/markdown-link-check) can be used.

Installation

```Shell Session
~ npm install markdown-link-check
```

```Shell Session
~ cd doc.zih.tu-dresden.de/
~ markdown-link-check docs/index.md

FILE: docs/index.md
[✖] http://141.76.17.11/hpc-wiki/bin/view/Compendium
[✓] https://docs.olcf.ornl.gov/
[✓] https://nersc.gitlab.io/
[✓] https://www.mkdocs.org/
[✓] https://docs.gitlab.com/runner/
[✓] https://docs.gitlab.com/ee/user/project/pages/
[✖] CONTRIBUTE.md

7 links checked.

ERROR: 2 dead links found!
[✖] http://141.76.17.11/hpc-wiki/bin/view/Compendium → Status: 0
[✖] CONTRIBUTE.md → Status: 400
```

### Usage

Check links within changed git-versioned markdown files, invoke

```Shell Session
~ sh doc.zih.tu-dresden.de/util/check-links.sh
```

from top-level directory.

To check all markdown files for broken links, invoke

```Shell Session
~ find . -name \*.md -exec markdown-link-check -q {} \;
```

## Check Code and Commands

All code blocks and commands should be runnable from a login node.

**TODO:** Implement [Issue #9](#9)

## Check Pages Structure

The script `check-no-floating.sh` contains two checks. It first checks the hierarchy depth of the
pages structure. By design, no page in the documentation should be lower than four levels w.r.t. top
level, i.e., landing page. Secondly, the script tests if every markdown file is included in the
navigation section within the `mkdocs.yaml` file of this project.

### Usage

```bash
sh doc.zih.tu-dresden.de/utils/check-no-floating.sh doc.zih.tu-dresden.de
```

### Return codes

* -1/255 if any error occurs, 0 otherwise
