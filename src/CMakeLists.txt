message("Building executable")


## Here we build the files we are copying variable values from cmake into our C(++) program
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

#
#  Here we have a different set of files we are compiling
#  depending on what frameworks we are using.
#

add_subdirectory("default")
add_subdirectory("Qt")
add_subdirectory("SDL")
add_subdirectory("GLFW")




# Define the link libraries
#target_link_libraries(${PROJECT_NAME} ${LIBS})

