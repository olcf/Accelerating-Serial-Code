#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <thrust/generate.h>
#include <thrust/random.h>
#include <thrust/iterator/counting_iterator.h>
#include <thrust/functional.h>
#include <thrust/transform_reduce.h>
#include <cmath>

struct montecarlo : public thrust::unary_function<unsigned int, float>
{
	__host__ __device__
	float operator()(unsigned int thread_id) 
	{
		unsigned int seed;
		seed = 49868^thread_id;
		int i;
		float x,y,z,sum=0.0;
		
		thrust::default_random_engine rng(seed);
		thrust::uniform_real_distribution<float> u01(0,1);	
		for (i = 0; i < 1000; i++)
		{
			x = u01(rng);
			y = u01(rng);
			z = ((x*x)+(y*y));
			if (z<=1)
				sum += 1;
		}
		return sum;
	}
};

int main(int argc, char* argv[])
{
	float pi;
	float count = 0.0;
	int niter = 1000;
	count = thrust::transform_reduce(thrust::counting_iterator<int>(0), thrust::counting_iterator<int>(niter),montecarlo(),0.0,thrust::plus<float>());
	pi = (count/(niter*niter))*4.0;			
	printf("Pi: %f\n", pi);			
}
