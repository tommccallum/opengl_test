# Basic OpenGL starter kit

This is not finished yet but it is intended to be a starter kit for students looking to use OpenGL on projects for University of Highlands and Islands.

<!-- [![codecov](https://codecov.io/gh/tommccallum/calc/branch/master/graph/badge.svg?token=QKAZL10PE6)](https://codecov.io/gh/tommccallum/calc) -->

[![Build Status](https://travis-ci.org/tommccallum/opengl_test.svg?branch=master)](https://travis-ci.org/tommccallum/opengl_test)


## Cloning this project

To get the most out of this starterkit you will want to create a new repo and modify the files.  Here are some basic instructions on how to do that:

### GitHub

If you have a Github account you can just use the Fork functionality. You can find more detailed instructions here:

https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github/fork-a-repo

In the top right hand corner you will see the Fork button.  If you have a GitHub account it will copy the repository to your account.

### Bitbucket

If you have a BitBucket account then you need to create a new project:

* Go to your workspace (list of repositories)
* Click on Create repository
* Click on Import repository in top right.
* Type in url 'https://github.com/tommccallum/opengl_test'
* Give it a project name
* Import repository
* Then once that is done clone the new repo as normal.
 
## Getting started

* the dnf commands are for Fedora 32 and other commands may be required for other distributions.
* I am using the static libraries rather than dynamic libraries
* For Ubuntu dependencies you can copy and paste from the Dockerfile

```
# required for all
sudo dnf -y install cppcheck
sudo dnf -y install ccache
# required for OpenGL
sudo dnf -y install mesa-libGL-devel mesa-libGLU-devel zlib-devel
sudo dnf -y install libXrandr-devel libXinerama-devel libXcursor-devel libXi-devel
sudo dnf -y install zlib-devel irrXML-devel
# required for DOxygen support
sudo dnf -y install doxygen graphviz
# required for QT5
sudo dnf -y install qt5-devel
# required for SDL framework
sudo dnf -y install libtool libfontenc-devel libXaw-devel libXcomposite-devel libXdmcp-devel libXtst-devel
sudo dnf -y install xorg-x11-xkb-utils-devel libXres-devel libXScrnSaver-devel libXvMC-devel xorg-x11-xtrans-devel
sudo dnf -y install xcb-util-wm-devel xcb-util-image-devel xcb-util-keysyms-devel xcb-util-renderutil-devel
sudo dnf -y install libXdamage-devel libXxf86vm-devel xkeyboard-config-devel libcap-devel
pip3 install --user mako
# gtkmm
sudo dnf install gtkmm30-devel gtk3-devel gstreamer1-devel clutter-devel webkit2gtk3-devel libgda-devel gobject-introspection-devel

# install conan
pip3 install --user conan
conan profile update settings.compiler.libcxx=libstdc++11 default

git clone https://github.com/tommccallum/opengl_test
./build.sh
./build/bin/opengl_test
```

## Frameworks

So this starterkit has multiple entry points depending on the frameworks you want to use. You can turn framework on and off in the top level CMakeLists.txt file.

```
option(CPP_STARTER_USE_DEFAULT "Enable default compilation" ON)
option(CPP_STARTER_USE_GLFW "Enable compilation of GLFW sample" OFF)
option(CPP_STARTER_USE_QT "Enable compilation of QT sample" OFF)
option(CPP_STARTER_USE_FLTK "Enable compilation of FLTK sample" OFF)
option(CPP_STARTER_USE_GTKMM "Enable compilation of GTKMM sample" OFF)
option(CPP_STARTER_USE_IMGUI "Enable compilation of ImGui sample" OFF)
option(CPP_STARTER_USE_NANA "Enable compilation of Nana GUI sample" OFF)
```

TIP: Run "./build.sh clean" before changing frameworks.

## Docker

It is a straight forward build process for the docker instance.

Currently it crashes when run in the docker environment currently, still investigating.

```
docker build -t opengltest .
docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY --privileged opengltest /bin/bash
```

To test the ability to show OpenGL within docker run ```glmark2```.

## Dependencies

* [The Open-Asset-Importer-Lib](https://www.assimp.org/)
* [GLAD is Multi-Language GL/GLES/EGL/GLX/WGL Loader-Generator based on the official specs.](https://glad.dav1d.de/)
* [GLM is OpenGL Mathematics](https://glm.g-truc.net/0.9.9/index.html)
* [STB is the Sean T Barrett C Library](https://github.com/nothings/stb)
* [GLFW is a multiplatform library for OpenGL and Vulkan](https://www.glfw.org/)
* [libXrandr-devel is required by GLFW used for X resize and rotate library](https://www.x.org/wiki/libraries/libxrandr/)
* [libxinerama]()
* [libXcursor-devel are the XCursor headers]()
* [libxi-devel are the XInput headers]()
* [GLEW](https://github.com/nigels-com/glew)

For OpenGL you need the following libraries:
```
sudo dnf -y install mesa-libGL-devel mesa-libGLU-devel
```

Assimp static libraries are:
```
./code/libassimp.a
```

Dependencies that need to be installed to get GLFW to compile:
```
sudo dnf -y install libXrandr-devel libxinerama-devel libXinerama-devel libXinerama-devel libXcursor-devel libXi-devel
```

## Digging in

* You can find out what commands are running in the build, by going to the build directory and running the following:

```
make VERBOSE=1
```

For debug mode you can specify the following argument to cmake when in the build directory:

```
cmake -DCMAKE_BUILD_TYPE=Debug ..
```

or type the following for build.sh:

```
./build.sh --debug
```

## Debug with gdb

```
gdb ./build/bin/opengltest
```

To set up with VS Code, setup a build task which calls build.sh and then a launch.json that points to the opengltest executable.


## Profiling

### Using GProf

In the CMakeFile.txt in the main application directory run on the option:

```
option(ENABLE_GPROF "Enable profiling using GPROF" ON)
```

Then you can build and run the following:

```
gprof ./build/bin/opengltest > run.stats
```


## References

* [How to setup OpenGL project with CMake by Tomasz Gałaj, posted May 29 2018](https://shot511.github.io/2018-05-29-how-to-setup-opengl-project-with-cmake/)
* [C++ Starter Project by Jason Turner aka Lefticus](https://github.com/lefticus/cpp_starter_project)
* [gprof Quick-Start Guide](http://web.eecs.umich.edu/~sugih/pointers/gprof_quick.html)
* [Adding profiling flags to CMake to use gprof](https://riptutorial.com/cmake/example/26665/adding-profiling-flags-to-cmake-to-use-gprof)