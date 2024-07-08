from testing import assert_equal, assert_true
from blerrorcode import BLResult

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

    @staticmethod
    fn validation() raises :
        var r:UInt8 = 16
        var g:UInt8 = 32
        var b:UInt8 = 64
        var a:UInt8 = 0
        var c = BLRgba32.rgba(r,g,b,a)
        assert_true(c.is_transparent())
        assert_equal(c.is_opaque(),False)
        assert_equal(c.get_a(),a)
        assert_equal(c.get_r(),r)
        assert_equal(c.get_g(),g)
        assert_equal(c.get_b(),b)
        r = 72
        c.set_r(r)
        # test everything to check some bleeding
        assert_equal(c.get_a(),a)
        assert_equal(c.get_r(),r)
        assert_equal(c.get_g(),g)
        assert_equal(c.get_b(),b)
        g = 76
        c.set_g(g)
        assert_equal(c.get_a(),a)
        assert_equal(c.get_r(),r)
        assert_equal(c.get_g(),g)
        assert_equal(c.get_b(),b)
        b = 143
        c.set_b(b)
        assert_equal(c.get_a(),a)
        assert_equal(c.get_r(),r)
        assert_equal(c.get_g(),g)
        assert_equal(c.get_b(),b)

        a = 255
        c.set_a(a)
        assert_equal(c.get_a(),a)
        assert_equal(c.get_r(),r)
        assert_equal(c.get_g(),g)
        assert_equal(c.get_b(),b)
        assert_true(c.is_opaque())
        assert_equal(c.is_transparent(),False)

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

