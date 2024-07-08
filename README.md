# blend2D-mojo
Blend2D bindings for Mojo. It's a work in progress.
I'll try to follow the spirit of the C++ version as much as possible.


For more info on Blend2D : 

https://blend2d.com/

https://github.com/blend2d/blend2d


To use this, you will need to build Blend2D by yourself.

Don't worry, it's easy :
https://blend2d.com/doc/build-instructions.html

You'll just have to put the .so file either in your library path, or in your application's directory.
In the future, I will use static linking to ease deployment.


For now, there is only 3 objects :

- BLFont to draw text/glyphs

- BLPath to draw paths

- BLImage to manage bitmaps.

Only three file format : JPEG, PNG, QOI

In each of these file, you will find a static method named validation.
It's a function that run some tests to check everything's okay and it describes how it works, how to use it.

to run all the tests for all the objects, simple execute :
```
mojo blvalidation.mojo
```