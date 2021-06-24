# Batch Systems

Applications on an HPC system can not be run on the login node. They have to be submitted to compute
nodes with dedicated resources for user jobs. Normally a job can be submitted with these data:

- number of CPU cores,
- requested CPU cores have to belong on one node (OpenMP programs) or
  can distributed (MPI),
- memory per process,
- maximum wall clock time (after reaching this limit the process is
  killed automatically),
- files for redirection of output and error messages,
- executable and command line parameters.

Depending on the batch system the syntax differs slightly:

- [Slurm](../jobs/Slurm.md) (taurus, venus)

If you are confused by the different batch systems, you may want to enjoy this [batch system
commands translation table](http://slurm.schedmd.com/rosetta.pdf).

**Comment:** Please keep in mind that for a large runtime a computation may not reach its end. Try
to create shorter runs (4...8 hours) and use checkpointing.  Here is an extreme example from
literature for the waste of large computing resources due to missing checkpoints:

*Earth was a supercomputer constructed to find the question to the answer to the Life, the Universe,
and Everything by a race of hyper-intelligent pan-dimensional beings. Unfortunately 10 million years
later, and five minutes before the program had run to completion, the Earth was destroyed by
Vogons.* (Adams, D. The Hitchhikers Guide Through the Galaxy)

## Exclusive Reservation of Hardware

If you need for some special reasons, e.g., for benchmarking, a project or paper deadline, parts of
our machines exclusively, we offer the opportunity to request and reserve these parts for your
project.

Please send your request **7 working days** before the reservation should start (as that's our
maximum time limit for jobs and it is therefore not guaranteed that resources are available on
shorter notice) with the following information to the [HPC
support](mailto:hpcsupport@zih.tu-dresden.de?subject=Request%20for%20a%20exclusive%20reservation%20of%20hardware&body=Dear%20HPC%20support%2C%0A%0AI%20have%20the%20following%20request%20for%20a%20exclusive%20reservation%20of%20hardware%3A%0A%0AProject%3A%0AReservation%20owner%3A%0ASystem%3A%0AHardware%20requirements%3A%0ATime%20window%3A%20%3C%5Byear%5D%3Amonth%3Aday%3Ahour%3Aminute%20-%20%5Byear%5D%3Amonth%3Aday%3Ahour%3Aminute%3E%0AReason%3A):

- `Project:` *\<Which project will be credited for the reservation?>*
- `Reservation owner:` *\<Who should be able to run jobs on the
  reservation? I.e., name of an individual user or a group of users
  within the specified project.>*
- `System:` *\<Which machine should be used?>*
- `Hardware requirements:` *\<How many nodes and cores do you need? Do
  you have special requirements, e.g., minimum on main memory,
  equipped with a graphic card, special placement within the network
  topology?>*
- `Time window:` *\<Begin and end of the reservation in the form
  year:month:dayThour:minute:second e.g.: 2020-05-21T09:00:00>*
- `Reason:` *\<Reason for the reservation.>*

**Please note** that your project CPU hour budget will be credited for the reserved hardware even if
you don't use it.
