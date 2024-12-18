## 创建目标文件
add_library(calc_obj OBJECT basic.cpp)
target_sources(calc_obj PUBLIC
               FILE_SET HEADERS
               BASE_DIRS include
               FILES include/calc/basic.h)
# 目标库也要设置位置无关的标志位，避免造成下面的静态库和动态库变成位置相关
set_target_properties(calc_obj PROPERTIES POSITION_INDEPENDENT_CODE 1)

# 为 clac_obj 添加测试覆盖率分析的标志位
InstrumentForCoverage(clac_obj)

## 利用目标文件分别创建静态库文件和动态库文件
# 创建静态库文件
add_library(calc_static STATIC)
target_link_libraries(calc_static calc_obj)

# 创建动态库文件
add_library(calc_shared SHARED)
target_link_libraries(calc_shared calc_obj)

## 指定静态和动态文件检查
# 将静态文件的覆盖率分析文件清除
CleanCoverage(calc_static)

# 引入代码格式化和CPP检查
Format(calc_static .)
AddCppCheck(calc_obj)


# 这里传入 calc 只是为了生成 doxygen-calc 命名的文档
Doxygen(calc src/calc)

## 指定 calc 库的安装方式
include(GNUInstallDirs)
install(TARGETS calc_obj calc_shared calc_static
        EXPORT CalcLibrary
        # 下面将不同类型的目标划分到不同的组件中
        ARCHIVE COMPONENT development  # ARCHIVE 类型包含 静态库文件
        LIBRARY COMPONENT runtime  # LIBRARY 类型包含 动态库文件
        FILE_SET HEADERS COMPONENT runtime)  # HEADERS 类型包含的是头文件
# UNIX 系统指定安装后注册共享库到 ldconfig
if(UNIX)
  install(CODE "execute_process(COMMAND ldconfig)"  # 运行 ldconfig 命令
          COMPONENT runtime)  # 指定代码属于 runtime 组件
endif()
# 为了能够让其他项目复用 Calc 库，生成并安装目标导出文件
install(EXPORT CalcLibrary
        DESTINATION ${CMAKE_INSTALL_PREFIX}/calc/cmake
        NAMESPACE Calc::
        COMPONENT runtime)
# CalcConfig.cmake 配置文件中只使用 include 引入目标导出文件
install(FILES "CalcConfig.cmake"
        DESTINATION ${CMAKE_INSTALL_PREFIX}/calc/cmake)