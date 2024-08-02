# Blend2D-mojo

Blend2D bindings for Mojo. It's a work in progress.
I'll try to follow the spirit of the C++ version as much as possible.

Blend2D is production-ready, but not these bindings.

## what is Blend2D ?

https://blend2d.com/

https://github.com/blend2d/blend2d

## why Blend2D ?
It is small, easy to use and it's API is stable, so ti is easy to maintain.

Qt is far more than a 2D library.

Skia is complex to build and its API change frequently.

Bonus : it is fast.
https://blend2d.com/performance.html

## how to install it ?
To use this, you will need to build Blend2D by yourself.

Don't worry, it's easy :
https://blend2d.com/doc/build-instructions.html

You'll just have to put the .so file in your library path, or in your application's directory.

In the future, I will use static linking to ease deployment.

## What can we do with that ?

- draw text/glyphs

- draw paths

- draw bitmaps/images and resize them
  
- draw linear gradients (Conic and radial later)

- fill an image using another image as a pattern/texture

- managing mipmaps

- and the basic stuff : draw lines, circles, rectangles, compositing (Porter & Duff operators), transparency, 

- grayscale conversion

Only three file formats for loading images : JPEG, PNG, QOI
and two file formats for saving :  PNG, QOI

If you haven't heard of QOI : https://qoiformat.org/

There are more things to come to the bindings (clipping, mask, ...)

## How am I suppose to use this ?

Execute the file run_examples.sh and look at the files in examples.
These are basic examples, with comments on how it works and how to use it.
It should gives you a rough idea on how things works.

There are 14 tutorials than show the basic usage of Blend2D and they could apply to any other 2D library

note : I've run into some troubles with  some destructors called at the wrong time. I think it is related to some @value decorator on some struct 
but haven't been able to pin precisely where. Probably a __copyinit__/__moveinit__ that happens when I don't want to and that I'm not aware of.
For now, the memory management of Blend3D object is manual, until I found time to solve this properly.
