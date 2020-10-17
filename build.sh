#!/bin/bash

# Need to remake everything with clang
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "Working directory: $CURDIR"
cd $CURDIR

if [ "x$1" == "xclean" ]
then
    echo "Cleaning directory"
    [[ -e build ]] && rm -rf build
    [[ -e submodules/assimp/build ]] && rm -rf submodules/assimp/build
    [[ -e submodules/glfw/build ]] && rm -rf submodules/glfw/build
    [[ -e lib/libassimp.a ]] && rm -f /lib/libassimp.a
    [[ -e lib/libglfw3.a ]] && rm -f /lib/libglfw3.a
    [[ -e include/glm ]] && rm -rf include/glm
    [[ -e include/GLFW ]] && rm -rf include/GLFW
    [[ -e include/assimp ]] && rm -rf include/assimp
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

if [ "x$1" == "x" ]
then
    # go with system defaults
    CMAKE_ARGS="" 
else
    # e.g. gcc/g++ or clang/clang++
    if [ "x$1" == "clang" ]
    then
        C_COMPILER="$1"
        CXX_COMPILER="${1}++"
    elif [ "x$1" == "gnu" ]
    then
        C_COMPILER="gcc"
        CXX_COMPILER="g++"
    else
        echo "Invalid argument, expected gnu or clang"
        exit 1
    fi
    CMAKE_ARGS="-DCMAKE_C_COMPILER=$(which $C_COMPILER) -DCMAKE_CXX_COMPILER=$(which ${CXX_COMPILER})"
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

echo "Building our application"
mkdir build
cd build
cmake ${CMAKE_ARGS} ..
if [ $? == 0 ]
then
    make -j ${CPUCOUNT}
    if [ $? == 0 ]
    then   
        make test
        if [ $? == 0 ]
        then
            echo "To run type: ./build/bin/opengltest"
        fi
    fi
fi
