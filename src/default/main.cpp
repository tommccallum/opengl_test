// Note that will have a red squiggly line, this is expected
// as the actual file is generated during compilation.
#include <helpers/RootDir.h>

// This file can be got rid of once you have decided your framework
// it allows a level of indirection for us to choose how we
// start our program.

#if !CPP_STARTER_USE_OPENGL && !CPP_STARTER_USE_QT && !CPP_STARTER_USE_SDL
#include <iostream>
int main() {
    std::cout << "Basic starter kit startup, no framework has been called." << '\n';
}
#endif