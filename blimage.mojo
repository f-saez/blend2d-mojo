from blerrorcode import *
from blcommon import *
from blcontext import BLContext, BLStrokeCap
from blpath import BLPath
from bllibblend2d import LibBlend2D
from pathlib import Path
from testing import assert_equal, assert_true
import os
from helpers import create_path_if_not_exists, set_extension, string_to_ffi
from blcodec import BLArrayCore

alias BLFormat_BL_FORMAT_NONE: UInt32   = 0
alias BLFormat_BL_FORMAT_PRGB32: UInt32 = 1  # pre-multiplied
alias BLFormat_BL_FORMAT_XRGB32: UInt32 = 2  # alpha ignore, ie always opaque
alias BLFormat_BL_FORMAT_A8: UInt32     = 3

alias BLDataAccessFlags_BL_DATA_ACCESS_NO_FLAGS: Int32 = 0
alias BLDataAccessFlags_BL_DATA_ACCESS_READ: Int32     = 1
alias BLDataAccessFlags_BL_DATA_ACCESS_WRITE: Int32    = 2
alias BLDataAccessFlags_BL_DATA_ACCESS_RW: Int32       = 3

alias BLImageScaleFilter_BL_IMAGE_SCALE_FILTER_NONE: Int32 = 0
alias BLImageScaleFilter_BL_IMAGE_SCALE_FILTER_NEAREST: Int32 = 1
alias BLImageScaleFilter_BL_IMAGE_SCALE_FILTER_BILINEAR: Int32 = 2
alias BLImageScaleFilter_BL_IMAGE_SCALE_FILTER_BICUBIC: Int32 = 3
alias BLImageScaleFilter_BL_IMAGE_SCALE_FILTER_LANCZOS: Int32 = 4

alias blImageInit = fn(UnsafePointer[BLImageCore]) -> BLResult
alias blImageReset = fn(UnsafePointer[BLImageCore]) -> BLResult
alias blImageGetData = fn(UnsafePointer[BLImageCore], UnsafePointer[BLImageData]) -> BLResult
alias blImageDestroy = fn(UnsafePointer[BLImageCore]) -> BLResult
alias blImageCreate = fn(UnsafePointer[BLImageCore], Int32, Int32, UInt32) -> BLResult
alias blImageWriteToFile = fn(UnsafePointer[BLImageCore], UnsafePointer[UInt8], UnsafePointer[UInt8]) -> BLResult # should be UnsafePointer[BLImageCodecCore]
alias blImageReadFromFile = fn(UnsafePointer[BLImageCore], UnsafePointer[UInt8], UnsafePointer[UInt8]) -> BLResult # should be UnsafePointer[BLImageCodecCore]

alias blImageReadFromData = fn(UnsafePointer[BLImageCore], UnsafePointer[UInt8], Int, UnsafePointer[UInt8]) -> BLResult 

alias blImageCodecArrayInitBuiltInCodecs = fn(UnsafePointer[BLArrayCore], UInt32) -> BLResult
alias blArrayInit = fn(UnsafePointer[BLArrayCore], UInt32) -> BLResult

@value
struct BLFileFormat:
    var ext : String

    fn __init__(inout self, owned value : String):
        self.ext = value

    fn set_extension(self, filename : Path) -> Path:
        return set_extension(filename, self.ext)

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
        if value==BLFormat_BL_FORMAT_PRGB32:
            self._bpp = 4
        elif value==BLFormat_BL_FORMAT_XRGB32:
            self._bpp = 4
        elif value==BLFormat_BL_FORMAT_A8:            
            self._bpp = 1

    @staticmethod
    @always_inline
    fn none() -> Self:
        return Self(BLFormat_BL_FORMAT_NONE)

    @staticmethod
    @always_inline
    fn prgb32() -> Self:
        return Self(BLFormat_BL_FORMAT_PRGB32)

    @staticmethod
    @always_inline
    fn xrgb32() -> Self:
        return Self(BLFormat_BL_FORMAT_XRGB32)

    @staticmethod
    @always_inline
    fn a8() -> Self:
        return Self(BLFormat_BL_FORMAT_A8)

    @always_inline
    fn bpp(self) -> Int:
        return self._bpp

@value
struct BLDataAccessFlag:     
    
    @staticmethod
    @always_inline
    fn no_flags() -> Int32:
        return BLDataAccessFlags_BL_DATA_ACCESS_NO_FLAGS

    @staticmethod
    @always_inline
    fn read() -> Int32:
        return BLDataAccessFlags_BL_DATA_ACCESS_READ     

    @staticmethod
    @always_inline
    fn write() -> Int32:
        return BLDataAccessFlags_BL_DATA_ACCESS_WRITE          

    @staticmethod
    @always_inline
    fn rw() -> Int32:
        return BLDataAccessFlags_BL_DATA_ACCESS_RW                 

@value
struct BLImageScaleFilter:    
    @staticmethod
    @always_inline
    fn none() -> Int32:
      return BLImageScaleFilter_BL_IMAGE_SCALE_FILTER_NONE

    @staticmethod
    @always_inline
    fn nearest() -> Int32:
      return BLImageScaleFilter_BL_IMAGE_SCALE_FILTER_NEAREST

    @staticmethod
    @always_inline
    fn bilinear() -> Int32:
      return BLImageScaleFilter_BL_IMAGE_SCALE_FILTER_BILINEAR

    @staticmethod
    @always_inline
    fn bicubic() -> Int32:
      return BLImageScaleFilter_BL_IMAGE_SCALE_FILTER_BICUBIC

    @staticmethod
    @always_inline
    fn lanczos() -> Int32:
      return BLImageScaleFilter_BL_IMAGE_SCALE_FILTER_LANCZOS

      
        
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

@value
struct BLImageCore:
    var detail : BLObjectDetail

    fn __init__(inout self):
        self.detail = BLObjectDetail()

@value
struct BLImage:
    var _b2d : LibBlend2D
    var _core : BLImageCore
    var _data : BLImageData

    fn __init__(inout self, owned b2d : LibBlend2D, owned core : BLImageCore):
        self._b2d = b2d
        self._core = core
        self._data = BLImageData()
        var res = self._b2d._handle.get_function[blImageGetData]("blImageGetData")(UnsafePointer(core), UnsafePointer(self._data))
        if res!=BL_SUCCESS:
            # if it fails, I don't know why but it could means the data retreived is garbage so.
            self._data = BLImageData()


    fn __del__(owned self):
        # I'm not sure in what order the destructor destroy his objects
        # but if I let him do it in is his own way, I run into troubles with LibBlend2D's destructor
        # maybe a bug, maybe a misunderstanding, maybe a lifetime thing, ...
        # to solve this, I close manually LibBlend2D after I'm done with it.
        # Not a big deal.
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
                    print("BLFontData failed with ",error_code(res))  
        return result

    fn create_context(self, threadcount : UInt32) -> Optional[BLContext]:
        var stuff = BLContext.begin(self, threadcount)
        return stuff

    @always_inline
    fn get_width(self) -> Int32:
        return self._data.size.w

    @always_inline
    fn get_height(self) -> Int32:
        return self._data.size.h

    @always_inline
    fn get_format(self) -> BLFormat:
        return self._data.format

    @always_inline
    fn get_stride(self) -> Int:
        return self._data.stride

    @always_inline
    fn get_core_ptr(self) -> UnsafePointer[BLImageCore]:
        return UnsafePointer[BLImageCore](self._core)

    fn reset(self) -> BLResult:
        return self._b2d._handle.get_function[blImageReset]("blImageReset")(UnsafePointer(self._core))

    fn image_info(self) -> BLResult:
        return self._b2d._handle.get_function[blImageReset]("blImageReset")(UnsafePointer(self._core))

    fn get_data(self) -> Optional[BLImageData]:
        """
            return some data on the image. It's very light, it just copy some internal stuff to
            a struct.
        """
        var data = BLImageData()
        var result = Optional[BLImageData](None)
        var res = self._b2d._handle.get_function[blImageGetData]("blImageGetData")(UnsafePointer(self._core), UnsafePointer(data))
        if res==BL_SUCCESS:
            result = Optional[BLImageData](data)
        else:
            print(error_code(res))
        return result

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
            var aaa = self.get_data()
            if aaa:
                var aab = other.get_data()
                if aab:
                    var data1 = aaa.take()
                    var data2 = aab.take()
                    # a dumb way to do that, but who cares ?
                    for y in range(h):
                        var idx = y*self.get_stride()
                        for x in range(w):
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
        create_path_if_not_exists(filename)
        var filename1 = file_format.set_extension(filename).__str__()
        var ptr = string_to_ffi(filename1)
        var res = self._b2d._handle.get_function[blImageWriteToFile]("blImageWriteToFile")(self.get_core_ptr(), ptr, UnsafePointer[UInt8]())
        ptr.free()
        return res

    @staticmethod
    fn from_file(filename : Path) raises -> Optional[Self]:
        """
            Only JPEG, PNG and QOI (https://qoiformat.org/).
        """
        var filename1 = string_to_ffi(filename.__str__())
        var result = Optional[Self](None)  
        var _b2d = LibBlend2D.new()
        if _b2d: 
            var b2d = _b2d.take()
            var core = BLImageCore()   
            var res = b2d._handle.get_function[blImageInit]("blImageInit")(UnsafePointer(core))
            if res==BL_SUCCESS:
                var core_ptr = UnsafePointer[BLImageCore](core)
                var res = b2d._handle.get_function[blImageReadFromFile]("blImageReadFromFile")(core_ptr,filename1, UnsafePointer[UInt8]())
                if res==BL_SUCCESS:
                    var img = Self(b2d^, core^)
                    result = Optional[Self](img)
            if res!=BL_SUCCESS:
                print(error_code(res),res)
        filename1.free()
        return result

    @staticmethod
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

        r = ctx.fill_rect_rgba32(BLRectI(150,150,320,240), BLRgba32.rgb(55,55,55) )
        assert_equal(r, BL_SUCCESS)

        assert_equal(r, BL_SUCCESS)
        var rect = BLRect(150,150,320,240)
        r = ctx.fill_rectd_rgba32(rect, BLRgba32.rgb(55,55,165) )
        assert_equal(r, BL_SUCCESS)
        r = ctx.save()
        assert_equal(r, BL_SUCCESS)
        r = ctx.identity()
        assert_equal(r, BL_SUCCESS)
        r = ctx.rotate_pt(0.1, rect.x+rect.w/2, rect.y+rect.h/2)
        assert_equal(r, BL_SUCCESS)  
        r = ctx.stroke_rectd_rgba32(rect, BLRgba32.rgb(165,55,55) )
        assert_equal(r, BL_SUCCESS)

        r = ctx.restore()
        assert_equal(r, BL_SUCCESS)
        
        var file_format = BLFileFormat.qoi()
        var filename = file_format.set_extension( Path("test").joinpath("image"))
        r = img.to_file(filename, file_format)
        assert_equal(r, BL_SUCCESS)

        var aaa = BLImage.from_file(Path("test").joinpath("image_ref.qoi"))
        assert_true(aaa)
        var img_ref = aaa.take()
        assert_true(img_ref.almost_equal(img, True))

        os.path.path.remove(filename)

    @staticmethod
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
                             

fn validation() raises:
    BLImage.validation()
    BLImage.validation_codecs()
