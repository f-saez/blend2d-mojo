
from testing import assert_true, assert_equal

from blend2d.blruntime import BLRuntime
from sys.info import is_x86, is_apple_m1, is_apple_m2, is_apple_m3, is_apple_silicon, is_neoverse_n1

fn validation() raises:
    var aaa = BLRuntime.new()
    assert_true(aaa)
    var runtime = aaa.take()
    if is_x86():
        assert_equal(runtime.cpu_arch,String("x86"))
    if is_apple_m1() or is_apple_m2() or is_apple_m3() or is_apple_silicon() or is_neoverse_n1():
        assert_equal(runtime.cpu_arch,String("ARM"))
  