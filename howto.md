# How to work with the git

Pre-requisites: see Readme.md

I want to change something in the RomeNodes.md documentation!

```Bash
git clone git@gitlab.hrz.tu-chemnitz.de:zih/hpc-compendium/hpc-compendium.git
cd hpc-compendium/
git checkout preview
cd doc.zih.tu-dresden.de
```

## 1. Create a new branch (for instance, using the filename as name of the branch):

```Bash
git checkout -b RomeNodes
```
## 2. Edit the file using your preferred editor

## 3. Run the linter:
```Bash
markdownlint --config .markdownlint.json  ./docs/use_of_hardware/RomeNodes.md
```
If there are still errors: go to step 2

## 4. Run the link checker:
```Bash
markdown-link-check ./docs/use_of_hardware/RomeNodes.md
```

If there are still errors: go to step 2

## 5. Commit and merge request
```Bash
git commit ./docs/use_of_hardware/RomeNodes.md -m "typo fixed"
git push origin RomeNodes    #the branch name
```
You will get a link you have to follow to create the merge request.







