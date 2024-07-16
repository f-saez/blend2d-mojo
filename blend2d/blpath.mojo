from .blcommon import *
from .blerrorcode import *
from .bllibblend2d import LibBlend2D
from .blimage import BLImage, BLFormat, BLStrokeCap, BLFileFormat
from .blcolor import BLRgba32
from .blmatrix2d import BLMatrix2D
from .blgeometry import *
from pathlib import Path
import os

alias BL_PATH_REVERSE_MODE_COMPLETE = 0 # Reverse each figure and their order as well (default).
alias BL_PATH_REVERSE_MODE_SEPARATE = 1 # Reverse each figure separately (keeps their order). 

@value
struct BLPathReverseMode:
    var value : UInt32

    @staticmethod
    @always_inline
    fn complete() -> Self:
        return Self(BL_PATH_REVERSE_MODE_COMPLETE)

    @staticmethod
    @always_inline
    fn separate() -> Self:
        return Self(BL_PATH_REVERSE_MODE_SEPARATE)

alias blPathInit = fn(UnsafePointer[BLPathCore]) -> BLResult
alias blPathDestroy = fn(UnsafePointer[BLPathCore]) -> BLResult
alias blPathClear = fn(UnsafePointer[BLPathCore]) -> BLResult
alias blPathReset = fn(UnsafePointer[BLPathCore]) -> BLResult
alias blPathClose = fn(UnsafePointer[BLPathCore]) -> BLResult
alias blPathGetSize = fn(UnsafePointer[BLPathCore]) -> Int

alias blPathMoveTo = fn(UnsafePointer[BLPathCore], Float64, Float64) -> BLResult
alias blPathLineTo = fn(UnsafePointer[BLPathCore], Float64, Float64) -> BLResult
alias blPathQuadTo = fn(UnsafePointer[BLPathCore], Float64, Float64, Float64, Float64) -> BLResult
alias blPathConicTo = fn(UnsafePointer[BLPathCore], Float64, Float64, Float64, Float64, Float64) -> BLResult
alias blPathCubicTo = fn(UnsafePointer[BLPathCore], Float64, Float64, Float64, Float64, Float64, Float64) -> BLResult
alias blPathSmoothQuadTo = fn(UnsafePointer[BLPathCore], Float64, Float64) -> BLResult
alias blPathSmoothCubicTo = fn(UnsafePointer[BLPathCore], Float64, Float64, Float64, Float64) -> BLResult
alias blPathArcTo = fn(UnsafePointer[BLPathCore], Float64, Float64, Float64, Float64, Float64, Float64, Bool) -> BLResult

alias blPathAddBoxI = fn(UnsafePointer[BLPathCore], UnsafePointer[BLBoxI], UInt32) -> BLResult
alias blPathAddBoxD = fn(UnsafePointer[BLPathCore], UnsafePointer[BLBox], UInt32) -> BLResult
alias blPathAddRectI = fn(UnsafePointer[BLPathCore], UnsafePointer[BLRectI], UInt32) -> BLResult
alias blPathAddRectD = fn(UnsafePointer[BLPathCore], UnsafePointer[BLRect], UInt32) -> BLResult
alias blPathAddPath = fn(UnsafePointer[BLPathCore], UnsafePointer[BLPathCore], UnsafePointer[BLRange]) -> BLResult
alias blPathAddReversedPath = fn(UnsafePointer[BLPathCore], UnsafePointer[BLPathCore], UnsafePointer[BLRange], UInt32) -> BLResult
alias blPathAddGeometry = fn(UnsafePointer[BLPathCore], UInt32, UnsafePointer[UInt8], UnsafePointer[BLMatrix2D], UInt32) -> BLResult

alias blPathTranslate = fn(UnsafePointer[BLPathCore], UnsafePointer[BLRange], UnsafePointer[BLPoint]) -> BLResult
alias blPathTransform = fn(UnsafePointer[BLPathCore], UnsafePointer[BLRange], UnsafePointer[BLMatrix2D]) -> BLResult
alias blPathHitTest = fn(UnsafePointer[BLPathCore], UnsafePointer[BLPoint], UInt32) -> BLResult
alias blPathGetBoundingBox = fn(UnsafePointer[BLPathCore], UnsafePointer[BLBox]) -> BLResult

@value
struct BLPathCore:
    var detail: BLObjectDetail

    fn __init__(inout self):
        self.detail = BLObjectDetail()    


@value 
struct BLPath:
    var _b2d  : LibBlend2D
    var _core : BLPathCore
    var bounding_box : BLBox
    
    fn __init__(inout self, owned b2d : LibBlend2D, owned core : BLPathCore):
        self._b2d = b2d
        self._core = core
        self.bounding_box = BLBox()

    @staticmethod
    fn new() -> Optional[Self]:
        var result = Optional[Self](None)  
        var _b2d = LibBlend2D.new()
        if _b2d: 
            var b2d = _b2d.take()
            var core = BLPathCore()
            var res = b2d._handle.get_function[blPathInit]("blPathInit")(UnsafePointer(core))
            if res==BL_SUCCESS:
                result = Optional[Self](Self(b2d^, core^))
            else:
                print("BLContext failed with ",error_code(res))
        return result
    
    @always_inline
    fn get_core_ptr(self) -> UnsafePointer[BLPathCore]:
        return UnsafePointer[BLPathCore](self._core)

    # just for convenience
    # cloning mean adding himself to an empty path
    fn clone(self) -> Optional[Self]:
        var result = Optional[Self](None)
        var aaa = Self.new()
        if aaa:
            var new_path = aaa.take()
            var range = BLRange(0, self.get_size())
            var res = self._b2d._handle.get_function[blPathAddPath]("blPathAddPath")(new_path.get_core_ptr(), self.get_core_ptr(), UnsafePointer[BLRange](range))
            if res==BL_SUCCESS:
                result = Optional[Self](new_path)
        return result

    # size is not the number of high-lebvel geometric objects but the number of
    # basic command to describe these objects.
    # more info in the file "examples/05-path.mojo"
    fn get_size(self) -> Int:
        return self._b2d._handle.get_function[blPathGetSize]("blPathGetSize")(self.get_core_ptr())

    fn clear(self) -> BLResult:
        return self._b2d._handle.get_function[blPathClear]("blPathClear")(self.get_core_ptr())
       
    fn close(self) -> BLResult:
        return self._b2d._handle.get_function[blPathClose]("blPathClose")(self.get_core_ptr())    

    fn reset(self) -> BLResult:
        return self._b2d._handle.get_function[blPathReset]("blPathReset")(self.get_core_ptr())  

    fn move_to(self, x : Float64, y : Float64) -> BLResult:
        return self._b2d._handle.get_function[blPathMoveTo]("blPathMoveTo")(self.get_core_ptr(), x, y)

    fn line_to(self, x : Float64, y : Float64) -> BLResult:
        return self._b2d._handle.get_function[blPathLineTo]("blPathLineTo")(self.get_core_ptr(), x, y)         
     
    fn quad_to(self, x1 : Float64, y1 : Float64, x2 : Float64, y2 : Float64) -> BLResult:
        return self._b2d._handle.get_function[blPathQuadTo]("blPathQuadTo")(self.get_core_ptr(), x1, y1, x2, y2)  

    fn conic_to(self, x1 : Float64, y1 : Float64, x2 : Float64, y2 : Float64, w : Float64) -> BLResult:
        return self._b2d._handle.get_function[blPathConicTo]("blPathConicTo")(self.get_core_ptr(), x1, y1, x2, y2, w)  

    fn cubic_to(self, x1 : Float64, y1 : Float64, x2 : Float64, y2 : Float64, x3 : Float64, y3 : Float64) -> BLResult:
        return self._b2d._handle.get_function[blPathCubicTo]("blPathCubicTo")(self.get_core_ptr(), x1, y1, x2, y2, x3, y3)  

    fn smooth_quad_to(self, x2 : Float64, y2 : Float64) -> BLResult:
        return self._b2d._handle.get_function[blPathSmoothQuadTo]("blPathSmoothQuadTo")(self.get_core_ptr(), x2, y2)  

    fn smooth_cubic_to(self, x2 : Float64, y2 : Float64, x3 : Float64, y3 : Float64) -> BLResult:
        return self._b2d._handle.get_function[blPathSmoothCubicTo]("blPathSmoothCubicTo")(self.get_core_ptr(), x2, y2, x3, y3)  

    fn arc_to(self, x : Float64, y : Float64, rx : Float64, ry : Float64, start : Float64, sweep : Float64, force_move_to : Bool) -> BLResult:
        return self._b2d._handle.get_function[blPathArcTo]("blPathArcTo")(self.get_core_ptr(), x, y, rx, ry, start, sweep, force_move_to) 

    fn add_boxI(self, box : BLBoxI, dir : BLGeometryDirection) -> BLResult:
        return self._b2d._handle.get_function[blPathAddBoxI]("blPathAddBoxI")(self.get_core_ptr(), UnsafePointer[BLBoxI](box), dir.value) 

    fn add_boxD(self, box : BLBox, dir : BLGeometryDirection) -> BLResult:
        return self._b2d._handle.get_function[blPathAddBoxD]("blPathAddBoxD")(self.get_core_ptr(), UnsafePointer[BLBox](box), dir.value) 

    fn add_rectI(self, rect : BLRectI, dir : BLGeometryDirection) -> BLResult:
        return self._b2d._handle.get_function[blPathAddRectI]("blPathAddRectI")(self.get_core_ptr(), UnsafePointer[BLRectI](rect), dir.value) 

    fn add_rectD(self, rect : BLRect, dir : BLGeometryDirection) -> BLResult:
        return self._b2d._handle.get_function[blPathAddRectD]("blPathAddRectD")(self.get_core_ptr(), UnsafePointer[BLRect](rect), dir.value) 

    fn add_path(self, other : BLPath, range : BLRange) -> BLResult:
        return self._b2d._handle.get_function[blPathAddPath]("blPathAddPath")(self.get_core_ptr(), other.ptr_core(), UnsafePointer[BLRange](range)) 

    fn add_reversed_path(self, other : BLPath, range : BLRange, mode : BLPathReverseMode) -> BLResult:
        return self._b2d._handle.get_function[blPathAddReversedPath]("blPathAddReversedPath")(self.get_core_ptr(), other.ptr_core(), UnsafePointer[BLRange](range), mode.value) 

    fn add_triangle(self, geo : BLTriangle, matrix : BLMatrix2D, dir : BLGeometryDirection) -> BLResult:
        var t = BLGeometry.triangle().value
        var ptr = UnsafePointer[BLTriangle](geo).bitcast[UInt8]()
        var ptr_m = UnsafePointer[BLMatrix2D](matrix)
        return self._b2d._handle.get_function[blPathAddGeometry]("blPathAddGeometry")(self.get_core_ptr(),t, ptr, ptr_m, dir.value)
 
    fn add_circle(self, geo : BLCircle, matrix : BLMatrix2D, dir : BLGeometryDirection) -> BLResult:
        var t = BLGeometry.circle().value
        var ptr = UnsafePointer[BLCircle](geo).bitcast[UInt8]()
        var ptr_m = UnsafePointer[BLMatrix2D](matrix)
        return self._b2d._handle.get_function[blPathAddGeometry]("blPathAddGeometry")(self.get_core_ptr(),t, ptr, ptr_m, dir.value)

    fn add_elipse(self, geo : BLElipse, matrix : BLMatrix2D, dir : BLGeometryDirection) -> BLResult:
        var t = BLGeometry.elipse().value
        var ptr = UnsafePointer[BLElipse](geo).bitcast[UInt8]()
        var ptr_m = UnsafePointer[BLMatrix2D](matrix)
        return self._b2d._handle.get_function[blPathAddGeometry]("blPathAddGeometry")(self.get_core_ptr(),t, ptr, ptr_m, dir.value)

    fn add_line(self, geo : BLLine, matrix : BLMatrix2D, dir : BLGeometryDirection) -> BLResult:
        var t = BLGeometry.line().value
        var ptr = UnsafePointer[BLLine](geo).bitcast[UInt8]()
        var ptr_m = UnsafePointer[BLMatrix2D](matrix)
        return self._b2d._handle.get_function[blPathAddGeometry]("blPathAddGeometry")(self.get_core_ptr(),t, ptr, ptr_m, dir.value)

    fn add_arc(self, geo : BLArc, matrix : BLMatrix2D, dir : BLGeometryDirection) -> BLResult:
        var t = BLGeometry.arc().value
        var ptr = UnsafePointer[BLArc](geo).bitcast[UInt8]()
        var ptr_m = UnsafePointer[BLMatrix2D](matrix)
        return self._b2d._handle.get_function[blPathAddGeometry]("blPathAddGeometry")(self.get_core_ptr(),t, ptr, ptr_m, dir.value)

    fn add_pie(self, geo : BLArc, matrix : BLMatrix2D, dir : BLGeometryDirection) -> BLResult:
        var t = BLGeometry.pie().value
        var ptr = UnsafePointer[BLArc](geo).bitcast[UInt8]()
        var ptr_m = UnsafePointer[BLMatrix2D](matrix)
        return self._b2d._handle.get_function[blPathAddGeometry]("blPathAddGeometry")(self.get_core_ptr(),t, ptr, ptr_m, dir.value)

    fn add_round_rect(self, geo : BLRoundRect, matrix : BLMatrix2D, dir : BLGeometryDirection) -> BLResult:
        var t = BLGeometry.round_rect().value
        var ptr = UnsafePointer[BLRoundRect](geo).bitcast[UInt8]()
        var ptr_m = UnsafePointer[BLMatrix2D](matrix)
        return self._b2d._handle.get_function[blPathAddGeometry]("blPathAddGeometry")(self.get_core_ptr(),t, ptr, ptr_m, dir.value)
        
    fn transform(self, range : BLRange, matrix : BLMatrix2D) -> BLResult:
        return self._b2d._handle.get_function[blPathTransform]("blPathTransform")(self.get_core_ptr(), UnsafePointer[BLRange](range), UnsafePointer[BLMatrix2D](matrix)) 

    fn translate(self, range : BLRange, point : BLPoint) -> BLResult:
        return self._b2d._handle.get_function[blPathTranslate]("blPathTranslate")(self.get_core_ptr(), UnsafePointer[BLRange](range), UnsafePointer[BLPoint](point)) 

    fn calc_boundingbox(inout self) -> BLResult:
        return self._b2d._handle.get_function[blPathGetBoundingBox]("blPathGetBoundingBox")(self.get_core_ptr(), UnsafePointer[BLBox](self.bounding_box)) 
    
    fn ptr_core(self) -> UnsafePointer[BLPathCore]:
        return UnsafePointer(self._core)
    
    fn hit_test(self, point : BLPoint) -> Bool:
        var r = self._b2d._handle.get_function[blPathHitTest]("blPathHitTest")(self.get_core_ptr(), UnsafePointer[BLPoint](point), BL_FILL_RULE_NON_ZERO)
        return r == BL_HIT_TEST_IN

    fn destroy(owned self):
        if not self._b2d.is_destroyed():
            _ = self._b2d._handle.get_function[blPathDestroy]("blPathDestroy")(UnsafePointer(self._core)) 
            self._b2d.close()

 