# How To Contribute

## Git Procedure

```Bash
~ git clone git@gitlab.hrz.tu-chemnitz.de:zih/hpc-compendium/hpc-compendium.git
~ cd hpc-compendium
~ git checkout preview
```

## Transferring Content

1. Grab a markdown source file from `twiki2md/root/` directory (a topic you are comfortable with)
1. Find place in new structure according to

  * Create new feature branch holding your work `~ git checkout -b <BRANCHNAME>`, whereas
  branch name can be `<FILENAME>` for simplicity
  * Copy reviewed markdown source file to `docs/` directory via
    `~ git mv twiki2md/root/<FILENAME>.md doc.zih.tu-dresden.de/docs/<SUBDIR>/<FILENAME>.md`
  * Update navigation section in `mkdocs.yaml`

1. Commit and push to feature branch via

```Bash
~ git commit docs/<SUBDIR>/<FILENAME>.md mkdocs.yaml -m "MESSAGE"
~ git push origin <BRANCHNAME>
```

1. Run checks locally and fix the issues. Otherwise the pipeline will fail.

    * [Check links](contrib_guide.md#check-links) (There might be broken links which can only be solved
        with ongoing transfer of content.)
    * [Check pages structure](contrib_guide.md#check-pages-structure)
    * [Markdown Linter](contrib_guide.md#markdown-linter)

1. Create
  [merge request](https://gitlab.hrz.tu-chemnitz.de/zih/hpc-compendium/hpc-compendium/-/merge_requests)
   against `preview` branch
