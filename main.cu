#include <iostream>
#include "foo.cuh"  // 在coding的时候，只要有头文件，就默认有了实现（实现可以在cpp里完成、在cu里完成、也可以在lib里完成） // 一定要把函数的声明include进来；

int main() {
    std::cout << "Hello, World!" << std::endl;

    const int N = 4;
    int h_A[N][N], h_B[N][N], h_C[N][N];

    // initialize h_A and h_B
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N; ++j) {
            h_A[i][j] = 1 * i * j;
            h_B[i][j] = 2 * i * j;
        }
    }

    std::cout << typeid(h_A).name() << std::endl;

    matrixAdd((int *) h_A, (int *) h_B, (int *) h_C, N);

    // wait cuda to finish
    cudaDeviceSynchronize();

    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N; ++j) {
            std::cout << h_C[i][j] << " ";
        }
        std::cout << std::endl;
    }

    //  system("pause");
    return 0;
}
