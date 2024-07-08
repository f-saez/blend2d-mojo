from blerrorcode import *
from blcommon import *
from testing import assert_equal, assert_true
from bllibblend2d import LibBlend2D

alias BL_IMAGE_CODEC_NO_FEATURES: UInt32 = 0	# No features.
alias BL_IMAGE_CODEC_FEATURE_READ: UInt32 = 1	# Image codec supports reading images (can create BLImageDecoder).
alias BL_IMAGE_CODEC_FEATURE_WRITE: UInt32 = 2	# Image codec supports writing images (can create BLImageEncoder).
alias BL_IMAGE_CODEC_FEATURE_LOSSLESS: UInt32 = 4	# Image codec supports lossless compression.
alias BL_IMAGE_CODEC_FEATURE_LOSSY: UInt32 = 8 	 # Image codec supports loosy compression.
alias BL_IMAGE_CODEC_FEATURE_MULTI_FRAME: UInt32 = 16	# Image codec supports writing multiple frames (GIF).
alias BL_IMAGE_CODEC_FEATURE_IPTC: UInt32 = 268435456	# Image codec supports IPTC metadata.
alias BL_IMAGE_CODEC_FEATURE_EXIF: UInt32 = 536870912	# Image codec supports EXIF metadata.
alias BL_IMAGE_CODEC_FEATURE_XMP: UInt32 = 1073741824	# Image codec supports XMP metadata. 

alias findByName = fn(UnsafePointer[UInt8]) -> BLResult

alias blImageCodecInit = fn(UnsafePointer[BLImageCodecCore]) -> BLResult
alias blImageCodecDestroy = fn(UnsafePointer[BLImageCodecCore]) -> BLResult
alias blImageCodecReset = fn(UnsafePointer[BLImageCodecCore]) -> BLResult

#============================================================================================================
#
#          The "enums" part
#
#============================================================================================================

@value
struct BLImageCodecFeatures:
    var value : UInt32

    @staticmethod
    @always_inline
    fn no_features() -> Self:
        return Self(BL_IMAGE_CODEC_NO_FEATURES)

    @staticmethod
    @always_inline
    fn read() -> Self:
        return Self(BL_IMAGE_CODEC_FEATURE_READ)

    @staticmethod
    @always_inline
    fn write() -> Self:
        return Self(BL_IMAGE_CODEC_FEATURE_WRITE)

    @staticmethod
    @always_inline
    fn lossless() -> Self:
        return Self(BL_IMAGE_CODEC_FEATURE_LOSSLESS)

    @staticmethod
    @always_inline
    fn lossy() -> Self:
        return Self(BL_IMAGE_CODEC_FEATURE_LOSSY)

    @staticmethod
    @always_inline
    fn multi_frame() -> Self:
        return Self(BL_IMAGE_CODEC_FEATURE_MULTI_FRAME)

    @staticmethod
    @always_inline
    fn iptc() -> Self:
        return Self(BL_IMAGE_CODEC_FEATURE_IPTC)

    @staticmethod
    @always_inline
    fn exif() -> Self:
        return Self(BL_IMAGE_CODEC_FEATURE_EXIF)

    @staticmethod
    @always_inline
    fn xmp() -> Self:
        return Self(BL_IMAGE_CODEC_FEATURE_XMP)

#============================================================================================================
#
#  the low-level Blend2D interface structs
#
#============================================================================================================
@value
struct BLImageCodecCore:
    var detail: BLObjectDetail

    fn __init__(inout self):
        self.detail = BLObjectDetail()  


@value
struct BLImageCodec:
    var _b2d : LibBlend2D
    var _core : BLImageCodecCore
    var _bl_array_code : BLArrayCore

    fn __init__(inout self, owned b2d: LibBlend2D, owned core : BLImageCodecCore):
        self._b2d = b2d
        self._core = core
        self._bl_array_code = BLArrayCore()
        
    @staticmethod
    fn new() -> Optional[Self]:
        var result = Optional[Self](None)  
        var _b2d = LibBlend2D.new()
        if _b2d: 
            var b2d = _b2d.take()
            var core = BLImageCodecCore()
            var res = b2d._handle.get_function[blImageCodecInit]("blImageCodecInit")(UnsafePointer[BLImageCodecCore](core))
            if res==BL_SUCCESS:
                result = Optional[Self]( Self(b2d^, core^))  
        return result

    fn reset(self) -> BLResult:
        return self._b2d._handle.get_function[blImageCodecReset]("blImageCodecReset")(UnsafePointer(self._core))
            

    fn __del__(owned self):
        # Same comment as BLImage
        _ = self._b2d._handle.get_function[blImageCodecDestroy]("blImageCodecDestroy")(UnsafePointer(self._core))
        self._b2d.close()

fn main() raises:
    var text = String("jpeg")
    var l = len(text)
