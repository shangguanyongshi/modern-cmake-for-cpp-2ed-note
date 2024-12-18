set(BUILDINFO_TEMPLATE_DIR ${CMAKE_CURRENT_LIST_DIR})
set(DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/buildinfo")
string(TIMESTAMP TIMESTAMP)  # 将当前时间戳保存到字符串变量 TIMESTAMP

find_program(GIT_PATH git REQUIRED)  # 查找 git 命令所在的路径
# 将命令的输出保存到 OUTPUT_VARIABLE 指定的变量中
execute_process(COMMAND ${GIT_PATH} log --pretty=format:'%h' -n 1
                OUTPUT_VARIABLE COMMIT_SHA)

# 利用上面定义的变量，替换 buildinfo.h.in 的占位符，并生成 buildinfo.h 头文件
configure_file("${BUILDINFO_TEMPLATE_DIR}/buildinfo.h.in"
               "${DESTINATION}/buildinfo.h"
               @ONLY) # @ONLY 指定只替换 @xxx@ 格式的占位符

# 为目标添加 buildinfo.h 头文件
function(BuildInfo target)
  target_include_directories(${target} PRIVATE ${DESTINATION})
endfunction()
