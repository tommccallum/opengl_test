if (CPP_STARTER_USE_GTKMM)
  message("Building GTKMM")
  find_package(PkgConfig REQUIRED)
  pkg_check_modules(
    GTKMM
    REQUIRED
    IMPORTED_TARGET
    gtkmm-3.0)
  add_executable(
    ${PROJECT_NAME}
    gtkmm_main.cpp
    hello_world.cpp
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
            PkgConfig::GTKMM
            ${LIBS}
            )
endif()