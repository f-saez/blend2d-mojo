from blimage import BLImage, BLFormat
from blcontext import BLContext
from blfont import BLFontFace, BLFont
from bllibblend2d import LibBlend2D
from blpath import BLPath
from blcommon import BLRgba32
from blruntime import BLRuntime

from blerrorcode import *
from blcommon import *
from pathlib import Path

from testing import assert_true, assert_equal

fn main() raises:
    LibBlend2D.validation()
    BLRuntime.validation()
    blimage.validation()
    BLPath.validation()
    BLRgba32.validation()
    blfont.validation()