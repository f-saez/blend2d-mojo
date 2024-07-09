from testing import assert_equal, assert_true

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