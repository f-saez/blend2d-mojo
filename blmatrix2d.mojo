
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
            Indentity matrix be default.
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
    
