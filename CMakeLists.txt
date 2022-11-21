cmake_minimum_required(VERSION 2.8.3)
project(mav_reconstrunction_utils_simple)

find_package(catkin_simple REQUIRED)

catkin_simple(ALL_DEPS_REQUIRED)

add_definitions(-std=c++11)

catkin_package()

cs_add_executable(eval_voxblox_node
        src/experiments/eval_voxblox_node.cpp
        )

