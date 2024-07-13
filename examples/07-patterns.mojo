from blend2d.blimage import BLImage,  BLFileFormat, BLFormat
from blend2d.blcontext import BLCompOp
from blend2d.blcommon import BLExtendMode
from blend2d.blgeometry import BLRectI, BLRect
from blend2d.blmatrix2d import BLMatrix2D
from blend2d.blpattern import BLPattern
from blend2d.blcolor import BLRgba32 , BLGradient, BLGradientStop, BLLinearGradientValues
from blend2d.blerrorcode import BL_SUCCESS, error_code
from pathlib import Path


# to keep the code readable, I will make the assumtion that any Optional if correct.
def main():
    tmp = BLImage.new(1024,1024, BLFormat.prgb32()) # alpha channel required
    img = tmp.take()
    aa = img.create_context(2)
    ctx = aa.take()   

    _ = ctx.set_fill_style_colour( BLRgba32.rgb(65,65,65) )
    _ = ctx.fill_all()
    _ = ctx.set_pattern_quality_bilinear() # best quality for rendering the pattern
    
    # here, we load the image we'll use as a pattern.
    # this image contains transparency data
    filename = Path("..").joinpath("examples").joinpath("Fish.qoi")
    file_format = BLFileFormat.qoi()
    a = BLImage.from_file(filename)
    img_fish = a.take()    

    # we define the part of the image that will be used as a pattern
    # here, it's the whole image, but it could a smaller part.
    # (0,0,150,img_fish.get_height()) would have given us a pattern with 
    # only the head of the fish
    area = BLRectI(0,0,img_fish.get_width(), img_fish.get_height())
    # BLExtend defin what to do with the pattern when it is smaller
    # than the area it needs to fill. Here, we repeated it.
    b = BLPattern.new(img_fish,area, BLExtendMode.repeat())
    pattern = b.take()    
    # ok, we've got a pattern. Let's use it as a filling style
    _ = ctx.set_fill_style_pattern(pattern)
    # now, we fill our rectangle with our pattern
    _ = ctx.fill_rect( BLRectI(50,100, 400, 350))
    # what do we see ? the point(0,0) of our pattern seems to start at the point(0,0)
    # of our image. Ok, let's change that.
    _ = pattern.translate(50,500)
    # mandatory. The pattern has changed, we need to pass the "new"
    # pattern to the context  
    _ = ctx.set_fill_style_pattern(pattern)
    _ = ctx.fill_rect( BLRectI(50,500, 400, 350))
    # that's better, no ?

    # need a smaller fish ?
    # let's reset the matrix
    _ = pattern.identity()
    # first, a translation on our next position
    _ = pattern.translate(500,100)
    _ = pattern.scale(0.35, 0.35)
    _ = ctx.set_fill_style_pattern(pattern)
    _ = ctx.fill_rect( BLRectI(500,100, 400, 350))

    # last one, let's add a rotation
    _ = pattern.identity()
    _ = pattern.translate(500,500)
    # let's rotate our fish a little bit. I want it to rotate
    # around the center of itself, so 
    _ = pattern.rotate_point(-0.88, img_fish.get_width_f64()/2, img_fish.get_height_f64()/2)
    _ = pattern.scale(0.65, 0.65)
    _ = ctx.set_fill_style_pattern(pattern)
    _ = ctx.fill_rect( BLRectI(500,500, 400, 350))

    _ = ctx.end()
    _ = img_fish

    file_format = BLFileFormat.qoi()
    filename = file_format.set_extension( Path("07-patterns"))
    _ = img.to_file(filename, file_format)    
