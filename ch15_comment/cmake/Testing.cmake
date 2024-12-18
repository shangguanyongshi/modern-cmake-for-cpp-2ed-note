# -----------------------------
# 1. 安装 GTest 测试框架
# 2. 定义 ADDTests 宏，为指定目标连接 gtest_main 库、测试覆盖率库、内存检测库
# -----------------------------
include(FetchContent)
FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG v1.14.0)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
# 只在项目中使用，不安装到系统
option(INSTALL_GMOCK "Install GMock" OFF)
option(INSTALL_GTEST "Install GTest" OFF)
FetchContent_MakeAvailable(googletest)

include(GoogleTest)
include(Coverage)
include(Memcheck)

# 执行如下操作：
# 1. 为目标添加 gtest_main 库文件，以生成可执行的测试文件
# 2. 使用 gtest_discover_tests 将测试用例注册到 CTest
# 3. 使用 AddCoverage 生成自定义目标 coverage-${target}，
#    自定义目标会执行 target，并生成代码执行覆盖率报告
# 4. 使用 AddMemcheck 生成自定义目标 coverage-${target}，
#    自定义目标会使用 memcheck 执行 target，以检查内存使用情况
macro(AddTests target)
  message("Adding tests to ${target}")
  target_link_libraries(${target} PRIVATE gtest_main gmock)
  gtest_discover_tests(${target})
  AddCoverage(${target})
  AddMemcheck(${target})
endmacro()
