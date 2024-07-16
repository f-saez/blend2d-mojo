from testing import assert_true, assert_equal

from blend2d.blimage import BLImage, BLFormat, BLFileFormat
from blend2d.blgeometry import BLRect, BLRectI
from blend2d.blcolor import BLRgba32
from blend2d.blerrorcode import BL_SUCCESS

from pathlib import Path
import os

fn validation_image() raises:
    var tmp = BLImage.new(1024,768, BLFormat.xrgb32())
    assert_true(tmp)
    var img = tmp.take()
    
    var aa = img.create_context(2)
    assert_true(aa)
    var ctx = aa.take()
    var r = ctx.set_fill_style_colour( BLRgba32.rgb(215,215,215) )
    assert_equal(r, BL_SUCCESS)
    r = ctx.fill_all()
    assert_equal(r, BL_SUCCESS)

    r = ctx.fill_rectI_rgba32(BLRectI(150,150,320,240), BLRgba32.rgb(55,55,55) )
    assert_equal(r, BL_SUCCESS)

    assert_equal(r, BL_SUCCESS)
    var rect = BLRect(150,150,320,240)
    r = ctx.fill_rectD_rgba32(rect, BLRgba32.rgb(55,55,165) )
    assert_equal(r, BL_SUCCESS)
    r = ctx.save()
    assert_equal(r, BL_SUCCESS)
    r = ctx.identity()
    assert_equal(r, BL_SUCCESS)
    r = ctx.rotate_pt(0.1, rect.x+rect.w/2, rect.y+rect.h/2)
    assert_equal(r, BL_SUCCESS)  
    r = ctx.stroke_rectD_rgba32(rect, BLRgba32.rgb(165,55,55) )
    assert_equal(r, BL_SUCCESS)

    r = ctx.end()
    assert_equal(r, BL_SUCCESS)
    var file_format = BLFileFormat.qoi()
    var filename = file_format.set_extension( Path("test").joinpath("image"))
    r = img.to_file(filename, file_format)
    assert_equal(r, BL_SUCCESS)

    var aaa = BLImage.from_file(Path("test").joinpath("image_ref.qoi"))
    assert_true(aaa)
    var img_ref = aaa.take()

    assert_true(img_ref.almost_equal(img, True))
    
    img_ref.destroy()    
    img.destroy()

    os.path.path.remove(filename)

fn validation_codecs() raises:
    var filename = Path("test").joinpath("logo_mojo.qoi")
    var r = BLImage.from_file(filename)
    assert_true(r)
    var img = r.take()
    assert_equal(img.get_width(), 314)
    assert_equal(img.get_height(), 471)
    assert_equal(img.get_format().value, BLFormat.prgb32().value)

    filename = Path("test").joinpath("logo_mojo.jpg")
    r = BLImage.from_file(filename)
    assert_true(r)
    var img1 = r.take()
    assert_equal(img1.get_width(), 314)
    assert_equal(img1.get_height(), 471)
    assert_equal(img1.get_format().value, BLFormat.xrgb32().value)
    assert_true(img.almost_equal(img1, False))

    var filename2 = Path("test").joinpath("logo_mojo.png")
    r = BLImage.from_file(filename2)
    assert_true(r)
    var img2 = r.take()
    assert_equal(img2.get_width(), 314)
    assert_equal(img2.get_height(), 471)
    assert_equal(img2.get_format().value, BLFormat.prgb32().value)  
    assert_true(img.almost_equal(img2, False))
    img.destroy()    
    img1.destroy()                  
    img2.destroy()                  

fn validation() raises:
    validation_image()
    validation_codecs()

