from blend2d.blimage import BLImage,  BLFileFormat, BLFormat, BLImageScaleFilter
from blend2d.blcolor import BLGradient, BLLinearGradientValues, BLGradientStop, BLExtendMode, BLRgba32
from blend2d.blcontext import BLContext
from blend2d.bllibblend2d import LibBlend2D
from blend2d.blgeometry import BLPoint,BLRect, BLRectI, BLSizeI
from blend2d.blerrorcode import BL_SUCCESS, BLResult,error_code, BL_ERROR_NOT_IMPLEMENTED
from pathlib import Path
from time.time import now

# in the last tutorial, we have talk avbout mipmap and how about they could help improve
# the quality while keeping a good level of speed.
# mipmaps are nothing new, they first appear in 1983, thanks to Lance Williams :
# https://web.archive.org/web/20140414134825/http://staff.cs.psu.ac.th/iew/cs344-481/p1-williams.pdf
#
# mipmaps are also incredibely easy to implement, that's why we are
# going to to that now.

@value
struct Mipmap:
    var items  : List[BLImage]
    var _b2d   : LibBlend2D
    var _ratio : Float64

    fn __init__(inout self, owned b2d : LibBlend2D, owned img_ref : BLImage, levels : Int):
        """
            create the mipmaps for the image with [levels] levels.
            meaning the image is the highest level and we have [levels-1] sub-levels below
            so, if we ask for 4 levels of mimap for an image,
            we're going to get the image at the highest level and 3 images below.
            The first one at half the size of image, the second at a quarter of the size, ...
        """
        self._b2d = b2d
        self.items = List[BLImage](capacity=levels+1)
        self._ratio = img_ref.get_ratio()
        # we're gonna look for the closest width of our image that is a power of 2
        # the point is to have mipmaps size aligned on power of two : 2048, 1024, 512, 256, ...
        # not really relevant on CPU, but more important on GPU
        var z = 2**16 # 65536 => yeah, I'm an optimist :-)
        var w = img_ref.get_width()
        var width:Int32 = 0
        for _ in range(16):
            if (w & z)>0:
                if (w - z)<(z*2-w):
                    width = z
                else:
                    width = z*2
                break
            z = z >> 1    
  
        if width>0:
            # now we got our size, we need to :
            # 1 - resize the original image to fit its new size
            # 2 - generate the mipmaps from the higher size to the lower size
            #     and each mipmap will be created using the former one.
            # so if our image is 1024, we will use it to generate the 512 width one and
            # use the 512 to generate the 256.
            # remember, in this case, the least pixels we process, the fastest the processing.
            var aaa:Optional[BLImage]
            if width!=w: # are we lucky, is the width already good ?
                var height = img_ref.calculate_height(width)
                aaa = img_ref.scale_to_new_image( BLSizeI(width,height), BLImageScaleFilter.lanczos())
                if aaa:
                    img_ref.destroy() # yep, I really need to solve ASAP my troubles with the destructor
            else:
                aaa = Optional[BLImage](img_ref)
            
            if aaa:                
                for _ in range(levels):
                    if aaa:
                        var img = aaa.take()
                        width /= 2
                        var height = img.calculate_height(width)
                        aaa = img.scale_to_new_image( BLSizeI(width,height), BLImageScaleFilter.lanczos())
                        if aaa:
                            self.items.append(img^)
        
    fn find_level(self, w : Int32) -> Int:
        """
            we need to find the index of the right mimap and the right mimap is the one
            that is a little bigger than the size provided
            return the index. 
            If the requested size is already bigger than our biggest image, return the index of the biggest image
            If the requested size is already smallest than our smallest image, return the index of the smallest image.
        """
        var found = 0
        if w<self.items[0].get_width():
            for idx in range(self.items.size-1):
                found = idx
                if w<self.items[idx].get_width() and w>self.items[idx+1].get_width():
                    break
        return found


    fn blit_scale_imageI(self, ctx : BLContext, src_rect : BLRectI) -> BLResult:
        """
            Mirror "BLContex.blit_scale_imageI" with a few differences.
            we always use the full image.
            the BLContext is a parameter but it could have been otherwise by passing 
            the mipmap to a context
            blit_scale_imageI => Integer
        .
        """
        var img = self.items[ self.find_level(src_rect.w) ]
        var rect2 = BLRectI(0,0, img.get_width(), img.get_height())
        return ctx.blit_scale_imageI(src_rect, img, rect2)

    fn blit_scale_imageD(self, ctx : BLContext, src_rect : BLRect) -> BLResult:
        """
            Mirror "BLContex.blit_scale_imageD" with a few differences.
            we always use the full image.
            the BLContext is a parameter but it could have been otherwise by passing 
            the mipmap to a context
            blit_scale_imageD => Float64
        .
        """
        var result = BL_ERROR_NOT_IMPLEMENTED
        for image in self.items:
            if image[].get_width_f64()<src_rect.w:
                var rect2 = BLRectI(0,0,image[].get_width(), image[].get_height())
                result = ctx.blit_scale_imageD(src_rect, image[], rect2)
                break
        return result

    @always_inline
    fn get_ratio(self) -> Float64:
        return self._ratio

    @always_inline
    fn calculate_height(self, width : Int32) -> Int32:
        """
            given the aspect ratio, calculate what would be the height 
            for a given width.
        """
        return (width.cast[DType.float64]()/self._ratio).roundeven().cast[DType.int32]()

    fn destroy(inout self):
        # I've try to use the destructor but I cannot make head or tails on how it works and when it works
        # because it seems to be fired sometimes for no reason or at the wrong time even when the object is still used
        # and the next time you call a function of this object, thinking it is in a working state, you'll end-up 
        # with a crash.
        if not self._b2d.is_destroyed():
            for img in self.items:
                img[].destroy()
            self._b2d.close()

    @staticmethod
    fn new(owned img : BLImage, levels : Int) -> Optional[Self]:
        var result = Optional[Self](None)
        if img.get_height()>0 and img.get_width()>0:
            var _b2d = LibBlend2D.new()
            if _b2d: 
                var b2d = _b2d.take()
                var img = Self(b2d^, img^, levels)
                result = Optional[Self](img)
        return result

    @staticmethod
    fn from_file(filename : Path, levels : Int) raises -> Optional[Self]:
        var result = Optional[Self](None)
        var aaa = BLImage.from_file(filename)
        if aaa:
            var img = aaa.take()
            result = Self.new(img^, levels)
        return result

def main():

    aaa = BLImage.new(1024,1024, BLFormat.prgb32())
    background = aaa.take()

    filename = Path("examples").joinpath("Octopus.qoi")
    bbb = Mipmap.from_file(filename,5)
    mipmap = bbb.take()

    aa = background.create_context(2)
    ctx = aa.take()     
           
    _ = ctx.set_fill_style_colour( BLRgba32.rgb(215,215,215) )
    _ = ctx.fill_all()

    # here, we define the quality of the scaling while blitting and even if it got
    # the same name than ImageScaleFilter, it's not the same.
    _ = ctx.set_pattern_quality_bilinear()

    rect1 = BLRectI(50,50,200,0)
    rect1.h = mipmap.calculate_height(rect1.w) # calculate the height to keep a correct aspect ratio
    _ = mipmap.blit_scale_imageI(ctx, rect1)

    rect1 = BLRectI(50,250,320,0)
    rect1.h = mipmap.calculate_height(rect1.w) # calculate the height to keep a correct aspect ratio
    _ = mipmap.blit_scale_imageI(ctx, rect1)

    rect1 = BLRectI(50,650,257,0)
    rect1.h = mipmap.calculate_height(rect1.w) # calculate the height to keep a correct aspect ratio
    _ = mipmap.blit_scale_imageI(ctx, rect1)

    rect1 = BLRectI(450,50,560,0)
    rect1.h = mipmap.calculate_height(rect1.w) # calculate the height to keep a correct aspect ratio
    _ = mipmap.blit_scale_imageI(ctx, rect1)

    rect1 = BLRectI(450,550,64,0)
    rect1.h = mipmap.calculate_height(rect1.w) # calculate the height to keep a correct aspect ratio
    _ = mipmap.blit_scale_imageI(ctx, rect1)

    rect1 = BLRectI(650,550,127,0)
    rect1.h = mipmap.calculate_height(rect1.w) # calculate the height to keep a correct aspect ratio
    _ = mipmap.blit_scale_imageI(ctx, rect1)

    _ = ctx.end()
    mipmap.destroy()

    file_format = BLFileFormat.qoi()
    filename = Path("10-mipmaps.qoi")
    _ = background.to_file(filename, file_format)
    
    # until I figure out what's wrong with Mojo's destructor, destruction is manual
    background.destroy()

