#include <stdio.h>
#include <stdlib.h>

#define BLOCK_DIM_X 16
#define BLOCK_DIM_Y 16



////////////////////////////////////////////////////////////////////////////////
//! Compute reference data set matrix multiply on GPU
//! C = alpha * A * B + beta * C
//! @param A          matrix A as provided to device
//! @param B          matrix B as provided to device
//! @param C          matrix C as provided to device
//! @param N          height of matrix A and matrix C
//! @param M          width of matrix B and matrix C
//! @param K          width of matrix A and height of matrix B
//! @param alpha      scala value for matrix multiplication
//! @param beta       scala value for matrix summation with C
////////////////////////////////////////////////////////////////////////////////
__global__ void 
sgemm_gpu_kernel(const float *A, const float *B, float *C, int N, int M, int K, float alpha, float beta)
{
    int col = blockIdx.x*blockDim.x + threadIdx.x;
    int row = blockIdx.y*blockDim.y + threadIdx.y;

    float sum_ = 0;
    for(int i=0;i<K;i++)
    {
        sum_ +=A[ row*K + i ]*B[ i*K + col];
    }
    C[row*M+col] = alpha*sum_+beta*C[row*M+col];
}

__global__
void idx_print()
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int warp_idx = threadIdx.x/warpSize;
    int lane_idx = threadIdx.x & (warpSize -1);

    // if ( (lane_idx & (warpSize/2-1) ) == 0 ) 
        printf(" %5d\t%5d\t %2d\t%2d\n", idx, blockIdx.x, warp_idx, lane_idx);
}


int main(int argc, char* argv[])
{
    if (argc == 1) {
        puts("Please put Block Size and Thread Block Size..");
        puts("./tid [grid size] [block size]");
        puts("e.g.) ./tid 4 128");

        exit(1);
    }

    int grid_size = atoi(argv[1]);
    int block_size = atoi(argv[2]);

    puts("Thread, block, warp, lane");
    idx_print<<<grid_size,block_size>>>();
    cudaDeviceSynchronize();

    return 0;
}


