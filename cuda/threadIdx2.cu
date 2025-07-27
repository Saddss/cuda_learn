#include <stdio.h>

__global__ void thread_idx_2()
{
    const int threadId = threadIdx.y * blockDim.x + threadIdx.x;
    const int blockId = blockIdx.y * gridDim.x + blockIdx.x;
    const int id = blockId * (blockDim.x * blockDim.y) + threadId;
    printf("blockId: %d, threadId: %d, id: %d\n", blockId, threadId, id);
}

int main()
{
    dim3 gridDim(2, 4);
    dim3 blockDim(5, 2);
    thread_idx_2<<<gridDim, blockDim>>>();
    return 0;
}