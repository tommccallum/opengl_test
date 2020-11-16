if (CPP_STARTER_USE_IMGUI)
  message("Building IMGUI")
  add_executable(
    ${PROJECT_NAME}
    imgui_main.cpp
    )
  # replace this with output from fltk-config
  target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_BINARY_DIR}/src)
  target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE project_options
            project_warnings
            CONAN_PKG::fmt
            CONAN_PKG::spdlog
            CONAN_PKG::docopt.cpp
            CONAN_PKG::imgui-sfml
            ${LIBS}
            )
endif()