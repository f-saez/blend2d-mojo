
from testing import assert_equal, assert_true, assert_almost_equal, assert_false
from blend2d.blfont import *

def BLFontStretch_validation():
    assert_equal(BLFontStretch.ultra_condensed().value, BL_FONT_STRETCH_ULTRA_CONDENSED)
    assert_equal(BLFontStretch.extra_condensed().value, BL_FONT_STRETCH_EXTRA_CONDENSED)
    assert_equal(BLFontStretch.condensed().value, BL_FONT_STRETCH_CONDENSED)
    assert_equal(BLFontStretch.semi_condensed().value, BL_FONT_STRETCH_SEMI_CONDENSED)
    assert_equal(BLFontStretch.normal().value, BL_FONT_STRETCH_NORMAL)
    assert_equal(BLFontStretch.semi_expanded().value, BL_FONT_STRETCH_SEMI_EXPANDED)
    assert_equal(BLFontStretch.expanded().value, BL_FONT_STRETCH_EXPANDED)
    assert_equal(BLFontStretch.extra_expanded().value, BL_FONT_STRETCH_EXTRA_EXPANDED)
    assert_equal(BLFontStretch.ultra_expanded().value, BL_FONT_STRETCH_ULTRA_EXPANDED)

def BLFontFace_validation():
    var filename = Path("test").joinpath("ReadexPro-Regular.ttf")
    var aaa = BLFontFace.from_path(filename,0)
    assert_true(aaa)
    var face = aaa.take()
    assert_equal(face.get_face_count(), 1)

def BLFont_validation():
    var filename = Path("test").joinpath("ReadexPro-Regular.ttf")
    var aaa = BLFontFace.from_path(filename,0)
    assert_true(aaa)
    var face = aaa.take()
    assert_equal(face.get_face_count(), 1)
    var aab = BLFont.new(face, 42)
    assert_true(aab)
    var font = aab.take()
    var metrics = font.get_metrics()
    assert_equal(metrics.size, 42)
    assert_equal(metrics.ascent, 42)
    assert_equal(metrics.vAscent, 0)
    assert_equal(metrics.descent, 10.5)
    assert_equal(metrics.vDescent, 0)
    assert_equal(metrics.line_gap, 0)
    assert_almost_equal(metrics.x_height, 22.05)
    assert_almost_equal(metrics.cap_height, 29.4)
    assert_almost_equal(metrics.x_min, -8.78, atol=0.01)
    assert_almost_equal(metrics.y_min, -47.63, atol=0.01)
    assert_almost_equal(metrics.x_max, 61.53, atol=0.01)
    assert_almost_equal(metrics.y_max, 21.59, atol=0.01)
    assert_almost_equal(metrics.underline_position, 2.1, atol=0.01)
    assert_almost_equal(metrics.underline_thickness, 2.1, atol=0.01)
    assert_almost_equal(metrics.strikethrough_position, -15.33, atol=0.01)
    assert_almost_equal(metrics.strikethrough_thickness, 2.1, atol=0.01)

def validation_text():
    var tmp = BLImage.new(1024,768, BLFormat.xrgb32())
    assert_true(tmp)
    var img = tmp.take()
    
    var aa = img.create_context(2)
    assert_true(aa)

    var ctx = aa.take()
    var c_background = BLRgba32.rgb(215,215,215)
    assert_true(c_background.is_opaque())
    assert_equal(c_background.get_g(),215)
    var r = ctx.fill_all_rgba32(c_background)
    assert_equal(r, BL_SUCCESS)
    
    var filename = Path("test").joinpath("ReadexPro-Regular.ttf")  # regular means vanilla, ie not bold, not italic, no light, ...
    var aaa = BLFontFace.from_path(filename,0)
    assert_true(aaa)
    var fontface = aaa.take()

    var originI = BLPointI(22,49)
    var text = String("Mojo - Blend2D")
    var l_text = len(text)
    var c = BLRgba32.rgb(45,45,45)
    assert_true(c.is_opaque())
    assert_equal(c.get_r(),45)

    # fontface must live longer than font !
    var aab = BLFont.new(fontface, 48)
    assert_true(aab)
    var font = aab.take()
    r = ctx.set_fill_style_colour( BLRgba32.rgb(145,145,145) )

    assert_equal(r, BL_SUCCESS)        
    r = ctx.fill_utf8_textI(originI, font, text,l_text )
    assert_equal(r, BL_SUCCESS)
    r = ctx.set_stroke_style_colour( BLRgba32.rgb(45,45,45) )  
    assert_equal(r, BL_SUCCESS)
    r = ctx.stroke_utf8_textI(originI, font, text,l_text)
    assert_equal(r, BL_SUCCESS)

    var origin = BLPoint(128.5,244.9)
    c = BLRgba32.rgb(0,0,185)
    assert_true(c.is_opaque())
    assert_equal(c.get_b(),185)
 
    r = ctx.fill_utf8_textD_rgba32(origin, font, text, l_text, c )        
    assert_equal(r, BL_SUCCESS)
    r = ctx.set_stroke_width(3)  
    assert_equal(r, BL_SUCCESS)
    r = ctx.stroke_utf8_textD_rgba32(origin, font, text,l_text, BLRgba32.rgb(15,15,15))
    assert_equal(r, BL_SUCCESS)
    r = ctx.set_stroke_width(1.5)  
    assert_equal(r, BL_SUCCESS)
    r = ctx.stroke_utf8_textD_rgba32(origin, font, text,l_text, BLRgba32.rgba(255,255,255,215))
    assert_equal(r, BL_SUCCESS)

    origin.x = 350
    origin.y = 400
    
    c = BLRgba32.rgb(15,15,15)
    r = ctx.fill_utf8_textD_rgba32(origin, font, text, l_text, c )        
    assert_equal(r, BL_SUCCESS)
    r = ctx.set_stroke_width(1.5)  # that's one way to create a bolder version
    assert_equal(r, BL_SUCCESS)
    r = ctx.stroke_utf8_textD_rgba32(origin, font, text,l_text, c)
    assert_equal(r, BL_SUCCESS)

    r = ctx.end()
    assert_equal(r, BL_SUCCESS)
    
    # fontface must live longer than font and I haven't found any other way to do that than this.
    # I've tried "with" but only got crashes
    _ = fontface.get_face_count()

    var file_format = BLFileFormat.qoi()
    filename = file_format.set_extension( Path("test").joinpath("text"))
    r = img.to_file(filename, file_format)
    assert_equal(r, BL_SUCCESS)   

    var aae = BLImage.from_file(Path("test").joinpath("text_ref.qoi"))
    assert_true(aae)
    var img_ref = aae.take()
    assert_true(img_ref.almost_equal(img, False))

    os.path.path.remove(filename)       

def validation_glyph():
    """
        text is easy as long as someone do the dirty job for you
        now, let's do the dirty job ourselves.
        It's the very basic thing to start with text.
        We could draw glyph by glyph, and for each glyph, change color, width, rotation, fill style, ...
        It's basically what is done by a text processor
        .
    """
    var tmp = BLImage.new(1024,768, BLFormat.xrgb32())
    assert_true(tmp)
    var img = tmp.take()
    
    var aa = img.create_context(2)
    assert_true(aa)

    var ctx = aa.take()
    var c = BLRgba32.rgb(215,215,215)
    var r = ctx.fill_all_rgba32(c)
    assert_equal(r, BL_SUCCESS)
    
    # the bold version of the font. We could a have created a somewhat bold
    # version of the regular by using a stroke more or less big but it's not the 
    # same a a bold version as its creator wanted it to be
    var filename = Path("test").joinpath("ReadexPro-Bold.ttf")  
    var aaa = BLFontFace.from_path(filename,0)
    assert_true(aaa)
    var fontface = aaa.take()

    var text = String("Hello Mojo!\nI'm a simple multiline text example\nthat uses GlyphBuffer and GlyphRun!")
    var l_text = len(text)
    c = BLRgba32.rgb(45,45,45)
    assert_true(c.is_opaque())
    assert_equal(c.get_r(),45)

    # fontface must live longer than font, and, no, I don't wanna copy 
    # duplicate fontface each time I create a font object
    var aab = BLFont.new(fontface, 48)
    assert_true(aab)
    var font = aab.take()
    r = ctx.set_fill_style_colour( BLRgba32.rgb(145,145,145) )

    c = BLRgba32.rgb(0,0,185)
    assert_true(c.is_opaque())
    assert_equal(c.get_b(),185)
 
    var text_metrics = BLTextMetrics()
    var font_metrics = font.get_metrics()
    var aac = BLGlyphBuffer.new()
    assert_true(aac)
    var glyphs_buffer = aac.take()
    var origin = BLPointI(0, 200 - font_metrics.ascent.cast[DType.int32]())
    for line in text.splitlines():
        r = glyphs_buffer.set_text_utf8(line[], len(line[]))
        assert_equal(r, BL_SUCCESS)     
        r = font.shape(glyphs_buffer)
        assert_equal(r, BL_SUCCESS)
        r = font.get_text_metrics(glyphs_buffer, text_metrics)
        assert_equal(r, BL_SUCCESS)
        origin.x = 512 - (text_metrics.bounding_box.x1 - text_metrics.bounding_box.x0) / 2
        r = ctx.fill_glyph_run_rgba32(origin, font, glyphs_buffer, c)
        assert_equal(r, BL_SUCCESS)
        origin.y += (font_metrics.ascent + font_metrics.descent + font_metrics.line_gap).cast[DType.int32]()

    text = String("Glyph to Path")
    l_text = len(text)
    r = glyphs_buffer.clear()
    assert_equal(r, BL_SUCCESS)  
    assert_false(glyphs_buffer.has_text())
    assert_true(glyphs_buffer.has_glyphs())
    r = glyphs_buffer.set_text_utf8(text, l_text)
    assert_equal(r, BL_SUCCESS)  
    assert_true(glyphs_buffer.has_text())
    assert_false(glyphs_buffer.has_invalid_chars())
    assert_false(glyphs_buffer.has_invalid_font_data())
    assert_false(glyphs_buffer.has_glyphs())
    r = font.shape(glyphs_buffer)
    assert_equal(r, BL_SUCCESS)
    var aad = BLPath.new()
    assert_true(aad)
    var path = aad.take()
    r = font.get_glyphrun_outlines(glyphs_buffer, path)
    assert_equal(r, BL_SUCCESS)     
    var p = BLPoint.new(380,520)
    r = ctx.fill_pathd_rgba32(p, path, BLRgba32.rgb(105,115,135))
    assert_equal(r, BL_SUCCESS)
    r = ctx.set_stroke_width(3)    
    assert_equal(r, BL_SUCCESS)    
    r = ctx.stroke_pathd_rgba32(p, path, BLRgba32.rgba(255,255,255,255))
    r = ctx.set_stroke_width(1)    
    assert_equal(r, BL_SUCCESS)    
    r = ctx.stroke_pathd_rgba32(p, path, BLRgba32.rgba(15,15,15,255))
    assert_equal(r, BL_SUCCESS)    

    r = ctx.end()
    assert_equal(r, BL_SUCCESS)
    
    # fontface must live longer than font and I haven't found any other way to do that than this.
    # I've tried implementing "with" but only got crashes
    _ = fontface.get_face_count()

    var file_format = BLFileFormat.qoi()
    filename = file_format.set_extension( Path("test").joinpath("glyphs"))
    r = img.to_file(filename, file_format)
    assert_equal(r, BL_SUCCESS)   

    var aae = BLImage.from_file(Path("test").joinpath("glyphs_ref.qoi"))
    assert_true(aae)
    var img_ref = aae.take()
    assert_true(img_ref.almost_equal(img, False))

    os.path.path.remove(filename)    

def validation():
    BLFontStretch_validation()
    BLFontFace_validation()
    BLFont_validation()
    validation_text()
    validation_glyph()

