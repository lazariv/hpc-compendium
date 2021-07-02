# Migration towards Phase 2

## How to copy your data from an old scratch (Atlas, Venus, Taurus I) to our new scratch (Taurus II)

Currently there is only Taurus (I) scracht mountet on Taurus (II). To
move files from Venus/Atlas to Taurus (II) you have to do an
intermediate step over Taurus (I)

## How to copy data from Atlas/Venus scratch to scratch of Taurus I (first step)

First you have to login to Taurus I.

```Bash
ssh <username>@tauruslogin[1-2].hrsk.tu-dresden.de
```

After your are logged in, you can use our tool called Datamover to copy
your data from A to B.

```Bash
dtcp -r /atlas_scratch/<project or user>/<directory> /scratch/<project or user>/<directory>

e.g. file: dtcp -r /atlas_scratch/rotscher/file.txt /scratch/rotscher/
e.g. directory: dtcp -r /atlas_scratch/rotscher/directory /scratch/rotscher/
```

## How to copy data from scratch of Taurus I to scratch of Taurus II (second step)

First you have to login to Taurus II.

```Bash
ssh <username>@tauruslogin[3-5].hrsk.tu-dresden.de
```

After your are logged in, you can use our tool called Datamover to copy
your data from A to B.

```Bash
dtcp -r /phase1_scratch/<project or user>/<directory> /scratch/<project or user>/<directory>

e.g. file: dtcp -r /phase1_scratch/rotscher/file.txt /scratch/rotscher/
e.g. directory: dtcp -r /phase1_scratch/rotscher/directory /scratch/rotscher/
```

## Examples on how to use data transfer commands:

### Copying data from Atlas' /scratch to Taurus' /scratch

```Bash
% dtcp -r /atlas_scratch/jurenz/results /taurus_scratch/jurenz/
```

### Moving data from Venus' /scratch to Taurus' /scratch

```Bash
% dtmv /venus_scratch/jurenz/results/ /taurus_scratch/jurenz/venus_results
```

### TGZ data from Taurus' /scratch to the Archive

```Bash
% dttar -czf /archiv/jurenz/taurus_results_20140523.tgz /taurus_scratch/jurenz/results
```
