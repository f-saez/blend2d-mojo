from blend2d.blimage import BLImage,  BLFileFormat, BLFormat
from blend2d.blcontext import BLCompOp
from blend2d.blcommon import BLExtendMode
from blend2d.blgeometry import BLRectI, BLRect
from blend2d.blmatrix2d import BLMatrix2D
from blend2d.blcolor import BLRgba32, BLRgba64, BLGradient, BLGradientStop, BLLinearGradientValues
from blend2d.blerrorcode import BL_SUCCESS, error_code
from pathlib import Path


# to keep the code readable, I will make the assumtion that any Optional if correct.
# there are 3 types of gradient : linear, radial and conic.
# I will only show linear this time. The others two will come later.
def main():
    tmp = BLImage.new(1024,1024, BLFormat.xrgb32())
    img = tmp.take()
    aa = img.create_context(2)
    ctx = aa.take()   

    # first thing to keep in mind when we define our values
    # they coordinates used are the same as the screen, meaning 
    # we define a linear gradient that starts at (0,0) and end at (0,768)
    # so purely vertical.
    # a purely horizontal would have been BLLinearGradientValues(0,0,img.get_width_f64(),0)
    # and an oblique : BLLinearGradientValues(0,0,img.get_width_f64(),img.get_height_f64())
    values = BLLinearGradientValues(0,0,0,img.get_height_f64())
    # the first "stop" - but it's really a start - is pure white.
    # the offset define the position of the color defined. 
    # 0,0 means the start
    stop = BLGradientStop.new(0.0, 255,255,255,255) # we start with the white color
    # the ExtendMode define how to manage the colours before and after the gradient
    # in our case, we use the full screen so it doesn't matter
    mode = BLExtendMode.pad()
    # we could use a matrix to scale or translate our gradient.
    matrix = BLMatrix2D()
    ab = BLGradient.new_linear(values, mode, stop, matrix)
    linear = ab.take()
    # a gradient with only one color isn't really a gradient
    # so let's add some colours.
    # offset= 1.0 means it is the last colour
    _ = linear.add_stop_rgba64(1.0, BLRgba64.rgb(0,0,0)) # we end with black 
    # I want a third colour at 0,5, in the middle of our gradient
    # I could add it now. The only thing that matters is the value of the offset
    _ = linear.add_stop(0.5, BLRgba32.rgb(127,127,190))
    #  we define the filling style with our gradient
    _ = ctx.set_fill_style_gradient(linear)
    _ = ctx.fill_all()
    linear.destroy() # until I figure out what's wrong with Mojo's destructor, destruction is manual
    
    # let's try something else
    # a small gradient the size of our rectangle
    rect = BLRectI(50,50, 400, 350)
    # this time it will be oblique. for it to be horizontal,
    # we should have used BLLinearGradientValues(100,100,550,100)
    # or vertical BLLinearGradientValues(100,100,100,450)
    values = BLLinearGradientValues.from_rectI(rect)
    ab = BLGradient.new_linear(values, mode, stop, matrix)
    linear = ab.take()
    _ = linear.add_stop(1.0, BLRgba32.rgb(125,180,230))
    _ = linear.add_stop(0.25, BLRgba32.rgb(250,80,130))
    _ = linear.add_stop(0.75, BLRgba32.rgb(125,200,130))
    _ = ctx.set_fill_style_gradient(linear)
    _ = ctx.fill_rectI(rect )
    linear.destroy() # until I figure out what's wrong with Mojo's destructor, destruction is manual

    # let's try padding
    # instead of having our gradient begening and ending with our rectangle
    # let downsize it a little bit to see what happens after and before
    rect = BLRectI(50,500, 400, 350)
    values = BLLinearGradientValues.from_rectI(rect)
    values.x0 += 100
    values.y0 += 100
    values.x1 -= 100
    values.y1 -= 100
    mode = BLExtendMode.reflect()
    ab = BLGradient.new_linear(values, mode, stop, matrix)
    linear = ab.take()
    _ = linear.add_stop(1.0, BLRgba32.rgb(75,75,210))
    _ = ctx.set_fill_style_gradient(linear)
    _ = ctx.fill_rectI(rect )
    linear.destroy() # until I figure out what's wrong with Mojo's destructor, destruction is manual

    rect = BLRectI(500,50, 400, 350)
    values = BLLinearGradientValues.from_rectI(rect)
    values.x0 += 100
    values.y0 += 100
    values.x1 -= 100
    values.y1 -= 100
    mode = BLExtendMode.repeat()
    ab = BLGradient.new_linear(values, mode, stop, matrix)
    linear = ab.take()
    _ = linear.add_stop(1.0, BLRgba32.rgb(75,75,210))
    _ = ctx.set_fill_style_gradient(linear)
    _ = ctx.fill_rectI(rect )
    linear.destroy()

    rect = BLRectI(500,500, 400, 350)
    values = BLLinearGradientValues.from_rectI(rect)
    values.x0 += 100
    values.y0 += 100
    values.x1 -= 100
    values.y1 -= 100
    mode = BLExtendMode.pad()
    ab = BLGradient.new_linear(values, mode, stop, matrix)
    linear = ab.take()
    _ = linear.add_stop(1.0, BLRgba32.rgb(75,75,210))
    _ = ctx.set_fill_style_gradient(linear)
    _ = ctx.fill_rectI(rect )
    _ = ctx.end()

    # until I figure out what's wrong with Mojo's destructor, destruction is manual
    linear.destroy()

    file_format = BLFileFormat.qoi()
    filename = file_format.set_extension( Path("06-gradients"))
    _ = img.to_file(filename, file_format)   

    img.destroy() # until I figure out what's wrong with Mojo's destructor, destruction is manual