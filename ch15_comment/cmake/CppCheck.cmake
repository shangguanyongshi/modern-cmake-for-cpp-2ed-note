# -----------------------------
# 为目标添加 cppcheck 属性，以在构建时执行 cppcheck
# -----------------------------
function(AddCppCheck target)
  find_program(CPPCHECK_PATH cppcheck REQUIRED)
  # 只需要为目标添加 CXX_CPPCHECK 属性，编译器会在编译时自动执行 cppcheck
  set_target_properties(${target}
      PROPERTIES CXX_CPPCHECK
          "${CPPCHECK_PATH};--enable=warning;--error-exitcode=1")
endfunction()
