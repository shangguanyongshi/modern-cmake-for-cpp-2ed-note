cmake_minimum_required(VERSION 3.26)
project(CalcTest VERSION 1.1.0 LANGUAGES CXX)

# 为 find_package 和 include 添加搜索路径
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# 引入禁止内部构建的检查脚本
include(NoInSourceBuilds)

# 引入 CTest，在根目录引入，以在 build_tree 下生成 CTestTestfile.cmake 文件
include(CTest)

# 分别编译源码目录和测试目录
add_subdirectory(src bin)
add_subdirectory(test)

include(Packaging)
