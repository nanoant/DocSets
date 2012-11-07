#!/bin/bash

if [ ! -d OpenGL2 ]; then
	svn co https://cvs.khronos.org/svn/repos/ogl/trunk/ecosystem/public/sdk/docs/man4 OpenGL4
fi

output=OpenGL4.docset
src=OpenGL4
css=OpenGL4
id=gl4
title="OpenGL 4"
icon=OpenGL4.png

source OpenGLx.sh
