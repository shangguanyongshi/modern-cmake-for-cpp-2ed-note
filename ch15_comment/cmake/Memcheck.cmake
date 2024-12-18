include(FetchContent)
FetchContent_Declare(
  memcheck-cover
  GIT_REPOSITORY https://github.com/Farigh/memcheck-cover.git
  GIT_TAG        release-1.2)
FetchContent_MakeAvailable(memcheck-cover)

# 添加自定义目标，使用 memcheck 执行 target，以执行内存检查
function(AddMemcheck target)
  set(MEMCHECK_PATH ${memcheck-cover_SOURCE_DIR}/bin)
  set(REPORT_PATH "${CMAKE_BINARY_DIR}/valgrind-${target}")
  # 添加自定义目标，生成该目标时会使用 memcheck 命令执行目标文件，以执行内存检查
  add_custom_target(memcheck-${target}
      COMMAND ${MEMCHECK_PATH}/memcheck_runner.sh -o
              "${REPORT_PATH}/report"
              -- $<TARGET_FILE:${target}>
      COMMAND ${MEMCHECK_PATH}/generate_html_report.sh
              -i ${REPORT_PATH}
              -o ${REPORT_PATH}
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
endfunction()
