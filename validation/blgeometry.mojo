
from blend2d.blgeometry import *
from testing import assert_equal

def BLGeometry_validation():
    assert_equal(BLGeometry.none().value, BL_GEOMETRY_TYPE_NONE)
    assert_equal(BLGeometry.boxI().value, BL_GEOMETRY_TYPE_BOXI)
    assert_equal(BLGeometry.boxD().value, BL_GEOMETRY_TYPE_BOXD)
    assert_equal(BLGeometry.rectI().value, BL_GEOMETRY_TYPE_RECTI)
    assert_equal(BLGeometry.rectD().value, BL_GEOMETRY_TYPE_RECTD)
    assert_equal(BLGeometry.circle().value, BL_GEOMETRY_TYPE_CIRCLE)
    assert_equal(BLGeometry.elipse().value, BL_GEOMETRY_TYPE_ELLIPSE)
    assert_equal(BLGeometry.round_rect().value, BL_GEOMETRY_TYPE_ROUND_RECT)
    assert_equal(BLGeometry.arc().value, BL_GEOMETRY_TYPE_ARC)
    assert_equal(BLGeometry.chord().value, BL_GEOMETRY_TYPE_CHORD)
    assert_equal(BLGeometry.pie().value, BL_GEOMETRY_TYPE_PIE)
    assert_equal(BLGeometry.line().value, BL_GEOMETRY_TYPE_LINE)
    assert_equal(BLGeometry.triangle().value, BL_GEOMETRY_TYPE_TRIANGLE)
    assert_equal(BLGeometry.polylineI().value, BL_GEOMETRY_TYPE_POLYLINEI)
    assert_equal(BLGeometry.polylineD().value, BL_GEOMETRY_TYPE_POLYLINED)
    assert_equal(BLGeometry.polygonI().value, BL_GEOMETRY_TYPE_POLYGONI)
    assert_equal(BLGeometry.polygonD().value, BL_GEOMETRY_TYPE_POLYGOND)

def validation():
    BLGeometry_validation()
