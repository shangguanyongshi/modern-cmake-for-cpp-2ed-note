# 利用 target 创建自定义目标，该目标会执行 target，并生成代码覆盖率报告
function(AddCoverage target)
  find_program(LCOV_PATH lcov REQUIRED)  # 查找本地的 lcov 命令
  find_program(GENHTML_PATH genhtml REQUIRED)  # 查找 genhtml 命令以生成 HTML 格式的测试覆盖率文件
  # 添加自定义目标 coverage-${target}
  # 生成该目标时，会执行参数指定的目标，并生成代码覆盖率报告
  add_custom_target(coverage-${target}
      COMMAND ${LCOV_PATH} -d . --zerocounters
      COMMAND $<TARGET_FILE:${target}>  # 执行该目标
      COMMAND ${LCOV_PATH} -d . --capture -o coverage.info
      COMMAND ${LCOV_PATH} -r coverage.info '/usr/include/*'
                           -o filtered.info
      COMMAND ${GENHTML_PATH} -o coverage-${target}
                              filtered.info --legend
      COMMAND rm -rf coverage.info filtered.info
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
endfunction()

function(CleanCoverage target)
  add_custom_command(TARGET ${target} PRE_BUILD 
      COMMAND find ${CMAKE_BINARY_DIR} -type f
                   -name '*.gcda' -exec cmake -E rm {} +)
endfunction()

# 为指定的目标在 DEBUG 编译时添加代码覆盖率编译选项
function(InstrumentForCoverage target)
  # DEBUG 编译时才需要为目标添加代码覆盖率的选项
  if (CMAKE_BUILD_TYPE STREQUAL Debug)
    # 为目标添加代码覆盖率标记，这样的目标编译器会插入特定的代码已生成代码覆盖率报告
    target_compile_options(${target} PRIVATE --coverage -fno-inline)
    target_link_options(${target} PUBLIC --coverage)
  endif()
endfunction()
