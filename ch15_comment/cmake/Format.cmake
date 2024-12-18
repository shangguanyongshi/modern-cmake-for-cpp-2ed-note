# -----------------------------
# 当构建 target 前，使用 clang-fromat 对 directory 中的所有文件执行代码格式化
# -----------------------------
function(Format target directory)
  find_program(CLANG-FORMAT_PATH clang-format REQUIRED)
  set(EXPRESSION h hpp hh c cc cxx cpp)
  # 为列表的每个元素添加 ${directory}/*. 前缀
  list(TRANSFORM EXPRESSION PREPEND "${directory}/*.")
  # 搜索与 EXPRESSION 通配符匹配的所有文件，保存到 SOURCE_FILES
  file(GLOB_RECURSE SOURCE_FILES
       FOLLOW_SYMLINKS
       LIST_DIRECTORIES false
       ${EXPRESSION})
  # 添加自定义命令，命令会在生成 target 前执行，使用 clang-format 调整所有文件的代码格式
  add_custom_command(TARGET ${target} PRE_BUILD COMMAND
      ${CLANG-FORMAT_PATH} -i --style=file ${SOURCE_FILES})
endfunction()
