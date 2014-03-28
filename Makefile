serial:
	cc serialpi.c -o $(MEMBERWORK)/<PROJID>/pi.out
	cd $(MEMBERWORK)/<PROJID>
	qsub titan.pbs

cuda:
	nvcc -arch=sm_35 -lcurand cpi.cu -o $(MEMBERWORK)/<PROJID>/pi.out
	cd $(MEMBERWORK)/<PROJID>
	qsub titan.pbs

openacc:
	CC -acc -Minfo=all -ta=nvidia:5.0,cc3x accpi.cpp -o $(MEMBERWORK)/<PROJID>/pi.out
	cd $(MEMBERWORK)/<PROJID>
	qsub titan.pbs

thrust:
	nvcc -arch=sm_35 thrust.cu -o $(MEMBERWORK)/<PROJID>/pi.out
	cd $(MEMBERWORK)/<PROJID>
	qsub titan.pbs
