# Intermediate Archive

With the "Intermediate Archive", ZIH is closing the gap between a normal disk-based filesystem and
[Long-term Archive](preservation_research_data.md). The Intermediate Archive is a hierarchical
filesystem with disks for buffering and tapes for storing research data.

Its intended use is the storage of research data for a maximal duration of 3 years. For storing the
data after exceeding this time, the user has to supply essential metadata and migrate the files to
the [Long-term Archive](preservation_research_data.md). Until then, she/he has to keep track of her/his
files.

Some more information:

- Maximum file size in the archive is 500 GB (split up your files, see
  [Datamover](../data_transfer/datamover.md))
- Data will be stored in two copies on tape.
- The bandwidth to this data is very limited. Hence, this filesystem
  must not be used directly as input or output for HPC jobs.

## Access the Intermediate Archive

For storing and restoring your data in/from the "Intermediate Archive" you can use the tool
[Datamover](../data_transfer/datamover.md). To use the DataMover you have to login to ZIH systems.

### Store Data

```console
marie@login$ dtcp -r /<directory> /archiv/<project or user>/<directory> # or
marie@login$ dtrsync -av /<directory> /archiv/<project or user>/<directory>
```

### Restore Data

```console
marie@login$ dtcp -r /archiv/<project or user>/<directory> /<directory> # or
marie@login$ dtrsync -av /archiv/<project or user>/<directory> /<directory>
```

### Examples

```console
marie@login$ dtcp -r /scratch/rotscher/results /archiv/rotscher/ # or
marie@login$ dtrsync -av /scratch/rotscher/results /archiv/rotscher/results
```
