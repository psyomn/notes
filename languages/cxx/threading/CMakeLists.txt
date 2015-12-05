cmake_minimum_required(VERSION 2.8)
project(threads)

set(CMAKE_CXX_FLAGS "-std=c++11")

include_directories("${PROJECT_BINARY_DIR}")

add_executable(simple_threading simple_threading.cxx)
target_link_libraries(simple_threading "-pthread")

add_executable(simple_locks simple_locks.cxx)
target_link_libraries(simple_locks "-pthread")

add_executable(simple_locks_increment simple_locks_increment.cxx)
target_link_libraries(simple_locks_increment "-pthread")
