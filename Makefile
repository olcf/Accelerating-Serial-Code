serial:
	cc serialpi.c -o /tmp/work/$(USER)/pi.out
	cd /tmp/work/$(USER)
	qsub titan.pbs

cuda:
	nvcc -arch=sm_35 -lcurand cpi.cu -o /tmp/work/$(USER)/pi.out
	cd /tmp/work/$(USER)
	qsub titan.pbs

openacc:
	CC -acc -Minfo=all -ta=nvidia:5.0,cc3x accpi.cpp -o /tmp/work/$(USER)/pi.out
	cd /tmp/work/$(USER)
	qsub titan.pbs

thrust:
	nvcc -arch=sm_35 thrust.cu -o /tmp/work/$(USER)/pi.out
	cd /tmp/work/$(USER)
	qsub titan.pbs
