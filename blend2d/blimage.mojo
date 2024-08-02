from .blerrorcode import *
from .blcommon import *
from .blcontext import BLContext, BLStrokeCap
from .blpath import BLPath
from .bllibblend2d import LibBlend2D
from pathlib import Path
import os
import .helpers
from .helpers import create_path_if_not_exists
from .blcodec import BLArrayCore
from .blcolor import BLRgba32
from .blgeometry import BLSizeI, BLRect, BLRectI

from algorithm import parallelize
from .grayscale import Grayscale, GrayscaleLensFilter

alias BL_FORMAT_NONE: UInt32   = 0
alias BL_FORMAT_PRGB32: UInt32 = 1  # pre-multiplied alpha
alias BL_FORMAT_XRGB32: UInt32 = 2  # alpha ignored, ie always opaque
alias BL_FORMAT_A8: UInt32     = 3

alias BL_DATA_ACCESS_NO_FLAGS: UInt32 = 0
alias BL_DATA_ACCESS_READ: UInt32     = 1
alias BL_DATA_ACCESS_WRITE: UInt32    = 2
alias BL_DATA_ACCESS_RW: UInt32       = 3

alias BL_IMAGE_SCALE_FILTER_NONE: UInt32 = 0
alias BL_IMAGE_SCALE_FILTER_NEAREST: UInt32 = 1
alias BL_IMAGE_SCALE_FILTER_BILINEAR: UInt32 = 2
alias BL_IMAGE_SCALE_FILTER_BICUBIC: UInt32 = 3
alias BL_IMAGE_SCALE_FILTER_LANCZOS: UInt32 = 4

alias blImageInit = fn(UnsafePointer[BLImageCore]) -> BLResult
alias blImageReset = fn(UnsafePointer[BLImageCore]) -> BLResult
alias blImageGetData = fn(UnsafePointer[BLImageCore], UnsafePointer[BLImageData]) -> BLResult
alias blImageDestroy = fn(UnsafePointer[BLImageCore]) -> BLResult
alias blImageCreate = fn(UnsafePointer[BLImageCore], Int32, Int32, UInt32) -> BLResult
alias blImageWriteToFile = fn(UnsafePointer[BLImageCore], UnsafePointer[UInt8], UnsafePointer[UInt8]) -> BLResult # should be UnsafePointer[BLImageCodecCore]
alias blImageReadFromFile = fn(UnsafePointer[BLImageCore], UnsafePointer[UInt8], UnsafePointer[UInt8]) -> BLResult # should be UnsafePointer[BLImageCodecCore]

alias blImageReadFromData = fn(UnsafePointer[BLImageCore], UnsafePointer[UInt8], Int, UnsafePointer[UInt8]) -> BLResult 

alias blImageScale = fn(UnsafePointer[BLImageCore], UnsafePointer[BLImageCore], UnsafePointer[BLSizeI], UInt32) -> BLResult 
alias blImageMakeMutable = fn(UnsafePointer[BLImageCore], UnsafePointer[BLImageData]) -> BLResult

alias blImageCodecArrayInitBuiltInCodecs = fn(UnsafePointer[BLArrayCore], UInt32) -> BLResult
alias blArrayInit = fn(UnsafePointer[BLArrayCore], UInt32) -> BLResult

#============================================================================================================
#
#          The "enums" part
#
#============================================================================================================

@value
struct BLFileFormat:
    var ext : String

    fn __init__(inout self, owned value : String):
        self.ext = value

    fn set_extension(self, filename : Path) -> Path:
        return helpers.set_extension(filename, self.ext)

    @staticmethod
    @always_inline
    fn jpeg() -> Self:
        return Self("jpg")

    @staticmethod
    @always_inline
    fn png() -> Self:
        return Self("png")

    @staticmethod
    @always_inline
    fn qoi() -> Self:
        return Self("qoi")

@value
struct BLFormat:
    var value : UInt32
    var _bpp  : Int

    fn __init__(inout self, value : UInt32):
        self.value = value
        self._bpp = 0
        if value==BL_FORMAT_PRGB32: # pre-multiplied alpha
            self._bpp = 4
        elif value==BL_FORMAT_XRGB32:# alpha ignored, ie always opaque
            self._bpp = 4
        elif value==BL_FORMAT_A8:            
            self._bpp = 1

    @staticmethod
    @always_inline
    fn none() -> Self:
        return Self(BL_FORMAT_NONE)

    @staticmethod
    @always_inline
    fn prgb32() -> Self:
        return Self(BL_FORMAT_PRGB32)

    @staticmethod
    @always_inline
    fn xrgb32() -> Self:
        return Self(BL_FORMAT_XRGB32)

    @staticmethod
    @always_inline
    fn a8() -> Self:
        return Self(BL_FORMAT_A8)

    @always_inline
    fn bpp(self) -> Int:
        return self._bpp

@value
struct BLDataAccessFlag:     
    var value : UInt32

    @staticmethod
    @always_inline
    fn no_flags() -> Int32:
        return BL_DATA_ACCESS_NO_FLAGS

    @staticmethod
    @always_inline
    fn read() -> Int32:
        return BL_DATA_ACCESS_READ     

    @staticmethod
    @always_inline
    fn write() -> Int32:
        return BL_DATA_ACCESS_WRITE          

    @staticmethod
    @always_inline
    fn rw() -> Int32:
        return BL_DATA_ACCESS_RW                 

@value
struct BLImageScaleFilter:  
    var value : UInt32

    @staticmethod
    @always_inline
    fn none() -> Self:
      return Self(BL_IMAGE_SCALE_FILTER_NONE)

    @staticmethod
    @always_inline
    fn nearest() -> Self:
      return Self(BL_IMAGE_SCALE_FILTER_NEAREST)

    @staticmethod
    @always_inline
    fn bilinear() -> Self:
      return Self(BL_IMAGE_SCALE_FILTER_BILINEAR)

    @staticmethod
    @always_inline
    fn bicubic() -> Self:
      return Self(BL_IMAGE_SCALE_FILTER_BICUBIC)

    @staticmethod
    @always_inline
    fn lanczos() -> Self:
      return Self(BL_IMAGE_SCALE_FILTER_LANCZOS)

#============================================================================================================
#
#  the low-level Blend2D interface structs
#
#============================================================================================================
@value
struct BLImageCore:
    var detail : BLObjectDetail

    fn __init__(inout self):
        self.detail = BLObjectDetail()

      
#============================================================================================================
#
#          The basic structs
#
#============================================================================================================    

@value
struct BLImageData(Stringable):
    var pixels: UnsafePointer[UInt8, AddressSpace.GENERIC]
    var stride : Int
    var size: BLSizeI
    var format: UInt32
    var flags: UInt32

    fn __init__(inout self):
        self.pixels = UnsafePointer[UInt8, AddressSpace.GENERIC]()
        self.stride = 0
        self.size = BLSizeI()
        self.format = 0
        self.flags = 0

    fn __str__(self) -> String:
        var result = StringList()
        print(self.pixels)
        result.append(String("stride: ")+String(self.stride))
        result.append(String("size: ")+self.size.__str__())
        result.append(String("format: ")+String(self.format))
        result.append(String("flags: ")+String(self.flags))
        return result.get_value()

#============================================================================================================
#
#  the usable objects
#
#============================================================================================================
@value
struct BLImage:
    var _b2d   : LibBlend2D
    var _core  : BLImageCore
    var _data  : BLImageData
    var _ratio : Float64

    fn __init__(inout self, owned b2d : LibBlend2D, owned core : BLImageCore):
        self._b2d = b2d
        self._core = core
        self._data = BLImageData()
        self._ratio = 1.
        _ = self.refresh_data()

    fn destroy(inout self):
        # I've try to use the destructor but I cannot make head or tails on how it works and when it works
        # because it seems to be fired sometimes for no reason or at the wrong time,
        # and the next time you call a function of this object, thinking it is in a working state, you'll end-up 
        # with a crash.
        if not self._b2d.is_destroyed():
            _ = self._b2d._handle.get_function[blImageDestroy]("blImageDestroy")(UnsafePointer(self._core))
            self._b2d.close()

    @staticmethod
    fn new(width : Int, height : Int, format : BLFormat) -> Optional[Self]:
        var result = Optional[Self](None)  
        if width>0 and height>0:
            var _b2d = LibBlend2D.new()
            if _b2d: 
                var b2d = _b2d.take()
                var core = BLImageCore()              
                var res = b2d._handle.get_function[blImageInit]("blImageInit")(UnsafePointer(core))
                if res==BL_SUCCESS:
                    res = b2d._handle.get_function[blImageCreate]("blImageCreate")(UnsafePointer(core), Int32(width), Int32(height), format.value)
                    if res==BL_SUCCESS:
                        var img = Self(b2d^, core^)
                        result = Optional[Self](img)
                if res!=BL_SUCCESS:
                    print("BLImage failed with ",error_code(res))  
        return result

    @staticmethod
    fn empty_from(img : Self) -> Optional[Self]:
        var w = img.get_width()
        var h = img.get_width()
        return Self.new(Int(w.value), Int(h.value), img.get_format())

    fn create_context(self, threadcount : UInt32) -> Optional[BLContext]:
        var stuff = BLContext.begin(self, threadcount)
        return stuff

    @always_inline
    fn calculate_height(self, width : Int32) -> Int32:
        """
            given the aspect ratio, calculate what would be the height 
            for a given width.
        """
        return (width.cast[DType.float64]()/self._ratio).roundeven().cast[DType.int32]()

    @always_inline
    fn get_pixels_ptr(self) -> DTypePointer[DType.uint8,AddressSpace.GENERIC]:
        return DTypePointer[ DType.uint8, AddressSpace.GENERIC ](self._data.pixels)

    @always_inline
    fn get_width(self) -> Int32:
        return self._data.size.w
    
    @always_inline
    fn get_width_f64(self) -> Float64:
        return self._data.size.w.cast[DType.float64]()

    @always_inline
    fn get_height(self) -> Int32:
        return self._data.size.h

    @always_inline
    fn get_height_f64(self) -> Float64:
        return self._data.size.h.cast[DType.float64]()

    @always_inline
    fn get_ratio(self) -> Float64:
        return self._ratio

    @always_inline
    fn get_format(self) -> BLFormat:
        return BLFormat(self._data.format)

    @always_inline
    fn get_stride(self) -> Int:
        return self._data.stride

    @always_inline
    fn get_core_ptr(self) -> UnsafePointer[BLImageCore]:
        return UnsafePointer[BLImageCore](self._core)

    fn reset(self) -> BLResult:
        return self._b2d._handle.get_function[blImageReset]("blImageReset")(self.get_core_ptr())

    fn image_info(self) -> BLResult:
        return self._b2d._handle.get_function[blImageReset]("blImageReset")(self.get_core_ptr())

    fn refresh_data(inout self) -> BLResult:
        """
            return some data on the image. It's very light, it just copy some internal stuff to
            a struct we keep at hand.
            Sometimes, after dealing externally with the image, we need to refresh the values by interrogating
            the blend2d's function.
        """
        var res = self._b2d._handle.get_function[blImageGetData]("blImageGetData")(self.get_core_ptr(), UnsafePointer(self._data))
        if res==BL_SUCCESS:
            self._ratio = self.get_width_f64() / self.get_height_f64()
        else:
            # if it fails - I don't know why it could fail - it could means the data retreived is garbage so.
            self._data = BLImageData()
            self._ratio = 1.
        return res
    
    fn get_data(self) -> BLImageData:
        """
            return some data on the image.
        """
        return self._data

    fn make_mutable(self) -> BLResult:
        """
            make the image mutable for an external processing.
        """
        return self._b2d._handle.get_function[blImageMakeMutable]("blImageMakeMutable")(self.get_core_ptr(), UnsafePointer[BLImageData](self._data))

    fn grayscale(self, filter : Grayscale, num_threads : Int) -> Optional[BLImage]:
        var stride = self.get_stride()
        var height = self.get_height().value
        var width = self.get_width().value
        var result = BLImage.new(width, height, self.get_format())

        if result:
            var img_dst = result.take()
            _ = img_dst.make_mutable()
            var ptr_src = self.get_pixels_ptr()
            var ptr_dst = img_dst.get_pixels_ptr()

            @parameter
            fn process_line(y : Int):	
                var idx = y*stride			
                for _ in range(Int(width)):
                    var rgb_src = ptr_src.load[width=4](idx)
                    var rgb = rgb_src.cast[DType.int32]()
                    rgb *= filter.coef
                    var gray = rgb.reduce_add[size_out=1]()
                    gray = gray >> 10
                    var g = gray.clamp(0,255).cast[DType.uint8]()
                    var dst = SIMD[DType.uint8,4](g[0], g[0], g[0], rgb_src[3])
                    ptr_dst.store[width=4](idx, dst)
                    idx += 4
            		
            parallelize[process_line](height, num_threads )            
            result = Optional[BLImage](img_dst)
				
        return result


    fn scale_to_new_image(self, size : BLSizeI, filter : BLImageScaleFilter) -> Optional[BLImage]:
        """
            resize an image to [size] with [filter] as a filter.
            If everything's ok, return the image as an Optional
            The new image got the same format as the former one (alpha channel).
            This function resize an image without using any context. You just take an existing 
            image an produce another one with other dimensions
            There are two scaling functions in BLContext with a little different purpose.
        """
        var result = Optional[BLImage](None)
        var aaa = BLImage.new( size.w.cast[DType.int32]().value, size.h.cast[DType.int32]().value, self.get_format())
        if aaa:
            var img = aaa.take()
            var res = self._b2d._handle.get_function[blImageScale]("blImageScale")(img.get_core_ptr(),self.get_core_ptr(),  UnsafePointer[BLSizeI](size), filter.value)
            if res==BL_SUCCESS:
                result = Optional[BLImage](img)
        return result

    fn scale_to_existing(self, dest_image : BLImage, filter : BLImageScaleFilter) -> BLResult:
        """
            resize an image to fit in an existing image with [filter] as a filter.
            The point is exactly the same as the former one, but without the need to create an new image.
            Let's say we need to resize 10 images to the same size.
            It is more efficient to create a destination image once and resize every image into the existing one
            than creating and disdcarding the same image 10 times.
            note : you should use the same format for both the images, but I won't hold your hand on that.
        """    
        return self._b2d._handle.get_function[blImageScale]("blImageScale")(dest_image.get_core_ptr(),self.get_core_ptr(), UnsafePointer[BLSizeI](dest_image._data.size), filter.value)

    fn almost_equal(self, other :BLImage, rgba : Bool) -> Bool:
        """
            Comparing two images, one reference and one created by the same library
            but on a different architecture or a different version or with a different codec could result in
            small and invisible differences (not the same rounding, not the same way to anti-alias, ...)
            So to prevent a bunch of troubles, I choose to allow a small percentage of differences.
            something like 5% of the pixels could have a 4% difference.
            if RGBA==True, we test the alpha channel, otherwise, it's just RGB.
        """
        var result = False
        var w = self.get_width()
        var h = self.get_height()
        var num_pixels = w*h
        var num_diff = 0
        if w==other.get_width() and h==other.get_height() and self.get_stride()==other.get_stride():
            var data1 = self.get_data()
            var data2 = other.get_data()
            # a dumb way to do that, but who cares ?
            for y in range(h):
                var idx = y*self.get_stride()
                for _ in range(w):
                    var delta = abs(data1.pixels[idx].cast[DType.int32]() - data2.pixels[idx].cast[DType.int32]())
                    if delta>=10:
                        num_diff += 1
                    else:
                        delta = abs(data1.pixels[idx+1].cast[DType.int32]() - data2.pixels[idx+1].cast[DType.int32]())
                        if delta>10:
                            num_diff += 1
                        else:                                    
                            delta = abs(data1.pixels[idx+2].cast[DType.int32]() - data2.pixels[idx+2].cast[DType.int32]())                            
                            if delta>10:
                                num_diff += 1
                            elif rgba:                                    
                                delta = abs(data1.pixels[idx+3].cast[DType.int32]() - data2.pixels[idx+3].cast[DType.int32]())                                
                                if delta>10:
                                    num_diff += 1                                                                            
            result = Float32(num_diff) / Float32(num_pixels) <= 0.05
        return result

    fn to_file(self, filename : Path, file_format : BLFileFormat) raises -> BLResult:
        var res = BL_ERROR_INVALID_HANDLE
        if not self._b2d.is_destroyed():
            var filename1 = file_format.set_extension(filename).__str__()
            var ptr = filename1.unsafe_uint8_ptr()        
            res = self._b2d._handle.get_function[blImageWriteToFile]("blImageWriteToFile")(self.get_core_ptr(), ptr, UnsafePointer[UInt8]())
            _ = filename1       
        return res

    @staticmethod
    fn from_file(filename : Path) raises -> Optional[Self]:
        """
            Only JPEG, PNG and QOI (https://qoiformat.org/).
        """
        var filename1 = filename.__str__()
        var ptr = helpers.string_to_ffi(filename1)
        var result = Optional[Self](None)  
        var _b2d = LibBlend2D.new()
        if _b2d: 
            var b2d = _b2d.take()
            var core = BLImageCore()   
            var res = b2d._handle.get_function[blImageInit]("blImageInit")(UnsafePointer(core))
            if res==BL_SUCCESS:
                var core_ptr = UnsafePointer[BLImageCore](core)
                var res = b2d._handle.get_function[blImageReadFromFile]("blImageReadFromFile")(core_ptr,ptr, UnsafePointer[UInt8]())
                if res==BL_SUCCESS:
                    var img = Self(b2d^, core^)
                    result = Optional[Self](img)
            if res!=BL_SUCCESS:
                print(error_code(res),res)
        ptr.free()
        return result

