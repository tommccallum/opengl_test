if (CPP_STARTER_USE_QT)
  message("Building QT executable")

  add_executable(
    ${PROJECT_NAME}
    # qt required files
    qt_main.cpp
    HelloQt.cpp
    )
  target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_BINARY_DIR}/src)
  target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE project_options
            project_warnings
            CONAN_PKG::fmt
            CONAN_PKG::spdlog
            CONAN_PKG::docopt.cpp
            Qt5::Widgets
            ${LIBS}
            )
  target_compile_features(${PROJECT_NAME} PUBLIC cxx_nullptr cxx_lambdas)
endif()