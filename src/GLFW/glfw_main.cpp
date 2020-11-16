/** 
 * This demonstrates a OpenGL program using GLFW
 * 
 * 
 * This was originally from a starterkit by:
 * Copyright (C) 2018 Tomasz Ga�aj
 **/

#include <helpers/RootDir.h>
#if CPP_STARTER_USE_GLFW


#include <iostream>
#include <glad/glad.h>
#include <GLFW/glfw3.h>

#define  GLM_FORCE_RADIANS
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>

#include <fmt/core.h>
#include <docopt/docopt.h>
#include <map>

#include "../rendering/Shader.h"
#include "../rendering/Texture.h"
#include "../rendering/Model.h"

// Note that any instructions starting with a hash (#) are interpreted by the 
// "preprocessor" which is a text replacement program.  Using #if...#else...#endif
// you can turn on and off bits of code for different platforms or different
// end user requirements.

// set this macro define statement to non-zero to activate docopt example code
#define ENABLE_DOCOPT_EXAMPLE 0
// set this macro define statement to non-zero to activate fmt example code
#define ENABLE_FMT_EXAMPLE 0


GLFWwindow* main_window;
const int WINDOW_WIDTH  = 1024;
const int WINDOW_HEIGHT = 768;

// some global variable objects that we need
// to clean up before we end.
Model   * mesh    = nullptr;
Shader  * shader  = nullptr;
Texture * texture = nullptr;

/* Matrices */
glm::vec3 cam_position = glm::vec3(0.0f, 1.0f, 1.2f);
glm::vec3 cam_look_at  = glm::vec3(0.0f, 0.5f, 0.0f);
glm::vec3 cam_up       = glm::vec3(0.0f, 1.0f, 0.0f);

glm::mat4 world_matrix      = glm::mat4(1.0f);
glm::mat4 view_matrix       = glm::lookAt(cam_position, cam_look_at, cam_up);
glm::mat4 projection_matrix = glm::perspectiveFov(glm::radians(60.0f), float(WINDOW_WIDTH), float(WINDOW_HEIGHT), 0.1f, 10.0f);

#if ENABLE_DOCOPT_EXAMPLE
// example docopt usage parameters from https://github.com/docopt/docopt.cpp
static const char USAGE[] =
R"(OpenGlTest.

    Usage:
      opengltest ship new <name>...
      opengltest ship <name> move <x> <y> [--speed=<kn>]
      opengltest ship shoot <x> <y>
      opengltest mine (set|remove) <x> <y> [--moored | --drifting]
      opengltest (-h | --help)
      opengltest --version

    Options:
      -h --help     Show this screen.
      --version     Show version.
      --speed=<kn>  Speed in knots [default: 10].
      --moored      Moored (anchored) mine.
      --drifting    Drifting mine.
)";
#endif


void window_size_callback(GLFWwindow* window, int width, int height)
{
    (void) window; // this stops variable not used warnings
    glViewport(0, 0, width, height);
    projection_matrix = glm::perspectiveFov(glm::radians(60.0f), float(width), float(height), 0.1f, 10.0f);

    if (shader != nullptr)
    {
        shader->setUniformMatrix4fv("viewProj", projection_matrix * view_matrix);
    }
}

int init()
{
    /* Initialize the library */
    if (!glfwInit())
        return -1;

    /* Create a windowed mode window and its OpenGL context */
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    main_window = glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Hello Modern GL!", nullptr, nullptr);

    if (!main_window)
    {
        glfwTerminate();
        return -1;
    }

    /* Make the window's context current */
    glfwMakeContextCurrent(main_window);
    
    glfwSetWindowSizeCallback(main_window, window_size_callback);

    /* Initialize glad */
    if (!gladLoadGLLoader(reinterpret_cast<GLADloadproc>(glfwGetProcAddress)) )
    {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return -1;
    }

    /* Set the viewport */
    glClearColor(0.6784f, 0.8f, 1.0f, 1.0f);
    glViewport(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);

    glEnable(GL_DEPTH_TEST);

    return 1;
}

int loadContent()
{
    mesh = new Model("assets/models/alliance.obj");

    /* Create and apply basic shader */
    shader = new Shader("Basic.vert", "Basic.frag");
    shader->apply();

    shader->setUniformMatrix4fv("world",        world_matrix);
    shader->setUniformMatrix3fv("normalMatrix", glm::inverse(glm::transpose(glm::mat3(world_matrix))));
    shader->setUniformMatrix4fv("viewProj",     projection_matrix * view_matrix);

    shader->setUniform3fv("cam_pos", cam_position);

    texture = new Texture();
    texture->load("assets/models/alliance.png");
    texture->bind();

    return 1;
}

void render(float time)
{
    // bitwise-or (|) : given 0 and a 0 => 0, otherwise 1 for each bit in the byte
    // logical-or (||) : is any bit in byte 1, if so that will be true (e.g. !0)
    // combining the two values 00001000 and 00000001 => 00001001
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    /* Draw our triangle */
    world_matrix = glm::rotate(glm::mat4(1.0f), time * glm::radians(-90.0f), glm::vec3(0, 1, 0));

    shader->setUniformMatrix4fv("world", world_matrix);
    shader->setUniformMatrix3fv("normalMatrix", glm::inverse(glm::transpose(glm::mat3(world_matrix))));

    shader->apply();
    texture->bind();
    mesh->Draw();
}

void update()
{
    float startTime = static_cast<float>(glfwGetTime());
    float newTime  = 0.0f;
    float gameTime = 0.0f;

    /* Loop until the user closes the window */
    while (!glfwWindowShouldClose(main_window))
    {
        /* Update game time value */
        newTime  = static_cast<float>(glfwGetTime());
        gameTime = newTime - startTime;
        if ( gameTime > 5.0f ) break;

        // You can put code about what your program does here
        // before we render the screen again

        /* Render here */
        render(gameTime);

        /* Swap front and back buffers */
        glfwSwapBuffers(main_window);

        /* Poll for and process events */
        glfwPollEvents();
    }
}




// This is the main entry into our OpenGL program
// the arguments to main can be:
//      empty
//      void                    // this will create a linter error "redundant void argument list in function definition"
//      int argc, char* argv[]
//      int argc, char** argv
//      int argc, char* argv[], char* env[] // get environment variables
#if ENABLE_DOCOPT_EXAMPLE
int main(int argc, char* argv[])
#else
int main()
#endif
{
    // first steps:
    //  can you read options in using docopt?
#if ENABLE_DOCOPT_EXAMPLE
    // to activate this piece of code set ENABLE_DOCOPT_EXAMPLE to a value > 0
    std::map<std::string, docopt::value> args = docopt::docopt(USAGE,
                         { argv + 1, argv + argc },
                         true,               // show help if requested
                         "OpenGlTest 2.0");  // version string

    for(auto const& arg : args) {
        std::cout << arg.first <<  arg.second << std::endl;
    }
#endif

#if ENABLE_FMT_EXAMPLE
    //  can you print some message using fmt library?
    fmt::print("Hello student! The answer is obviously {}.", 42); // notice WHEN is this printed? what if you add '\n' to the end of the string?
#endif

    // Next step: can you add a short log message using spdlog which we have
    // already added to our build?  See spdlog for example lines to add (https://github.com/gabime/spdlog).

    // we are going to set up our OpenGL environment first
    if (!init())
        return -1;

    // load our models and textures
    if (!loadContent())
        return -1;

    // update based on user interaction
    update();

    // terminate the application
    glfwTerminate();

    // clean up any objects that we created directly on the stack
    delete mesh;
    delete shader;
    delete texture;

    return 0;
}

#endif // end of #if CPP_STARTER_USE_OPENGL