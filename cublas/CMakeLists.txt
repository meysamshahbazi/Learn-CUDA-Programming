cmake_minimum_required(VERSION 2.8)
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}" ${CMAKE_MODULE_PATH})

project( cublas )

find_package(CUDA REQUIRED)
# find_package(cuBLAS REQUIRED)
set(CUDA_SEPARABLE_COMPILATION ON)
set(CUDA_PROPAGATE_HOST_FLAGS OFF)
set(CUDA_HOST_COMPILER /usr/bin/g++)
# list( APPEND CUDA_NVCC_FLAGS "-O3 --gpu-architecture compute_86 -std=c++14")
set(CUDA_NVCC_FLAGS
    ${CUDA_NVCC_FLAGS};
    -O3 -gencode arch=compute_86,code=sm_86)

SET(GCC_COVERAGE_COMPILE_FLAGS "-std=c++14 -Wunused-function")
SET( CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} ${GCC_COVERAGE_COMPILE_FLAGS}" )
add_executable( ${PROJECT_NAME} main.cpp)

target_include_directories(${PROJECT_NAME} PUBLIC ${CUBLAS_INCLUDE_DIRS} )
target_link_libraries(${PROJECT_NAME} PUBLIC ${CUDA_LIBRARIES} ${CUDA_CUBLAS_LIBRARIES})


