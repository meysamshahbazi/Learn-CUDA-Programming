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
void init_(int n, float *x,float *y)
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x*gridDim.x;

    for (int i =index; i <n; i+=stride)
    {
        x[i] = 1.0f;
        y[i] = 2.0f;
    }
}

#define STRIDE_64K 65536

__global__
void init_align(int n, float *x,float *y)
{
    int lane_id = threadIdx.x & 31;
    // another way to say that
    // int lane_id = threadIdx.x % 32;

    size_t warp_id = (threadIdx.x + blockIdx.x*blockDim.x)>>5;

    size_t wapr_per_grid = (blockDim.x * gridDim.x)>>5;
    // size_t warp_total = 
    // TODO need to be completed !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11

}


int main(void)
{
    int N = 1<<20;
    float *x, *y;
     
    int device = -1;

    cudaMallocManaged(&x, N*sizeof(float));
    cudaMallocManaged(&y, N*sizeof(float));

    for(int i=0; i<N; i++)
    {
        x[i] = 1.0f;
        y[i] = 2.0f;
    }

    cudaGetDevice(&device);
    cudaMemPrefetchAsync(x, N*sizeof(float), device, NULL);
    cudaMemPrefetchAsync(y, N*sizeof(float), device, NULL);

    int block_size = 256;
    int num_blocks = (N + block_size-1)/block_size;

    // init_<<<num_blocks,block_size>>>(N, x, y);
    
    add<<<num_blocks,block_size>>>(N,x,y);

    cudaDeviceSynchronize();

    cudaMemPrefetchAsync(y, N*sizeof(float), cudaCpuDeviceId, NULL);
    
    float maxError = 0.0f;
    for (int i = 0; i < N; i++)
        maxError = fmax(maxError, fabs(y[i]-3.0f));
    std::cout << "Max error: " << maxError << std::endl;

    // Free memory
    cudaFree(x);
    cudaFree(y);
    return 0;
}



