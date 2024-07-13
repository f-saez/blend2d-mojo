from testing import assert_true, assert_equal

from blend2d.blerrorcode import BL_SUCCESS
from blend2d.blimage import BLImage, BLFormat, BLFileFormat
from blend2d.blcolor import BLRgba32
from blend2d.blpath import BLPath, BLStrokeCap
from blend2d.blgeometry import BLPoint

from pathlib import Path

import os

fn validation() raises:
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
    var ab = BLPath.new()
    assert_true(ab)
    var path = ab.take()

    r = path.move_to(26, 31)
    assert_equal(r, BL_SUCCESS)

    r = path.cubic_to(642, 132, 587, -136, 25, 464)
    assert_equal(r, BL_SUCCESS)

    r = path.cubic_to(882, 404, 144, 267, 27, 31)
    assert_equal(r, BL_SUCCESS)

    r = path.close()
    assert_equal(r, BL_SUCCESS)
    var p = BLPoint.new(15,13)
    r = ctx.fill_pathd_rgba32(p, path, BLRgba32.rgb(215,0,0))
    assert_equal(r, BL_SUCCESS)
    r = ctx.set_stroke_width(3.0)    
    assert_equal(r, BL_SUCCESS)
    r = ctx.stroke_pathd_rgba32(p, path, BLRgba32.rgb(15,15,15))
    assert_equal(r, BL_SUCCESS)
    
    r = path.clear()
    assert_equal(r, BL_SUCCESS)
    r = path.move_to(119, 49)
    assert_equal(r, BL_SUCCESS)
    r = path.cubic_to(259, 29, 99, 279, 275, 267)
    assert_equal(r, BL_SUCCESS)
    r = path.cubic_to(537, 245, 300, -170, 274, 430)
    assert_equal(r, BL_SUCCESS)
    r = ctx.set_stroke_start_cap(BLStrokeCap.triangle())    
    assert_equal(r, BL_SUCCESS)
    r = ctx.set_stroke_end_cap(BLStrokeCap.triangle_rev())    
    assert_equal(r, BL_SUCCESS)    
    p = BLPoint.new(380,22)
    r = ctx.set_stroke_width(22.0)    
    assert_equal(r, BL_SUCCESS)    
    r = ctx.stroke_pathd_rgba32(p, path, BLRgba32.rgb(115,125,145))
    assert_equal(r, BL_SUCCESS)    
    r = ctx.end()
    assert_equal(r, BL_SUCCESS)

    var file_format = BLFileFormat.qoi()
    var filename = file_format.set_extension( Path("test").joinpath("path"))
    r = img.to_file(filename, file_format)
    assert_equal(r, BL_SUCCESS)

    var aaa = BLImage.from_file(Path("test").joinpath("path_ref.qoi"))
    assert_true(aaa)
    var img_ref = aaa.take()
    assert_true(img_ref.almost_equal(img, True))

    os.path.path.remove(filename)