# 获取 Doxygen 和对 Doxygen 文档优化的库
find_package(Doxygen REQUIRED)
include(FetchContent)
FetchContent_Declare(doxygen-awesome-css
  GIT_REPOSITORY https://github.com/jothepro/doxygen-awesome-css.git
  GIT_TAG v2.3.1)
FetchContent_MakeAvailable(doxygen-awesome-css)

# 根据创建自定义目标 doxygen-${target}，会根据 input 目标生成文档
function(Doxygen target input)
  set(NAME "doxygen-${target}")
  set(DOXYGEN_GENERATE_HTML YES)
  set(DOXYGEN_HTML_OUTPUT ${PROJECT_BINARY_DIR}/${output})

  UseDoxygenAwesomeCss()
  UseDoxygenAwesomeExtensions()

  # 该命令会添加一个自定义目标，只有执行 CMake --build 指定生成该目标时，才会生成最终的文档
  doxygen_add_docs("doxygen-${target}"
      ${PROJECT_SOURCE_DIR}/${input}
      COMMENT "Generate HTML documentation")

endfunction()

# 使用 DoxygenAwesoeCss 中的相关信息对文档美化
macro(UseDoxygenAwesomeCss)
  set(DOXYGEN_GENERATE_TREEVIEW     YES)
  set(DOXYGEN_HAVE_DOT              YES)
  set(DOXYGEN_DOT_IMAGE_FORMAT      svg)
  set(DOXYGEN_DOT_TRANSPARENT       YES)
  set(DOXYGEN_HTML_EXTRA_STYLESHEET
        ${doxygen-awesome-css_SOURCE_DIR}/doxygen-awesome.css)
endmacro()

# 将 DoxygenAwesoeCss 中的一些 JS 和样式添加到生成的文档页面中
macro(UseDoxygenAwesomeExtensions)
  set(DOXYGEN_HTML_EXTRA_FILES
    ${doxygen-awesome-css_SOURCE_DIR}/doxygen-awesome-darkmode-toggle.js
    ${doxygen-awesome-css_SOURCE_DIR}/doxygen-awesome-fragment-copy-button.js
    ${doxygen-awesome-css_SOURCE_DIR}/doxygen-awesome-paragraph-link.js
    ${doxygen-awesome-css_SOURCE_DIR}/doxygen-awesome-interactive-toc.js)

  execute_process(COMMAND doxygen -w html header.html footer.html style.css
                  WORKING_DIRECTORY ${PROJECT_BINARY_DIR})
  execute_process(COMMAND sed -i 
                            "/<\\/head>/r ${PROJECT_SOURCE_DIR}/cmake/doxygen_extra_headers"
                            header.html
                  WORKING_DIRECTORY ${PROJECT_BINARY_DIR})
  set(DOXYGEN_HTML_HEADER ${PROJECT_BINARY_DIR}/header.html)
endmacro()
