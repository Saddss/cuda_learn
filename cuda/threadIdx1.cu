#include <stdio.h>

__global__ void thread_idx_1()
{
    const int tid = threadIdx.x;
    const int bid = blockIdx.x;
    const int id = blockDim.x * bid + tid;
    printf("blockId : %d, threadId : %d, id : %d\n", bid, tid, id);
}

int main(void)
{
    thread_idx_1<<<2, 4>>>();
    cudaDeviceSynchronize();
    return 0;
}
