
from blend2d.blcontext import *
from testing import assert_equal

def BLCompOp_validation():
    assert_equal(BLCompOp.src_over().value, BL_COMP_OP_SRC_OVER)
    assert_equal(BLCompOp.src_copy().value, BL_COMP_OP_SRC_COPY)
    assert_equal(BLCompOp.src_in().value, BL_COMP_OP_SRC_IN)
    assert_equal(BLCompOp.src_out().value, BL_COMP_OP_SRC_OUT)
    assert_equal(BLCompOp.src_atop().value, BL_COMP_OP_SRC_ATOP)
    assert_equal(BLCompOp.dst_over().value, BL_COMP_OP_DST_OVER)
    assert_equal(BLCompOp.dst_copy().value, BL_COMP_OP_DST_COPY)
    assert_equal(BLCompOp.dst_in().value, BL_COMP_OP_DST_IN)
    assert_equal(BLCompOp.dst_out().value, BL_COMP_OP_DST_OUT)
    assert_equal(BLCompOp.dst_atop().value, BL_COMP_OP_DST_ATOP)
    assert_equal(BLCompOp.xor().value, BL_COMP_OP_XOR)
    assert_equal(BLCompOp.clear().value, BL_COMP_OP_CLEAR)
    assert_equal(BLCompOp.plus().value, BL_COMP_OP_PLUS)
    assert_equal(BLCompOp.minus().value, BL_COMP_OP_MINUS)
    assert_equal(BLCompOp.modulate().value, BL_COMP_OP_MODULATE)
    assert_equal(BLCompOp.multiply().value, BL_COMP_OP_MULTIPLY)
    assert_equal(BLCompOp.screen().value, BL_COMP_OP_SCREEN)
    assert_equal(BLCompOp.overlay().value, BL_COMP_OP_OVERLAY)        
    assert_equal(BLCompOp.darken().value, BL_COMP_OP_DARKEN)
    assert_equal(BLCompOp.lighten().value, BL_COMP_OP_LIGHTEN)
    assert_equal(BLCompOp.color_dodge().value, BL_COMP_OP_COLOR_DODGE)
    assert_equal(BLCompOp.color_burn().value, BL_COMP_OP_COLOR_BURN)
    assert_equal(BLCompOp.linear_burn().value, BL_COMP_OP_LINEAR_BURN)
    assert_equal(BLCompOp.linear_light().value, BL_COMP_OP_LINEAR_LIGHT)
    assert_equal(BLCompOp.pin_light().value, BL_COMP_OP_PIN_LIGHT)
    assert_equal(BLCompOp.hard_light().value, BL_COMP_OP_HARD_LIGHT)
    assert_equal(BLCompOp.soft_light().value, BL_COMP_OP_SOFT_LIGHT)
    assert_equal(BLCompOp.difference().value, BL_COMP_OP_DIFFERENCE)
    assert_equal(BLCompOp.exclusion().value, BL_COMP_OP_EXCLUSION)

def validation():
    BLCompOp_validation()
        