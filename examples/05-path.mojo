from blend2d.blimage import BLImage, BLFileFormat, BLFormat, BLContext
from blend2d.blgeometry import BLRect
from blend2d.blpath import *
from blend2d.blcolor import BLRgba32   
from blend2d.blerrorcode import BL_SUCCESS
from pathlib import Path


def create_path() -> Optional[BLPath]:
    result = Optional[BLPath](None)
    aaa = BLPath.new()
    if aaa:
        path = aaa.take()
        matrix = BLMatrix2D() # identiy matrix
        dir = BLGeometryDirection.none()
        # here our path is empty
        _ = path.add_triangle( BLTriangle(0.1,0.1, 0.2,0.2, 0.15, 0.05), matrix, dir )
        # our path contains 4 elements
        _ = path.add_circle( BLCircle(0.3,0.3, 0.1), matrix, dir )
        # our path contains 18 elements
        _ = path.add_line( BLLine(0.4,0.2, 0.2, 0.4), matrix, dir )
        # our path contains 20 elements
        _ = path.add_pie( BLArc(0.4,0.2, 0.1, 0.2, 0.0, 0.7), matrix, dir )
        # our path contains 26 elements
        _ = path.add_arc( BLArc(0.4,0.2, 0.1, 0.2, 0.7, 1.0), matrix, dir )
        # our path contains 30 elements
        _ = path.add_round_rect( BLRoundRect(0.2,0.5, 0.15, 0.1, 0.05, 0.05), matrix, dir )
        # our path contains 47 elements
        # you could ask : why 47 elements when we have inserted only 6 objects ?
        # You remeber when I've talk about what a path really contains only
        # line, move_to, cubic and quadratic ?
        # a triangle is 3 lines + 1 move_to
        # a circle is 14 curves
        # a line is 1 move_to + 1 line_to
        # ...
        result = Optional[BLPath](path)
    return result

def build_scene(ctx : BLContext, path1 : BLPath, path2 : BLPath):
    # first test, a small rectangle at the center of the image
    # remember, a BLRect is (x,y, width, height)
    _ = ctx.fill_rectD_rgba32( BLRect(0.49, 0.49, 0.02, 0.02), BLRgba32.rgb(145,145,145))
    # the change of scale impact obviously the stroke size
    _ = ctx.set_stroke_width(0.002)
    # we stroke, it means everything will be drawn
    _ = ctx.stroke_pathD_rgba32( BLPoint(0.0,0.0), path1, BLRgba32.rgb(125,125,125))
    # we only fill, meaning we will draw the things that can be filled (so, no line or elipse)
    _ = ctx.fill_pathD_rgba32( BLPoint(0.45,0.3), path2, BLRgba32.rgb(85,85,125))
    
    # drawing a path is fine but knowing if a point is in a path is better
    # so let's start shooting!
    red = BLRgba32.rgb(255,0,0) # when we hit something
    gray = BLRgba32.rgb(155,155,155) # when we miss

    p = BLPoint(0.276,0.546)
    if path1.hit_test(p):
        _ = ctx.fill_rectD_rgba32( BLRect(p.x-0.005, p.y-0.005, 0.01, 0.01), red)
    else:
        _ = ctx.fill_rectD_rgba32( BLRect(p.x-0.005, p.y-0.005, 0.01, 0.01), gray)
    p = BLPoint(0.273, 0.272)
    if path1.hit_test(p):
        _ = ctx.fill_rectD_rgba32( BLRect(p.x-0.005, p.y-0.005, 0.01, 0.01), red)
    else:
        _ = ctx.fill_rectD_rgba32( BLRect(p.x-0.005, p.y-0.005, 0.01, 0.01), gray)  
    p = BLPoint(0.1, 0.8)
    if path1.hit_test(p):
        _ = ctx.fill_rectD_rgba32( BLRect(p.x-0.005, p.y-0.005, 0.01, 0.01), red)
    else:
        _ = ctx.fill_rectD_rgba32( BLRect(p.x-0.005, p.y-0.005, 0.01, 0.01), gray)  
    
    # great, but if with path2, we'll have a trouble.
    # why ? let's see
    p = BLPoint(0.919,0.456)
    if path2.hit_test(p):
        _ = ctx.fill_rectD_rgba32( BLRect(p.x-0.005, p.y-0.005, 0.01, 0.01), red)
    else:
        _ = ctx.fill_rectD_rgba32( BLRect(p.x-0.005, p.y-0.005, 0.01, 0.01), gray)
    p = BLPoint(0.851, 0.565)
    if path2.hit_test(p):
        _ = ctx.fill_rectD_rgba32( BLRect(p.x-0.005, p.y-0.005, 0.01, 0.01), red)
    else:
        _ = ctx.fill_rectD_rgba32( BLRect(p.x-0.005, p.y-0.005, 0.01, 0.01), gray)   
    # the coordinates used here are screen coordinates. So if we look
    # at the image, we'll see the 2 points with 2 of them right in the path and 
    # none out of the path
    # so, what's wrong ?
    # here, we test if something hit the path, not if something hit the path 
    # where it is drawn.
    # if you look some lines above, you will see that we have drawn the path 
    # starting at 0.45,0.3 when path1 was drawn starting at (0,0)
    # so, to test correctly we should substract (0.45, 0.3) to each point we test
    # or translate path2 himself to (0.45, 0.3), using path2.translate()

def create_context(img : BLImage) -> BLContext:
    aa = img.create_context(2)
    ctx = aa.take() 
    _ = ctx.set_fill_style_colour( BLRgba32.rgb(215,215,215) )
    _ = ctx.fill_all()
    
    _ = ctx.identity()
    # here we go from (0, width)(0,height) to (0, 1)(0,1) 
    _ = ctx.scale( img.get_width_f64(), img.get_height_f64())
    return ctx

def main():
    # back to the paths, with something a little more complex.
    # first we are going work with [0,1] coordinates, meaning we are not
    # tied to a specific resolution.
    # one thing to keep in mind is the aspect ratio of the image
    # if you image is a square, there is not trouble working with [0,1] coordinates
    # but if your image is not a square, let's say 1024x768, its aspect ratio will be 4/3 (1.333)
    # so could decide to use :
    # [0, 1.33] for X and [0, 1] for Y
    # [0,1] for X, and [0, 0.75] for Y
    # [0,1] for both X and Y
    # It's really your choice   
    # 
    # for sake the clarity, let's say that each Optional will never fail 
    tmp = BLImage.new(1024,1024, BLFormat.xrgb32())
    img = tmp.take()
    ctx = create_context(img)
    
    aaa = create_path()
    path1 = aaa.take()
    aaa = path1.clone() # deep copy
    path2 = aaa.take()
    # ok, now we have Path1 and Path2 that contains the same objects
    # Path1 will serve as a reference
    # to downsize Path2 we have two choices
    # first : change the scale of the context when we will drawn the path and don't touch Path2
    # two : scale down Path2 himself and don't touch the context
    # I will go for the second solution because it will help us understand
    # how to deal with paths
    # first we need a matrix do describe the transformation.
    # it will be a simple one, we just want to dowsize the path then translate it
    matrix = BLMatrix2D()
    matrix.scale(0.5,0.5)
    matrix.translate(0.25,0.25)
    # then we need to decide what part of the path will be impacted by the transformation
    # for that, we will use a BLRange. We only want to touch the first two objects, so :
    range = BLRange(0, 18) # the 18 is from create_path()
    # BLPath contains a function named get_size() then return the numbers of elements
    _ = path2.transform(range, matrix)            
    # now I've changed my mind and I don't want to see the last object of my path
    # how to do that ?
    aaa = BLPath.new()
    path3 = aaa.take()
    _ = path3.add_path(path2, BLRange(0,30))

    build_scene(ctx, path1, path3)                                    
    # the usual stuff
    _ = ctx.end()
    file_format = BLFileFormat.qoi()
    filename = file_format.set_extension( Path("05-path-1"))
    _ = img.to_file(filename, file_format)

    # new image with a lower resolution, we keep the same path
    tmp = BLImage.new(512,512, BLFormat.xrgb32())
    img = tmp.take()
    ctx = create_context(img)

    build_scene(ctx, path1, path3)                                    
    # the usual stuff
    _ = ctx.end()

    # until I figure out what's wrong with Mojo's destructor, destruction is manual
    path1.destroy()
    path2.destroy()
    path2.destroy()

    file_format = BLFileFormat.qoi()
    filename = file_format.set_extension( Path("05-path-2"))
    _ = img.to_file(filename, file_format)

    img.destroy()# until I figure out what's wrong with Mojo's destructor, destruction is manual