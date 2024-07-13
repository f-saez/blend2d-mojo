from .blcommon import *
from .blerrorcode import *
from .blimage import BLImage, BLImageCore
from .blpath import BLPath, BLPathCore
from .blfont import BLFont, BLFontCore, BLGlyphBuffer, BLGlyphRun
from .blmatrix2d import *
from .blcolor import BLRgba32, BLGradient
from .blgeometry import *
from .blpattern import BLPattern, BLPatternCore
from .bllibblend2d import LibBlend2D

alias BL_CONTEXT_CREATE_NO_FLAGS: UInt32 = 0
alias BL_CONTEXT_CREATE_FLAG_DISABLE_JIT: UInt32 = 1
alias BL_CONTEXT_CREATE_FLAG_FALLBACK_TO_SYNC: UInt32 = 1048576
alias BL_CONTEXT_CREATE_FLAG_ISOLATED_THREAD_POOL: UInt32 = 16777216
alias BL_CONTEXT_CREATE_FLAG_ISOLATED_JIT_RUNTIMEL: UInt32 = 33554432
alias BL_CONTEXT_CREATE_FLAG_ISOLATED_JIT_LOGGING: UInt32 = 67108864
alias BL_CONTEXT_CREATE_FLAG_OVERRIDE_CPU_FEATURES: UInt32 = 134217728

alias BL_CONTEXT_HINT_RENDERING_QUALITY: UInt32 = 0 # Rendering quality.
alias BL_CONTEXT_HINT_GRADIENT_QUALITY: UInt32 = 1 	# Gradient quality.
alias BL_CONTEXT_HINT_PATTERN_QUALITY: UInt32 = 2 	# Pattern quality. 

alias BL_PATTERN_QUALITY_NEAREST:UInt32 = 0 # Nearest neighbor interpolation.
alias BL_PATTERN_QUALITY_BILINEAR:UInt32 = 1 # Bilinear interpolation. 

alias BL_COMP_OP_SRC_OVER:UInt32 = 0 # Source-over [default].
alias BL_COMP_OP_SRC_COPY:UInt32 = 1 # Source-copy.
alias BL_COMP_OP_SRC_IN:UInt32 = 2 # Source-in.
alias BL_COMP_OP_SRC_OUT:UInt32 = 3 # Source-out.
alias BL_COMP_OP_SRC_ATOP:UInt32 = 4 # Source-atop.
alias BL_COMP_OP_DST_OVER:UInt32 = 5 # Destination-over.
alias BL_COMP_OP_DST_COPY:UInt32 = 6 # Destination-copy [nop].
alias BL_COMP_OP_DST_IN:UInt32 = 7 # Destination-in.
alias BL_COMP_OP_DST_OUT:UInt32 = 8 # Destination-out.
alias BL_COMP_OP_DST_ATOP:UInt32 = 9 # Destination-atop.
alias BL_COMP_OP_XOR:UInt32 = 10 # Xor.
alias BL_COMP_OP_CLEAR:UInt32 = 11 # Clear.
alias BL_COMP_OP_PLUS:UInt32 = 12 # Plus.
alias BL_COMP_OP_MINUS:UInt32 = 13 # Minus.
alias BL_COMP_OP_MODULATE:UInt32 = 14 # Modulate.
alias BL_COMP_OP_MULTIPLY:UInt32 = 15 # Multiply.
alias BL_COMP_OP_SCREEN:UInt32 = 16 # Screen.
alias BL_COMP_OP_OVERLAY:UInt32 = 17 # Overlay.
alias BL_COMP_OP_DARKEN:UInt32 = 18 # Darken.
alias BL_COMP_OP_LIGHTEN:UInt32 = 19 # Lighten.
alias BL_COMP_OP_COLOR_DODGE:UInt32 = 20 # Color dodge.
alias BL_COMP_OP_COLOR_BURN:UInt32 = 21 # Color burn.
alias BL_COMP_OP_LINEAR_BURN:UInt32 = 22 # Linear burn.
alias BL_COMP_OP_LINEAR_LIGHT:UInt32 = 23 # Linear light.
alias BL_COMP_OP_PIN_LIGHT:UInt32 = 24 # Pin light.
alias BL_COMP_OP_HARD_LIGHT:UInt32 = 25 # Hard-light.
alias BL_COMP_OP_SOFT_LIGHT:UInt32 = 26 # Soft-light.
alias BL_COMP_OP_DIFFERENCE:UInt32 = 27 # Difference.
alias BL_COMP_OP_EXCLUSION:UInt32 = 28 # Exclusion. 

alias BL_STROKE_CAP_BUTT: UInt32 = 0
alias BL_STROKE_CAP_SQUARE: UInt32 = 1
alias BL_STROKE_CAP_ROUND: UInt32 = 2
alias BL_STROKE_CAP_ROUND_REV: UInt32 = 3
alias BL_STROKE_CAP_TRIANGLE: UInt32 = 4
alias BL_STROKE_CAP_TRIANGLE_REV: UInt32 = 5

alias BL_STROKE_CAP_POSITION_START: UInt32 = 0	
alias BL_STROKE_CAP_POSITION_END: UInt32 = 1

alias BL_RENDERING_QUALITY_ANTIALIAS = 0
alias BL_CONTEXT_FLUSH_NO_FLAGS = 0



alias blContextInitAs = fn(UnsafePointer[BLContextCore], UnsafePointer[BLImageCore], UnsafePointer[BLContextCreateInfo]) -> BLResult
alias blContextEnd = fn(UnsafePointer[BLContextCore]) -> BLResult
alias blContextDestroy = fn(UnsafePointer[BLContextCore]) -> BLResult
alias blContextFlush = fn(UnsafePointer[BLContextCore]) -> BLResult
alias blContextClearAll = fn(UnsafePointer[BLContextCore]) -> BLResult

alias blContextSave = fn(UnsafePointer[BLContextCore], UnsafePointer[BLContextCookie]) -> BLResult
alias blContextRestore = fn(UnsafePointer[BLContextCore], UnsafePointer[BLContextCookie]) -> BLResult
alias blContextSetCompOp = fn(UnsafePointer[BLContextCore], UInt32) -> BLResult
alias blContextApplyTransformOp = fn(UnsafePointer[BLContextCore], UInt32, UnsafePointer[UInt8]) -> BLResult

alias blContextSetStrokeWidth = fn(UnsafePointer[BLContextCore], Float64) -> BLResult
alias blContextSetStrokeStyleRgba32 = fn(UnsafePointer[BLContextCore], UInt32) -> BLResult
alias blContextStrokeRectI = fn(UnsafePointer[BLContextCore], UnsafePointer[BLRectI]) -> BLResult
alias blContextStrokeRectIRgba32 = fn(UnsafePointer[BLContextCore], UnsafePointer[BLRectI], UInt32) -> BLResult
alias blContextStrokeRectD = fn(UnsafePointer[BLContextCore], UnsafePointer[BLRect]) -> BLResult
alias blContextStrokeRectDRgba32 = fn(UnsafePointer[BLContextCore], UnsafePointer[BLRect], UInt32) -> BLResult
alias blContextStrokePathD = fn(UnsafePointer[BLContextCore], UnsafePointer[BLPoint], UnsafePointer[BLPathCore]) -> BLResult
alias blContextStrokePathDRgba32 = fn(UnsafePointer[BLContextCore], UnsafePointer[BLPoint], UnsafePointer[BLPathCore], UInt32) -> BLResult
alias blContextFillRectI = fn(UnsafePointer[BLContextCore], UnsafePointer[BLRectI]) -> BLResult
alias blContextFillRectIRgba32 = fn(UnsafePointer[BLContextCore], UnsafePointer[BLRectI], UInt32) -> BLResult
alias blContextFillRectD = fn(UnsafePointer[BLContextCore], UnsafePointer[BLRect]) -> BLResult
alias blContextFillRectDRgba32 = fn(UnsafePointer[BLContextCore], UnsafePointer[BLRect], UInt32) -> BLResult

alias blContextFillPathD = fn(UnsafePointer[BLContextCore], UnsafePointer[BLPoint], UnsafePointer[BLPathCore]) -> BLResult
alias blContextFillPathDRgba32 = fn(UnsafePointer[BLContextCore], UnsafePointer[BLPoint], UnsafePointer[BLPathCore], UInt32) -> BLResult
alias blContextFillAll = fn(UnsafePointer[BLContextCore]) -> BLResult
alias blContextFillAllRgba32 = fn(UnsafePointer[BLContextCore], UInt32) -> BLResult
alias blContextFillGlyphRunI = fn(UnsafePointer[BLContextCore], UnsafePointer[BLPointI], UnsafePointer[BLFontCore], UnsafePointer[BLGlyphRun]) -> BLResult
alias blContextFillGlyphRunIRgba32 = fn(UnsafePointer[BLContextCore], UnsafePointer[BLPointI], UnsafePointer[BLFontCore], UnsafePointer[BLGlyphRun], UInt32) -> BLResult

alias blContextSetFillStyleRgba32 = fn(UnsafePointer[BLContextCore], UInt32) -> BLResult
alias blContextSetFillStyle = fn(UnsafePointer[BLContextCore], UnsafePointer[UInt8]) -> BLResult

alias blContextSetStrokeCap = fn(UnsafePointer[BLContextCore], UInt32, UInt32) -> BLResult
alias blContextSetStrokeCaps = fn(UnsafePointer[BLContextCore], UInt32) -> BLResult

alias blContextStrokeUtf8TextI = fn(UnsafePointer[BLContextCore], UnsafePointer[BLPointI], UnsafePointer[BLFontCore], UnsafePointer[UInt8], Int) -> BLResult
alias blContextStrokeUtf8TextIRgba32 = fn(UnsafePointer[BLContextCore], UnsafePointer[BLPointI], UnsafePointer[BLFontCore], UnsafePointer[UInt8], Int, UInt32) -> BLResult
alias blContextFillUtf8TextI = fn(UnsafePointer[BLContextCore], UnsafePointer[BLPointI], UnsafePointer[BLFontCore], UnsafePointer[UInt8], Int) -> BLResult
alias blContextFillUtf8TextIRgba32 = fn(UnsafePointer[BLContextCore], UnsafePointer[BLPointI], UnsafePointer[BLFontCore], UnsafePointer[UInt8], Int, UInt32) -> BLResult

alias blContextStrokeUtf8TextD = fn(UnsafePointer[BLContextCore], UnsafePointer[BLPoint], UnsafePointer[BLFontCore], UnsafePointer[UInt8], Int) -> BLResult
alias blContextStrokeUtf8TextDRgba32 = fn(UnsafePointer[BLContextCore], UnsafePointer[BLPoint], UnsafePointer[BLFontCore], UnsafePointer[UInt8], Int, UInt32) -> BLResult
alias blContextFillUtf8TextD = fn(UnsafePointer[BLContextCore], UnsafePointer[BLPoint], UnsafePointer[BLFontCore], UnsafePointer[UInt8], Int) -> BLResult
alias blContextFillUtf8TextDRgba32 = fn(UnsafePointer[BLContextCore], UnsafePointer[BLPoint], UnsafePointer[BLFontCore], UnsafePointer[UInt8], Int, UInt32) -> BLResult

alias blContextSetHint = fn(UnsafePointer[BLContextCore], UInt32, UInt32) -> BLResult
#============================================================================================================
#
#          The "enums" part
#
#============================================================================================================

@value
struct BLCompOp:
    var value : UInt32

    @staticmethod
    @always_inline
    fn src_over() -> Self:
        return Self(BL_COMP_OP_SRC_OVER)  

    @staticmethod
    @always_inline
    fn src_copy() -> Self:
        return Self(BL_COMP_OP_SRC_COPY)  

    @staticmethod
    @always_inline
    fn src_in() -> Self:
        return Self(BL_COMP_OP_SRC_IN)  

    @staticmethod
    @always_inline
    fn src_out() -> Self:
        return Self(BL_COMP_OP_SRC_OUT)  

    @staticmethod
    @always_inline
    fn src_atop() -> Self:
        return Self(BL_COMP_OP_SRC_ATOP)  

    @staticmethod
    @always_inline
    fn dst_over() -> Self:
        return Self(BL_COMP_OP_DST_OVER)  

    @staticmethod
    @always_inline
    fn dst_copy() -> Self:
        return Self(BL_COMP_OP_DST_COPY)  

    @staticmethod
    @always_inline
    fn dst_in() -> Self:
        return Self(BL_COMP_OP_DST_IN)  

    @staticmethod
    @always_inline
    fn dst_out() -> Self:
        return Self(BL_COMP_OP_DST_OUT)  
    
    @staticmethod
    @always_inline
    fn dst_atop() -> Self:
        return Self(BL_COMP_OP_DST_ATOP)  

    @staticmethod
    @always_inline
    fn xor() -> Self:
        return Self(BL_COMP_OP_XOR) 

    @staticmethod
    @always_inline
    fn clear() -> Self:
        return Self(BL_COMP_OP_CLEAR) 

    @staticmethod
    @always_inline
    fn plus() -> Self:
        return Self(BL_COMP_OP_PLUS) 

    @staticmethod
    @always_inline
    fn minus() -> Self:
        return Self(BL_COMP_OP_MINUS) 

    @staticmethod
    @always_inline
    fn modulate() -> Self:
        return Self(BL_COMP_OP_MODULATE) 

    @staticmethod
    @always_inline
    fn multiply() -> Self:
        return Self(BL_COMP_OP_MULTIPLY) 

    @staticmethod
    @always_inline
    fn screen() -> Self:
        return Self(BL_COMP_OP_SCREEN) 

    @staticmethod
    @always_inline
    fn overlay() -> Self:
        return Self(BL_COMP_OP_OVERLAY) 

    @staticmethod
    @always_inline
    fn darken() -> Self:
        return Self(BL_COMP_OP_DARKEN) 

    @staticmethod
    @always_inline
    fn lighten() -> Self:
        return Self(BL_COMP_OP_LIGHTEN) 

    @staticmethod
    @always_inline
    fn color_dodge() -> Self:
        return Self(BL_COMP_OP_COLOR_DODGE) 

    @staticmethod
    @always_inline
    fn color_burn() -> Self:
        return Self(BL_COMP_OP_COLOR_BURN)    

    @staticmethod
    @always_inline
    fn linear_burn() -> Self:
        return Self(BL_COMP_OP_LINEAR_BURN)    

    @staticmethod
    @always_inline
    fn linear_light() -> Self:
        return Self(BL_COMP_OP_LINEAR_LIGHT) 

    @staticmethod
    @always_inline
    fn pin_light() -> Self:
        return Self(BL_COMP_OP_PIN_LIGHT) 

    @staticmethod
    @always_inline
    fn hard_light() -> Self:
        return Self(BL_COMP_OP_HARD_LIGHT) 

    @staticmethod
    @always_inline
    fn soft_light() -> Self:
        return Self(BL_COMP_OP_SOFT_LIGHT) 

    @staticmethod
    @always_inline
    fn difference() -> Self:
        return Self(BL_COMP_OP_DIFFERENCE) 

    @staticmethod
    @always_inline
    fn exclusion() -> Self:
        return Self(BL_COMP_OP_EXCLUSION) 



@value
struct BLStrokeCap:
    var value : UInt32

    @staticmethod
    @always_inline
    fn butt() -> Self:
        return Self(BL_STROKE_CAP_BUTT)

    @staticmethod
    @always_inline
    fn square() -> Self:
        return Self(BL_STROKE_CAP_SQUARE)

    @staticmethod
    @always_inline
    fn round() -> Self:
        return Self(BL_STROKE_CAP_ROUND)

    @staticmethod
    @always_inline
    fn round_rev() -> Self:
        return Self(BL_STROKE_CAP_ROUND_REV)

    @staticmethod
    @always_inline
    fn triangle() -> Self:
        return Self(BL_STROKE_CAP_TRIANGLE)

    @staticmethod
    @always_inline
    fn triangle_rev() -> Self:
        return Self(BL_STROKE_CAP_TRIANGLE_REV)

#============================================================================================================
#
#          The basic structs
#
#============================================================================================================

@value
struct BLRotatePoint:
    var r : Float64
    var x : Float64
    var y : Float64

@value
struct BLContextCore:
    var detail: BLObjectDetail

    fn __init__(inout self):
        self.detail = BLObjectDetail()      

@value
struct BLContextCookie:
    var data: InlineArray[UInt64, 2]

    fn __init__(inout self):
        self.data = InlineArray[UInt64, 2](0)

@value
struct BLContextCreateInfo(Stringable):
    var flags: UInt32
    var thread_count: UInt32
    var cpu_features: UInt32
    var command_queue_limit: UInt32
    var saved_state_limit: UInt32
    var pixel_origin : BLPointI
    var reserved: InlineArray[UInt32, 1]

    fn __init__(inout self):
        self.flags = BL_CONTEXT_CREATE_NO_FLAGS
        self.thread_count = 0  # synchronous rendering
        self.cpu_features = 0
        self.command_queue_limit = 0
        self.saved_state_limit = 0
        self.pixel_origin = BLPointI()
        self.reserved = InlineArray[UInt32, 1](0)

    fn __str__(self) -> String:
        var result = StringList()
        result.append(String("flags: ")+String(self.flags))
        result.append(String("thread_count: ")+String(self.thread_count))
        result.append(String("cpu_features: ")+String(self.cpu_features))
        result.append(String("command_queue_limit: ")+String(self.command_queue_limit))
        result.append(String("saved_state_limit: ")+String(self.saved_state_limit))
        result.append(String("pixel_origin: ")+self.pixel_origin.__str__())
        return result.get_value()


@value
struct BLContext:
    var _b2d    : LibBlend2D
    var _core   : BLContextCore
    var cookies : List[BLContextCookie]

    fn __init__(inout self, owned b2d : LibBlend2D, owned core : BLContextCore):
        self._b2d = b2d
        self._core = core
        self.cookies = List[BLContextCookie]()

    fn ptr_core(self) -> UnsafePointer[BLContextCore]:
        return UnsafePointer[BLContextCore](self._core)

    @staticmethod
    fn begin(img : BLImage, threadcount : UInt32) -> Optional[Self]:
        var result = Optional[Self](None)  
        var _b2d = LibBlend2D.new()
        if _b2d: 
            var b2d = _b2d.take()
            var info = BLContextCreateInfo()
            info.thread_count = threadcount
            var core = BLContextCore()
            var res = b2d._handle.get_function[blContextInitAs]("blContextInitAs")(UnsafePointer(core), img.get_core_ptr(), UnsafePointer(info))
            if res==BL_SUCCESS:
                result = Optional[Self](Self(b2d^, core^))
            else:
                print("BLContext failed with ",error_code(res))           
        return result

    fn end(self) -> BLResult:
        return self._b2d._handle.get_function[blContextEnd]("blContextEnd")(self.ptr_core())        

    fn __del__(owned self):
        _ = self._b2d._handle.get_function[blContextDestroy]("blContextDestroy")(self.ptr_core()) 

    fn flush(self) -> BLResult:
        return self._b2d._handle.get_function[blContextFlush]("blContextFlush")(self.ptr_core())        
    
    @always_inline
    fn set_comp_op(self, op : BLCompOp) -> BLResult:
        return self._b2d._handle.get_function[blContextSetCompOp]("blContextSetCompOp")(self.ptr_core(), op.value)

    @always_inline
    fn set_fill_style_colour(self, colour : BLRgba32) -> BLResult:
        return self._b2d._handle.get_function[blContextSetFillStyleRgba32]("blContextSetFillStyleRgba32")(self.ptr_core(), colour.value)

    @always_inline
    fn fill_all(self) -> BLResult:
        return self._b2d._handle.get_function[blContextFillAll]("blContextFillAll")(self.ptr_core())

    @always_inline
    fn fill_all_rgba32(self, colour : BLRgba32) -> BLResult:
        return self._b2d._handle.get_function[blContextFillAllRgba32]("blContextFillAllRgba32")(self.ptr_core(), colour.value)

    @always_inline
    fn clear_all(self) -> BLResult:
        return self._b2d._handle.get_function[blContextClearAll]("blContextClearAll")(self.ptr_core())

    @always_inline
    fn save(inout self) -> BLResult:
        var cookie = BLContextCookie()        
        var result = self._b2d._handle.get_function[blContextSave]("blContextSave")(self.ptr_core(), UnsafePointer[BLContextCookie](cookie))    
        self.cookies.append(cookie)
        return result

    @always_inline
    fn restore(inout self) -> BLResult:
        var result = BL_ERROR_NO_MATCHING_COOKIE
        if self.cookies.size>0:
            var cookie = self.cookies.pop()
            result = self._b2d._handle.get_function[blContextRestore]("blContextRestore")(self.ptr_core(), UnsafePointer[BLContextCookie](cookie))            
        return result

    @always_inline
    fn _apply_transform(self, op : UInt32, ptr : UnsafePointer[UInt8]) -> BLResult:
        return self._b2d._handle.get_function[blContextApplyTransformOp]("blContextApplyTransformOp")(self.ptr_core(), op, ptr)

    @always_inline
    fn identity(self) -> BLResult:
        return self._apply_transform( BL_TRANSFORM_OP_RESET, UnsafePointer[UInt8]())

    @always_inline
    fn rotate(self, radians : Float64) -> BLResult:
        var ptr = UnsafePointer[Float64]( Float64(radians)).bitcast[UInt8]()
        return self._apply_transform( BL_TRANSFORM_OP_ROTATE, ptr)
    
    @always_inline
    fn rotate_pt(self, radians : Float64, x : Float64, y : Float64) -> BLResult:
        var bytes = BLRotatePoint(radians,x,y)
        var ptr = UnsafePointer[BLRotatePoint](bytes).bitcast[UInt8]()
        return self._apply_transform( BL_TRANSFORM_OP_ROTATE_PT, ptr)

    @always_inline
    fn translate(self, p : BLPoint) -> BLResult:
        var ptr = UnsafePointer[BLPoint]( p).bitcast[UInt8]()
        return self._apply_transform( BL_TRANSFORM_OP_TRANSLATE, ptr)

    @always_inline
    fn translate(self, x : Float64, y : Float64) -> BLResult:
        var p = BLPoint(x,y)
        return self.translate(p)
    
    @always_inline
    fn scale(self, x : Float64, y : Float64) -> BLResult:
        var p = BLPoint(x,y)
        return self.scale(p)

    @always_inline
    fn scale(self, p : BLPoint) -> BLResult:
        var ptr = UnsafePointer[BLPoint]( p).bitcast[UInt8]()
        return self._apply_transform( BL_TRANSFORM_OP_SCALE, ptr)

    @always_inline
    fn set_pattern_quality_bilinear(self) -> BLResult:
        return self._b2d._handle.get_function[blContextSetHint]("blContextSetHint")(self.ptr_core(), BL_CONTEXT_HINT_PATTERN_QUALITY, BL_PATTERN_QUALITY_BILINEAR)

    fn set_pattern_quality_nearest(self) -> BLResult:
        return self._b2d._handle.get_function[blContextSetHint]("blContextSetHint")(self.ptr_core(), BL_CONTEXT_HINT_PATTERN_QUALITY, BL_PATTERN_QUALITY_NEAREST)

    @always_inline
    fn set_stroke_width(self, width : Float64) -> BLResult:
        return self._b2d._handle.get_function[blContextSetStrokeWidth]("blContextSetStrokeWidth")(self.ptr_core(), width)

    @always_inline
    fn set_stroke_style_colour(self, colour : BLRgba32) -> BLResult:
        return self._b2d._handle.get_function[blContextSetStrokeStyleRgba32]("blContextSetStrokeStyleRgba32")(self.ptr_core(), colour.value)

    @always_inline
    fn set_stroke_rect(self, rect : BLRectI) -> BLResult:
        return self._b2d._handle.get_function[blContextStrokeRectI]("blContextStrokeRectI")(self.ptr_core(), UnsafePointer(rect))

    @always_inline
    fn stroke_rect_rgba32(self, rect : BLRectI, colour : BLRgba32) -> BLResult:
        return self._b2d._handle.get_function[blContextStrokeRectIRgba32]("blContextStrokeRectIRgba32")(self.ptr_core(), UnsafePointer(rect), colour.value)

    @always_inline
    fn fill_rect(self, rect : BLRectI) -> BLResult:
        return self._b2d._handle.get_function[blContextFillRectI]("blContextFillRectI")(self.ptr_core(), UnsafePointer(rect))

    @always_inline
    fn fill_rect_rgba32(self, rect : BLRectI, colour : BLRgba32) -> BLResult:
        return self._b2d._handle.get_function[blContextFillRectIRgba32]("blContextFillRectIRgba32")(self.ptr_core(), UnsafePointer(rect), colour.value)

    @always_inline
    fn stroke_rectd(self, rect : BLRect) -> BLResult:
        return self._b2d._handle.get_function[blContextStrokeRectD]("blContextStrokeRectD")(self.ptr_core(), UnsafePointer(rect))

    @always_inline
    fn stroke_rectd_rgba32(self, rect : BLRect, colour : BLRgba32) -> BLResult:
        return self._b2d._handle.get_function[blContextStrokeRectDRgba32]("blContextStrokeRectDRgba32")(self.ptr_core(), UnsafePointer(rect), colour.value)

    @always_inline
    fn filld_rect(self, rect : BLRect) -> BLResult:
        return self._b2d._handle.get_function[blContextFillRectD]("blContextFillRectD")(self.ptr_core(), UnsafePointer(rect))

    @always_inline
    fn fill_rectd_rgba32(self, rect : BLRect, colour : BLRgba32) -> BLResult:
        return self._b2d._handle.get_function[blContextFillRectDRgba32]("blContextFillRectDRgba32")(self.ptr_core(), UnsafePointer(rect), colour.value)

    @always_inline
    fn stroke_pathd(self, origin : BLPoint, path : BLPath) -> BLResult:
        return self._b2d._handle.get_function[blContextStrokePathD]("blContextStrokePathD")(self.ptr_core(), UnsafePointer(origin), path.ptr_core())

    @always_inline
    fn stroke_pathd_rgba32(self, origin : BLPoint, path : BLPath, colour : BLRgba32) -> BLResult:
        return self._b2d._handle.get_function[blContextStrokePathDRgba32]("blContextStrokePathDRgba32")(self.ptr_core(), UnsafePointer(origin), path.ptr_core(), colour.value)

    @always_inline
    fn fill_pathd(self, origin : BLPoint, path : BLPath) -> BLResult:
        return self._b2d._handle.get_function[blContextFillPathD]("blContextFillPathD")(self.ptr_core(), UnsafePointer(origin), path.ptr_core() )

    @always_inline
    fn fill_pathd_rgba32(self, origin : BLPoint, path : BLPath, colour : BLRgba32) -> BLResult:
        return self._b2d._handle.get_function[blContextFillPathDRgba32]("blContextFillPathDRgba32")(self.ptr_core(), UnsafePointer(origin), path.ptr_core(), colour.value )

    @always_inline
    fn set_stroke_start_cap(self, x : BLStrokeCap) -> BLResult:
        return self._b2d._handle.get_function[blContextSetStrokeCap]("blContextSetStrokeCap")(self.ptr_core(), BL_STROKE_CAP_POSITION_START, x.value )
      
    @always_inline
    fn set_stroke_end_cap(self, x : BLStrokeCap) -> BLResult:
        return self._b2d._handle.get_function[blContextSetStrokeCap]("blContextSetStrokeCap")(self.ptr_core(), BL_STROKE_CAP_POSITION_END, x.value )

    @always_inline
    fn set_stroke_caps(self, x : BLStrokeCap) -> BLResult:
        return self._b2d._handle.get_function[blContextSetStrokeCaps]("blContextSetStrokeCaps")(self.ptr_core(), x.value )

    @always_inline
    fn stroke_utf8_textI(self, origin : BLPointI, font : BLFont, text : String, length : Int) -> BLResult:
        var ptr = UnsafePointer[BLPointI](origin)
        var l = len(text)
        return self._b2d._handle.get_function[blContextStrokeUtf8TextI]("blContextStrokeUtf8TextI")(self.ptr_core(), ptr, font.ptr_core(), text.unsafe_uint8_ptr(), length )

    @always_inline
    fn stroke_utf8_textI_rgba32(self, origin : BLPointI, font : BLFont, text : String, length : Int, colour : BLRgba32) -> BLResult:
        var ptr = UnsafePointer[BLPointI](origin)
        var l = len(text)
        return self._b2d._handle.get_function[blContextStrokeUtf8TextIRgba32]("blContextStrokeUtf8TextIRgba32")(self.ptr_core(), ptr, font.ptr_core(), text.unsafe_uint8_ptr(), length, colour.value )        

    @always_inline
    fn fill_utf8_textI(self, origin : BLPointI, font : BLFont, text : String, length : Int) -> BLResult:
        var ptr = UnsafePointer[BLPointI](origin)
        return self._b2d._handle.get_function[blContextFillUtf8TextI]("blContextFillUtf8TextI")(self.ptr_core(), ptr, font.ptr_core(), text.unsafe_uint8_ptr(), length )

    @always_inline
    fn fill_utf8_textI_rgba32(self, origin : BLPointI, font : BLFont, text : String, length : Int, colour : BLRgba32) -> BLResult:
        var ptr = UnsafePointer[BLPointI](origin)
        return self._b2d._handle.get_function[blContextFillUtf8TextIRgba32]("blContextFillUtf8TextIRgba32")(self.ptr_core(), ptr, font.ptr_core(), text.unsafe_uint8_ptr(), length, colour.value )        

    @always_inline
    fn stroke_utf8_textD(self, origin : BLPoint, font : BLFont, text : String, length : Int) -> BLResult:
        var ptr = UnsafePointer[BLPoint](origin)
        return self._b2d._handle.get_function[blContextStrokeUtf8TextD]("blContextStrokeUtf8TextD")(self.ptr_core(), ptr, font.ptr_core(), text.unsafe_uint8_ptr(), length )

    @always_inline
    fn stroke_utf8_textD_rgba32(self, origin : BLPoint, font : BLFont, text : String, length : Int, colour : BLRgba32) -> BLResult:
        var ptr = UnsafePointer[BLPoint](origin)
        return self._b2d._handle.get_function[blContextStrokeUtf8TextDRgba32]("blContextStrokeUtf8TextDRgba32")(self.ptr_core(), ptr, font.ptr_core(), text.unsafe_uint8_ptr(), length, colour.value )        

    @always_inline
    fn fill_utf8_textD(self, origin : BLPoint, font : BLFont, text : String, length : Int) -> BLResult:
        var ptr = UnsafePointer[BLPoint](origin)
        return self._b2d._handle.get_function[blContextFillUtf8TextD]("blContextFillUtf8TextD")(self.ptr_core(), ptr, font.ptr_core(), text.unsafe_uint8_ptr(), length )

    @always_inline
    fn fill_utf8_textD_rgba32(self, origin : BLPoint, font : BLFont, text : String, length : Int, colour : BLRgba32) -> BLResult:
        var ptr = UnsafePointer[BLPoint](origin)
        return self._b2d._handle.get_function[blContextFillUtf8TextDRgba32]("blContextFillUtf8TextDRgba32")(self.ptr_core(), ptr, font.ptr_core(), text.unsafe_uint8_ptr(), length, colour.value )        
    
    @always_inline
    fn fill_glyph_run(self, origin : BLPointI, font : BLFont, glyphs_buffer : BLGlyphBuffer) -> BLResult:
        var ptr = UnsafePointer[BLPointI](origin)
        var ptr2 = glyphs_buffer.get_glyph_run()
        return self._b2d._handle.get_function[blContextFillGlyphRunI]("blContextFillGlyphRunI")(self.ptr_core(), ptr, font.ptr_core(), ptr2 )        

    @always_inline
    fn fill_glyph_run_rgba32(self, origin : BLPointI, font : BLFont, glyphs_buffer : BLGlyphBuffer, colour : BLRgba32) -> BLResult:
        var ptr = UnsafePointer[BLPointI](origin)
        var ptr2 = glyphs_buffer.get_glyph_run()
        return self._b2d._handle.get_function[blContextFillGlyphRunIRgba32]("blContextFillGlyphRunIRgba32")(self.ptr_core(), ptr, font.ptr_core(), ptr2, colour.value )        
    
    @always_inline
    fn set_fill_style_gradient(self, gradient : BLGradient) -> BLResult:
        var ptr = gradient.get_core_ptr().bitcast[UInt8]()
        return self._b2d._handle.get_function[blContextSetFillStyle]("blContextSetFillStyle")(self.ptr_core(), ptr)

    @always_inline
    fn set_fill_style_pattern(self, pattern : BLPattern) -> BLResult:
        var ptr = pattern.get_core_ptr().bitcast[UInt8]()
        return self._b2d._handle.get_function[blContextSetFillStyle]("blContextSetFillStyle")(self.ptr_core(), ptr)
