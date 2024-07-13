
from testing import assert_true
from blend2d.blmatrix2d import BLMatrix2D    
    
def validation():
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