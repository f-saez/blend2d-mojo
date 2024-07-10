from blend2d.blimage import BLImage, BLFileFormat, BLFormat
from blend2d.blgeometry import BLRect,BLPointI, BLPoint
from blend2d.blfont import BLFontFace,BLFont
from blend2d.blcolor import BLRgba32   
from blend2d.blerrorcode import BL_SUCCESS
from pathlib import Path

def main():
    # Text is at the same time easy at awfully complicated
    # rendering text is hard (https://faultlore.com/blah/text-hates-you/) and sometimes font contains wrong values
    # we will start with the easy part : 
    var tmp = BLImage.new(1024,1024, BLFormat.xrgb32())
    if tmp:
        var img = tmp.take()
        var aa = img.create_context(2)
        if aa:
            var ctx = aa.take() 
            _ = ctx.set_fill_style_colour( BLRgba32.rgb(215,215,215) )
            _ = ctx.fill_all()

            # first, let's load a font
            var filename = Path("../examples").joinpath("ReadexPro-Regular.ttf")   # regular means vanilla, i.e. not bold, not italic, no light, ...
            var aaa = BLFontFace.from_path(filename,0)
            if aaa:
                var fontface = aaa.take()
                # BLFontFace is an object that contains the font loaded from a file.
                # but it is an abstract object. To draw a font, we first to need to decide its size
                # note : fontface must live longer than font !
                # let's do this
                var aab = BLFont.new(fontface, 48)
                # we have used fontface to create a font with a size of 48
                if aab:
                    var font = aab.take()
                    # nice. We're ready to draw our first text
                    var originI = BLPointI(22,49)
                    var text = String("Mojo - Blend2D")
                    var l_text = len(text)
                    _ = ctx.set_fill_style_colour( BLRgba32.rgb(145,145,145) )
                    _ = ctx.fill_utf8_textI(originI, font, text,l_text )
                    # done. That's really easy, no ?
                    # a little stroke perhaps ?
                    _ = ctx.set_stroke_width(3)  
                    _ = ctx.stroke_utf8_textI_rgba32(originI, font, text,l_text, BLRgba32.rgb(45,45,45))
                    
                    # we can work with float too 
                    var origin = BLPoint(128.5,244.9)
                    # emphasis the D 
                    _ = ctx.fill_utf8_textD_rgba32(origin, font, text, l_text, BLRgba32.rgb(0,0,185) )        
                    _ = ctx.set_stroke_width(4)  
                    _ = ctx.stroke_utf8_textD_rgba32(origin, font, text,l_text, BLRgba32.rgb(15,15,15))
                    _ = ctx.set_stroke_width(2)  
                    _ = ctx.stroke_utf8_textD_rgba32(origin, font, text,l_text, BLRgba32.rgba(255,255,255,215))

                    # we can use the width of the stroke to make a text look bolder
                    origin.x = 150
                    origin.y = 400
                    var offset = 52
                    var c = BLRgba32.rgb(0,0,0)
                    _ = ctx.set_stroke_width(0)  
                    _ = ctx.fill_utf8_textD_rgba32(origin, font, text, l_text, c )        
                    origin.y += offset
                    _ = ctx.set_stroke_width(1)  
                    _ = ctx.fill_utf8_textD_rgba32(origin, font, text, l_text, c )
                    _ = ctx.stroke_utf8_textD_rgba32(origin, font, text,l_text, c)
                    origin.y += offset
                    _ = ctx.set_stroke_width(1.8)  
                    _ = ctx.fill_utf8_textD_rgba32(origin, font, text, l_text, c )
                    _ = ctx.stroke_utf8_textD_rgba32(origin, font, text,l_text, c)
                    origin.y += offset
                    _ = ctx.set_stroke_width(2.4)  
                    _ = ctx.fill_utf8_textD_rgba32(origin, font, text, l_text, c )
                    _ = ctx.stroke_utf8_textD_rgba32(origin, font, text,l_text, c)                    
                    origin.y += offset
                    _ = ctx.set_stroke_width(3.5)  
                    _ = ctx.fill_utf8_textD_rgba32(origin, font, text, l_text, c )
                    _ = ctx.stroke_utf8_textD_rgba32(origin, font, text,l_text, c)                    

                    # can can also use rotation
                    _ = ctx.identity()
                    _ = ctx.save()
                    origin.x = 640
                    origin.y = 500
                    c = BLRgba32.rgb(40,40,200)
                    # rotation around origin, meaning the start of the text.
                    _ = ctx.rotate_pt(1.57, origin.x, origin.y)
                    _ = ctx.set_stroke_width(0) 
                    _ = ctx.fill_utf8_textD_rgba32(origin, font, text, l_text, c )
                    # rotating a context may be confusing, so I will draw the origin 
                    # to help understand what's going on
                    var small_rect = BLRect(origin.x,origin.y,5,5)
                    _ = ctx.fill_rectd_rgba32(small_rect, BLRgba32.rgb(40,200,40))
                    _ = ctx.restore()

                    # here, are returning to the previous state, meaning identity
                    c = BLRgba32.rgb(200,140,60)
                    _ = ctx.rotate_pt(-1.57, origin.x, origin.y)
                    origin.x = 720
                    small_rect = BLRect(origin.x,origin.y,5,5)
                    _ = ctx.fill_utf8_textD_rgba32(origin, font, text, l_text, BLRgba32.rgb(40,200,200)) 
                    _ = ctx.fill_rectd_rgba32(small_rect, c)

                    _ = ctx.end()
                    # the following line is very important, at least until I figure out to create a context manager
                    # for fontface
                    _ = fontface.get_face_count() # just to make sure fontface live up to this point.

                    var file_format = BLFileFormat.qoi()
                    var filename = file_format.set_extension( Path("03-basic_text"))
                    _ = img.to_file(filename, file_format)