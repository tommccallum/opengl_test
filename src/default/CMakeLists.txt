if (CPP_STARTER_USE_DEFAULT)
  message("Building default")
  add_executable(
    ${PROJECT_NAME}
    # main entry into application that will build specific main entry points
    main.cpp
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
