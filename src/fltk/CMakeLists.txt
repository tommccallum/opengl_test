if (CPP_STARTER_USE_FLTK)
  message("Building FLTK")
  find_package(FLTK REQUIRED)
  add_executable(
    ${PROJECT_NAME}
    # opengl required files
    fltk_main.cpp
    )
  target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_BINARY_DIR}/src)
  target_include_directories(${PROJECT_NAME} PRIVATE ${FLTK_INCLUDE_DIR})
  target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE project_options
            project_warnings
            CONAN_PKG::fmt
            CONAN_PKG::spdlog
            CONAN_PKG::docopt.cpp
            ${FLTK_LIBRARIES}
            ${LIBS}
            )
endif()