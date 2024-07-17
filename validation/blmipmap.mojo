from blend2d.blmipmap import BLMipmap
from blend2d.blimage import BLImage, BLFormat, BLFileFormat
from blend2d.blcolor import BLRgba32
from blend2d.blerrorcode import BL_SUCCESS
from blend2d.blgeometry import BLRectI

from testing import assert_true, assert_equal

from pathlib import Path

fn validation() raises:

    var aaa = BLImage.new(1024,1024, BLFormat.prgb32())
    assert_true(aaa)
    var background = aaa.take()

    var filename = Path("test").joinpath("Octopus.qoi")
    var bbb = BLMipmap.from_file(filename,5)
    assert_true(bbb)
    var mipmap = bbb.take()

    var aa = background.create_context(2)
    assert_true(aa)
    var ctx = aa.take()     
           
    var r = ctx.set_fill_style_colour( BLRgba32.rgb(215,215,215) )
    assert_equal(r, BL_SUCCESS)
    r = ctx.fill_all()
    assert_equal(r, BL_SUCCESS)

    r = ctx.set_pattern_quality_bilinear()
    assert_equal(r, BL_SUCCESS)

    var rect1 = BLRectI(50,50,200,0)
    rect1.h = mipmap.calculate_height(rect1.w) # calculate the height to keep a correct aspect ratio
    r = mipmap.blit_scale_imageI(ctx, rect1)
    assert_equal(r, BL_SUCCESS)

    rect1 = BLRectI(50,250,320,0)
    rect1.h = mipmap.calculate_height(rect1.w) # calculate the height to keep a correct aspect ratio
    r = mipmap.blit_scale_imageI(ctx, rect1)
    assert_equal(r, BL_SUCCESS)

    rect1 = BLRectI(50,650,257,0)
    rect1.h = mipmap.calculate_height(rect1.w) # calculate the height to keep a correct aspect ratio
    r = mipmap.blit_scale_imageI(ctx, rect1)
    assert_equal(r, BL_SUCCESS)

    rect1 = BLRectI(450,50,560,0)
    rect1.h = mipmap.calculate_height(rect1.w) # calculate the height to keep a correct aspect ratio
    r = mipmap.blit_scale_imageI(ctx, rect1)
    assert_equal(r, BL_SUCCESS)

    rect1 = BLRectI(450,550,64,0)
    rect1.h = mipmap.calculate_height(rect1.w) # calculate the height to keep a correct aspect ratio
    r = mipmap.blit_scale_imageI(ctx, rect1)
    assert_equal(r, BL_SUCCESS)

    rect1 = BLRectI(650,550,127,0)
    rect1.h = mipmap.calculate_height(rect1.w) # calculate the height to keep a correct aspect ratio
    r = mipmap.blit_scale_imageI(ctx, rect1)
    assert_equal(r, BL_SUCCESS)

    r = ctx.end()
    assert_equal(r, BL_SUCCESS)
    # until I figure out what's wrong with Mojo's destructor, destruction is manual
    mipmap.destroy()

    aaa = BLImage.from_file(Path("test").joinpath("mipmaps.qoi"))
    assert_true(aaa)
    var img_ref = aaa.take()
    assert_true(img_ref.almost_equal(background, True))

    # until I figure out what's wrong with Mojo's destructor, destruction is manual
    background.destroy()
