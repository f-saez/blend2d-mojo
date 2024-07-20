
from blend2d.blimage import BLImage,  BLFileFormat, BLFormat
from blend2d.blmipmap import BLMipmap
from blend2d.blgeometry import BLRectI, BLRect, BLPoint
from blend2d.blcolor import BLRgba32  
from blend2d.blpath import BLPath 
from blend2d.blerrorcode import BL_SUCCESS
from pathlib import Path


def main():
    tmp = BLImage.new(1024,1024, BLFormat.prgb32())
    img = tmp.take()
    aa = img.create_context(2)
    ctx = aa.take()
    _ = ctx.set_fill_style_colour( BLRgba32.rgb(215,215,215) )
    _ = ctx.fill_all()
                
    # first thing, clipping.
    # let's imagine you a drawing a path and you zoom-in/zoom-out
    # you want your path do be drawn in an area and you don't want 
    # it to be drawn outside this area.
    # how could you do that ?
    # the first that may come to mind is : I create an image with 
    # the same size as my area, I drawn the path on this image and I "blit"
    # the image on the erea each time.
    # it will work but it will cost you the blitting each time you draw your path.
    # Blend2D is fast but, still, avoiding any unecessary operation is always a 
    # better way to go.
    # the other thing that may come to mind is : let's define a clipping area the 
    # same position and size as the area we want to drawn our path in. This way
    # we could at the same time mindlessly draw what we want and avoir the cost 
    # of blitting another image.
    # clipping means avoiding drawing outside the clipping rectangle. It is 
    # slower than no clipping at all, but  cheaper than a full blitting.
    #
    # in Blend2D, clipping is defined by a simple rectangle and nothing more.
    # 
    # Skia allow you to use a polygon for clipping but it's way harder to implement
    # and not that often used.

    # so, how do we do that ?
    # we are going to use 2 examples : one for a Path and one for an image

    # first let's create a Path
    ab = BLPath.new()
    path = ab.take()
    _ = path.move_to(26, 31)
    _ = path.cubic_to(642, 132, 587, -136, 25, 464)
    _ = path.cubic_to(882, 404, 144, 267, 27, 31)

    _ = ctx.set_stroke_width( 2.5 )
    # no clipping, we will draw our path with an half-transparent colour
    # we could also have used set_global_alpha and fully opaque colours
    _ = ctx.fill_pathD_rgba32(BLPoint(50,50), path, BLRgba32.rgba(145,145,165,100))
    _ = ctx.stroke_pathD_rgba32(BLPoint(50,50), path, BLRgba32.rgba(105,105,115,100))
    
    # we setup the clipping area
    clipping = BLRectI(90,130,360,360)
    # just to see the clipping rectangle
    _ = ctx.set_stroke_style_colour(BLRgba32.rgb(185,105,105))
    _ = ctx.set_stroke_rectI(clipping)
    _ = ctx.clip_to_rectI( clipping)
    # and we draw again with an opaque colour
    _ = ctx.fill_pathD_rgba32(BLPoint(50,50), path, BLRgba32.rgb(145,145,165))
    _ = ctx.stroke_pathD_rgba32(BLPoint(50,50), path, BLRgba32.rgb(105,105,115))
    # what do we see ?
    # the clipping rectangle define exactly the limits, meaning 90,130 is in the drawing area
    # that's why the red rectangle is overdrawn by our path in some cases.
    path.destroy() # until I solve something with Mojo's destructor, destruction is manual

    # let's get rid of the current clipping
    _ = ctx.restore_clipping()

    # let's do the same thing with an image
    filename = Path("..").joinpath("examples").joinpath("Octopus.qoi")
    a = BLMipmap.from_file(filename, 4)
    octopus = a.take()  
    rect = BLRectI(50,550,500,0)
    # up to now, we have always use full opacity for every image we have to use.
    # sure, the image may have some transparency but every pixel of the image that 
    # was not transparent was drawn "as-is"
    # here, we change that by definign a global transparency meaning a fully opaque 
    # pixel in our image will be drawn with a 20% opacity
    _ = ctx.set_global_alpha(0.2)
    _ = octopus.blit_scale_imageI(ctx, rect)
    # back to normal
    _ = ctx.set_global_alpha(1)

    clipping = BLRectI(100,580,360,270)
    _ = ctx.set_stroke_rectI(clipping)
    _ = ctx.clip_to_rectI( clipping)
    _ = octopus.blit_scale_imageI(ctx, rect)
    octopus.destroy()

    # you could do the same thing for text, if you please.

    _ = ctx.end()               
 
    file_format = BLFileFormat.qoi()
    filename = file_format.set_extension( Path("12-clipping"))
    _ = img.to_file(filename, file_format)
        
    img.destroy()


