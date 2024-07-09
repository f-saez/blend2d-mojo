
import sys.ffi
from collections.vector import InlinedFixedVector
from memory.unsafe_pointer import UnsafePointer
from utils import InlineArray
from memory.unsafe import DTypePointer
from memory import memset_zero, AddressSpace
from pathlib import Path
from testing import assert_equal, assert_true
import os 
from collections import Optional
from memory import Arc
from sys import os_is_macos

import .blruntime

alias LIBJPEG_NAME = get_libname()

fn get_libname() -> StringLiteral:
    @parameter
    if os_is_macos():
        return "libblend2d.dylib"
    else:
        return "libblend2d.so"

@value
struct LibBlend2D:
    var _handle      : ffi.DLHandle

    fn __init__(inout self, handle : ffi.DLHandle):
        self._handle = handle

    fn close(owned self):
        # why not putting this in the destructor ?
        # easy answer : because it may crash 
        # long answer :
        # if I put this in the destructor and embed this in a object
        # I cannot control if this destructor will be called at the begening or the end of the parent destructor
        # and if the parent destructor need this do destroy himself properly, I will run into troubles
        # so, to solve this, I destroy manually what need to be destroyed in a proper order
        self._handle.close()

    @staticmethod
    fn new() -> Optional[LibBlend2D]:
        var result = Optional[LibBlend2D](None)        
        var handle = ffi.DLHandle(LIBJPEG_NAME, ffi.RTLD.NOW)
        if handle:                        
            result = Optional[LibBlend2D](LibBlend2D(handle))
        else:
            print("Unable to load ",LIBJPEG_NAME)
        return result
    
    @staticmethod
    fn validation() raises :
        var aaa = LibBlend2D.new()
        assert_true(aaa)
        var lib = aaa.take()
        lib.close()
        

