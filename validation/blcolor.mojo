
from blend2d.blcolor import BLRgba32
from testing import assert_equal, assert_true

def validation():
    BLRgba32_validation()
            
def BLRgba32_validation():
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