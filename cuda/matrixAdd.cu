#include <stdio.h>

__global__ void kernel_add(float* p1, float* p2, float* p3, int N)
{
    const int tid = threadIdx.x;
    const int bid = blockIdx.x;
    const int id = tid + bid * blockDim.x;
    if (id < N) {
        p3[id] = p1[id] + p2[id];
    } else {
        printf("Thread %d is out of bounds!\n", id);  // 这可能会帮助你看到超出范围的线程
    }
}

void initData(float* p, int elementNum)
{
    for (int i = 0; i < elementNum; i++)
    {
        p[i] = (float)(rand() & 0xFF) / 10.0f;
    }
}

int main()
{
    // 检测计算机GPU数量
    int iDeviceCount = 0;
    cudaError_t error = cudaGetDeviceCount(&iDeviceCount);

    if (error != cudaSuccess || iDeviceCount == 0){
        printf("No CUDA campatable GPU found!\n");
        exit(-1);
    }
    else{
        printf("The count of GPUs is %d.\n", iDeviceCount);
    }

    // 设置执行
    int iDev = 0;
    error = cudaSetDevice(iDev);
    if (error != cudaSuccess){
        printf("fail to set GPU 0 for computing.\n");
        exit(-1);
    }
    else{
        printf("set GPU 0 for computing.\n");
    }

    int iElemCount = 513;
    int byteCount = iElemCount * sizeof(float);
    float* p1 = (float*)malloc(byteCount);
    float* p2 = (float*)malloc(byteCount);
    float* p3 = (float*)malloc(byteCount);

    memset(p1, 0, byteCount);
    memset(p2, 0, byteCount);
    memset(p3, 0, byteCount);

    initData(p1, iElemCount);
    initData(p2, iElemCount);

    float* dp1, *dp2, *dp3;
    cudaMalloc((float**)&dp1, byteCount);
    cudaMalloc((float**)&dp2, byteCount);
    cudaMalloc((float**)&dp3, byteCount);

    cudaMemcpy(dp1, p1, byteCount, cudaMemcpyHostToDevice);
    cudaMemcpy(dp2, p2, byteCount, cudaMemcpyHostToDevice);
    cudaMemcpy(dp3, p3, byteCount, cudaMemcpyHostToDevice);
    
    dim3 block(32);
    dim3 grid((iElemCount + block.x - 1) / 32);
    kernel_add<<<grid, block>>>(dp1, dp2, dp3, iElemCount);
    cudaDeviceSynchronize();

    cudaMemcpy(p1, dp1, byteCount, cudaMemcpyDeviceToHost);
    cudaMemcpy(p2, dp2, byteCount, cudaMemcpyDeviceToHost);
    cudaMemcpy(p3, dp3, byteCount, cudaMemcpyDeviceToHost);

    for (int i = 0; i < iElemCount; i++)
    {
        printf("%.2f + %.2f = %.2f\n", p1[i], p2[i], p3[i]);
    }

    free(p1);
    free(p2);
    free(p3);
    cudaFree(dp1);
    cudaFree(dp2);
    cudaFree(dp3);
    return 0;
}