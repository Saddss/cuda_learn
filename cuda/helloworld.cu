#include<stdio.h>

__global__ void helloWorld()
{
    printf("Hello World from gpu!\n");
}

int main()
{
    helloWorld<<<1, 1>>>();
    cudaDeviceSynchronize();
    return 0;
}