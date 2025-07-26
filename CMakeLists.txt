cmake_minimum_required(VERSION 3.27)
project(fuck_cuda CUDA)

set(CMAKE_CUDA_STANDARD 11)

set(INC_DIR "C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v12.6/include/")
set(LINK_DIR "C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v12.6/lib/x64/")
include_directories(${INC_DIR})
link_directories(${LINK_DIR})
link_libraries(cufft nppial nppist nvml cufftw nppicc nppisu nvrtc curand nppitc OpenCL cuda cusolver nppidei npps cudadevrt cusparse nppif nvblas cudart nppc nppig cudart_static nppim)

add_executable(fuck_cuda main.cu
        foo.cu # 在编译的时候，只需要编译cpp文件、cu文件，或者添加lib文件。不需要编译头文件！！！
        #        foo.cuh # 编译的是时候，添加或者不添加头文件，都没什么意义
)

set_target_properties(fuck_cuda PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)
