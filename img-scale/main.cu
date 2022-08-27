
#include<stdio.h>
#include"scrImagePgmPpmPackage.h"





int main(int argc, const char * argv[])
{
	int height=0, width =0, scaled_height=0,scaled_width=0;
	//Define the scaling ratio	
	float scaling_ratio=0.5;
	unsigned char*data;
	unsigned char*scaled_data,*d_scaled_data;

	char inputStr[] = {"../../Chapter02/02_memory_overview/05_image_scaling/aerosmith-double.pgm"};
	char outputStr[1024] = {"aerosmith-double-scaled.pgm"};

    cudaError_t return_value;

    cudaArray* cu_array;

    cudaChannelFormatKind kind = cudaChannelFormatKindUnsigned;
    cudaChannelFormatDesc channel_desc = cudaCreateChannelDesc(8,0,0,0,kind);

    get_PgmPpmParams(inputStr,&height,&width);
    data  = (unsigned char*)malloc(width*height*sizeof(unsigned char));
    printf("\n Reading image width height and width [%d][%d]\n", height, width);

    return 0;
}