# Hackathon June 2021

The goals for the hackathon are:

* Familiarize main editors (ZIH admin group and domain experts) with new workflow and system
* Bringing new compendium to life by
  1. Transferring content from old compendium into new structure and system
  1. Fixing checks
  1. Reviewing and updating transferred content

## twiki2md

The script `twiki2md` converts twiki source files into markdown source files using pandoc. It
outputs the markdown source files according to the old pages tree into subdirectories. The
output and **starting point for transferring** old content into the new system can be found
at branch `preview` within directory `twiki2md/root/`.

## Steps

### Familiarize with New Wiki System

* Make sure your are member of the [repository](https://gitlab.hrz.tu-chemnitz.de/zih/hpcsupport/hpc-compendium).
  If not, ask Danny Rotscher for adding you.
* Clone repository and checkout branch `preview`

```Shell Session
~ git clone git@gitlab.hrz.tu-chemnitz.de:zih/hpcsupport/hpc-compendium.git
~ cd hpc-compendium
~ git checkout preview
```

* Open terminal and build documentation using `mkdocs`
  * [using mkdocs](README.md#preview-using-mkdocs)
  * [installing dependencies](README.md#install-dependencies)

### Transferring Content

1. Grab a markdown source file from `twiki2md/root/` directory (a topic you are comfortable with)
1. Find place in new structure according to
[Typical Project Schedule](https://doc.zih.tu-dresden.de/hpc-wiki/bin/view/Compendium/TypicalProjectSchedule)

  * Create new feature branch holding your work `~ git checkout -b <BRANCHNAME>`, whereas branch
      name can be `<FILENAME>` for simplicity
  * Copy reviewed markdown source file to `docs/` directory via
    `~ git mv twiki2md/root/<FILENAME>.md doc.zih.tu-dresden.de/docs/<SUBDIR>/<FILENAME>.md`
  * Update navigation section in `mkdocs.yaml`

1. Commit and push to feature branch via

```Shell Session
~ git commit docs/<SUBDIR>/<FILENAME>.md mkdocs.yaml -m "MESSAGE"
~ git push origin <BRANCHNAME>
```

1. Run checks locally and fix the issues. Otherwise the pipeline will fail.
    * [Check links](README.md#check-links) (There might be broken links which can only be solved
        with ongoing transfer of content.)
    * [Check pages structure](README.md#check-pages-structure)
    * [Markdown Linter](README.md#markdown-linter)
1. Create
  [merge request](https://gitlab.hrz.tu-chemnitz.de/zih/hpcsupport/hpc-compendium/-/merge_requests)
   against `preview` branch

### Review Content

The following steps are optional in a sense, that the first goal of the hackathon is to transfer all
old pages into new structure. If this is done, the content of the files need to be reviewed:

  * Remove outdated information
  * Update content
  * Apply [writing style](README.md#writing-style)
  * Replace or remove (leftover) html constructs in markdown source file
  * Add ticks for code blocks and command if necessary
  * Fix internal links (mark as todo if necessary)
  * Review and update, remove outdated content
