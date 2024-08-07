from .blcommon import *
from .blerrorcode import *
from pathlib import Path
from .bllibblend2d import LibBlend2D
from .blimage import BLImage, BLFormat, BLFileFormat
from .blpath import BLPath, BLPathCore
from .blmatrix2d import BLMatrix2D
from .blgeometry import BLPoint, BLBox, BLPointI
from .blcolor import BLRgba32
from .helpers import string_to_ffi
import os

# text is harder than most people think

alias BL_FONT_FACE_TYPE_NONE:UInt32 = 0
alias BL_FONT_FACE_TYPE_OPENTYPE:UInt32 = 1

alias BL_FONT_STYLE_NORMAL:UInt32 = 0 	
alias BL_FONT_STYLE_OBLIQUE :UInt32 = 1	
alias BL_FONT_STYLE_ITALIC:UInt32 = 2 	

alias BL_FONT_STRETCH_ULTRA_CONDENSED:UInt32 = 1 	
alias BL_FONT_STRETCH_EXTRA_CONDENSED:UInt32 = 2  	
alias BL_FONT_STRETCH_CONDENSED:UInt32 = 3
alias BL_FONT_STRETCH_SEMI_CONDENSED:UInt32 = 4
alias BL_FONT_STRETCH_NORMAL:UInt32 = 5
alias BL_FONT_STRETCH_SEMI_EXPANDED:UInt32 = 6
alias BL_FONT_STRETCH_EXPANDED:UInt32 = 7
alias BL_FONT_STRETCH_EXTRA_EXPANDED:UInt32 = 8
alias BL_FONT_STRETCH_ULTRA_EXPANDED:UInt32 = 9 

alias BL_TEXT_ENCODING_UTF8:UInt32 = 0 	
alias BL_TEXT_ENCODING_UTF16:UInt32 = 1 	
alias BL_TEXT_ENCODING_UTF32:UInt32 = 2 	
alias BL_TEXT_ENCODING_LATIN1:UInt32 = 3  	

alias BL_GLYPH_RUN_NO_FLAGS:UInt32 = 0
alias BL_GLYPH_RUN_FLAG_UCS4_CONTENT:UInt32 = 268435456
alias BL_GLYPH_RUN_FLAG_INVALID_TEXT:UInt32 = 536870912
alias BL_GLYPH_RUN_FLAG_UNDEFINED_GLYPHS:UInt32 = 1073741824
alias BL_GLYPH_RUN_FLAG_INVALID_FONT_DATA:UInt32 = 2147483648

alias blFontDataCreateFromData = fn(UnsafePointer[BLFontDataCore], UnsafePointer[UInt8], Int, UnsafePointer[UInt8], UnsafePointer[UInt8]) -> BLResult
alias blFontDataInit = fn(UnsafePointer[BLFontDataCore]) -> BLResult
alias blFontDataDestroy = fn(UnsafePointer[BLFontDataCore]) -> BLResult
alias blFontDataGetFaceCount = fn(UnsafePointer[BLFontDataCore]) -> UInt32

alias blFontFaceInit = fn(UnsafePointer[BLFontFaceCore]) -> BLResult
alias blFontFaceCreateFromData = fn(UnsafePointer[BLFontFaceCore], UnsafePointer[BLFontDataCore], UInt32) -> BLResult
alias blFontFaceDestroy = fn(UnsafePointer[BLFontFaceCore]) -> BLResult

# this functions are only for C++ users. I will remove them latter after being sure I can do nothing with them
alias blFontFaceGetFullName = fn(UnsafePointer[BLFontFaceCore], UnsafePointer[BLStringCore]) -> BLResult
alias blFontFaceGetFamilyName = fn(UnsafePointer[BLFontFaceCore], UnsafePointer[BLStringCore]) -> BLResult
alias blFontFaceGetSubfamilyName = fn(UnsafePointer[BLFontFaceCore], UnsafePointer[BLStringCore]) -> BLResult
alias blFontFaceGetPostScriptName = fn(UnsafePointer[BLFontFaceCore], UnsafePointer[BLStringCore]) -> BLResult

alias blFontFeatureSettingsInit = fn(UnsafePointer[BLFontFeatureSettingsCore]) -> BLResult
alias blFontFeatureSettingsDestroy = fn(UnsafePointer[BLFontFeatureSettingsCore]) -> BLResult
alias blFontFeatureSettingsClear = fn(UnsafePointer[BLFontFeatureSettingsCore]) -> BLResult

alias blFontInit = fn(UnsafePointer[BLFontCore]) -> BLResult
alias blFontDestroy = fn(UnsafePointer[BLFontCore]) -> BLResult
alias blFontCreateFromFace = fn(UnsafePointer[BLFontCore], UnsafePointer[BLFontFaceCore], Float32) -> BLResult
alias blFontShape = fn(UnsafePointer[BLFontCore], UnsafePointer[BLGlyphBufferCore]) -> BLResult
alias blFontSetSize = fn(UnsafePointer[BLFontCore], Float32) -> BLResult
alias blFontGetMetrics = fn(UnsafePointer[BLFontCore], UnsafePointer[BLFontMetrics]) -> BLResult
alias blFontGetTextMetrics = fn(UnsafePointer[BLFontCore], UnsafePointer[BLGlyphBufferCore], UnsafePointer[BLTextMetrics]) -> BLResult
alias blFontApplyKerning = fn(UnsafePointer[BLFontCore], UnsafePointer[BLGlyphBufferCore]) -> BLResult
alias blFontPositionGlyphs = fn(UnsafePointer[BLFontCore], UnsafePointer[BLGlyphBufferCore]) -> BLResult
alias blFontSetFeatureSettings = fn(UnsafePointer[BLFontCore], UnsafePointer[BLFontFeatureSettingsCore]) -> BLResult
alias blFontGetGlyphRunOutlines = fn(UnsafePointer[BLFontCore], UnsafePointer[BLGlyphRun], UnsafePointer[BLMatrix2D], UnsafePointer[BLPathCore], UnsafePointer[UInt8], UnsafePointer[UInt8]) -> BLResult


alias blGlyphBufferInit = fn(UnsafePointer[BLGlyphBufferCore]) -> BLResult
alias blGlyphBufferDestroy = fn(UnsafePointer[BLGlyphBufferCore]) -> BLResult
alias blGlyphBufferReset = fn(UnsafePointer[BLGlyphBufferCore]) -> BLResult
alias blGlyphBufferClear = fn(UnsafePointer[BLGlyphBufferCore]) -> BLResult
alias blGlyphBufferSetText = fn(UnsafePointer[BLGlyphBufferCore], UnsafePointer[UInt8], Int, UInt32) -> BLResult
alias blGlyphBufferGetFlags = fn(UnsafePointer[BLGlyphBufferCore]) -> UInt32
alias blGlyphBufferGetGlyphRun = fn(UnsafePointer[BLGlyphBufferCore]) -> UnsafePointer[BLGlyphRun]

#============================================================================================================
#
#          The "enums" part
#
#============================================================================================================

@value
struct BLFontStyle:
    var value : UInt32

    @staticmethod
    @always_inline
    fn normal() -> Self:
        return Self(BL_FONT_STYLE_NORMAL)    

    @staticmethod
    @always_inline
    fn oblique() -> Self:
        return Self(BL_FONT_STYLE_OBLIQUE)    

    @staticmethod
    @always_inline
    fn italic() -> Self:
        return Self(BL_FONT_STYLE_ITALIC)    


@value
struct BLFontStretch:
    var value : UInt32

    @staticmethod
    @always_inline
    fn ultra_condensed() -> Self:
        return Self(BL_FONT_STRETCH_ULTRA_CONDENSED)    

    @staticmethod
    @always_inline
    fn extra_condensed() -> Self:
        return Self(BL_FONT_STRETCH_EXTRA_CONDENSED)    

    @staticmethod
    @always_inline
    fn condensed() -> Self:
        return Self(BL_FONT_STRETCH_CONDENSED)    

    @staticmethod
    @always_inline
    fn semi_condensed() -> Self:
        return Self(BL_FONT_STRETCH_SEMI_CONDENSED)    

    @staticmethod
    @always_inline
    fn normal() -> Self:
        return Self(BL_FONT_STRETCH_NORMAL)  

    @staticmethod
    @always_inline
    fn semi_expanded() -> Self:
        return Self(BL_FONT_STRETCH_SEMI_EXPANDED)  

    @staticmethod
    @always_inline
    fn expanded() -> Self:
        return Self(BL_FONT_STRETCH_EXPANDED)  

    @staticmethod
    @always_inline
    fn extra_expanded() -> Self:
        return Self(BL_FONT_STRETCH_EXTRA_EXPANDED) 

    @staticmethod
    @always_inline
    fn ultra_expanded() -> Self:
        return Self(BL_FONT_STRETCH_ULTRA_EXPANDED) 



@value
struct BLFontFaceType:
    var value : UInt32

    @staticmethod
    @always_inline
    fn none() -> Self:
        return Self(BL_FONT_FACE_TYPE_NONE)

    @staticmethod
    @always_inline
    fn BL_FONT_FACE_TYPE_OPENTYPE() -> Self:
        return Self(BL_FONT_FACE_TYPE_OPENTYPE)   

#============================================================================================================
#
#          The basic structs
#
#============================================================================================================

@value
struct BLTextMetrics:
    var advance: BLPoint
    var leading_bearing: BLPoint
    var trailing_bearing: BLPoint
    var bounding_box: BLBox

    fn __init__(inout self):
        self.advance = BLPoint()
        self.leading_bearing = BLPoint()
        self.trailing_bearing = BLPoint()
        self.bounding_box = BLBox()

        
@value
struct BLFontMetrics(Stringable):
    # Font size.
    var size : Float32

    # I haven't found any union for Mojo so I had to make a choice.
    # I could probably solve that with bitfields and some not-so clean stuff

    # Font ascent (horizontal orientation)
    var ascent: Float32
    # Font ascent (vertical orientation)
    var vAscent: Float32
    # Font descent (horizontal orientation)
    var descent: Float32
    # Font descent (vertical orientation)
    var vDescent: Float32  

    # Line gap
    var line_gap : Float32
    # Distance between the baseline and the mean line of lower-case letters.
    var x_height: Float32
    # Maximum height of a capital letter above the baseline.
    var cap_height: Float32
    # Minimum x, reported by the font.
    var x_min: Float32
    # Minimum y, reported by the font
    var y_min: Float32
    # Maximum x, reported by the font
    var x_max: Float32
    # Maximum y, reported by the font
    var y_max: Float32
    # Text underline position
    var underline_position: Float32
    # Text underline thickness
    var underline_thickness: Float32
    # Text strikethrough position
    var strikethrough_position: Float32
    # Text strikethrough thickness
    var strikethrough_thickness: Float32

    fn __init__(inout self):
        self.size = 0
        self.ascent = 0
        self.vAscent = 0
        self.descent =0
        self.vDescent = 0
        self.line_gap = 0
        self.x_height = 0
        self.cap_height = 0
        self.x_min =0
        self.y_min = 0        
        self.x_max = 0
        self.y_max = 0                
        self.underline_position = 0
        self.underline_thickness = 0
        self.strikethrough_position = 0
        self.strikethrough_thickness = 0

    fn __str__(self) -> String:
        var result = StringList()
        result.append(String("size: ")+String(self.size))
        result.append(String("ascent: ")+String(self.ascent))
        result.append(String("vAscent: ")+String(self.vAscent))
        result.append(String("descent: ")+String(self.descent))
        result.append(String("vDescent: ")+String(self.vDescent))
        result.append(String("line_gap: ")+String(self.line_gap))
        result.append(String("x_height: ")+String(self.x_height))
        result.append(String("cap_height: ")+String(self.cap_height))
        result.append(String("x_min: ")+String(self.x_min))
        result.append(String("y_min: ")+String(self.y_min))
        result.append(String("x_max: ")+String(self.x_max))
        result.append(String("y_max: ")+String(self.y_max))
        result.append(String("underline_position: ")+String(self.underline_position))
        result.append(String("underline_thickness: ")+String(self.underline_thickness))
        result.append(String("strikethrough_position: ")+String(self.strikethrough_position))
        result.append(String("strikethrough_thickness: ")+String(self.strikethrough_thickness))
        return result.get_value()

@value
struct BLFontFaceInfo:
    # Font face type, see \\ref BLFontFaceType
    var faceType: UInt8
    # Type of outlines used by the font face, see \\ref BLFontOutlineType
    var outlineType: UInt8
    # Reserved fields
    var reserved8: InlineArray[UInt8, 2]
    # Number of glyphs provided by this font face
    var glyphCount: UInt32
    # Revision (read from 'head' table, represented as 16.16 fixed point)
    var revision: UInt32
    # Face face index in a TTF/OTF collection or zero if not part of a collection
    var faceIndex: UInt32
    # Font face flags, see BLFontFaceFlags
    var faceFlags: UInt32
    # Font face diagnostic flags, see BLFontFaceDiagFlags
    var diagFlags: UInt32
    # Reserved for future use, set to zero
    var reserved: InlineArray[UInt32, 2]

    fn __init__(inout self):
        self.faceType = 0
        self.outlineType = 0
        self.reserved8 = InlineArray[UInt8, 2](0)
        self.glyphCount = 0
        self.revision = 0
        self.faceIndex = 0
        self.faceFlags = 0
        self.diagFlags = 0
        self.reserved = InlineArray[UInt32, 2](0)

@value        
struct BLGlyphRun:
    # Glyph id data (abstract, incremented by `glyphAdvance`)
    var glyphData: UnsafePointer[UInt8]
    # Glyph placement data (abstract, incremented by `placementAdvance`)
    var placementData: UnsafePointer[UInt8]
    # Size of the glyph-run in glyph units.
    var size: Int
    # Reserved for future use, muse be zero.
    var reserved: UInt8
    # Type of placement, see \\ref BLGlyphPlacementType.
    var placementType: UInt8
    # Advance of `glyphData` array.
    var glyphAdvance: Int8
    # Advance of `placementData` array.
    var placementAdvance: Int8
    # Glyph-run flags.
    var flags: UInt32

    fn __init__(inout self):
        self.glyphData = UnsafePointer[UInt8]()
        self.placementData = UnsafePointer[UInt8]()
        self.size = 0
        self.reserved = 0
        self.placementType = 0
        self.glyphAdvance = 0
        self.placementAdvance = 0
        self.flags = 0

@value        
struct BLGlyphPlacement:
    var placement: BLPointI
    var advance: BLPointI

    fn __init__(inout self):
        self.placement = BLPointI()
        self.advance = BLPointI()

#============================================================================================================
#
#  the low-level Blend2D interface structs
#
#============================================================================================================
@value
struct BLFontDataCore:
    var detail: BLObjectDetail

    fn __init__(inout self):
        self.detail = BLObjectDetail()  

@value
struct BLFontFeatureSettingsCore:
    var detail: BLObjectDetail

    fn __init__(inout self):
        self.detail = BLObjectDetail()  

@value
struct BLFontFaceCore:
    var detail: BLObjectDetail

    fn __init__(inout self):
        self.detail = BLObjectDetail()  

@value
struct BLFontCore:
    var detail: BLObjectDetail

    fn __init__(inout self):
        self.detail = BLObjectDetail()  

@value
struct BLGlyphInfo:
    var cluster: UInt32
    var reserved: UInt32

    fn __init__(inout self):
        self.cluster = 0 
        self.reserved = 0

@value
struct BLGlyphBufferImpl:
    var glyphRun  : BLGlyphRun
    var info_data : UnsafePointer[BLGlyphInfo]

    fn __init__(inout self, info_data : UnsafePointer[BLGlyphInfo]):
        self.glyphRun  = BLGlyphRun() 
        self.info_data = info_data

@value
struct BLGlyphBufferCore:
    var impl : UnsafePointer[BLGlyphBufferImpl]

#============================================================================================================
#
#  the usable objects
#
#============================================================================================================

@value
struct BLFontFeatureSettings:
    var _b2d    : LibBlend2D   
    var _core   : BLFontFeatureSettingsCore

    fn __init__(inout self, owned b2d : LibBlend2D, owned core : BLFontFeatureSettingsCore):
        self._b2d = b2d
        self._core = core

    fn ptr_core(self) -> UnsafePointer[BLFontFeatureSettingsCore]:
        return UnsafePointer[BLFontFeatureSettingsCore](self._core)
    
    @staticmethod
    fn new() -> Optional[BLFontData]:
        var result = Optional[Self](None)  
        var _b2d = LibBlend2D.new()
        if _b2d: 
            var b2d = _b2d.take()
            var core = BLFontFeatureSettingsCore()
            var ptr = UnsafePointer[BLFontFeatureSettingsCore](core)
            var res = b2d._handle.get_function[blFontFeatureSettingsInit]("blFontFeatureSettingsInit")(ptr)
            if res==BL_SUCCESS:
                result = Optional[Self](Self(b2d^, core^))         
            else:
                print("BLFontFeatureSettings failed with ",error_code(res))           
        return result
    
    fn clear(self):
        _ = self._b2d._handle.get_function[blFontFeatureSettingsClear]("blFontFeatureSettingsClear")(self.ptr_core())

    fn __del__(owned self):
        # same comment as BLImage        
        _ = self._b2d._handle.get_function[blFontFeatureSettingsDestroy]("blFontFeatureSettingsDestroy")(self.ptr_core())
        self._b2d.close()

@value
struct BLFontData:
    var _b2d    : LibBlend2D   
    var _core   : BLFontDataCore
    var external_data : List[UInt8]
    var _face_count   : UInt32

    fn __init__(inout self, owned b2d : LibBlend2D, owned core : BLFontDataCore, owned data : List[UInt8]):
        self._face_count = b2d._handle.get_function[blFontDataGetFaceCount]("blFontDataGetFaceCount")(UnsafePointer[BLFontDataCore](core))
        self._b2d = b2d
        self._core = core
        self.external_data = data

    fn ptr_core(self) -> UnsafePointer[BLFontDataCore]:
        return UnsafePointer[BLFontDataCore](self._core)

    @staticmethod
    fn new(owned data : List[UInt8]) -> Optional[BLFontData]:
        var result = Optional[Self](None)  
        var _b2d = LibBlend2D.new()
        if _b2d: 
            var b2d = _b2d.take()
            var core = BLFontDataCore()
            var ptr = UnsafePointer(core)
            var res = b2d._handle.get_function[blFontDataInit]("blFontDataInit")(ptr)
            if res==BL_SUCCESS:
                res = b2d._handle.get_function[blFontDataCreateFromData]("blFontDataCreateFromData")(ptr, data.unsafe_ptr(), data.size, UnsafePointer[UInt8](), UnsafePointer[UInt8]())
                if res==BL_SUCCESS:
                    result = Optional[Self](Self(b2d^, core^, data^))         
            if res!=BL_SUCCESS:
                print("BLFontData failed with ",error_code(res))           
        return result

    @always_inline
    fn get_face_count(self) -> UInt32:
        return self._face_count

    fn destroy(owned self):
        if not self._b2d.is_destroyed():
            _ = self._b2d._handle.get_function[blFontDataDestroy]("blFontDataDestroy")(self.ptr_core())
            self._b2d.close()

@value
struct BLFontFace:
    var _b2d      : LibBlend2D     
    var _core     : BLFontFaceCore
    var font_data : BLFontData


    fn __init__(inout self, owned b2d : LibBlend2D, owned core : BLFontFaceCore, owned data : BLFontData, face_index : UInt32):
        self._b2d = b2d
        self._core = core
        self.font_data = data

    fn ptr_core(self) -> UnsafePointer[BLFontFaceCore]:
        return UnsafePointer[BLFontFaceCore](self._core)
    
    @staticmethod
    fn from_path(owned filename : Path, face_index : UInt32) raises -> Optional[BLFontFace]:
        var result = Optional[Self](None)  
        if filename.is_file():
            var file_size = filename.stat().st_size
            var bytes = List[UInt8](capacity=file_size)
            with open(filename, "rb") as f:
                bytes = f.read_bytes()    
            result = BLFontFace.new(bytes, face_index)
        return result

    @staticmethod
    fn new(owned bytes : List[UInt8], face_index : UInt32) -> Optional[BLFontFace]:
        var result = Optional[Self](None)  
        var _b2d = LibBlend2D.new()
        if _b2d: 
            var b2d = _b2d.take()
            var aaa = BLFontData.new(bytes)
            if aaa:
                var font_data = aaa.take()
                var core = BLFontFaceCore()
                var ptr = UnsafePointer(core)
                var res = b2d._handle.get_function[blFontFaceInit]("blFontFaceInit")(ptr)
                if res==BL_SUCCESS:
                    res = b2d._handle.get_function[blFontFaceCreateFromData]("blFontFaceCreateFromData")(ptr, font_data.ptr_core(), face_index) 
                    if res==BL_SUCCESS:
                        result = Optional[Self](Self(b2d^, core^, font_data^, face_index))         
                if res!=BL_SUCCESS:
                    print("BLFontData failed with ",error_code(res))           
        return result       

    fn destroy(owned self):
        if not self._b2d.is_destroyed():            
            _ = self._b2d._handle.get_function[blFontFaceDestroy]("blFontFaceDestroy")(self.ptr_core())
            self.font_data.destroy()
            self._b2d.close()

    fn __enter__(owned self) -> Self:
        return self^

    @always_inline
    fn get_face_count(self) -> UInt32:
        return self.font_data._face_count    

@value
struct BLFont:
    var _b2d      : LibBlend2D     
    var _core     : BLFontCore 
    var _metrics  : BLFontMetrics

    fn __init__(inout self, owned b2d : LibBlend2D, owned core : BLFontCore, owned metrics : BLFontMetrics):
        self._b2d = b2d
        self._core = core
        self._metrics = metrics  

    fn ptr_core(self) -> UnsafePointer[BLFontCore]:
        return UnsafePointer[BLFontCore](self._core)

    @staticmethod
    fn new(face : BLFontFace, size : Float32) -> Optional[BLFont]:
        var result = Optional[Self](None)  
        var _b2d = LibBlend2D.new()
        if _b2d: 
            var b2d = _b2d.take()
            var core = BLFontCore()
            var ptr = UnsafePointer[BLFontCore](core)
            var res = b2d._handle.get_function[blFontInit]("blFontInit")(ptr)
            if res==BL_SUCCESS:
                res = b2d._handle.get_function[blFontCreateFromFace]("blFontCreateFromFace")(ptr, face.ptr_core(), size)  
                if res==BL_SUCCESS:
                    var metrics = BLFontMetrics()
                    res = b2d._handle.get_function[blFontGetMetrics]("blFontGetMetrics")(ptr, UnsafePointer[BLFontMetrics](metrics))  
                    if res==BL_SUCCESS:
                        result = Optional[Self]( Self(b2d^, core^, metrics^))
            if res!=BL_SUCCESS:
                print("BLFontData failed with ",error_code(res))        
        return result  

    @always_inline
    fn get_metrics(self) -> BLFontMetrics:
        return self._metrics  
         
    @always_inline
    fn shape(self, glyphs_buffer : BLGlyphBuffer) -> BLResult:
        return self._b2d._handle.get_function[blFontShape]("blFontShape")(self.ptr_core(), glyphs_buffer.ptr_core())  

    @always_inline
    fn apply_kerning(self, glyphs_buffer : BLGlyphBuffer) -> BLResult:
        """
         always crashes but I will dive into that later.
        """
        return self._b2d._handle.get_function[blFontApplyKerning]("blFontApplyKerning")(self.ptr_core(), glyphs_buffer.ptr_core())  

    @always_inline
    fn position_glyphs(self, glyphs_buffer : BLGlyphBuffer) -> BLResult:
        """
         the only documentation is the name of the function. Don't when to use or even if I need to use it. TODO : check the source code to find more info.
        """
        return self._b2d._handle.get_function[blFontPositionGlyphs]("blFontPositionGlyphs")(self.ptr_core(), glyphs_buffer.ptr_core())  

     
    @always_inline
    fn get_glyphrun_outlines(self, glyphs_buffer : BLGlyphBuffer, path : BLPath) -> BLResult:
        var matrix2D = BLMatrix2D()
        var ptr_m = UnsafePointer[BLMatrix2D](matrix2D)
        var ptr_g = glyphs_buffer.get_glyph_run()        
        return self._b2d._handle.get_function[blFontGetGlyphRunOutlines]("blFontGetGlyphRunOutlines")(self.ptr_core(), ptr_g, ptr_m, path.ptr_core(), UnsafePointer[UInt8](), UnsafePointer[UInt8]())  


    @always_inline
    fn get_text_metrics(self, glyphs_buffer : BLGlyphBuffer, text_metrics : BLTextMetrics) -> BLResult:
        return self._b2d._handle.get_function[blFontGetTextMetrics]("blFontGetTextMetrics")(self.ptr_core(), glyphs_buffer.ptr_core(), UnsafePointer[BLTextMetrics](text_metrics))  

    fn destroy(owned self):           
        if not self._b2d.is_destroyed():            
            _ = self._b2d._handle.get_function[blFontDestroy]("blFontDestroy")(self.ptr_core())
            self._b2d.close()                

@value
struct BLGlyphBuffer:
    var _b2d         : LibBlend2D   
    var _core        : BLGlyphBufferCore
    var glyph_info   : BLGlyphInfo
    var glyph_buffer : BLGlyphBufferImpl
    var _text        : String

    fn __init__(inout self, owned b2d : LibBlend2D, owned core : BLGlyphBufferCore, owned glyph_info : BLGlyphInfo, owned glyph_buffer : BLGlyphBufferImpl):
        self._b2d = b2d
        self._core = core
        self.glyph_info = glyph_info
        self.glyph_buffer = glyph_buffer
        self._text = String()

    fn ptr_core(self) -> UnsafePointer[BLGlyphBufferCore]:
        return UnsafePointer[BLGlyphBufferCore](self._core)

    @staticmethod
    fn new() -> Optional[Self]:
        var result = Optional[Self](None)  
        var _b2d = LibBlend2D.new()
        if _b2d: 
            var b2d = _b2d.take()
            var glyph_info = BLGlyphInfo()
            var glyph_buffer = BLGlyphBufferImpl( UnsafePointer[BLGlyphInfo](glyph_info))
            var core = BLGlyphBufferCore(UnsafePointer[BLGlyphBufferImpl](glyph_buffer))
            var ptr = UnsafePointer[BLGlyphBufferCore](core)
            var res = b2d._handle.get_function[blGlyphBufferInit]("blGlyphBufferInit")(ptr)
            if res==BL_SUCCESS:
                result = Optional[Self]( Self(b2d^, core^, glyph_info^, glyph_buffer^))
            else:
                print("BLGlyphBuffer failed with ",error_code(res))        
        return result  

    @always_inline
    fn _set_text(inout self, owned text : String, length : Int, encoding : UInt32) -> BLResult:
        self._text = text
        var ptr = self._text.unsafe_uint8_ptr()
        return self._b2d._handle.get_function[blGlyphBufferSetText]("blGlyphBufferSetText")(self.ptr_core(), ptr, length, encoding)  

    @always_inline
    fn set_text_utf8(inout self, owned text : String, length : Int) -> BLResult:
        return self._set_text(text, length, BL_TEXT_ENCODING_UTF8)  

    @always_inline
    fn _get_flags(self) -> UInt32:
        return self._b2d._handle.get_function[blGlyphBufferGetFlags]("blGlyphBufferGetFlags")(self.ptr_core())  

    @always_inline
    fn has_text(self) -> Bool:
        return (self._get_flags() & BL_GLYPH_RUN_FLAG_UCS4_CONTENT) > 0  

    @always_inline
    fn has_invalid_chars(self) -> Bool:
        return (self._get_flags() & BL_GLYPH_RUN_FLAG_INVALID_TEXT) > 0 
 
    @always_inline
    fn has_glyphs(self) -> Bool:
        return (self._get_flags() & BL_GLYPH_RUN_FLAG_UCS4_CONTENT) == 0 # TODO need to be checked
    
    @always_inline
    fn has_undefined_glyphs(self) -> Bool:
        return (self._get_flags() & BL_GLYPH_RUN_FLAG_UNDEFINED_GLYPHS) > 0 

    @always_inline
    fn has_invalid_font_data(self) -> Bool:
        return (self._get_flags() & BL_GLYPH_RUN_FLAG_INVALID_FONT_DATA) > 0 

    @always_inline
    fn clear(self) -> BLResult:
        return self._b2d._handle.get_function[blGlyphBufferClear]("blGlyphBufferClear")(self.ptr_core())

    @always_inline
    fn reset(self) -> BLResult:
        return self._b2d._handle.get_function[blGlyphBufferReset]("blGlyphBufferReset")(self.ptr_core())

    @always_inline
    fn get_glyph_run(self) -> UnsafePointer[BLGlyphRun]:
        return self._b2d._handle.get_function[blGlyphBufferGetGlyphRun]("blGlyphBufferGetGlyphRun")(self.ptr_core())

    fn destroy(owned self):
        if not self._b2d.is_destroyed():
            _ = self._b2d._handle.get_function[blGlyphBufferDestroy]("blGlyphBufferDestroy")(self.ptr_core())
            self._b2d.close()                 

