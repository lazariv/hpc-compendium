# Lustre File System(s)



### Large Files in /scratch

The data containers in Lustre are called object storage targets (OST).  The capacity of one OST is
about 21 TB. All files are striped over a certain number of these OSTs. For small and medium files,
the default number is 2. As soon as a file grows above \~1 TB it makes sense to spread it over a
higher number of OSTs, eg. 16. Once the file system is used \> 75%, the average space per OST is
only 5 GB. So, it is essential to split your larger files so that the chunks can be saved!

Lets assume you have a dierctory where you tar your results, e.g.  `/scratch/mark/tar`. Now, simply
set the stripe count to a higher number in this directory with:

```Bash
lfs setstripe -c 20  /scratch/ws/mark-stripe20/tar
```

**Note:** This does not affect existing files. But all files that **will be created** in this
directory will be distributed over 20 OSTs.


## Useful Commands for Lustre
These commands work for `/scratch` and `/ssd`.

### Listing Disk Usages per OST and MDT

```Bash
lfs quota -h -u username /path/to/my/data
```

It is possible to display the usage on each OST by adding the "-v"-parameter.

### Listing space usage per OST and MDT

```Bash
lfs df -h /path/to/my/data
```

### Listing inode usage for an specific path

```Bash
lfs df -i /path/to/my/data
```

### Listing OSTs

```Bash
lfs osts /path/to/my/data
```

### View striping information

```Bash
lfs getstripe myfile
lfs getstripe -d mydirectory
```

The `-d`-parameter will also display striping for all files in the directory

