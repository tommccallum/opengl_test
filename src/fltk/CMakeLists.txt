if (CPP_STARTER_USE_FLTK)
  message("Building FLTK")
  #find_package(FLTK REQUIRED)
  add_executable(
    ${PROJECT_NAME}
    fltk_main.cpp
    )
  # replace this with output from fltk-config
  set(FLTK_LIBRARIES fltk fltk_forms fltk_gl fltk_images Xrender Xcursor Xfixes Xext Xft fontconfig Xinerama pthread dl m X11)
  target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_BINARY_DIR}/src)
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