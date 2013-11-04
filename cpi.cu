#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <curand.h>
#include <time.h>

__global__ void kernel(int* count_d, float* randomnums)
{
	int i;
	double x,y,z;
	int tid = blockDim.x * blockIdx.x + threadIdx.x;
	i = tid;
	int xidx = 0, yidx = 0;

	xidx = (i+i);
	yidx = (xidx+1);

	x = randomnums[xidx];
	y = randomnums[yidx];
	z = ((x*x)+(y*y));

	if (z<=1)
		count_d[tid] = 1;
	else
		count_d[tid] = 0;	
}

void CUDAErrorCheck()
{
	cudaError_t error = cudaGetLastError();
	if (error != cudaSuccess)
	{	
		printf("CUDA error : %s (%d)\n", cudaGetErrorString(error), error);
		exit(0);
	}
}

int main(int argc,char* argv[])
{
	int niter = 100000;
	float *randomnums;
	double pi;
	cudaMalloc((void**)&randomnums, (2*niter)*sizeof(float));
	// Use CuRand to generate an array of random numbers on the device
	int status;
	curandGenerator_t gen;
	status = curandCreateGenerator(&gen, CURAND_RNG_PSEUDO_MRG32K3A);
	status |= curandSetPseudoRandomGeneratorSeed(gen, 4294967296ULL^time(NULL));
	status |= curandGenerateUniform(gen, randomnums, (2*niter));
	status |= curandDestroyGenerator(gen);
	if (status != CURAND_STATUS_SUCCESS)
	{
		printf("CuRand Failure\n");
		exit(EXIT_FAILURE);
	}

	int threads = 1000;
	int blocks = 100;
	int* count_d;
	int *count = (int*)malloc(blocks*threads*sizeof(int));
	unsigned int reducedcount = 0;
	cudaMalloc((void**)&count_d, (blocks*threads)*sizeof(int));
	CUDAErrorCheck();
	//one point per thread
	kernel <<<blocks, threads>>> (count_d, randomnums);
	cudaDeviceSynchronize();
	CUDAErrorCheck();
	cudaMemcpy(count, count_d, blocks*threads*sizeof(int), cudaMemcpyDeviceToHost);
	int i = 0;
	//reduce array into int
	for(i = 0; i<niter; i++)
		reducedcount += count[i];
	cudaFree(randomnums);
	cudaFree(count_d);
	free(count);

	pi = ((double)reducedcount/niter)*4.0;
	printf("Pi: %f\n", pi);

	return 0;
}
