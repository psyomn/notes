cmake_minimum_required(VERSION 2.8)
project(threads)

set(EXECUTABLE_NAME "thread_test")
set(CMAKE_CXX_FLAGS "-std=c++11")

include_directories("${PROJECT_BINARY_DIR}")

add_executable(${EXECUTABLE_NAME}
main.cxx)

target_link_libraries(${EXECUTABLE_NAME} "-pthread")
