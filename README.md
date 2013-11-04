Accelerating Serial Code for the GPUs
=====================================

This tutorial covers how to accelerate a simple Monte Carlo operation using CUDA, OpenACC, and finally using the Thrust template library.

Before these examples can be compiled, you need to make sure that the PGI programming environment, the CUDA tool kit, and  the latest version of the PGI compiler is loaded.

'''
module load PrgEnv-pgi
module load cudatoolkit
module switch pgi pgi/13.7.0
'''

Before you can submit any of these examples, you need to edit the submit script (titan.pbs) and change AAA123 to the appropriate project ID.

To compile and submit:
*For the serial version: 'make serial'
*For the CUDA version: 'make cuda'
*For the OpenACC version: 'make openacc'
*For the Thrust version: 'make thrust'

The output should look something like:
'''
Mon Nov  4 11:07:43 EST 2013
Pi: 3.140640
Application 3854599 resources: utime ~0s, stime ~0s, Rss ~4820, inblocks ~2623, outblocks ~7171
'''

The tutorial which goes with this code can be found on the OLCF website at: http://www.olcf.ornl.gov/tutorials/cuda-monte-carlo-pi/
