# Intel Xeon Phi (Knights Landing)

!!! warning

    This page is deprceated. The Xeon Phi nodes are **out of service**.

The nodes `taurusknl[1-32]` are equipped with

- Intel Xeon Phi processors: 64 cores Intel Xeon Phi 7210 (1,3 GHz)
- 96 GB RAM DDR4
- 16 GB MCDRAM
- `/scratch`, `/lustre/ssd`, `/projects`, `/home` are mounted

Benchmarks, so far (single node):

- HPL (LINPACK): 1863.74 GFLOPS
- SGEMM (single precision) MKL: 4314 GFLOPS
- Stream (only 1.4 GiB memory used): 431 GB/s

Each of them can run 4 threads, so one can start a job here with e.g.

```console
marie@login$ srun -p knl -N 1 --mem=90000 -n 1 -c 64 a.out
```

In order to get their optimal performance please re-compile your code with the most recent Intel
compiler and explicitly set the compiler flag `-xMIC-AVX512`.

MPI works now, we recommend to use the latest Intel MPI version (intelmpi/2017.1.132). To utilize
the OmniPath Fabric properly, make sure to use the "ofi" fabric provider, which is the new default
set by the module file.

Most nodes have a fixed configuration for cluster mode (Quadrant) and memory mode (Cache). For
testing purposes, we have configured a few nodes with different modes (other configurations are
possible upon request):

| Nodes              | Cluster Mode | Memory Mode |
|:-------------------|:-------------|:------------|
| `taurusknl[1-28]`  | Quadrant     | Cache       |
| `taurusknl29`      | Quadrant     | Flat        |
| `taurusknl[30-32]` | SNC4         | Flat        |

They have Slurm features set, so that you can request them specifically by using the Slurm parameter
`--constraint` where multiple values can be linked with the & operator, e.g.
`--constraint="SNC4&Flat"`. If you don't set a constraint, your job will run preferably on the nodes
with Quadrant+Cache.

Note that your performance might take a hit if your code is not NUMA-aware and does not make use of
the Flat memory mode while running on the nodes that have those modes set, so you might want to use
`--constraint="Quadrant&Cache"` in such a case to ensure your job does not run on an unfavorable
node (which might happen if all the others are already allocated).

[KNL Best Practice Guide](https://prace-ri.eu/training-support/best-practice-guides/best-practice-guide-knights-landing/)
