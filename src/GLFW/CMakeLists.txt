if (CPP_STARTER_USE_GLFW)
  message("Building GLFW")
  add_executable(
    ${PROJECT_NAME}
    # opengl required files
    glfw_main.cpp
    ../rendering/Shader.cpp
    ../rendering/Texture.cpp
    )
  target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_BINARY_DIR}/src)
  target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE project_options
            project_warnings
            CONAN_PKG::fmt
            CONAN_PKG::spdlog
            CONAN_PKG::docopt.cpp
            ${LIBS}
            )
endif()