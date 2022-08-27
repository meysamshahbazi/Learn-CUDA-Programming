#include <stdio.h>
#include <stdlib.h>

#define N 16
#define BLOCK_SIZE 4

__global__
void matrix_transpose_naive(int *input, int *output)
{
    int indexX = threadIdx.x + blockIdx.x*blockDim.x;
    int indexY = threadIdx.y + blockIdx.y*blockDim.y;
    int index = indexY*N + indexX;
    int transposedIndex = indexX*N + indexY;

    output[transposedIndex] = input[index];

    // another way :
    // output[index] = input[transposedIndex];

}

__global__
void matrix_trnspose_shared(int *input,int *output)
{
    // __shared__ int shared_mem [BLOCK_SIZE][BLOCK_SIZE];
    // use + 1 for no bank conflict?!
    __shared__ int shared_mem [BLOCK_SIZE][BLOCK_SIZE + 1];

    int indexX = threadIdx.x + blockIdx.x*blockDim.x;
    int indexY = threadIdx.y + blockIdx.y*blockDim.y;

    int tindexX = threadIdx.x + blockIdx.y * blockDim.x;
    int tindexY = threadIdx.y + blockIdx.x * blockDim.y;

    int localIndexX = threadIdx.x;
    int localIndexY = threadIdx.y;

    int index = indexY + N*indexX;
    int transpoesedIndex = tindexX + N*tindexY;


    shared_mem[localIndexX][localIndexY] = input[index];

    __syncthreads();

    output[transpoesedIndex] = shared_mem[localIndexY][localIndexX]; 
}


void fill_array(int *data) {
	for(int idx=0;idx<(N*N);idx++)
		data[idx] = idx;
}


void print_output(int *a, int *b) {
	printf("\n Original Matrix::\n");
	for(int idx=0;idx<(N*N);idx++) {
		if(idx%N == 0)
			printf("\n");
		printf(" %d ",  a[idx]);
	}
    
	printf("\n Transposed Matrix::\n");
	for(int idx=0;idx<(N*N);idx++) {
		if(idx%N == 0)
			printf("\n");
		printf(" %d ",  b[idx]);
	}
    printf("\n");
}




int main()
{
    int *a, *b;
    int *d_a, *d_b; // device copies of a, b, c

    int size = N * N *sizeof(int);

    a = (int *)malloc(size); fill_array(a);
	b = (int *)malloc(size);

    cudaMalloc((void **)&d_a, size);
    cudaMalloc((void **)&d_b, size);

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);

    dim3 blockSize(BLOCK_SIZE,BLOCK_SIZE,1);
    dim3 gridSize(N/BLOCK_SIZE,N/BLOCK_SIZE,1);

    // matrix_transpose_naive<<<gridSize,gridSize>>>(d_a,d_b);
    matrix_trnspose_shared<<<gridSize,gridSize>>>(d_a,d_b);

    cudaMemcpy(b,d_b,size,cudaMemcpyDeviceToHost);

    print_output(a,b);

    free(a);
    free(b);
    cudaFree(d_a);
    cudaFree(d_b);
    
    return 0;
}