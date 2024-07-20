from blend2d.blimage import BLImage,  BLFileFormat, BLFormat, BLImageScaleFilter
from blend2d.blcolor import BLGradient, BLLinearGradientValues, BLGradientStop, BLExtendMode, BLRgba32
from blend2d.blcontext import BLContext
from blend2d.blmatrix2d import BLMatrix2D
from blend2d.blgeometry import BLPoint,BLRect, BLRectI, BLPointI
from blend2d.blerrorcode import BL_SUCCESS, BLResult,error_code
from blend2d.blmipmap import BLMipmap
from blend2d.blfont import BLFontFace, BLFont, BLGlyphBuffer, BLTextMetrics
from pathlib import Path

# our first try to mix together text, images, and gradient.
# it will be very basic : 3 images with a text describing each image.
# but when you want to move a mountain, it easier to start with the small rocks (chineese wisdom)
#
# so what are we gonna do ?
# 
# we're gonna define 3 areas for our screen, download 3 images and put each image in each area
# for each image, we're gonna draw a little text with a defined colour.
# each image will have to resize itself to fill the area and the text will be centered in the area
#
# all of this will be resolution independant
#
# it's very basic stuff. 
#
# again, for readability, I will assume every Optional and function are OK

# an area, meaning a portion of the screen/image where we will draw an image
# it's very basic :
# a rectangle : describe the area of the screen/image where things will happends.
# the number of an image, so we will need the list of images
# and a margin that'll calculate the max size of the image without having
# the image hitting the very border of the area
@value 
struct Area:
    var rect      : BLRect
    var num_image : Int
    var margin    : Float64

# a struct holding a text and tasked with rendering it
# each time you read text, you have to think : Glyph
@value
struct BasicText:
    var text          : String
    var colour        : BLRgba32
    var glyphs_buffer : BLGlyphBuffer
    var text_metrics  : BLTextMetrics
    var len_text      : Int

    def __init__(inout self, owned text : String, owned colour : BLRgba32):
        self.text = String()
        self.len_text = 0
        self.colour = colour
        self.text_metrics = BLTextMetrics()
        aac = BLGlyphBuffer.new()
        self.glyphs_buffer = aac.take()    
        self.set_text(text)   

    def set_text(inout self, owned text : String):
        self.text = text
        self.len_text = len(self.text)
        _ = self.glyphs_buffer.set_text_utf8(self.text, self.len_text)


    # the fun part, we've got a context, a font and an area
    # so we know were to draw and we have what we need to take measures
    # the thing to keep in mind is fonts are not measured in the same "space" as the context
    # so we will have to put everything either in pixels or in normalized coordinates.
    # note that we don't check that the text we fit in the area
    # neither we check if the text is drawn on the image
    def display(self, ctx : BLContext, area : BLRect, font : BLFont):        
        _ = font.shape(self.glyphs_buffer)
        _ = font.get_text_metrics(self.glyphs_buffer, self.text_metrics)
        # here we got pixels
        width_text = self.text_metrics.bounding_box.x1 - self.text_metrics.bounding_box.x0 
        #so we need to have everything in the same "coordinates space" so
        area_pixels = area * ctx.height_pixels_f64 #  => pixels

        # where do we want to put it ?
        # let's say at the bottom of the area, but inside, and horizontally centered
        # let's start with x
        x = area_pixels.x + (area_pixels.w - width_text) / 2
        
        font_metrics = font.get_metrics()
        # one thing to keep in mind with the text is that we drawn from the baseline
        # and the baseline in not in the middle of the text
        # for a given y, the bottom of the line is 
        descent = font_metrics.descent.cast[DType.float64]()
        # our text may do down up to descent pixels under the baseline
        # so we just have to put our baseline "descent" higher
        y = area_pixels.y + area_pixels.h - descent
        # we have decided to use pixel, but is our context in pixels ?
        # in fact, we don't care because but don't need to know
        _ = ctx.save()  # save the existing state of our context
        _ = ctx.identity() # back to pixels
        # we fill the shape. 
        _ = ctx.fill_glyph_runD_rgba32(BLPoint(x,y), font, self.glyphs_buffer, self.colour)
        _ = ctx.restore() # retore things at their original state


# a struct holding an image with a text (a caption) and tasked with rendering it
@value
struct Image:
    var image       : BLMipmap
    var text        : BasicText

    def __init__(inout self, owned img : BLMipmap, owned txt : StringLiteral, owned colour : BLRgba32):
        self.image = img
        self.text = BasicText( String(txt), colour)

    @staticmethod
    def from_file(filename : Path, owned text : StringLiteral, owned colour :BLRgba32) -> Optional[Self]:
        result = Optional[Self](None)
        aaa = BLMipmap.from_file(filename,5) # 5 levels but you may want to try different values
        img = aaa.take()
        result = Self(img^, text, colour)
        return result

    def display(self, ctx : BLContext, area : Area, font : BLFont):
        # we know our context in a [0,1] space but we could have go the safer way
        # and save it, define [0,1] coordinates because it suits us.
        # In fact, it was what we have done for the text
        _ = ctx.set_stroke_width(0.002)
        _ = ctx.fill_rectD_rgba32(area.rect, BLRgba32.rgb(55,55,180))
        _ = ctx.stroke_rectD_rgba32(area.rect, BLRgba32.black())
        # blitscale allows us to choose where we're going to put our image
        # and its size, so we don't have to do translate+scale.
        # we need to scale down our image size a little bit
        width_image = area.rect.w - area.margin*2 # 
        # now we got the width, let's calculate the height
        height_image = self.image.calculate_height(width_image)
        # basic stuff, we just want the image to be centered in our rectangle
        x = area.rect.x + area.margin
        y = area.rect.y + (area.rect.w - height_image) / 2
        rect = BLRect(x,y,width_image,height_image)
        # it seems fine, let's draw !
        # but first, we must think about our coordinates
        # rect is in [0,1] but is our mimap in [0,1] ?
        # no ! an image, in itself, is always in pixels, so to avoid
        # some bad surprise, we need to use the pixels size.
        # only you can know what type of coordinates you have used
        # [0,1] ? maybe your image is not a square
        # and [0,1] is for y or for x, ...
        # in our case, we have choosen to use [0,1] for the y but as our
        # image is a square ... :-)
        width = width_image * ctx.height_pixels_f64
        _ = self.image.blit_scale_imageD(ctx, rect, width) 
        # now the text
        self.text.display(ctx, area.rect, font)    

    fn destroy(owned self):
        self.image.destroy()

# a struct holding the background image, the canvas, ... where we are going to draw stuff
@value
struct Background:
    var image : BLImage

    def __init__(inout self, width : Int):
        var aaa = BLImage.new(width,width, BLFormat.prgb32())
        self.image = aaa.take()
        self.clear()

    # help the code to be readable
    # we clear the image by drawing a gradient
    def clear(self):
        aa = self.image.create_context(2)
        ctx = aa.take()  
        _ = ctx.identity()
        values = BLLinearGradientValues(0,0,0,self.image.get_height_f64())
        stop = BLGradientStop.new(0.0, 250,250,250,255)
        mode = BLExtendMode.pad()
        matrix = BLMatrix2D()
        ab = BLGradient.new_linear(values, mode, stop, matrix)        
        linear = ab.take()
        _ = linear.add_stop(1.0, BLRgba32.rgb(35,35,180))
        _ = ctx.set_fill_style_gradient(linear)
        _ = ctx.fill_all()
        _ = ctx.end()

    # our main part
    # 1 - create a context with 2 threads
    # 2 - define the coordinates of our context => [0,1]
    # 3 - for each area, draw the image associated
    # to keep thing simple, I do not check if the image is valid, laoded, ...
    def display(self, images : List[Image], areas : List[Area], font : BLFont):
        aa = self.image.create_context(2)
        ctx = aa.take()          
        _ = ctx.scale(self.image.get_width_f64(), self.image.get_height_f64())
        for area in areas:
            images[area[].num_image].display(ctx, area[], font)
        _ = ctx.end()


    def get_height_f64(self) -> Float64:
        return self.image.get_height_f64()

    def save(self, filename : Path) -> BLResult:
        file_format = BLFileFormat.qoi()
        filename1 = file_format.set_extension(filename)
        return self.image.to_file(filename1, file_format)

    fn destroy(inout self):
        self.image.destroy()       

# we want to have a font whose size is independant of the size of the screen/canvas/background
# it just means that we have to calculate the size of our font given the size
# of the image/canvas/background/
# it is not always a good idea to have the text size that scale with the size of an image.
# we could end-up with text to small to be readable, or so big that we waste space.
# text should strech with some reasonnable limits but that's a matter for another tutorial 
def cal_size_font(fontface : BLFontFace, height : Float64) -> BLFont:
    size_font = 100
    aax = BLFont.new(fontface, size_font)
    font = aax.take()
    font_metrics = font.get_metrics()
    # we collect the metrics about these glyphs. The result will be in text_metrics                            
    # now we have the height of our text for a size 100 font.
    # we haven't draw anything, it's just administrative stuff so the CPU cost is very low
    # and as it is only administrative stuff, we don't need a context :-)
    height_text = font_metrics.y_max - font_metrics.y_min
    # so, the height we want is :
    font_size = (height_text / size_font) * height
    # we create the font and that's all
    aab = BLFont.new(fontface, font_size)
    font = aab.take()
    return font

def main():
    # then a structure that will holding our images.
    # let's says 3 images
    images = List[Image](capacity=3)
    
    # then we need our 3 images
    filename = Path("..").joinpath("examples").joinpath("Fish.qoi")
    aaa = Image.from_file(filename, "A fish", BLRgba32.rgb(248,110,22))
    img_fish = aaa.take()
    images.append( img_fish )

    filename = Path("..").joinpath("examples").joinpath("Octopus.qoi")
    aaa = Image.from_file(filename, "An octopus", BLRgba32.rgb(110,220,52))
    img_octopus = aaa.take()
    images.append( img_octopus )

    filename = Path("..").joinpath("examples").joinpath("Whale.qoi")
    aaa = Image.from_file(filename, "An whale", BLRgba32.rgb(52,105,141))
    img_whale = aaa.take()
    images.append( img_whale )

    # if we want to be able to display some text, we will need a font
    # well, a BLFontFace to be precise
    filename = Path("..").joinpath("examples").joinpath("ReadexPro-Regular.ttf")   
    aaz = BLFontFace.from_path(filename,0)
    fontface = aaz.take()

    # let's define 3 areas on the screen and the image attached to each area
    areas = List[Area]()

    areas.append( Area( BLRect(0.1, 0.1, 0.33, 0.33), 0, 0.05) )
    areas.append( Area( BLRect(0.6, 0.1, 0.33, 0.33), 1, 0.05) )
    areas.append( Area( BLRect(0.1, 0.6, 0.33, 0.33), 2, 0.05) )

    # to keep things simple, we want the same font from the same size 
    # and same color ... for every text.
    # but, as we want to be resolution independant, we cannot specify a fixed size
    # we want our text to be, let's say, with a height of 0.02 time the height of our 
    # background.
    text_height = 0.02

    # the first background
    background = Background(1024)
    font = cal_size_font(fontface, text_height* background.get_height_f64())
       
    # let's display each area on the background
    background.display(images, areas, font)
    _ = background.save(Path("11_first_try-1"))

    background.destroy()

    # the second background
    background = Background(512)
    font = cal_size_font(fontface, text_height* background.get_height_f64())
       
    # let's display each area on the background
    background.display(images, areas, font)
    _ = background.save(Path("11_first_try-2"))

    background.destroy()

    for image in images:
        image[].destroy()









    