
import blimage
import blruntime
import blpath
import blgeometry
import blcolor
import blfont
import blmatrix
import blcontext
import blcommon
import helpers
import blmipmap

from blend2d.bllibblend2d import LibBlend2D
from testing import assert_true

def LibBlend2D_validation():
    var aaa = LibBlend2D.new()
    assert_true(aaa)
    var lib = aaa.take()
    lib.close()

def main():
    helpers.validation()   
    LibBlend2D_validation()
    blruntime.validation()
    blimage.validation()
    blpath.validation()
    blgeometry.validation()
    blcolor.validation()
    blfont.validation()
    blmatrix.validation()
    blcontext.validation()
    blcommon.validation()
    blmipmap.validation()

