#include<stdio.h>
#include<stdlib.h>

#define N 512

void host_add(int *a, int *b, int *c) {
	for(int idx=0;idx<N;idx++)
		c[idx] = a[idx] + b[idx];
}

//basically just fills the array with index.
void fill_array(int *data) {
	for(int idx=0;idx<N;idx++)
		data[idx] = idx;
}

void print_output(int *a, int *b, int*c) {
	for(int idx=0;idx<N;idx++)
		printf("\n %d + %d  = %d",  a[idx] , b[idx], c[idx]);
}

__global__ void device_add(int *a, int *b,int *c)
{
    c[threadIdx.x] = a[threadIdx.x] + b[threadIdx.x];
}



int main()
{
    int *a,*b,*c; // host vars

    int *d_a,*d_b,*d_c; // device copies of host vars

    int size = N*sizeof(int);

    a = (int *)malloc(size);
    fill_array(a);
    b = (int *)malloc(size);
    fill_array(b);
    c = (int *)malloc(size);

    cudaMalloc((void **) &d_a, size);
    cudaMalloc((void **) &d_b, size);
    cudaMalloc((void **) &d_c, size);
    
    // host_add(a,b,c);

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);

    device_add<<<1,N>>>(d_a, d_b, d_c);

    cudaMemcpy(c, d_c, size,cudaMemcpyDeviceToHost);

    print_output(a,b,c);


    free(a);
    free(b);
    free(c);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    
    printf("\n");

    return 0;
}