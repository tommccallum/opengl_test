# opengl_test

## Getting starts

Notes

* the dnf commands are for Fedora 32 and other commands may be required for other distributions.
* 8 is the number of CPUs, if you have more/less then modify this number

```
sudo dnf -y install mesa-libGL-devel mesa-libGLU-devel zlib-devel
sudo dnf -y install libXrandr-devel libxinerama-devel libXinerama-devel libXinerama-devel libXcursor-devel libXi-devel

git clone https://github.com/tommccallum/opengl_test
git submodule init
git submodule update

cd submodules/assimp
mkdir build
cmake -DBUILD_SHARED_LIBS=OFF ..
make -j 8
cp ./lib/libassimp.a ../../../lib/

cd submodules/glfw
mkdir build
cmake ..
make -j 8
cp ./src/libglfw3.a ../../../lib/

cd ../../../
mkdir build
cd build
cmake ..
make
./opengl_test
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
./contrib/irrXML/libIrrXML.a
```

Dependencies that need to be installed to get GLFW to compile:
```
sudo dnf -y install libXrandr-devel libxinerama-devel libXinerama-devel libXinerama-devel libXcursor-devel libXi-devel
```

## References

* [How to setup OpenGL project with CMake, posted May 29 2018](https://shot511.github.io/2018-05-29-how-to-setup-opengl-project-with-cmake/)