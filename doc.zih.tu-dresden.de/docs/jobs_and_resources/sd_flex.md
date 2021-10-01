# Large Shared-Memory Node - HPE Superdome Flex

- Hostname: `taurussmp8`
- Access to all shared filesystems
- Slurm partition `julia`
- 32 x Intel(R) Xeon(R) Platinum 8276M CPU @ 2.20GHz (28 cores)
- 48 TB RAM (usable: 47 TB - one TB is used for cache coherence protocols)
- 370 TB of fast NVME storage available at `/nvme/<projectname>`

## Local Temporary NVMe Storage

There are 370 TB of NVMe devices installed. For immediate access for all projects, a volume of 87 TB
of fast NVMe storage is available at `/nvme/1/<projectname>`. For testing, we have set a quota of
100 GB per project on this NVMe storage.

With a more detailed proposal on how this unique system (large shared memory + NVMe storage) can
speed up their computations, a project's quota can be increased or dedicated volumes of up to the
full capacity can be set up.

## Hints for Usage

- granularity should be a socket (28 cores)
- can be used for OpenMP applications with large memory demands
- To use OpenMPI it is necessary to export the following environment
  variables, so that OpenMPI uses shared memory instead of Infiniband
  for message transport. `export OMPI_MCA_pml=ob1;   export  OMPI_MCA_mtl=^mxm`
- Use `I_MPI_FABRICS=shm` so that Intel MPI doesn't even consider
  using Infiniband devices itself, but only shared-memory instead

## Open for Testing

- At the moment we have set a quota of 100 GB per project on this NVMe
  storage. As soon as the first projects come up with proposals how
  this unique system (large shared memory + NVMe storage) can speed up
  their computations, we will gladly increase this limit, for selected
  projects.
- Test users might have to clean-up their `/nvme` storage within 4 weeks
  to make room for large projects.
