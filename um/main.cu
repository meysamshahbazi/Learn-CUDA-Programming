#include <iostream>
#include <math.h>

__global__
void add(int n,float *x,float *y)
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x*gridDim.x;

    for (int i=index; i < n; i+=stride)
        y[i] = x[i] + y[i];
}

__global__
void init(int n, float *x,float *y)
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x*gridDim.x;

    for (int i =index; i <n; i+=stride)
    {
        x[i] = 1.0f;
        y[i] = 2.0f;
    }
}


int main(void)
{
    int N = 1<<20;
    float *x, *y;

    cudaMallocManaged(&x, N*sizeof(float));
    cudaMallocManaged(&y, N*sizeof(float));

    // for(int i=0; i<N; i++)
    // {
    //     x[i] = 1.0f;
    //     y[i] = 2.0f;
    // }

    int block_size = 256;
    int num_blocks = (N + block_size-1)/block_size;

    init<<<num_blocks,block_size>>>(N, x, y);
    
    add<<<num_blocks,block_size>>>(N,x,y);

    cudaDeviceSynchronize();

    float maxError = 0.0f;
    for (int i = 0; i < N; i++)
        maxError = fmax(maxError, fabs(y[i]-3.0f));
    std::cout << "Max error: " << maxError << std::endl;

    // Free memory
    cudaFree(x);
    cudaFree(y);
    return 0;
}



