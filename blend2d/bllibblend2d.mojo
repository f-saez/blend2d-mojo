
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
    var _destroyed   : Bool

    fn __init__(inout self, handle : ffi.DLHandle):
        self._handle = handle
        self._destroyed = False

    fn close(inout self):
        # why not putting this in the destructor ?
        # easy answer : because it may crash 
        # long answer :
        # if I put this in the destructor and embed this in a object
        # I will run into troubles for reason I can't understand. The destructor seems to be fired
        # at the wrong time or for no reason because the object is still used a few lines later.
        # to solve this, I destroy manually what need to be destroyed in a proper order
        if not self.is_destroyed():
            self._handle.close()
            self._destroyed = True

    @always_inline
    fn is_destroyed(self) -> Bool:
        return self._destroyed

    @staticmethod
    fn new() -> Optional[LibBlend2D]:
        var result = Optional[LibBlend2D](None)        
        var handle = ffi.DLHandle(LIBJPEG_NAME, ffi.RTLD.NOW)
        if handle:                        
            result = Optional[LibBlend2D](LibBlend2D(handle))
        else:
            print("Unable to load ",LIBJPEG_NAME)
        return result
    

        

