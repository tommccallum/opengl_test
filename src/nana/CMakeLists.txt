if (CPP_STARTER_USE_NANA)
  message("Building NANA")

  include(ExternalProject)
  ExternalProject_Add(
    Nana
    GIT_REPOSITORY https://github.com/cnjinhao/nana.git
    GIT_TAG v1.6.2
    CMAKE_CACHE_ARGS "-DNANA_CMAKE_SHARED_LIB:BOOL=TRUE"
    INSTALL_COMMAND "")

    # ExternalProject_Get_Property(Nana NANA_INCLUDE_DIR)
    ExternalProject_Get_Property(Nana SOURCE_DIR BINARY_DIR)

  add_executable(
    ${PROJECT_NAME}
    nana_main.cpp
    )
  # replace this with output from fltk-config
  target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_BINARY_DIR}/src)
  target_include_directories(${PROJECT_NAME} PRIVATE ${SOURCE_DIR}/include)
  add_dependencies(${PROJECT_NAME} Nana)
  target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE project_options
            #project_warnings       # we have to relax this as Nana library is full of warnings!
            CONAN_PKG::fmt
            CONAN_PKG::spdlog
            CONAN_PKG::docopt.cpp
            ${BINARY_DIR}/libnana.so
            ${NANA_LINKS}
            ${LIBS}
            )
endif()