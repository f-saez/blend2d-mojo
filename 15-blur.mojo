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

from math import exp

@value
struct Weights:
    var weights : List[SIMD[DType.float32,4]]
    var _radius  : Int

    fn __init__(inout self, owned w : List[SIMD[DType.float32,4]], radius : Int):
        self.weights = w
        self._radius = radius

    @staticmethod
    fn boxblur(radius : Int) -> Self:
        var width = radius * 2 + 1
        var weights = List[SIMD[DType.float32,4]](capacity=width)
        var offset = 1.0 / Float32(width)
        offset *= offset
        for _ in range(width):
            weights.append(SIMD[DType.float32,4](offset))
        return Self(weights, radius)

    @always_inline
    @staticmethod
    fn gaussian(x : Float32, mu : Float32, sigma : Float32) -> Float32:
        return exp[DType.float32](-(((x-mu)/(sigma))**2)/2.0 )

    @staticmethod
    fn _gaussian(radius : Int) -> Self:
        var width = radius*2+1
        var weights = List[SIMD[DType.float32,4]](capacity=width)
        var sigma = Float32(radius) / 2
        var sum:Float32 = 0
        for x in range(width):
            var w = Self.gaussian(x, radius, sigma)
            sum += w
            weights.append( SIMD[DType.float32,4](w) )
        # normalization
        for x in weights:
            x[] /= sum    
        return Self(weights, radius)

    @staticmethod
    fn gaussian(radius : Int) -> Self:
        self._gaussian()

fn convolution(img_src : BLImage, weights : Weights) -> Optional[BLImage]:
    var result = Optional[BLImage](None)
    var aaa = BLImage.empty_from(img_src)
    if aaa:
        var img_tmp = aaa.take()
        aaa = BLImage.empty_from(img_src)
        if aaa:
            var width_vec = 8
            var img_final = aaa.take()            
            var ptr_src = DTypePointer[DType.uint8](img_src.get_data().pixels)
            var ptr_tmp = DTypePointer[DType.uint8](img_tmp.get_data().pixels)
            for y in range(img_src.get_height()):
                var idx = y * img_src.get_stride()
                var src = ptr_src.load[width=16](idx).cast[DType.float32]()
                src *= 1


    return result

def main():
    var stuff = DTypePointer[DType.uint8]().alloc(256)
    var idx = 16
    #var src = stuff.load[width=16](idx).cast[DType.float32]()
    var src = SIMD[DType.float32](1,2,3,4, 1,6,7,8, 1,10,11,12, 1,14,15,16)
    print(src)
    src *= 2
    print(src)
    var src2 = src.reduce_add[size_out=4]()
    print(src2)
    stuff.free()

def shit_main():

    file_format = BLFileFormat.qoi()

    tmp = BLImage.new(1024,256, BLFormat.prgb32())
    img = tmp.take()

    filename = Path("examples").joinpath("Octopus.qoi")   
    tmp1 = BLImage.from_file(filename)
    img = tmp1.take()

    blur_range = 16
    ptr = img.get_data().pixels
    offset = 1.0 / Float32(blur_range)
    w = (img.get_width() - blur_range) // blur_range
    print(w, img.get_width(), img.get_height(), blur_range)
    for y in range(img.get_height()-1):
        idx = y * img.get_stride()
        for _ in range(w):
            idx1 = idx + blur_range*4 # 8 pixels further
            b0 = ptr[idx].cast[DType.float32]() # blue
            g0 = ptr[idx+1].cast[DType.float32]() # green
            r0 = ptr[idx+2].cast[DType.float32]() # red
            b1 = ptr[idx1].cast[DType.float32]()  # blue
            g1 = ptr[idx1+1].cast[DType.float32]() # green
            r1 = ptr[idx1+2].cast[DType.float32]() # red
            idx += 4
            
            coef1 = Float32(1.0)
            coef2 = Float32(0.0)
            for _ in range(blur_range):
                b = b0 * coef1 + b1 * coef2
                g = g0 * coef1 + g1 * coef2
                r = r0 * coef1 + r1 * coef2
                ptr[idx] = b.cast[DType.uint8]().value
                ptr[idx+1] = g.cast[DType.uint8]().value
                ptr[idx+2] = r.cast[DType.uint8]().value
                coef1 -= offset
                coef2 += offset
                idx += 4

    h = (img.get_height() - blur_range) // blur_range
    for x in range(img.get_height()):
        for y in range(w):
            idx = y * img.get_stride() + x * 4
            b0 = ptr[idx].cast[DType.float32]() # blue
            g0 = ptr[idx+1].cast[DType.float32]() # green
            r0 = ptr[idx+2].cast[DType.float32]() # red

            idx1 = idx + img.get_stride()*blur_range # 8 pixels further
            b1 = ptr[idx1].cast[DType.float32]()  # blue
            g1 = ptr[idx1+1].cast[DType.float32]() # green
            r1 = ptr[idx1+2].cast[DType.float32]() # red
            
            coef1 = Float32(1.0)
            coef2 = Float32(0.0)
            for _ in range(blur_range):
                b = b0 * coef1 + b1 * coef2
                g = g0 * coef1 + g1 * coef2
                r = r0 * coef1 + r1 * coef2
                ptr[idx] = b.cast[DType.uint8]().value
                ptr[idx+1] = g.cast[DType.uint8]().value
                ptr[idx+2] = r.cast[DType.uint8]().value
                coef1 -= offset
                coef2 += offset
                idx += img.get_stride()
    filename = Path("blur")
    filename1 = file_format.set_extension(filename)
    _ = img.to_file(filename1, file_format)   

    img.destroy()    