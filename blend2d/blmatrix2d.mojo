from testing import assert_true

alias BL_TRANSFORM_OP_RESET: UInt32 = 0	# Reset matrix to identity
alias BL_TRANSFORM_OP_ASSIGN: UInt32 = 1	
alias BL_TRANSFORM_OP_TRANSLATE: UInt32 = 2
alias BL_TRANSFORM_OP_SCALE: UInt32 = 3	
alias BL_TRANSFORM_OP_SKEW: UInt32 = 4	
alias BL_TRANSFORM_OP_ROTATE: UInt32 = 5
alias BL_TRANSFORM_OP_ROTATE_PT: UInt32 = 6 	
alias BL_TRANSFORM_OP_TRANSFORM: UInt32 = 7
alias BL_TRANSFORM_OP_POST_TRANSLATE: UInt32 = 8
alias BL_TRANSFORM_OP_POST_SCALE: UInt32 = 9
alias BL_TRANSFORM_OP_POST_SKEW: UInt32 = 10
alias BL_TRANSFORM_OP_POST_ROTATE: UInt32 = 11	
alias BL_TRANSFORM_OP_POST_ROTATE_PT: UInt32 = 12	
alias BL_TRANSFORM_OP_POST_TRANSFORM: UInt32 = 13


# using Blen2D matrix with dynamic linking seems a little too much
# for what I need.
# Anyway, 2D transformation matrix are easy enough to do it by hand
# matrix multiplication should by done in SIMD
@value
struct BLMatrix2D:
    var m00: Float64
    var m01: Float64
    var m10: Float64
    var m11: Float64
    var m20: Float64
    var m21: Float64 
    
    fn __init__(inout self):
        """
            Identity matrix be default.
        """
        self.m00 = 1
        self.m01 = 0
        self.m10 = 0
        self.m11 = 1
        self.m20 = 0
        self.m21 = 0 

    @always_inline
    fn identity(inout self):
        self.m00 = 1
        self.m01 = 0
        self.m10 = 0
        self.m11 = 1
        self.m20 = 0
        self.m21 = 0 
    
    @always_inline
    fn scale_scalar(inout self, x : Float64, y : Float64):
        self.m00 *= x
        self.m01 *= x
        self.m10 *= y
        self.m11 *= y

    @always_inline
    fn translate_scalar(inout self, x : Float64, y : Float64):
        self.m20 += x * self.m00 + y * self.m10
        self.m21 += x * self.m01 + y * self.m11

    @always_inline
    fn scale(inout self, x : Float64, y : Float64):
        var ptr1 = UnsafePointer[BLMatrix2D](self)
        var ptr2 = DTypePointer[DType.float64](ptr1.bitcast[Float64]())
        var m00_11 = ptr2.load[width=4]()
        m00_11 *= SIMD[DType.float64, size=4](x, x, y, y)
        ptr2.store[width=4](m00_11)
       
    @always_inline
    fn translate(inout self, x : Float64, y : Float64):
        # "wtf, u mad bro ? SIMD for that !?"
        # yeas, I know it doesn't really make sense beacause it isn't even that faster
        # feel free to use the scalar version for readability
        var ptr1 = UnsafePointer[BLMatrix2D](self)
        var ptr2 = DTypePointer[DType.float64](ptr1.bitcast[Float64]())
        var m00_11 = ptr2.load[width=4]()
        m00_11 *= SIMD[DType.float64, size=4](x, x, y, y)
        var m2 = m00_11.reduce_add[size_out=2]()
        var m3 = ptr2.load[width=2](4)
        ptr2.store[width=2](4,m3 + m2)

    fn print(self):
        print("m00: ",self.m00, " m01: ",self.m01)
        print("m10: ",self.m10, " m11: ",self.m11)
        print("m20: ",self.m20, " m21: ",self.m21)
        print()
        
    fn equal(self, other : Self) -> Bool:
        return  self.m00==other.m00 and self.m10==other.m10 and
                self.m10==other.m10 and self.m11==other.m11 and
                self.m20==other.m20 and self.m21==other.m21

    @staticmethod
    fn validation() raises:
        var x = 1.12
        var y = 1.456
        var max = 100
        var m = BLMatrix2D()
        var m2 = BLMatrix2D()
        for _ in range(max):
            m.translate_scalar(x,y)
            m.scale_scalar(x,y)
            m.scale_scalar(-x,-y)
            m.translate_scalar(-x,-y)

            m2.translate(x,y)
            m2.scale(x,y)
            m2.scale(-x,-y)
            m2.translate(-x,-y)

            assert_true(m2.equal(m))    
