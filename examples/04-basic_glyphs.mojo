from blend2d.blimage import BLImage, BLFileFormat, BLFormat
from blend2d.blgeometry import BLRect, BLPointI, BLPoint
from blend2d.blfont import BLFontFace,BLFont, BLTextMetrics, BLGlyphBuffer
from blend2d.blcolor import BLRgba32   
from blend2d.blpath import BLPath
from blend2d.blerrorcode import BL_SUCCESS
from pathlib import Path
from testing import assert_false, assert_true

def main():
    # now the hard part of the text.
    # https://en.wikipedia.org/wiki/Character_encoding
    # https://en.wikipedia.org/wiki/Complex_text_layout
    # https://freetype.org/freetype2/docs/glyphs/glyphs-3.html
    # and for a more general overview of text : https://behdad.org/text2024/
    # so, a string of character is composed of UTF_8 code-point
    # a font is a dictionnary of code-point associated to glyphs
    # and a glyph is a path describing it with lines, cubic and quadratic functions.
    # that's why we have already see BLPath.
    # suddenly, it's less sexy ... or more :-)
    # we're just going to see the most useful part of what is hardest part of text.
    # I'll keep the worst and less useful for the end, like mixing differents fonts
    # in a single text for example, or using a texture to fill the first oversized letter of a text :-)
    #
    # there is one important thing to keep in mind. 
    # When you draw a glyph, the (X,Y) where you start to drawn the glyph 
    # is the first point where the glyph hit the baseline. It may not be the leftmost point.
    # let's take 0 for example. the glyph hit the baseline almost at the center (horizontaly) of the glyph
    # that's one thing to keep in mind when we're going to calculate the position of the next glyph.
    #
    # another thing to keep in mind : the "space" glyph.
    # it's a special case as it is a non-drawable char that we need to draw and that is extensively used
    # being non-drawabale means it has no size. One way to get the width of a space is to measure the width of
    # two strings like this "aaaabcdefgh" and "aaaab cdefgh". The width of the space is the difference.

    var tmp = BLImage.new(1024,1024, BLFormat.xrgb32())
    if tmp:
        var img = tmp.take()
        var aa = img.create_context(2)
        if aa:
            var ctx = aa.take() 
            _ = ctx.set_fill_style_colour( BLRgba32.rgb(215,215,215) )
            _ = ctx.fill_all()
            # this time, it's a multi-line text
            var text = String("Hello Mojo!\nI'm a simple multiline text example\nthat uses GlyphBuffer and GlyphRun!")
            var filename = Path("..").joinpath("examples").joinpath("ReadexPro-Regular.ttf")  
            var aaa = BLFontFace.from_path(filename,0)
            if aaa:
                var fontface = aaa.take()
                var aab = BLFont.new(fontface, 48)
                if aab:
                    var font = aab.take()
                    # so far, so good but the most important thing is not the fall but the impact with the ground
                    # we need to metrics : one for the text we want to draw and one for the font
                    # what contains text_metrics ?
                    # advance: BLPoint
                    #    advance.x : The horizontal distance to increment (for left-to-right writing) 
                    #                or decrement (for right-to-left writing) the pen position after 
                    #                a glyph has been rendered when processing text
                    #    advance.y : The vertical distance to decrement (for top-to-bottom writing) or 
                    #                increment (for bottom-to-top writing, which is extremely rare) 
                    #                the pen position after a glyph has been rendered.
                    # leading_bearing: BLPoint : we will see that later, as we don't need it now
                    # trailing_bearing: BLPoint: we will see that later, as we don't need it now
                    # bounding_box: This is an imaginary box that encloses all glyphs from the font, usually as tightly as possible.
                    var text_metrics = BLTextMetrics()
                    # what contains font_metrics ?
                    # size : the size used when creating the font, so 48 in our case
                    # ascent : The highest point of what is above the baseline (think of letters h,l, t, ...).
                    # vAscent : Font ascent (vertical orientation)
                    # descent : The lowest point of what is below the baseline (think of letters q, p)
                    # vDescent : font descent (vertical orientation)
                    # line_gap : imagine a line with a "q", the line below with a "l". 
                    #             descent gives you the lower point of the first line
                    #             ascent, the higher point of the second line
                    #             line_gap gives you the space between the two so they don't touch each other.
                    #             obviously, if the two lines have an "a", the distance between them will still be the same.
                    # x_height : Distance between the baseline and the mean line of lower-case letters.
                    # cap_height : Maximum height of a capital letter above the baseline.
                    # x_min : Minimum x, reported by the font
                    # y_min : Minimum y, reported by the font
                    # x_max : Maximum x, reported by the font
                    # y_max : Maximum y, reported by the font
                    # underline_position : Text underline position
                    # underline_thickness : Text underline thickness
                    # strikethrough_position : Text strikethrough position
                    # strikethrough_thickness : Text strikethrough thickness
                    #
                    # font_metrics give you general information about the font. How to draw the underline and the recomended width
                    # the highest letter, the lowest, ...
                    # ascent+descent+line_gap gives you the distance between two lines. 
                    # It may be a little more complicated than that when you have a font with wrong values
                    var font_metrics = font.get_metrics()
                    var c = BLRgba32.rgb(45,45,185)
                    var origin = BLPointI(0, 200 - font_metrics.ascent.cast[DType.int32]())
                    # then we need a glyph buffer
                    var aac = BLGlyphBuffer.new()
                    # it's an "Optional" so ... you know the drill
                    if aac:
                        var glyphs_buffer = aac.take()
                        # multi-line means at least 2 lines, and we have to process them one by one
                        for line in text.splitlines():
                            # we fill our glyph buffer with the text from the current line
                            _ = glyphs_buffer.set_text_utf8(line[], len(line[]))
                            # we ask the font to "shape" for these glyphs. Nothing is draw, it's just administrative stuff
                            # the font will parse the glyphbuffer to know what shapes are needed, so
                            # we could have the metrics of our future drawing
                            _ = font.shape(glyphs_buffer)
                            # we collect the metrics about these glyphs. The result will be in text_metrics                            
                            _ = font.get_text_metrics(glyphs_buffer, text_metrics)
                            # some basic centering around a point. and for that, we only need bounding_box                           
                            origin.x = 512 - (text_metrics.bounding_box.x1 - text_metrics.bounding_box.x0) / 2
                            # we fill the shape. 
                            _ = ctx.fill_glyph_runI_rgba32(origin, font, glyphs_buffer, c)
                            # now we need to jump to the next line. Remember font_metrics ?
                            # ascent + descent + line_gap
                            origin.y += (font_metrics.ascent + font_metrics.descent + font_metrics.line_gap).cast[DType.int32]()
                        # that's it for our glyphs. We could have use rotation, scale, ... but I will adress that 
                        # in another tutorial.
                        
                        # have you sometimes use a font a see a strange glyph when the font doesn't 
                        # know the text you try to draw ?
                        # Imagine a font that contains only uppercase glyph, when  you try to draw a lowercase one, 
                        # you will run into a problem. How to check if everything's fine ?
                        text = String("Glyph to Path")
                        var l_text = len(text)
                        _ = glyphs_buffer.clear()
                        # our glyphbuffer is empty.
                        assert_false(glyphs_buffer.has_text()) # should be False since the buffer is empty
                        _ = glyphs_buffer.set_text_utf8(text, l_text)
                        assert_true(glyphs_buffer.has_text()) # should be True now
                        assert_false(glyphs_buffer.has_invalid_chars()) # no invalid char, so each glyph can be drawn
                        assert_false(glyphs_buffer.has_invalid_font_data()) # no troulbe with the data of the font
                        # when a glyph is missing, we could choose to use a replacement font (for the glyph or the text), 
                        # to not draw the glyph, ...

                        # I've been telling you about how a glyph is a Path.
                        # let's try this.
                        _ = font.shape(glyphs_buffer)
                        var aad = BLPath.new()
                        var path = aad.take()
                        # instead of drawing the glyph, we ask the font to give us a Path.
                        # be carefull, all the data from text_metrics will be unavailable with the Path.
                        _ = font.get_glyphrun_outlines(glyphs_buffer, path)
                        # we already know how to draw a path
                        _ = ctx.fill_pathD_rgba32(BLPoint.new(380,520), path, BLRgba32.rgb(105,115,135))
                        
                        # here our path contains all the glyphs from "Glyph to Path"
                        # but we could do differently and extract a path for each glyph
                        # it's how we could do some "special effects" like drawing a text that follows a curve.
                        path.destroy()
                        glyphs_buffer.destroy()

                    _ = ctx.end()
                    # until I figure out what's wrong with Mojo's destructor, destruction is manual
                    font.destroy()

                    var file_format = BLFileFormat.qoi()
                    var filename = file_format.set_extension( Path("04-basic_glyphs"))
                    _ = img.to_file(filename, file_format)
                fontface.destroy() 

        img.destroy() # until I figure out what's wrong with Mojo's destructor, destruction is manual                 