# Basic OpenGL starter kit

This is not finished yet but it is intended to be a starter kit for students looking to use OpenGL on projects for University of Highlands and Islands.

<!-- [![codecov](https://codecov.io/gh/tommccallum/calc/branch/master/graph/badge.svg?token=QKAZL10PE6)](https://codecov.io/gh/tommccallum/calc) -->

[![Build Status](https://travis-ci.org/github/tommccallum/opengl_test.svg?branch=master)](https://travis-ci.org/tommccallum/opengl_test)


## Getting started

Notes

* the dnf commands are for Fedora 32 and other commands may be required for other distributions.
* I am using the static libraries rather than dynamic libraries
* For Ubuntu dependencies you can copy and paste from the Dockerfile

```
sudo dnf -y install mesa-libGL-devel mesa-libGLU-devel zlib-devel
sudo dnf -y install libXrandr-devel libXinerama-devel libXcursor-devel libXi-devel
sudo dnf -y install zlib-devel irrXML-devel

git clone https://github.com/tommccallum/opengl_test
./build.sh
cd build
./opengl_test
```

## Docker

It is a straight forward build process for the docker instance.

Currently it crashes when run in the docker environment currently, still investigating.

```
docker build .
docker run -ti <CHECKSUM> /bin/bash
```

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

## References

* [How to setup OpenGL project with CMake by Tomasz Gałaj, posted May 29 2018](https://shot511.github.io/2018-05-29-how-to-setup-opengl-project-with-cmake/)