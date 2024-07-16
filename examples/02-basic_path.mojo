from blend2d.blimage import BLImage, BLFileFormat, BLFormat
from blend2d.blgeometry import BLRect
from blend2d.blpath import BLPath, BLPoint, BLStrokeCap
from blend2d.blcolor import BLRgba32   
from blend2d.blerrorcode import BL_SUCCESS
from pathlib import Path


def main():
    # we had fun (I hope) with rectangles, 
    # but we can draw something more complex.
    # I will focus only on the Path part
    var tmp = BLImage.new(1024,1024, BLFormat.xrgb32())
    if tmp:
        var img = tmp.take()
        var aa = img.create_context(2)
        if aa:
            var ctx = aa.take() 
            _ = ctx.set_fill_style_colour( BLRgba32.rgb(215,215,215) )
            _ = ctx.fill_all()
            # let's start by creating a empty path
            var ab = BLPath.new()
            # agin, an Optional, so ...
            if ab:
                var path = ab.take()
                # lovely. Now, what can we do with that ?
                # a Path is a collection of drawing primitives
                # move_to => move to a point without drawing anything
                # line_to => draw a line between the current postion and the new position
                # cubic_to => https://en.wikipedia.org/wiki/Cubic_plane_curve
                # quad_to =>  https://en.wikipedia.org/wiki/Quadratic_function
                # there are many others thing a Path can describes but we'll see that later.
                # it may seem a little bit intimidating at first but that's how the way any font is built
                # a path can be a comlicated line or a complicated form when it is closed, meaning the 
                # last point is connected to the first
                # let's start simple

                _ = path.move_to(26, 31) # first point will be 26,31
                _ = path.line_to(52,60)
                _ = path.line_to(82,82)
                _ = path.line_to(32,82)
                _ = path.line_to(-20,42)
                _ = path.close()
                # we have describe a shaped, and you may ask yourself : why -20 ?
                # our path is in relative coordinates and when we will draw it, we will say
                # draw this path at pixel x,y
                # so in our case, we will draw something at x-20

                # remember fill and stroke from 01-basics ?
                _ = ctx.set_stroke_width( 2.5 )
                # our path describe a shape and we want to draw it starting at pixel 45,53
                # if you remember -20, it means we will draw something at pixel (45-20).
                _ = ctx.fill_pathD_rgba32( BLPoint.new(45,53), path, BLRgba32.rgb(125,65,215) )
                _ = ctx.stroke_pathD_rgba32( BLPoint.new(45,53), path, BLRgba32.rgb(165,65,125) )

                # ok, done. let's draw something else.
                # why keep our object, we just clear it
                _ = path.clear()
                # if our path if not clsed, it means that it has two "caps"
                # meaning how is drawn the begening of our shape and how if drawn the end of our shape.
                # think of an arrow : a triangle at the start, feathers at the end
                # let's see what we can do
                _ = path.move_to(119, 49)
                _ = path.cubic_to(259, 29, 99, 279, 275, 267)
                _ = path.cubic_to(537, 245, 300, -170, 274, 430)
                # BLStrokeCap define the shape of a cap andwe have the following choices :
                # butt : the default value
                # square : a square
                # round : a round
                # round_rev : a reversed round
                # triangle : a triangle
                # triangle_rev : a reversed triangle
                # what reversed means ? triangle means the pointy end of the triangle point outside the shape
                # reversed mean it point inside the shape.
                # let's see that in practise :
                _ = ctx.set_stroke_start_cap(BLStrokeCap.triangle())    
                _ = ctx.set_stroke_end_cap(BLStrokeCap.triangle_rev())    
                _ = ctx.set_stroke_width(25.0) # large enough to see somehting
                _ = ctx.stroke_pathD_rgba32(BLPoint.new(380,22), path, BLRgba32.rgb(115,125,145))
                
                # we will draw the same shape at a different place with different caps
                _ = ctx.set_stroke_start_cap(BLStrokeCap.round())    
                _ = ctx.set_stroke_end_cap(BLStrokeCap.butt())    
                _ = ctx.set_stroke_width(25.0) # large enough to see somehting
                _ = ctx.stroke_pathD_rgba32(BLPoint.new(380,422), path, BLRgba32.rgb(155,125,185))
                
                # a last one
                _ = path.clear()
                _ = path.move_to(26, 31)
                _ = path.cubic_to(642, 132, 587, -136, 25, 464)
                _ = path.cubic_to(882, 404, 144, 267, 27, 31)
                var p = BLPoint.new(15,213)
                # obviously, we could also use a rotation
                # I don't save the context because it is the last operation
                _ = ctx.identity()
                _ = ctx.rotate_pt(0.2, 277,444)
                _ = ctx.fill_pathD_rgba32(p, path, BLRgba32.rgb(215,0,0))        
                _ = ctx.set_stroke_width(3.0)    
                _ = ctx.stroke_pathD_rgba32(p, path, BLRgba32.rgb(15,15,15))
                
                # the usual stuff
                _ = ctx.end()
                
                _ = path.destroy() # until I solve something with Mojo's destructor, destruction is manual

                var file_format = BLFileFormat.qoi()
                var filename = file_format.set_extension( Path("02-basic_path"))
                _ = img.to_file(filename, file_format)
        
        img.destroy() # until I solve something with Mojo's destructor, destruction is manual



