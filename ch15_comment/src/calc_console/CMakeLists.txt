# 将程序逻辑和main文件分离，以支持单独对主程序的逻辑执行测试

# 1. 将程序的实际逻辑编译为静态库
add_library(calc_console_static STATIC tui.cpp)
target_include_directories(calc_console_static PUBLIC include)
# 预编译 C++ 的 string 头文件以加快编译速度
target_precompile_headers(calc_console_static PUBLIC <string>)

# 引入自定义模块获取 FIXUI 依赖
include(GetFTXUI)
# 给静态文件指定依赖库，包含 calc 动态库和 ftxui 相关的库
target_link_libraries(calc_console_static PUBLIC 
                      calc_shared ftxui::screen ftxui::dom ftxui::component)

# 引入自定义模块生成构建信息
include(BuildInfo)
BuildInfo(calc_console_static)

# 引入代码格式化和检查
Format(calc_console_static .)
AddCppCheck(calc_console_static)

# 生成 doxygen-calc_console 命令的文档
Doxygen(calc_console src/calc_console)

# 添加测试覆盖率的相关标识
InstrumentForCoverage(calc_console_static)
CleanCoverage(calc_console_static)

# 2. 在生产环境中，需要使用 bootstrap.cpp 中定义的 main 函数调用生成的静态库中的实际主程序逻辑
add_executable(calc_console bootstrap.cpp)
target_link_libraries(calc_console calc_console_static)


# 3. 将可执行文件安装到胸中
include(GNUInstallDirs)
install(TARGETS calc_console
        RUNTIME COMPONENT runtime)