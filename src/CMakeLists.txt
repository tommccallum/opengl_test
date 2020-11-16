message("Building executable")

configure_file(helpers/RootDir.h.in helpers/RootDir.h)
configure_file(helpers/version.hpp.in helpers/version.hpp)
include_directories(${CMAKE_BINARY_DIR}/src)

# Add source files
# file(GLOB_RECURSE SOURCE_FILES 
# 	${CMAKE_SOURCE_DIR}/src/*.c
# 	${CMAKE_SOURCE_DIR}/src/*.cpp)
	
# # Add header files
# file(GLOB_RECURSE HEADER_FILES 
# 	${CMAKE_SOURCE_DIR}/src/*.h
# 	${CMAKE_SOURCE_DIR}/src/*.hpp)
#add_executable(${PROJECT_NAME} ${HEADER_FILES} ${SOURCE_FILES})

add_executable(
  ${PROJECT_NAME}
  main.cpp
  opengl_main.cpp
  rendering/Shader.cpp
  rendering/Texture.cpp
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
# Define the link libraries
#target_link_libraries(${PROJECT_NAME} ${LIBS})