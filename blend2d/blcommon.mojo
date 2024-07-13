from .blerrorcode import BLResult

alias BL_FILE_READ_NO_FLAGS:UInt32 = 0
alias BL_FILE_READ_MMAP_ENABLED:UInt32 = 1
alias BL_FILE_READ_MMAP_AVOID_SMALL:UInt32 = 2
alias BL_FILE_READ_MMAP_NO_FALLBACK:UInt32 = 8

alias BL_OBJECT_TYPE_IMAGE_CODEC:UInt32 = 101	# Object is BLImageCodec.
alias BL_OBJECT_TYPE_IMAGE_DECODER:UInt32 = 102	# Object is BLImageDecoder.
alias BL_OBJECT_TYPE_IMAGE_ENCODER:UInt32 = 103	# Object is BLImageEncoder. 

alias BL_FILL_RULE_NON_ZERO:UInt32 = 0 	# Non-zero fill-rule.
alias BL_FILL_RULE_EVEN_ODD:UInt32 = 1 	# Even-odd fill-rule. 

alias BL_HIT_TEST_IN:UInt32 = 0 	 # Fully in.
alias BL_HIT_TEST_PART:UInt32 = 1 	 # Partially in/out.
alias BL_HIT_TEST_OUT:UInt32 = 2 	 # Fully out.
alias BL_HIT_TEST_INVALID:UInt32 = 3 # Hit test failed (invalid argument, NaNs, etc). 

alias BL_EXTEND_MODE_PAD:UInt32 = 0 # Pad extend [default].
alias BL_EXTEND_MODE_REPEAT:UInt32 = 1 # Repeat extend.
alias BL_EXTEND_MODE_REFLECT:UInt32 = 2 # Reflect extend.
alias BL_EXTEND_MODE_PAD_X_PAD_Y:UInt32 = 3 # Alias to BL_EXTEND_MODE_PAD.
alias BL_EXTEND_MODE_PAD_X_REPEAT_Y:UInt32 = 4 # Pad X and repeat Y.
alias BL_EXTEND_MODE_PAD_X_REFLECT_Y:UInt32 = 5 # Pad X and reflect Y.
alias BL_EXTEND_MODE_REPEAT_X_REPEAT_Y:UInt32 = 6 # Alias to BL_EXTEND_MODE_REPEAT.
alias BL_EXTEND_MODE_REPEAT_X_PAD_Y:UInt32 = 7 # Repeat X and pad Y.
alias BL_EXTEND_MODE_REPEAT_X_REFLECT_Y:UInt32 = 8 # Repeat X and reflect Y.
alias BL_EXTEND_MODE_REFLECT_X_REFLECT_Y:UInt32 = 9 # Alias to BL_EXTEND_MODE_REFLECT.
alias BL_EXTEND_MODE_REFLECT_X_PAD_Y:UInt32 = 10 # Reflect X and pad Y.
alias BL_EXTEND_MODE_REFLECT_X_REPEAT_Y:UInt32 = 11 # Reflect X and repeat Y.

#============================================================================================================
#
#          The "enums" part
#
#============================================================================================================

@value
struct BLExtendMode:
    var value : UInt32

    @staticmethod
    @always_inline
    fn pad() -> Self:
        return Self(BL_EXTEND_MODE_PAD)    

    @staticmethod
    @always_inline
    fn repeat() -> Self:
        return Self(BL_EXTEND_MODE_REPEAT)    

    @staticmethod
    @always_inline
    fn reflect() -> Self:
        return Self(BL_EXTEND_MODE_REFLECT)    

    @staticmethod
    @always_inline
    fn pad_x_pad_y() -> Self:
        return Self(BL_EXTEND_MODE_PAD_X_PAD_Y)    

    @staticmethod
    @always_inline
    fn pad_x_repeat_y() -> Self:
        return Self(BL_EXTEND_MODE_PAD_X_REPEAT_Y)    

    @staticmethod
    @always_inline
    fn pad_x_reflect_y() -> Self:
        return Self(BL_EXTEND_MODE_PAD_X_REFLECT_Y)    

    @staticmethod
    @always_inline
    fn repeat_x_repeat_y() -> Self:
        return Self(BL_EXTEND_MODE_REPEAT_X_REPEAT_Y) 

    @staticmethod
    @always_inline
    fn repeat_x_pad_y() -> Self:
        return Self(BL_EXTEND_MODE_REPEAT_X_PAD_Y) 

    @staticmethod
    @always_inline
    fn repeat_x_reflect_y() -> Self:
        return Self(BL_EXTEND_MODE_REPEAT_X_REFLECT_Y) 

    @staticmethod
    @always_inline
    fn reflect_x_reflect_y() -> Self:
        return Self(BL_EXTEND_MODE_REFLECT_X_REFLECT_Y) 

    @staticmethod
    @always_inline
    fn reflect_x_pad_y() -> Self:
        return Self(BL_EXTEND_MODE_REFLECT_X_PAD_Y) 

    @staticmethod
    @always_inline
    fn reflect_x_repeat_y() -> Self:
        return Self(BL_EXTEND_MODE_REFLECT_X_REPEAT_Y) 


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
struct BLRange:
    var start: Int
    var end: Int

    fn __init__(inout self):
        self.start = 0
        self.end = 0
        
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

