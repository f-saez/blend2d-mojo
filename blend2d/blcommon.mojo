from testing import assert_equal, assert_true
from .blerrorcode import BLResult

alias BL_FILE_READ_NO_FLAGS:UInt32 = 0
alias BL_FILE_READ_MMAP_ENABLED:UInt32 = 1
alias BL_FILE_READ_MMAP_AVOID_SMALL:UInt32 = 2
alias BL_FILE_READ_MMAP_NO_FALLBACK:UInt32 = 8

alias BL_OBJECT_TYPE_IMAGE_CODEC:UInt32 = 101	# Object is BLImageCodec.
alias BL_OBJECT_TYPE_IMAGE_DECODER:UInt32 = 102	# Object is BLImageDecoder.
alias BL_OBJECT_TYPE_IMAGE_ENCODER:UInt32 = 103	# Object is BLImageEncoder. 

alias blArrayInit = fn(UnsafePointer[BLArrayCore], UInt32) -> BLResult


@value
struct BLArrayCore:
    var detail: BLObjectDetail

    fn __init__(inout self):
        self.detail = BLObjectDetail()  

        
@value
struct BLFileReadFlags:
    var value : UInt32

    @staticmethod
    @always_inline
    fn no_flags() -> Self:
        return Self(BL_FILE_READ_NO_FLAGS)

    @staticmethod
    @always_inline
    fn mmap_enabled() -> Self:
        return Self(BL_FILE_READ_MMAP_ENABLED)

    @staticmethod
    @always_inline
    fn mmap_avoid_small() -> Self:
        return Self(BL_FILE_READ_MMAP_AVOID_SMALL)

    @staticmethod
    @always_inline
    fn mmap_no_fallback() -> Self:
        return Self(BL_FILE_READ_MMAP_NO_FALLBACK)


@value
struct BLObjectDetail:
    var u8_data: InlineArray[UInt8, 16]
    
    fn __init__(inout self):
        self.u8_data = InlineArray[UInt8, 16](0)

@value
struct BLStringCore:
    var _core: BLObjectDetail
    
    fn __init__(inout self):
        self._core = BLObjectDetail()

@value
struct BLSizeI(Stringable):
    var w: Int32
    var h: Int32

    fn __init__(inout self):
        self.w = 0
        self.h = 0  

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """        
        return String("w: ")+String(self.w)+String(" h: ")+String(self.h)

@value
struct BLPointI(Stringable):
    var x: Int32
    var y: Int32

    fn __init__(inout self):
        self.x = 0
        self.y = 0                  

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """        
        return String("x: ")+String(self.x)+String(" y: ")+String(self.y)

@value
struct BLRectI(Stringable):
    var x: Int32
    var y: Int32
    var w: Int32
    var h: Int32

    fn __init__(inout self):
        self.x = 0
        self.y = 0                  
        self.w = 0
        self.h = 0                  

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        return String("x: ")+String(self.x)+String(" y: ")+String(self.y)+String("w: ")+String(self.w)+String(" h: ")+String(self.h)

@value
struct BLRect(Stringable):
    var x: Float64
    var y: Float64
    var w: Float64
    var h: Float64

    fn __init__(inout self):
        self.x = 0
        self.y = 0                  
        self.w = 0
        self.h = 0                  

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        return String("x: ")+String(self.x)+String(" y: ")+String(self.y)+String("w: ")+String(self.w)+String(" h: ")+String(self.h)




@value
struct BLBox(Stringable):
    var x0: Float64
    var y0: Float64
    var x1: Float64
    var y1: Float64
    
    fn __init__(inout self):
        self.x0 = 0
        self.y0 = 0
        self.x1 = 0
        self.y1 = 0

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        return String("x0: ")+String(self.x0)+String(" y0: ")+String(self.y0)+String("x1: ")+String(self.x1)+String(" y1: ")+String(self.y1)

@value
struct BLPoint(Stringable):
    var x: Float64
    var y: Float64
    
    fn __init__(inout self):
        self.x = 0
        self.y = 0

    @staticmethod
    fn new(x : Float64, y : Float64) -> BLPoint:
        """
          I frequently use stayic method "new" associated with Optional.
          here I don't need that but I keep using "new" just for coherence.
        """
        return Self(x,y)
        

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        return String("x: ")+String(self.x)+String(" y: ")+String(self.y)


@value
struct StringList:
    var _value : String

    fn __init__(inout self):
        self._value = String()

    fn append(inout self, x : String):
        self._value += x
        self._value += String("\n")

    fn get_value(self) -> String:
        return self._value

