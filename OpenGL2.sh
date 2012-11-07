#!/bin/bash

if [ ! -d OpenGL2 ]; then
	svn co https://cvs.khronos.org/svn/repos/ogl/trunk/ecosystem/public/sdk/docs/man2 OpenGL2
fi
# needed for CSS
if [ ! -d OpenGL4 ]; then
	svn co https://cvs.khronos.org/svn/repos/ogl/trunk/ecosystem/public/sdk/docs/man4 OpenGL4
fi

output=OpenGL2.docset
src=OpenGL2
# we take base CSS from OpenGL4 documentation
css=OpenGL4
id=gl2
title="OpenGL 2.1"
icon=OpenGL2.png

source OpenGLx.sh
