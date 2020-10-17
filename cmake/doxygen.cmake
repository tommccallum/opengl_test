function(build_documentation)
  find_package(Doxygen)
  if (DOXYGEN_FOUND)
    if(ENABLE_DOXYGEN)
      # find the variable in CMakeDoxyfile.in in build
      # and link to CMake variable or your own value.
      set(DOXYGEN_INPUT ${CMAKE_CURRENT_SOURCE_DIR}/src)
      set(DOXYGEN_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/docs)
      set(DOXYGEN_PROJECT_NAME ${PROJECT_NAME})
      set(DOXYGEN_PROJECT_NUMBER ${PROJECT_NUMBER})
      set(GENERATE_MAN YES)
      set(MAN_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/docs)
      set(MAN_SUBDIR ${CMAKE_CURRENT_BINARY_DIR}/docs/man)
      set(MAN_LINKS YES)
      find_package(Doxygen REQUIRED dot)
      #doxygen_add_docs(doxygen-docs ${PROJECT_SOURCE_DIR} COMMENT "Generate html and man pages")

      # set input and output files
      set(DOXYGEN_IN ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in)
      set(DOXYGEN_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)

      # request to configure the file
      configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT} @ONLY)
      message("Doxygen build started")

      # note the option ALL which allows to build the docs together with the application
      add_custom_target( doc_doxygen ALL
          COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUT}
          WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
          COMMENT "Generating API documentation with Doxygen"
          VERBATIM )
    endif()
  else (DOXYGEN_FOUND)
    message("Doxygen need to be installed to generate the doxygen documentation")
  endif (DOXYGEN_FOUND)
endfunction()