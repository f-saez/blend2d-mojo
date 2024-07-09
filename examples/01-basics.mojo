
from blend2d.blimage import BLImage, BLRect, BLFileFormat, BLFormat
from blend2d.blcommon import BLRectI
from blend2d.blcolor import BLRgba32   
from blend2d.blerrorcode import BL_SUCCESS
from pathlib import Path


def main():
    # we're gonna start simple. 
    # first we create an 1024x768 image. 
    # we have the choice between :
    # xrgb32 => 32-bit (X)RGB pixel format (8-bit components, alpha ignored). 
    # prgb32 => 32-bit premultiplied ARGB pixel format (8-bit components).
    # a8 => 8-bit alpha-only pixel format. It's not for drawing image but for building masks
    # in the end, we have a choice between having an alpha channel or not.
    # we will use pixels coordinate, so we're going to live in a space where X is between 0 and 1024 
    # and y between 0 and 768
    # later, we will see how to be resolution independant and always be between 0 and 1
    var tmp = BLImage.new(1024,768, BLFormat.xrgb32())
    # tmp is an Optional because the function can fail (memory error, unable to connect to the library ...)
    if tmp:
        var img = tmp.take()
        # ok, we got our image. Now we need to draw something on it and for that
        # we need a context because all the drawing operations go through a context.
        # let's create a context
        # blend2d is multi-threaded and when we create the context we could specify the number of threads.
        # more is not always better,it depends if the workload is heavy or not.
        # let's say we want 2 threads.
        var aa = img.create_context(2)
        # again an Optional, so ...
        if aa:
            var ctx = aa.take()
            # we have an image and it's fill with ... we don't know what, so probably random junk.
            # let's start clean and fill it with something
            # first we define the filling color. 
            # Remember, we haven't choose to have an alpha channel so no need to use RGBA
            # here we define the default filling color
            var r = ctx.set_fill_style_colour( BLRgba32.rgb(215,215,215) )
            # each function return an error code or BL_SUCCESS
            # I will check it this time but for clarity sake, let's say it will alway be a success
            if r==BL_SUCCESS:
                _ = ctx.fill_all()
                # ook, we have a blank image, now we need to draw something. Let's say a rectangle.
                # BLRectI(150,150,320,240) => I stands for integer (more on that later)
                # 150,150 is the pixel top-left, 320 the width, 240 the height
                # so our rectangle will start at pixel 150,150 and end at pixel 150+320, 150+240
                var rectI = BLRectI(150,150,320,240)
                # we define the filling color so we don't use the default one
                _ = ctx.fill_rect_rgba32(rectI, BLRgba32.rgb(55,55,55) )

                # ok, done. What about something more exotic like a rotation ?
                # first thing, we need to save our context so we can restore it later
                # iit's a very cheap operation so we can abuse it :-)
                _ = ctx.save()
                # the matrix is probably the identity one by default, but for clarity sake
                # let's define it
                _ = ctx.identity()
                # now the rotation. we want to rotate around the center of the rectangle
                # so we are going to rotate around a point and this point is the center of our previous rectangle
                # the rotation function use floating values, not integer one's.
                # remember the I in BLRectI, meaning Integer ?
                # BLRect is like a BLRectI but with floating values
                var rect = BLRect(250,250,380,290)
                # 0.1 => 0.1 radians
                # rect.x+rect.w/2,rect.y+rect.h/2 => the center of our rect
                _ = ctx.rotate_pt(0.1, rect.x+rect.w/2, rect.y+rect.h/2)
                # ok, the matrix is configured, let's draw something
                # last time, we have filled a rectangle, now we're gonna stroke it.
                # rect is a "float" rectangle, so we're have to use stroke_rectd_rgba32
                # emphasis on the D after rect.
                # let's define the width of our stroke
                _ = ctx.set_stroke_width(2.5)
                _ = ctx.stroke_rectd_rgba32(rect, BLRgba32.rgb(165,55,55) )
                # done, we can restore our context to it's previous state
                # only if we have something else to do with it
                _ = ctx.restore()
                # we have finish, no need to keep the context.
                # this point is important, we cannot forget to end the context
                # think of this as : I've give you a bunch of command, execute them.
                _ = ctx.end()

                # as we don't draw on a windows (again, more on that later)
                # we need to save our work to see it.
                # we have three choices : JPEG, PNG and QOI. 
                # Think as QOI as a modern take on PNG but way faster. (https://qoiformat.org/)
                var file_format = BLFileFormat.qoi()
                var filename = file_format.set_extension( Path("01-basics"))
                _ = img.to_file(filename, file_format)


