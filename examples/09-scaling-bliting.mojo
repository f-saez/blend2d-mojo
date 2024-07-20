from blend2d.blimage import BLImage,  BLFileFormat, BLFormat, BLImageScaleFilter
from blend2d.blcolor import BLGradient, BLLinearGradientValues, BLGradientStop, BLExtendMode, BLRgba32
from blend2d.blcontext import BLContext
from blend2d.blmatrix2d import BLMatrix2D
from blend2d.blgeometry import BLPoint,BLRect, BLRectI, BLSizeI
from blend2d.blerrorcode import BL_SUCCESS, BLResult,error_code
from pathlib import Path
from time.time import now

@always_inline
def convert_to_ms(x : Int) -> Int:
    return x // 1000000

# this time, we gonna dive into some differnce between scaling (resizing the image) and "blitting"
# blitting stands for bit block transfert, meaning it is the operation you use to copy a bunch 
# of pixels (bytes) from a memory area (the source) to another (the destination)
# typically, when you draw an image on the screen, you do blitting and maybe scaling if you change the size of the image.
# we're going to see how to do that with Blend2D

# First, Blend2D provides a blit+scale function but with some caveat when we scale down a bit too much
# the first two images use "blit_scale_imageD" but the result is not really ok. 
# the second two images or more in line with what we expect. It is smooth but we need two operations
# one for downscaling the image, then we "blit" her
# the last image is ok, similar in quality with the former two.
#
# So what happens ?
# "blit+scale" in our case, works only well when we scale down a factor of two (width and height), at best. When Blend2D 
# apply its filter, it works only on 4 pixels, so we could reduce without artefact from half the width and half the height.
# Our first two images, we went from a width of 993 to 200 and it's too much. Hence, the artefacts.
# Rescaling, doesn't suffer this limitation but it is slower.
# in our case, the image are small enough to don't make much a difference on a modern machine.
#
# So, a solution ?
# yep and a old one. It's call Mipmaps : https://en.wikipedia.org/wiki/Mipmap
# when we need to render the same image at much different size, we just have to proccess the image first to
# create high-quality imageq of different size then blit it using the image of the nearest size.
# Skia does that for you, for example, but Skia is far more complex than Blend2D

def main():

    aaa = BLImage.new(1024,1024, BLFormat.prgb32())
    background = aaa.take()

    filename = Path("..").joinpath("examples").joinpath("Octopus.qoi")
    aaa = BLImage.from_file(filename)
    img_octopus = aaa.take()

    aa = background.create_context(2)
    ctx = aa.take()     
           
    _ = ctx.set_fill_style_colour( BLRgba32.rgb(215,215,215) )
    _ = ctx.fill_all()
    # here, we define the quality of the scaling while blitting and even if it got
    # the same name than ImageScaleFilter, it's not the same.
    _ = ctx.set_pattern_quality_bilinear()
    # where we want the image do be drawn and what size we want. 
    # Here, we want 200 pixel wide and it's quite a reduction from the original image
    rect1 = BLRect(50,50,200,0)
    rect1.h = rect1.w / img_octopus.get_ratio() # calculate the height to keep a correct aspect ratio
    # the source of our image. Here, we choose to use the full image
    rect2 = BLRectI(0,0,img_octopus.get_width(),img_octopus.get_height())
    tic = now()
    # simple as that : 
    _ = ctx.blit_scale_imageD(rect1, img_octopus, rect2)
    toc = now() - tic
    print("time blit_scale_image / bilinear: ", convert_to_ms(toc), "ms")

    # same thing but with a nearest filter
    _ = ctx.set_pattern_quality_nearest()
    rect1.x = rect1.x + rect1.w + 10
    tic = now()
    _ = ctx.blit_scale_imageD(rect1, img_octopus, rect2)
    toc = now() - tic
    print("time blit_scale_image / Nearest neighbor: ", convert_to_ms(toc), "ms")

    # we have already see that, so no more comment
    tic = now()
    aaa = img_octopus.scale_to_new_image(BLSizeI(rect1.w, rect1.h), BLImageScaleFilter.lanczos())    
    img_octopus2 = aaa.take()
    rect1.x = 50
    rect1.y += rect1.h + 10
    rect2 = BLRectI(0,0,img_octopus2.get_width(),img_octopus2.get_height())
    _ = ctx.blit_scale_imageD(rect1, img_octopus2, rect2)
    toc = now() - tic
    img_octopus2.destroy()
    print("time scale + blit_scale_image / lanczos: ", convert_to_ms(toc), "ms")
    
    tic = now()
    aaa = img_octopus.scale_to_new_image(BLSizeI(rect1.w, rect1.h), BLImageScaleFilter.bilinear())    
    img_octopus3 = aaa.take()
    rect1.x = rect1.x + rect1.w + 10
    rect2 = BLRectI(0,0,img_octopus3.get_width(),img_octopus3.get_height())
    _ = ctx.blit_scale_imageD(rect1, img_octopus3, rect2)
    toc = now() - tic
    img_octopus3.destroy()
    print("time scale + blit_scale_image / bilinear: ", convert_to_ms(toc), "ms")

    # getting back on our first function but, this time, we will use a more 
    # "appropriate" width.
    _ = ctx.set_pattern_quality_bilinear()
    rect1 = BLRect(50,350,720,0)
    rect1.h = rect1.w / img_octopus.get_ratio()
    rect2 = BLRectI(0,0,img_octopus.get_width(),img_octopus.get_height())
    tic = now()
    _ = ctx.blit_scale_imageD(rect1, img_octopus, rect2)
    toc = now() - tic
    print("time blit_scale_image / bilinear: ", convert_to_ms(toc), "ms")
    
    _ = ctx.end()

    file_format = BLFileFormat.qoi()
    filename = Path("09-scaling-blitting.qoi")
    _ = background.to_file(filename, file_format)
    
    # until I figure out what's wrong with Mojo's destructor, destruction is manual
    background.destroy()
    img_octopus.destroy()

