#use of dask-jobqueue for the estimation of Pi by Monte-Carlo method

import time
from time import time, sleep

from dask.distributed import Client
from dask_jobqueue import SLURMCluster
import subprocess as sp

import dask.array as da
import numpy as np

#setting up the dashboard

uid = int( sp.check_output('id -u', shell=True).decode('utf-8').replace('\n','') )
portdash = 10001 + uid

#create a slurm cluster, please specify your project 

cluster = SLURMCluster(queue='alpha', cores=2, project='p_scads', memory="8GB", walltime="00:30:00", extra=['--resources gpu=1'], scheduler_options={"dashboard_address": f":{portdash}"})

#submit the job to the scheduler with the number of nodes (here 2) requested:

cluster.scale(2)

#wait for SLURM to allocate a resources

sleep(120)

#check resources

client = Client(cluster)
client

#real calculations with a Monte Carlo method

def calc_pi_mc(size_in_bytes, chunksize_in_bytes=200e6):
    """Calculate PI using a Monte Carlo estimate."""
    
    size = int(size_in_bytes / 8)
    chunksize = int(chunksize_in_bytes / 8)
    
    xy = da.random.uniform(0, 1,
                           size=(size / 2, 2),
                           chunks=(chunksize / 2, 2))
    
    in_circle = ((xy ** 2).sum(axis=-1) < 1)
    pi = 4 * in_circle.mean()

    return pi

def print_pi_stats(size, pi, time_delta, num_workers):
    """Print pi, calculate offset from true value, and print some stats."""
    print(f"{size / 1e9} GB\n"
          f"\tMC pi: {pi : 13.11f}"
          f"\tErr: {abs(pi - np.pi) : 10.3e}\n"
          f"\tWorkers: {num_workers}"
          f"\t\tTime: {time_delta : 7.3f}s")
          
#let's loop over different volumes of double-precision random numbers and estimate it

for size in (1e9 * n for n in (1, 10, 100)):
    
    start = time()
    pi = calc_pi_mc(size).compute()
    elaps = time() - start

    print_pi_stats(size, pi, time_delta=elaps,
                   num_workers=len(cluster.scheduler.workers))

#Scaling the Cluster to twice its size and re-run the experiments
                   
new_num_workers = 2 * len(cluster.scheduler.workers)

print(f"Scaling from {len(cluster.scheduler.workers)} to {new_num_workers} workers.")

cluster.scale(new_num_workers)

sleep(120)

client
                   
#Re-run same experiments with doubled cluster

for size in (1e9 * n for n in (1, 10, 100)):    
        
    start = time()
    pi = calc_pi_mc(size).compute()
    elaps = time() - start

    print_pi_stats(size, pi,
                   time_delta=elaps,
                   num_workers=len(cluster.scheduler.workers))
