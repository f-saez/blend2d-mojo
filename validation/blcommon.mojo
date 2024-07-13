

from blend2d.blpattern import *
from testing import assert_equal

def BLExtendMode_validation():
    assert_equal( BLExtendMode.pad().value, BL_EXTEND_MODE_PAD)
    assert_equal( BLExtendMode.repeat().value, BL_EXTEND_MODE_REPEAT)
    assert_equal( BLExtendMode.reflect().value, BL_EXTEND_MODE_REFLECT)
    assert_equal( BLExtendMode.pad_x_pad_y().value, BL_EXTEND_MODE_PAD_X_PAD_Y)
    assert_equal( BLExtendMode.pad_x_repeat_y().value, BL_EXTEND_MODE_PAD_X_REPEAT_Y)
    assert_equal( BLExtendMode.pad_x_reflect_y().value, BL_EXTEND_MODE_PAD_X_REFLECT_Y)
    assert_equal( BLExtendMode.repeat_x_repeat_y().value, BL_EXTEND_MODE_REPEAT_X_REPEAT_Y)
    assert_equal( BLExtendMode.repeat_x_pad_y().value, BL_EXTEND_MODE_REPEAT_X_PAD_Y)
    assert_equal( BLExtendMode.repeat_x_reflect_y().value, BL_EXTEND_MODE_REPEAT_X_REFLECT_Y)
    assert_equal( BLExtendMode.reflect_x_reflect_y().value, BL_EXTEND_MODE_REFLECT_X_REFLECT_Y)
    assert_equal( BLExtendMode.reflect_x_pad_y().value, BL_EXTEND_MODE_REFLECT_X_PAD_Y)
    assert_equal( BLExtendMode.reflect_x_repeat_y().value, BL_EXTEND_MODE_REFLECT_X_REPEAT_Y)


def validaiton():
    BLExtendMode_validation()
