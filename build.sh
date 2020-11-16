#!/bin/bash

BUILD_TYPE="Release"    # either Release / Debug
ACTION="build"          # either build / clean
LOCAL_C_COMPILER=""           # if empty string, use system default
LOCAL_CXX_COMPILER=""         # if empty string, use system default

# Need to remake everything with clang
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "Working directory: $CURDIR"
cd $CURDIR

for arg in "$@"
do
    if [ "x$arg" == "x--debug" ]
    then
        BUILD_TYPE="Debug"
    fi
    if [ "x$arg" == "xclean" ]
    then
        ACTION="clean"
    fi
    if [ "x$arg" == "x--compiler=gnu" ]
    then
        LOCAL_C_COMPILER="gcc"
        LOCAL_CXX_COMPILER="g++"
    fi
    if [ "x$arg" == "x--compiler=clang" ]
    then
        LOCAL_C_COMPILER="clang"
        LOCAL_CXX_COMPILER="clang++"
    fi
done

if [ "x${ACTION}" == "xclean" ]
then
    echo "Cleaning directory"
    [[ -e build ]] && rm -rf build
    [[ -e submodules/assimp/build ]] && rm -rf submodules/assimp/build
    [[ -e submodules/glfw/build ]] && rm -rf submodules/glfw/build
    [[ -e submodules/glew/build ]] && rm -rf submodules/glew/build
    [[ -e lib/libassimp.a ]] && rm -f ./lib/libassimp.a
    [[ -e lib/libglfw3.a ]] && rm -f ./lib/libglfw3.a
    [[ -e include/glm ]] && rm -rf include/glm
    [[ -e include/GLFW ]] && rm -rf include/GLFW
    [[ -e include/assimp ]] && rm -rf include/assimp

    [[ -e submodules/fltk ]] && rm -rf include/FL
    [[ -e submodules/fltk ]] && rm -f lib/libfltk*
    [[ -e submodules/fltk ]] && cd submodules/fltk && make clean
    # [[ -e include/GL ]] && rm -rf include/GL  ## remove GLEW as it does the same job as GLAD
    exit 0
fi



CPUCOUNT=$( cat /proc/cpuinfo | grep "^processor" | tail -n 1 | awk '{print $3}' )
if [ "x$CPUCOUNT" == "x" ]
then
    CPUCOUNT=1
else
    CPUCOUNT=$(( CPUCOUNT + 1 ))
fi
echo "Using ${CPUCOUNT} processors for compilation"

if [ "x${CXX_COMPILER}" == "x" ]
then
    # go with system defaults
    CMAKE_ARGS="" 
else
    CMAKE_ARGS="-DCMAKE_C_COMPILER=$(which $LOCAL_C_COMPILER) -DCMAKE_CXX_COMPILER=$(which ${LOCAL_CXX_COMPILER})"
    echo "cmake arguments: ${CMAKE_ARGS}"
fi



echo "Creating/Updating submodules"
git submodule init
git submodule update

echo "Building Asset Importer library"
cd submodules/assimp
[[ ! -e build ]] && mkdir build
cd build
cmake ${CMAKE_ARGS} -DBUILD_SHARED_LIBS=OFF ..
make -j ${CPUCOUNT}
cp ./lib/libassimp.a ../../../lib/
cd ..
cp -R ./include/assimp ../../include/assimp
cp -R ./build/include/assimp/* ../../include/assimp
cd ../../

echo "Building GLFW library"
cd submodules/glfw
[[ ! -e build ]] && mkdir build
cd build
cmake ${CMAKE_ARGS} ..
make -j ${CPUCOUNT}
cp ./src/libglfw3.a ../../../lib/
cd ..
cp -R ./include/GLFW ../../include/GLFW
cd ../../

echo "Copying over GLM header only library"
cp -R submodules/glm/glm include/glm

echo "Building FLTK library"
cd submodules/fltk
./autogen.sh
./configure
make -j ${CPUCOUNT}
cp ./lib/lib*.a ../../lib/
cp -R ./FL ../../include/FL
cd ../../

# echo "Building GLEW library"
# cd submodules/glew
# cd auto
# make -j ${CPUCOUNT}
# cd ../build
# cmake ./cmake
# cp lib/libGLEW.a ../../../lib
# cd ..
# cp -R ./include/GL ../../include/
# cd ../..

echo "Building our application"
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} ${CMAKE_ARGS} ..
if [ $? == 0 ]
then
    make -j ${CPUCOUNT} VERBOSE=1
    if [ $? == 0 ]
    then   
        make test
        if [ $? == 0 ]
        then
            echo "To run type: ./build/bin/opengltest"
        fi
    fi
fi
