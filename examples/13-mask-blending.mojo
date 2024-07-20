from blend2d.blimage import BLImage,  BLFileFormat, BLFormat
from blend2d.blcontext import BLCompOp
from blend2d.blpattern import BLPattern,BLExtendMode
from blend2d.blmipmap import BLMipmap
from blend2d.blgeometry import BLRectI, BLRect, BLPoint
from blend2d.blcolor import BLRgba32  
from blend2d.blpath import BLPath 
from blend2d.blfont import BLFontFace, BLFont, BLGlyphBuffer, BLTextMetrics
from blend2d.blerrorcode import BL_SUCCESS
from pathlib import Path

# we want to draw a text filled with an image.
# we could play with BLPattern but we will go another route
# so we can see masking and blending operations (with Porter-Duff operators)
# let's say I want to write the text "Blue Mountains" filled with a 
# image of the blue mountains
# and I want to write that in an image filled with whales.
# It won't be pretty, I know. :-)

def main():
    file_format = BLFileFormat.qoi()

    tmp = BLImage.new(1024,256, BLFormat.prgb32())
    img = tmp.take()

    filename = Path("..").joinpath("examples").joinpath("Whale.qoi")   
    tmp1 = BLImage.from_file(filename)
    img_whale = tmp1.take()
    tmp2 = BLPattern.new(img_whale, BLRectI(0,0,img_whale.get_width(), img_whale.get_height()), BLExtendMode.repeat())
    pattern_whale = tmp2.take()   

    aa = img.create_context(2)
    ctx = aa.take()
    _ = ctx.set_fill_style_colour(BLRgba32.rgb(11,51,80))
    _ = ctx.fill_all()
    _ = pattern_whale.scale(0.34, 0.34)
    _ = ctx.set_fill_style_pattern(pattern_whale)
    _ = ctx.fill_all()
    _ = ctx.end()

    pattern_whale.destroy()
    img_whale.destroy()

    # ok, we got our ugly background.
    # 
    # now for the text we need to do 2 things :
    # 1 - draw the text where we want with transparency. basically, we're gonna make an hole in 1 so we can see
    #  throught it and it's our mask.
    # 2 - draw our image of the blue mountains under our background. How do we do that ? 
    # until now, we have use the basic operator (BLCompOp) when we have drawn an image into another
    # there they are many more. They are called Porter-Duff operators.
    # so, let's start
    
    # load the font
    filename = Path("..").joinpath("examples").joinpath("Badonk-a-donk.ttf")
    aaz = BLFontFace.from_path(filename,0)
    fontface = aaz.take()   
    aab = BLFont.new(fontface, 60)
    font = aab.take()

    filename = Path("..").joinpath("examples").joinpath("blue_mountains.qoi")
    aay = BLMipmap.from_file(filename,5)
    texture = aay.take()   

    x = 50
    y = 100

    aac = BLGlyphBuffer.new()
    glyphs_buffer = aac.take()

    text = String("Blue Mountains")
    _ = glyphs_buffer.set_text_utf8(text, len(text))  
    _ = font.shape(glyphs_buffer)

    var text_metrics = BLTextMetrics()
    _ = font.get_text_metrics(glyphs_buffer, text_metrics)
    var font_metrics = font.get_metrics()

    # we need to know the size needed to draw our texture
    # here we may run into troubles using differents fonts
    # you may want to load some fonts and check the results of 
    # text_metrics and font_metrics. Sometimes, you may have bad surprises
    # Ok, enough ranting, what can we do to avoid this ? use a BLPath
    var aax = BLPath.new()
    var path = aax.take()    
    _ = font.get_glyphrun_outlines(glyphs_buffer, path)
    _ = path.calc_boundingbox()

    aa = img.create_context(2)
    ctx = aa.take()
    _ = ctx.set_comp_op(BLCompOp.clear()) # don't fill with color but with transparency, same as BLRgba32.rgba(0,0,0,0)
    _ = ctx.fill_pathD(BLPoint(x,y), path)

    width = Int( (path.bounding_box.x1 -path.bounding_box.x0).cast[DType.int32]().value )
    height = Int( (path.bounding_box.y1 - path.bounding_box.y0).cast[DType.int32]().value)
    # important point. Here we want to keep the aspect ratio of our texture
    # and it's probably not the same as our text
    # remember that y, for a text, describe the baseline, not the highest point, neither the lowest
    y_texture = y + font_metrics.y_min.cast[DType.int32]()
    rect = BLRectI(x,y_texture,width, 0)
    rect.h = texture.calculate_height( Int32(width) )
    if rect.h<height:
        width_tmp = texture.calculate_width( Int32(height) )
        if width_tmp>=width: # ok, good but if not, rollback
            rect.h=height
            rect.w = width_tmp
    # our texture will have the same width than our text(, but the texture will not be centered vertically
    # so will see mainly the sky and not the skyline.
    # so we need to translate our texture a bit
    rect.y -= (rect.h-height) // 2
    # obviously, this code works for this font and this texture.
    # something more generic that will work in every case is a little bit more complex
    # and could be a good exercice.
    _ = ctx.set_comp_op(BLCompOp.dst_atop()) # the "magic" operator => the destination is on top of the source    
    _ = texture.blit_scale_imageI(ctx, rect)
          
    # We have done all of this without allocating new objects or creating temporary bitmaps,
    # even without using complex processing.
    _ = ctx.set_comp_op(BLCompOp.default()) #back to the default operator (src_over)
    _ = ctx.set_stroke_width(2)
    _ = ctx.stroke_pathD_rgba32(BLPoint(x,y), path, BLRgba32.rgb(255,255,255))
    _ = ctx.end()

    font.destroy()
    fontface.destroy()

    filename = Path("13-mask_blending")
    filename1 = file_format.set_extension(filename)
    _ = img.to_file(filename1, file_format)   

    img.destroy() 
