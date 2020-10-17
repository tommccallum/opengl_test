#ifndef TEXTURE_H
#define TEXTURE_H
/** 
 * Copyright (C) 2018 Tomasz Gałaj
 **/


#include <string>
#include <glad/glad.h>

class Texture
{
public:
    Texture();
    ~Texture();

    bool load(const std::string & file_name);
    
    void bind(unsigned int index = 0) const
    {
        if(to_id != 0)
        {
            glActiveTexture(GL_TEXTURE0 + index);
            glBindTexture(GL_TEXTURE_2D, to_id);
        }
    }

    bool use_linear;

private:
    GLuint to_id;
};

#endif /* TEXTURE_H */
