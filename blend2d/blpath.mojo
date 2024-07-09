from .blcommon import *
from .blerrorcode import *
from .bllibblend2d import LibBlend2D
from .blimage import BLImage, BLFormat, BLStrokeCap, BLFileFormat
from .blcolor import BLRgba32
from pathlib import Path
import os

alias blPathInit = fn(UnsafePointer[BLPathCore]) -> BLResult
alias blPathDestroy = fn(UnsafePointer[BLPathCore]) -> BLResult
alias blPathClear = fn(UnsafePointer[BLPathCore]) -> BLResult
alias blPathReset = fn(UnsafePointer[BLPathCore]) -> BLResult
alias blPathClose = fn(UnsafePointer[BLPathCore]) -> BLResult
alias blPathMoveTo = fn(UnsafePointer[BLPathCore], Float64, Float64) -> BLResult
alias blPathLineTo = fn(UnsafePointer[BLPathCore], Float64, Float64) -> BLResult
alias blPathQuadTo = fn(UnsafePointer[BLPathCore], Float64, Float64, Float64, Float64) -> BLResult
alias blPathConicTo = fn(UnsafePointer[BLPathCore], Float64, Float64, Float64, Float64, Float64) -> BLResult
alias blPathCubicTo = fn(UnsafePointer[BLPathCore], Float64, Float64, Float64, Float64, Float64, Float64) -> BLResult
alias blPathSmoothQuadTo = fn(UnsafePointer[BLPathCore], Float64, Float64) -> BLResult
alias blPathSmoothCubicTo = fn(UnsafePointer[BLPathCore], Float64, Float64, Float64, Float64) -> BLResult

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

    fn clear(self) -> BLResult:
        return self._b2d._handle.get_function[blPathClear]("blPathClear")(UnsafePointer(self._core))
       
    fn close(self) -> BLResult:
        return self._b2d._handle.get_function[blPathClose]("blPathClose")(UnsafePointer(self._core))    

    fn reset(self) -> BLResult:
        return self._b2d._handle.get_function[blPathReset]("blPathReset")(UnsafePointer(self._core))  

    fn move_to(self, x : Float64, y : Float64) -> BLResult:
        return self._b2d._handle.get_function[blPathMoveTo]("blPathMoveTo")(UnsafePointer(self._core), x, y)

    fn line_to(self, x : Float64, y : Float64) -> BLResult:
        return self._b2d._handle.get_function[blPathLineTo]("blPathLineTo")(UnsafePointer(self._core), x, y)         
     
    fn quad_to(self, x1 : Float64, y1 : Float64, x2 : Float64, y2 : Float64) -> BLResult:
        return self._b2d._handle.get_function[blPathQuadTo]("blPathQuadTo")(UnsafePointer(self._core), x1, y1, x2, y2)  

    fn conic_to(self, x1 : Float64, y1 : Float64, x2 : Float64, y2 : Float64, w : Float64) -> BLResult:
        return self._b2d._handle.get_function[blPathConicTo]("blPathConicTo")(UnsafePointer(self._core), x1, y1, x2, y2, w)  

    fn cubic_to(self, x1 : Float64, y1 : Float64, x2 : Float64, y2 : Float64, x3 : Float64, y3 : Float64) -> BLResult:
        return self._b2d._handle.get_function[blPathCubicTo]("blPathCubicTo")(UnsafePointer(self._core), x1, y1, x2, y2, x3, y3)  

    fn smooth_quad_to(self, x2 : Float64, y2 : Float64) -> BLResult:
        return self._b2d._handle.get_function[blPathSmoothQuadTo]("blPathSmoothQuadTo")(UnsafePointer(self._core), x2, y2)  

    fn smooth_cubic_to(self, x2 : Float64, y2 : Float64, x3 : Float64, y3 : Float64) -> BLResult:
        return self._b2d._handle.get_function[blPathSmoothCubicTo]("blPathSmoothCubicTo")(UnsafePointer(self._core), x2, y2, x3, y3)  

    fn calc_boundingbox(inout self) -> BLResult:
        return self._b2d._handle.get_function[blPathGetBoundingBox]("blPathGetBoundingBox")(UnsafePointer(self._core), UnsafePointer(self.bounding_box)) 
    
    fn ptr_core(self) -> UnsafePointer[BLPathCore]:
        return UnsafePointer(self._core)

    fn __del__(owned self):
        # same comment as BLImage
        _ = self._b2d._handle.get_function[blPathDestroy]("blPathDestroy")(UnsafePointer(self._core)) 
        self._b2d.close()

    @staticmethod
    fn validation() raises:
        var tmp = BLImage.new(1024,768, BLFormat.xrgb32())
        assert_true(tmp)
        var img = tmp.take()

        var aa = img.create_context(2)
        assert_true(aa)
        var ctx = aa.take()
        var r = ctx.set_fill_style_colour( BLRgba32.rgb(215,215,215) )
        if r!=BL_SUCCESS:
            print(error_code(r))
        assert_equal(r, BL_SUCCESS)
        r = ctx.fill_all()
        assert_equal(r, BL_SUCCESS)
        var ab = BLPath.new()
        assert_true(ab)
        var path = ab.take()

        r = path.move_to(26, 31)
        assert_equal(r, BL_SUCCESS)

        r = path.cubic_to(642, 132, 587, -136, 25, 464)
        assert_equal(r, BL_SUCCESS)

        r = path.cubic_to(882, 404, 144, 267, 27, 31)
        assert_equal(r, BL_SUCCESS)

        r = path.close()
        assert_equal(r, BL_SUCCESS)
        var p = BLPoint.new(15,13)
        r = ctx.fill_pathd_rgba32(p, path, BLRgba32.rgb(215,0,0))
        assert_equal(r, BL_SUCCESS)
        r = ctx.set_stroke_width(3.0)    
        assert_equal(r, BL_SUCCESS)
        r = ctx.stroke_pathd_rgba32(p, path, BLRgba32.rgb(15,15,15))
        assert_equal(r, BL_SUCCESS)
        
        r = path.clear()
        assert_equal(r, BL_SUCCESS)
        r = path.move_to(119, 49)
        assert_equal(r, BL_SUCCESS)
        r = path.cubic_to(259, 29, 99, 279, 275, 267)
        assert_equal(r, BL_SUCCESS)
        r = path.cubic_to(537, 245, 300, -170, 274, 430)
        assert_equal(r, BL_SUCCESS)
        r = ctx.set_stroke_start_cap(BLStrokeCap.triangle())    
        assert_equal(r, BL_SUCCESS)
        r = ctx.set_stroke_end_cap(BLStrokeCap.triangle_rev())    
        assert_equal(r, BL_SUCCESS)    
        p = BLPoint.new(380,22)
        r = ctx.set_stroke_width(22.0)    
        assert_equal(r, BL_SUCCESS)    
        r = ctx.stroke_pathd_rgba32(p, path, BLRgba32.rgb(115,125,145))
        assert_equal(r, BL_SUCCESS)    
        r = ctx.end()
        assert_equal(r, BL_SUCCESS)

        var file_format = BLFileFormat.qoi()
        var filename = file_format.set_extension( Path("test").joinpath("path"))
        r = img.to_file(filename, file_format)
        assert_equal(r, BL_SUCCESS)

        var aaa = BLImage.from_file(Path("test").joinpath("path_ref.qoi"))
        assert_true(aaa)
        var img_ref = aaa.take()
        assert_true(img_ref.almost_equal(img, True))

        os.path.path.remove(filename)