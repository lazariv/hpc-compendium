# Hackathon June 2021

The goals for the hackathon are:

* Familiarize main editors (ZIH admin group and domain experts) with new workflow and system
* Bringing new compendium to life by
  1. Transferring content from old compendium into new structure and system
  1. Fixing checks
  1. Reviewing and updating transferred content

## twiki2md

The script `twiki2md` converts twiki source files into markdown source files using pandoc. It outputs the
markdown source files according to the old pages tree. The output and **starting point for transferring**
old content into the new system can be found at branch `preview` within directory `twiki2md/root/`.

## Steps

### Familiarize with New Wiki System

* Make sure your are member of the [repository](https://gitlab.hrz.tu-chemnitz.de/zih/hpc-compendium/hpc-compendium).
  If not, ask Danny Rotscher for adding you.
* Clone repository and checkout branch `preview`

```Shell Session
~ git clone git@gitlab.hrz.tu-chemnitz.de:zih/hpc-compendium/hpc-compendium.git
~ cd hpc-compendium
~ git checkout preview
```

* Open terminal and build documentation using mkdocs, refer [link](README.md#preview-using-mkdocs)


### Transferring Content




1. Grab a markdown source file from `twiki2md/root/` directory (a topic you are comfortable with)
1. Find place in new structure according to
[Typical Project Schedule](https://doc.zih.tu-dresden.de/hpc-wiki/bin/view/Compendium/TypicalProjectSchedule)
  * Copy reviewed markdown source file to `doc.zih.tu-dresden.de/docs/SUBDIR/<FILENAME>.md`
  * Update navigation section in `mkdocs.yaml`
1. Review the markdown source file
  * Replace or remove (leftover) html constructs in markdown source file
  * Add ticks for code blocks and command if necessary
  * Fix internal links (mark as todo if necessary)
  * Review and update, remove outdated content
1. Apply git workflow
  * Add `<FILENAME>.md` to git repository
  * Commit all changed file, e.g., `<FILENAME.md>`, `mkdocs.yaml` and graphics from this documentation
      page
  * Push changes to new branch
    * ``git push origin 
  * Create [merge request](https://gitlab.hrz.tu-chemnitz.de/zih/hpc-compendium/hpc-compendium/-/merge_requests)
