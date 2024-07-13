from .blcommon import BLObjectDetail, BLExtendMode
from .blmatrix2d import BLMatrix2D
from .blgeometry import BLPoint, BLRect, BLRectI
from .blerrorcode import BLResult, BL_SUCCESS, error_code
from .bllibblend2d import LibBlend2D

alias BL_GRADIENT_TYPE_LINEAR:UInt32 = 0 # Linear gradient type.
alias BL_GRADIENT_TYPE_RADIAL:UInt32 = 1 # Radial gradient type.
alias BL_GRADIENT_TYPE_CONIC:UInt32  = 2 # Conic gradient type. 

alias BL_GRADIENT_QUALITY_NEAREST:UInt32 = 0 # Nearest neighbor.
alias BL_GRADIENT_QUALITY_SMOOTH:UInt32 = 1 # Use smoothing, if available (currently never available).
alias BL_GRADIENT_QUALITY_DITHER:UInt32 = 2 # The renderer will use an implementation-specific dithering algorithm to prevent banding. 

alias BL_GRADIENT_VALUE_COMMON_X0:UInt32 = 0 # x0 - start 'x' for a Linear gradient and x center for both Radial and Conic gradients.
alias BL_GRADIENT_VALUE_COMMON_Y0:UInt32 = 1 # y0 - start 'y' for a Linear gradient and y center for both Radial and Conic gradients.
alias BL_GRADIENT_VALUE_COMMON_X1:UInt32 = 2 # x1 - end 'x' for a Linear gradient and focal point x for a Radial gradient.
alias BL_GRADIENT_VALUE_COMMON_Y1:UInt32 = 3 # y1 - end 'y' for a Linear/gradient and focal point y for a Radial gradient.
alias BL_GRADIENT_VALUE_RADIAL_R0:UInt32 = 4 # Radial gradient center radius.
alias BL_GRADIENT_VALUE_RADIAL_R1:UInt32 = 5 # Radial gradient focal radius.
alias BL_GRADIENT_VALUE_CONIC_ANGLE:UInt32 = 6 # Conic gradient angle.
alias BL_GRADIENT_VALUE_CONIC_REPEAT:UInt32 = 7 # Conic gradient angle. 

alias blGradientDestroy = fn(UnsafePointer[BLGradientCore]) -> BLResult
alias blGradientReset = fn(UnsafePointer[BLGradientCore]) -> BLResult
alias blGradientInit = fn(UnsafePointer[BLGradientCore]) -> BLResult
alias blGradientCreate = fn(UnsafePointer[BLGradientCore], UInt32, UnsafePointer[Float64], UInt32, UnsafePointer[BLGradientStop], Int, UnsafePointer[BLMatrix2D]) -> BLResult
alias blGradientAddStopRgba32 = fn(UnsafePointer[BLGradientCore], Float64, UInt32) -> BLResult
alias blGradientAddStopRgba64 = fn(UnsafePointer[BLGradientCore], Float64, UInt64) -> BLResult
alias blGradientGetSize = fn(UnsafePointer[BLGradientCore]) -> Int

#============================================================================================================
#
#          The "enums" part
#
#============================================================================================================

@value
struct BLGradientType:
    var value : UInt32

    @staticmethod
    @always_inline
    fn linear() -> Self:
        return Self(BL_GRADIENT_TYPE_LINEAR)

    @staticmethod
    @always_inline
    fn radial() -> Self:
        return Self(BL_GRADIENT_TYPE_RADIAL)

    @staticmethod
    @always_inline
    fn conic() -> Self:
        return Self(BL_GRADIENT_TYPE_CONIC)

@value
struct BLGradientQuality:
    var value : UInt32

    @staticmethod
    @always_inline
    fn nearest() -> Self:
        return Self(BL_GRADIENT_QUALITY_NEAREST)

    @staticmethod
    @always_inline
    fn smooth() -> Self:
        return Self(BL_GRADIENT_QUALITY_SMOOTH)

    @staticmethod
    @always_inline
    fn dither() -> Self:
        return Self(BL_GRADIENT_QUALITY_DITHER)

@value
struct BLGradientValue:
    var value : UInt32

    @staticmethod
    @always_inline
    fn common_x0() -> Self:
        return Self(BL_GRADIENT_VALUE_COMMON_X0)

    @staticmethod
    @always_inline
    fn common_y0() -> Self:
        return Self(BL_GRADIENT_VALUE_COMMON_Y0)   

    @staticmethod
    @always_inline
    fn common_x1() -> Self:
        return Self(BL_GRADIENT_VALUE_COMMON_X1)

    @staticmethod
    @always_inline
    fn common_y1() -> Self:
        return Self(BL_GRADIENT_VALUE_COMMON_Y1)   

    @staticmethod
    @always_inline
    fn radial_r0() -> Self:
        return Self(BL_GRADIENT_VALUE_RADIAL_R0)   

    @staticmethod
    @always_inline
    fn radial_r1() -> Self:
        return Self(BL_GRADIENT_VALUE_RADIAL_R1)   

    @staticmethod
    @always_inline
    fn conic_angle() -> Self:
        return Self(BL_GRADIENT_VALUE_CONIC_ANGLE)   

    @staticmethod
    @always_inline
    fn conic_repeat() -> Self:
        return Self(BL_GRADIENT_VALUE_CONIC_REPEAT)   

#============================================================================================================
#
#  the low-level Blend2D interface structs
#
#============================================================================================================

@value
struct BLGradientCore:
    var detail: BLObjectDetail

    fn __init__(inout self):
        self.detail = BLObjectDetail()

@value
struct BLLinearGradientValues:
    var x0: Float64
    var y0: Float64
    var x1: Float64
    var y1: Float64

    @staticmethod    
    fn from_rect(rect : BLRect) -> Self:
        return Self(rect.x, rect.y, rect.x + rect.w, rect.y + rect.h)

    @staticmethod    
    fn from_rectI(rect : BLRectI) -> Self:
        var x = rect.x.cast[DType.float64]()
        var y = rect.y.cast[DType.float64]()
        var w = rect.w.cast[DType.float64]()
        var h = rect.h.cast[DType.float64]()
        return Self( x, y, x+w, y+h)

@value
struct BLGradientStop:
    var offset: Float64
    var rgba: BLRgba64 

    @staticmethod
    @always_inline
    fn new(offset : Float64, r : UInt8, g : UInt8, b : UInt8, a : UInt8) -> Self:    
        return Self(offset, BLRgba64.rgba(r,g,b,a))

#============================================================================================================
#
#  the usable objects
#
#============================================================================================================
struct BLRgba32(Stringable):
    var value: UInt32  # 32-bit RGBA color (8-bit per component) stored as `0xAARRGGBB

    fn __init__(inout self, v : UInt32):
        self.value = v   
           
    @staticmethod
    @always_inline
    fn rgba(r : UInt8, g : UInt8, b : UInt8, a : UInt8) -> Self:
        var g1 = g.cast[DType.uint32]() << 8
        var r1 = r.cast[DType.uint32]() << 16
        var a1 = a.cast[DType.uint32]() << 24 
        var v = b.cast[DType.uint32]() + g1 + r1 + a1        
        return Self(v)

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        var r = Int(self.get_r().cast[DType.int32]().value)
        var g = Int(self.get_g().cast[DType.int32]().value)
        var b = Int(self.get_b().cast[DType.int32]().value)
        var a = Int(self.get_a().cast[DType.int32]().value)
        return String("r: ")+String(r)+String(" g: ")+String(g)+String(" b: ")+String(b)+String(" a: ")+String(a)

    @staticmethod
    @always_inline
    fn white() -> Self:
        return Self.rgba(255,255,255,255)

    @staticmethod
    @always_inline
    fn black() -> Self:
        return Self.rgba(0,0,0,0)
        
    @staticmethod
    @always_inline
    fn rgb(r : UInt8, g : UInt8, b : UInt8) -> Self:
        return Self.rgba(r,g,b,255)
    
    @always_inline
    fn is_opaque(self) -> Bool:
        return self.get_a() == 255
    
    @always_inline
    fn is_transparent(self) -> Bool:
        return self.get_a() == 0

    @always_inline
    fn set_b(inout self, b : UInt8):
        var b1 = b.cast[DType.uint32]()
        var v = self.value & 0xFFFFFF00
        self.value = (self.value & 0xFFFFFF00) + b1

    @always_inline
    fn set_g(inout self, g : UInt8):
        var g1 = g.cast[DType.uint32]() << 8
        self.value = (self.value & 0xFFFF00FF) + g1

    @always_inline
    fn set_r(inout self, r : UInt8):
        var r1 = r.cast[DType.uint32]() << 16
        self.value = (self.value & 0xFF00FFFF) + r1

    @always_inline
    fn set_a(inout self, a : UInt8):
        var a1 = a.cast[DType.uint32]() << 24
        self.value = (self.value & 0x00FFFFFF) + a1

    @always_inline
    fn get_b(self) -> UInt8:
        var b1 = self.value & 0x000000FF
        return b1.cast[DType.uint8]()

    @always_inline
    fn get_g(self) -> UInt8:
        var g1 = (self.value & 0xFF00) >> 8
        return (g1 & 255).cast[DType.uint8]()

    @always_inline
    fn get_r(self) -> UInt8:
        var r1 = (self.value & 0xFF0000) >> 16
        return (r1 & 255).cast[DType.uint8]()

    @always_inline
    fn get_a(self) -> UInt8:
        var a1 = self.value >> 24
        return a1.cast[DType.uint8]()



@value
struct BLRgba64:
    var value: UInt64  # 64-bit RGBA color (16-bit per component) stored as `0xAAAARRRRGGGGBBBB

    @staticmethod
    @always_inline
    fn from_rgba32(colour : BLRgba32) -> Self:
        # it's really the worst way to do this king of thing
        # but this function is barely used so ...
        return Self.rgba(colour.get_r(), colour.get_g(), colour.get_b(), colour.get_a())    

    @staticmethod
    @always_inline
    fn rgba(r : UInt8, g : UInt8, b : UInt8, a : UInt8) -> Self:
        # could do this with integer algebra
        # should be a little bit faster but, again, the only use for BLRgba64
        # is for the first stop of the gradients and I don't use gradients
        var tmp = SIMD[DType.uint8, size=4](a,r,g,b)
        var tmp2 = tmp.cast[DType.float32]()
        tmp2 /= 255 # normalize to [0,1]
        tmp2 *= 65535 # back to [0,UInt16.max]
        var tmp3 = tmp2.cast[DType.uint64]()
        tmp3 *= SIMD[DType.uint64, size=4](281474976710656,4294967296,65536,1) # <<48, <<32, <<16
        return Self(tmp3.reduce_add())

    @staticmethod
    @always_inline
    fn rgb(r : UInt8, g : UInt8, b : UInt8) -> Self:
        return Self.rgba(r,g,b,255)

@value
struct BLGradient:
    var _b2d  : LibBlend2D
    var _core : BLGradientCore

    fn __init__(inout self, owned b2d : LibBlend2D, owned core : BLGradientCore):
        self._b2d = b2d
        self._core = core

    fn __del__(owned self):
        # I'm not sure in what order the destructor destroy his objects
        # but if I let him do it in is his own way, I run into troubles with LibBlend2D's destructor
        # maybe a bug, maybe a misunderstanding, maybe a lifetime thing, ...
        # to solve this, I close manually LibBlend2D after I'm done with it.
        # Not a big deal.
        _ = self._b2d._handle.get_function[blGradientDestroy]("blGradientDestroy")(self.get_core_ptr())
        self._b2d.close()   

    @always_inline
    fn get_core_ptr(self) -> UnsafePointer[BLGradientCore]:
        return UnsafePointer[BLGradientCore](self._core)

    @staticmethod
    fn new_linear(values : BLLinearGradientValues, mode : BLExtendMode, stop : BLGradientStop, matrix : BLMatrix2D) -> Optional[Self]:
        var result = Optional[Self](None)  
        var _b2d = LibBlend2D.new()
        if _b2d: 
            var b2d = _b2d.take()
            var core = BLGradientCore()  
            var ptr =  UnsafePointer[BLGradientCore](core)   
            var res = b2d._handle.get_function[blGradientInit]("blGradientInit")(ptr)
            if res==BL_SUCCESS:
                var ptr1 = UnsafePointer[BLLinearGradientValues](values).bitcast[Float64]() # => 4xFloat64 in a row
                res = b2d._handle.get_function[blGradientCreate]("blGradientCreate")(ptr, BLGradientType.linear().value, ptr1, mode.value, UnsafePointer[BLGradientStop](stop), 1, UnsafePointer[BLMatrix2D](matrix))
                if res==BL_SUCCESS:
                    var img = Self(b2d^, core^)
                    result = Optional[Self](img)
            if res!=BL_SUCCESS:
                print("BLGradient failed with ",error_code(res))  
        return result        

    @always_inline
    fn get_size(self) -> Int:
        return self._b2d._handle.get_function[blGradientGetSize]("blGradientGetSize")(self.get_core_ptr())        
    
    @always_inline        
    fn add_stop(self, offset : Float64, colour : BLRgba32 ) -> BLResult:
        return self._b2d._handle.get_function[blGradientAddStopRgba32]("blGradientAddStopRgba32")(self.get_core_ptr(), offset, colour.value)        

    fn add_stop_rgba64(self, offset : Float64, colour : BLRgba64 ) -> BLResult:
        return self._b2d._handle.get_function[blGradientAddStopRgba64]("blGradientAddStopRgba64")(self.get_core_ptr(), offset, colour.value)        
