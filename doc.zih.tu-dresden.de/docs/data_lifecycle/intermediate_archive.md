# Intermediate Archive

With the "Intermediate Archive", ZIH is closing the gap between a normal disk-based file system and
[Longterm Archive](preservation_research_data.md). The Intermediate Archive is a hierarchical file
system with disks for buffering and tapes for storing research data.

Its intended use is the storage of research data for a maximal duration of 3 years. For storing the
data after exceeding this time, the user has to supply essential metadata and migrate the files to
the [Longterm Archive](preservation_research_data.md). Until then, she/he has to keep track of her/his
files.

Some more information:

- Maximum file size in the archive is 500 GB (split up your files, see
  [Datamover](../data_transfer/data_mover.md))
- Data will be stored in two copies on tape.
- The bandwidth to this data is very limited. Hence, this file system
  must not be used directly as input or output for HPC jobs.

## How to access the "Intermediate Archive"

For storing and restoring your data in/from the "Intermediate Archive" you can use the tool
[Datamover](../data_transfer/data_mover.md). To use the DataMover you have to login to Taurus
(taurus.hrsk.tu-dresden.de).

### Store data

```Shell Session
dtcp -r /<directory> /archiv/<project or user>/<directory> # or
dtrsync -av /<directory> /archiv/<project or user>/<directory>
```

### Restore data

```Shell Session
dtcp -r /archiv/<project or user>/<directory> /<directory> # or
dtrsync -av /archiv/<project or user>/<directory> /<directory>
```

### Examples

```Shell Session
dtcp -r /scratch/rotscher/results /archiv/rotscher/ # or
dtrsync -av /scratch/rotscher/results /archiv/rotscher/results
```
