# blend2D-mojo

Blend2D bindings for Mojo. It's a work in progress.
I'll try to follow the spirit of the C++ version as much as possible.


## what is if Blend2D ?

https://blend2d.com/

https://github.com/blend2d/blend2d

## why Blend2D ?
It is small, easy to use and it's API is stable.

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
For now, there is only 3 objects :

- BLFont to draw text/glyphs

- BLPath to draw paths

- BLImage to manage bitmaps.

Only three file formats to load and save : JPEG, PNG, QOI

If you haven't heard of QOI : https://qoiformat.org/

There are more things to come obviously (Geometry, textures,, clipping, mask, ...) :-)

## How am I suppose to use this ?

Execute the file run_examples.sh and look at the files in examples.
These are basic examples, with some comments on how it works. 
It should gives you a rough idea on how things works.
I will add a tutorial for each new feature, don't worry.