from .blcommon import *
from .blerrorcode import *
from .blimage import BLImage, BLImageCore, BLFormat
from .blgeometry import BLRectI, BLPoint, BLPointI
from .blcolor import BLRgba32
from .blcontext import BLRotatePoint
from .bllibblend2d import LibBlend2D
from .blmatrix2d import *
from pathlib import Path

alias blPatternInit = fn(UnsafePointer[BLPatternCore]) -> BLResult
alias blPatternReset = fn(UnsafePointer[BLPatternCore]) -> BLResult
alias blPatternDestroy = fn(UnsafePointer[BLPatternCore]) -> BLResult
alias blPatternCreate = fn(UnsafePointer[BLPatternCore], UnsafePointer[BLImageCore], UnsafePointer[BLRectI], UInt32, UnsafePointer[BLMatrix2D]) -> BLResult

alias blPatternGetArea = fn(UnsafePointer[BLPatternCore], UnsafePointer[BLRectI]) -> BLResult
alias blPatternSetArea = fn(UnsafePointer[BLPatternCore], UnsafePointer[BLRectI]) -> BLResult
alias blPatternResetArea = fn(UnsafePointer[BLPatternCore]) -> BLResult
alias blPatternGetImage = fn(UnsafePointer[BLPatternCore], UnsafePointer[BLImageCore]) -> BLResult

alias blPatternApplyTransformOp = fn(UnsafePointer[BLPatternCore], UInt32, UnsafePointer[UInt8]) -> BLResult

#============================================================================================================
#
#  the low-level Blend2D interface structs
#
#============================================================================================================

@value
struct BLPatternCore:
    var detail: BLObjectDetail

    fn __init__(inout self):
        self.detail = BLObjectDetail()

#============================================================================================================
#
#  the usable objects
#
#============================================================================================================

@value
struct BLPattern:
    var _b2d  : LibBlend2D
    var _core : BLPatternCore
    var _matrix : BLMatrix2D

    fn __init__(inout self, owned b2d : LibBlend2D, owned core : BLPatternCore):
        self._b2d = b2d
        self._core = core
        self._matrix = BLMatrix2D()

    fn __del__(owned self):
        # same comment as for BLImage
        _ = self._b2d._handle.get_function[blPatternDestroy]("blPatternDestroy")(self.get_core_ptr())
        self._b2d.close()   

    @always_inline
    fn get_core_ptr(self) -> UnsafePointer[BLPatternCore]:
        return UnsafePointer[BLPatternCore](self._core)

    @staticmethod
    fn new(img : BLImage, area : BLRectI, mode : BLExtendMode) -> Optional[Self]:
        var result = Optional[Self](None)  
        var _b2d = LibBlend2D.new()
        if _b2d: 
            var b2d = _b2d.take()
            var core = BLPatternCore()  
            var ptr =  UnsafePointer[BLPatternCore](core)   
            var res = b2d._handle.get_function[blPatternInit]("blPatternInit")(ptr)
            if res==BL_SUCCESS:
                var ptr1 = UnsafePointer[BLRectI](area)
                var matrix = BLMatrix2D()
                res = b2d._handle.get_function[blPatternCreate]("blPatternCreate")(ptr, img.get_core_ptr(), ptr1, mode.value, UnsafePointer[BLMatrix2D](matrix))
                if res==BL_SUCCESS:
                    var img = Self(b2d^, core^)
                    result = Optional[Self](img)
            if res!=BL_SUCCESS:
                print("BLPattern failed with ",error_code(res))  
        return result 

    fn set_area(self, area : BLRectI) -> BLResult:
        return self._b2d._handle.get_function[blPatternSetArea]("blPatternSetArea")(self.get_core_ptr(), UnsafePointer[BLRectI](area)) 

    fn get_area(self, inout area : BLRectI) -> BLResult:
        return self._b2d._handle.get_function[blPatternGetArea]("blPatternGetArea")(self.get_core_ptr(), UnsafePointer[BLRectI](area))         

    fn get_image(self, inout img : BLImage) -> BLResult:
        var result = self._b2d._handle.get_function[blPatternGetImage]("blPatternGetImage")(self.get_core_ptr(), img.get_core_ptr())   
        _ = img.refresh_data() # a new image means we need to get the new data back
        return result

    fn reset_area(self) -> BLResult:
        return self._b2d._handle.get_function[blPatternResetArea]("blPatternResetArea")(self.get_core_ptr()) 

    fn scale(inout self, x : Float64, y : Float64) -> BLResult:
        var p = BLPoint(x,y)
        var ptr = UnsafePointer[BLPoint](p).bitcast[UInt8]()
        return self._b2d._handle.get_function[blPatternApplyTransformOp]("blPatternApplyTransformOp")(self.get_core_ptr(), BL_TRANSFORM_OP_SCALE, ptr)         

    fn rotate_point(inout self, radians : Float64, x : Float64, y : Float64) -> BLResult:
        var bytes = BLRotatePoint(radians,x,y)
        var ptr = UnsafePointer[BLRotatePoint](bytes).bitcast[UInt8]()
        return self._b2d._handle.get_function[blPatternApplyTransformOp]("blPatternApplyTransformOp")(self.get_core_ptr(), BL_TRANSFORM_OP_ROTATE_PT, ptr)         

    fn translate(inout self, x : Float64, y : Float64) -> BLResult:
        var p = BLPoint(x,y)
        var ptr = UnsafePointer[BLPoint](p).bitcast[UInt8]()
        return self._b2d._handle.get_function[blPatternApplyTransformOp]("blPatternApplyTransformOp")(self.get_core_ptr(), BL_TRANSFORM_OP_TRANSLATE, ptr)                

    fn identity(inout self) -> BLResult:
        return self._b2d._handle.get_function[blPatternApplyTransformOp]("blPatternApplyTransformOp")(self.get_core_ptr(), BL_TRANSFORM_OP_RESET, UnsafePointer[UInt8]())                


