#include "foo.cuh"
#include "cuda_runtime.h"
#include "stdio.h"  //函数在实现的时候，要用到很多依赖，在这里include进来！

__global__ void addKernel(int *A, int *B, int *C, int N) {
    int i = blockIdx.y * blockDim.y + threadIdx.y;
    int j = blockIdx.x * blockDim.x + threadIdx.x;
    printf("i is %d, j is %d\n", i, j);

    if (i < N && j < N) {
        C[i * N + j] = A[i * N + j] + B[i * N + j];
    }
}

void matrixAdd(int *A, int *B, int *C, int N) {
    const int blockSize = 4;
    int TILE_WIDTH = 2; //
    dim3 dimGrid(N / TILE_WIDTH, N / TILE_WIDTH);  //定义一个Grid有多少个Block；

    dim3 dimBlock(TILE_WIDTH, TILE_WIDTH);  //定义一个Blcok有多少个线程；

    int *d_A, *d_B, *d_C;
    cudaMalloc((void **) &d_A, N * N * sizeof(int));
    cudaMalloc((void **) &d_B, N * N * sizeof(int));
    cudaMalloc((void **) &d_C, N * N * sizeof(int));

    cudaMemcpy(d_A, A, N * N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, N * N * sizeof(int), cudaMemcpyHostToDevice);
    addKernel<<<dimGrid, dimBlock>>>(d_A, d_B, d_C, N);

    cudaMemcpy(C, d_C, N * N * sizeof(int), cudaMemcpyDeviceToHost);

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
}