library(Rmpi)

# initialize an Rmpi environment
ns <- mpi.universe.size()-1
mpi.spawn.Rslaves(nslaves=ns)

# send these commands to the slaves
mpi.bcast.cmd( id <- mpi.comm.rank() )
mpi.bcast.cmd( ns <- mpi.comm.size() )
mpi.bcast.cmd( host <- mpi.get.processor.name() )

# all slaves execute this command
mpi.remote.exec(paste("I am", id, "of", ns, "running on", host))

# close down the Rmpi environment
mpi.close.Rslaves(dellog = FALSE)
mpi.exit()
