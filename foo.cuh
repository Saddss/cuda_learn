#ifndef FOO_CUH
#define FOO_CUH

__global__ void addKernel(int *A, int *B, int *C, int N);
void matrixAdd(int *A, int *B, int *C, int N);

#endif // FOO_CUH