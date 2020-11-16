cmake_minimum_required(VERSION 3.2 FATAL_ERROR)
set(PROJ_NAME "opengltest")
project(${PROJ_NAME} LANGUAGES C CXX VERSION 0.1)

# set todays date so we can store build date and time
string(TIMESTAMP TODAY "%Y-%m-%d %H:%M")
# output to user what compiler we are using
message("CMAKE_CXX_COMPILER_ID: " ${CMAKE_CXX_COMPILER_ID})

include(cmake/standard_project_settings.cmake)
include(cmake/prevent_in_source_builds.cmake)
# Link this 'library' to set the c++ standard / compile-time options requested
add_library(project_options INTERFACE)
target_compile_features(project_options INTERFACE cxx_std_17)

# User options for cmake 
# use with -Doption=ON/OFF argument to cmake
# e.g. cmake -DBUILD_SHARED_LIBS=ON ..
option(BUILD_SHARED_LIBS "Enable compilation of shared libraries" OFF)
option(ENABLE_TESTING "Enable Test Builds" ON)
option(ENABLE_FUZZING "Enable Fuzzing Builds, requires Clang compiler" OFF)
option(ENABLE_DOXYGEN "Enable doxygen doc builds of source" OFF)
option(USE_CLANG "build application with clang (ON) or gcc (OFF)" OFF) 
option(ENABLE_BUILD_WITH_TIME_TRACE "Enable -ftime-trace to generate time tracing .json files on clang" OFF)
option(ENABLE_CPPCHECK "Enable static analysis with cppcheck" OFF)
option(ENABLE_CLANG_TIDY "Enable static analysis with clang-tidy" OFF)
option(ENABLE_UNITY "Enable Unity builds of projects" OFF)
option(ENABLE_GPROF "Enable profiling using GPROF" OFF)

# Framework options, turn one on at a time!
option(CPP_STARTER_USE_DEFAULT "Enable default compilation" OFF)
option(CPP_STARTER_USE_GLFW "Enable compilation of GLFW sample" OFF)
option(CPP_STARTER_USE_QT "Enable compilation of QT sample" OFF)
option(CPP_STARTER_USE_SDL "Enable compilation of SDL sample" OFF)        # buggy still
option(CPP_STARTER_USE_FLTK "Enable compilation of FLTK sample" OFF)
option(CPP_STARTER_USE_GTKMM "Enable compilation of GTKMM sample" OFF)
option(CPP_STARTER_USE_IMGUI "Enable compilation of ImGui sample" ON)
#option(CPP_STARTER_USE_NANA "Enable compilation of Nana GUI sample" OFF)



# turned on by .travis.yml script
option(ENABLE_COVERAGE "Enable coverage reporting for gcc/clang" OFF)

# convert our options to numeric values for interpretation by our
# C(++) program
set(CPP_STARTER_USE_GLFW_VALUE 0)
if (CPP_STARTER_USE_GLFW)
  set(CPP_STARTER_USE_DEFAULT OFF)
  set(CPP_STARTER_USE_GLFW_VALUE 1)
endif()

set(CPP_STARTER_USE_QT_VALUE 0)
if (CPP_STARTER_USE_QT)
  set(CPP_STARTER_USE_DEFAULT OFF)
  set(CPP_STARTER_USE_QT_VALUE 1)
endif()

set(CPP_STARTER_USE_SDL_VALUE 0)
if (CPP_STARTER_USE_SDL)
  set(CPP_STARTER_USE_DEFAULT OFF)
  set(CPP_STARTER_USE_SDL_VALUE 1)
endif()

set(CPP_STARTER_USE_FLTK_VALUE 0)
if (CPP_STARTER_USE_FLTK)
  set(CPP_STARTER_USE_DEFAULT OFF)
  set(CPP_STARTER_USE_FLTK_VALUE 1)
endif()

set(CPP_STARTER_USE_GTKMM_VALUE 0)
if (CPP_STARTER_USE_GTKMM)
  set(CPP_STARTER_USE_DEFAULT OFF)
  set(CPP_STARTER_USE_GTKMM_VALUE 1)
endif()

set(CPP_STARTER_USE_IMGUI_VALUE 0)
if (CPP_STARTER_USE_IMGUI)
  set(CPP_STARTER_USE_DEFAULT OFF)
  set(CPP_STARTER_USE_IMGUI_VALUE 1)
endif()



set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)


# add compiler specific settings
if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")  
  if(ENABLE_BUILD_WITH_TIME_TRACE)
    add_compile_definitions(project_options INTERFACE -ftime-trace)
  endif()
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES ".*GNU")
  if (ENABLE_GPROF)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pg")
    SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pg")
    SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -pg")
  endif()
endif()

# Link this 'library' to use the warnings specified in CompilerWarnings.cmake
# We want warnings to be treated as errors 
add_library(project_warnings INTERFACE)

# enable cache system
include(cmake/cache.cmake)

# standard compiler warnings
include(cmake/compiler_warnings.cmake)
set_project_warnings(project_warnings)

# sanitizer options if supported by compiler
include(cmake/sanitizers.cmake)
enable_sanitizers(project_options)

# build doxygen if enabled
include(cmake/doxygen.cmake)
build_documentation()

# allow for static analysis options
include(cmake/static_analyzers.cmake)

# Set up some extra Conan dependencies based on our needs before loading Conan
set(CONAN_EXTRA_REQUIRES "")
set(CONAN_EXTRA_OPTIONS "")

if(CPP_STARTER_USE_IMGUI)
  set(CONAN_EXTRA_REQUIRES ${CONAN_EXTRA_REQUIRES} imgui-sfml/2.1@bincrafters/stable)

  # set(CONAN_EXTRA_OPTIONS ${CONAN_EXTRA_OPTIONS} sfml:shared=False sfml:graphics=True sfml:audio=False
  # sfml:window=True libalsa:disable_python=True)
endif()

if(CPP_STARTER_USE_SDL)
  # WARNING: this can take A LOOOONNNNNGGGG time to download and compile
  set(CONAN_EXTRA_REQUIRES ${CONAN_EXTRA_REQUIRES} sdl2/2.0.10@bincrafters/stable)
  # set(CONAN_EXTRA_OPTIONS ${CONAN_EXTRA_OPTIONS} sdl2:wayland=True)
endif()

include(cmake/conan.cmake)
run_conan()


link_directories(${CMAKE_SOURCE_DIR}/lib)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

# OpenGL
find_package(OpenGL REQUIRED)

# GLM 
find_package(GLM REQUIRED)
message(STATUS "GLM included at ${GLM_INCLUDE_DIR}")

# GLFW
find_package(GLFW3 REQUIRED)
message(STATUS "Found GLFW3 in ${GLFW3_INCLUDE_DIR}")

# STB_IMAGE (https://github.com/nothings/stb)
add_library(STB_IMAGE "thirdparty/stb_image.cpp")

# GLAD (https://glad.dav1d.de/)
add_library(GLAD "thirdparty/glad.c")

#Qt (https://cmake.org/cmake/help/v3.5/manual/cmake-qt.7.html)
# Instruct CMake to run moc automatically when needed.
if ( CPP_STARTER_USE_QT )
  set(Qt5_DIR )
  set(CMAKE_AUTOMOC ON)
  find_package(Qt5Widgets REQUIRED)
endif()

# zlib
find_package(ZLIB REQUIRED)

# Put all libraries into a variable
# WARNING zlib needs to go last otherwise the build on Ubuntu fails
# TODO this needs cleaning up as we don't need all these for all frameworks
set(LIBS glfw3 GL dl pthread assimp STB_IMAGE GLAD z)

# Define the include DIRs
include_directories(
	"${CMAKE_SOURCE_DIR}/src"
	SYSTEM "${CMAKE_SOURCE_DIR}/include"
)

if(ENABLE_TESTING)
  enable_testing()
  message("Building Tests. Be sure to check out test/constexpr_tests for constexpr testing")
  add_subdirectory(tests)
endif()


if(ENABLE_FUZZING)
  message("Building Fuzz Tests, using fuzzing sanitizer https://www.llvm.org/docs/LibFuzzer.html")
  add_subdirectory(fuzz_tests)
endif()

if(ENABLE_UNITY)
  # Add for any project you want to apply unity builds for
  set_target_properties(intro PROPERTIES UNITY_BUILD ON)
endif()

# read in CMakeLists.txt from src directory
add_subdirectory(src)

# uninstall target
if(NOT TARGET uninstall)
  configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/uninstall.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/uninstall.cmake"
    IMMEDIATE @ONLY)

  add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/uninstall.cmake)
endif()

# Install target
INSTALL(TARGETS ${PROJ_NAME}
    DESTINATION  "${${PROJ_NAME}_PATH_INSTALL}/lib/${CMAKE_BUILD_TYPE}/"
	)