if (CPP_STARTER_USE_SDL)
  message("Building SDL executable")
  add_executable(
    ${PROJECT_NAME}
    # main entry into application that will build specific main entry points
    main.cpp
    # opengl required files
    sdl_main.cpp
    )
  target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_BINARY_DIR}/src)
  target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE project_options
            project_warnings
            CONAN_PKG::fmt
            CONAN_PKG::spdlog
            CONAN_PKG::docopt.cpp
            CONAN_PKG::sdl2
            ${LIBS}
            )
endif()