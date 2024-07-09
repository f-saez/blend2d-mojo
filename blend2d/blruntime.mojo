import sys.ffi
from memory import UnsafePointer
from .bllibblend2d import LibBlend2D
from .blerrorcode import *
from testing import assert_equal, assert_true
from memory import Arc
from collections import OptionalReg
from sys.info import is_x86, is_apple_m1, is_apple_m2, is_apple_m3, is_apple_silicon, is_neoverse_n1

alias blRuntimeQueryInfo = fn(UInt32, UnsafePointer[UInt8]) -> BLResult

alias BL_RUNTIME_BUILD_TYPE_DEBUG:UInt32 = 0
alias BL_RUNTIME_BUILD_TYPE_RELEASE:UInt32 = 1
  
alias BL_RUNTIME_CPU_ARCH_UNKNOWN:UInt32 = 0
alias BL_RUNTIME_CPU_ARCH_X86:UInt32 = 1
alias BL_RUNTIME_CPU_ARCH_ARM:UInt32 = 2
alias BL_RUNTIME_CPU_ARCH_MIPS:UInt32 = 3

alias BL_RUNTIME_CPU_FEATURE_X86_SSE2:UInt32 = 0x00000001
alias BL_RUNTIME_CPU_FEATURE_X86_SSE3:UInt32 = 0x00000002
alias BL_RUNTIME_CPU_FEATURE_X86_SSSE3:UInt32 = 0x00000004
alias BL_RUNTIME_CPU_FEATURE_X86_SSE4_1:UInt32 = 0x00000008
alias BL_RUNTIME_CPU_FEATURE_X86_SSE4_2:UInt32 = 0x00000010
alias BL_RUNTIME_CPU_FEATURE_X86_AVX:UInt32 = 0x00000020
alias BL_RUNTIME_CPU_FEATURE_X86_AVX2:UInt32 = 0x00000040
alias BL_RUNTIME_CPU_FEATURE_X86_AVX512:UInt32 = 0x00000080

@value
struct BLRuntimeInfoType:

    @staticmethod
    @always_inline
    fn build() -> UInt32:
        return 0

    @staticmethod 
    @always_inline
    fn system() -> UInt32:
        return 1

    @staticmethod 
    @always_inline
    fn resource() -> UInt32:
        return 2

@value
struct BLRuntimeBuildInfo:
    var major_version : UInt32  # Major version number.
    var minor_version: UInt32 # Minor version number.
    var patch_version: UInt32 # Patch version number.
    var build_type: UInt32 # Blend2D build type, see `BLRuntimeBuildType
    var baseline_cpu_features: UInt32  # Baseline CPU features, see `BLRuntimeCpuFeatures`.\n!\n! These features describe CPU features that were detected at compile-time. Baseline features are used to compile\n! all source files so they represent the minimum feature-set the target CPU must support to run Blend2D.\n!\n! Official Blend2D builds set baseline at SSE2 on X86 target and NEON on ARM target. Custom builds can set use\n! a different baseline, which can be read through `BLRuntimeBuildInfo
    var supported_cpu_features: UInt32  # These features do not represent the features that the host CPU must support, instead, they represent all features\n! that Blend2D can take advantage of in C++ code that uses instruction intrinsics. For example if AVX2 is part of\n! `supportedCpuFeatures` it means that Blend2D can take advantage of it if there is a separate code-path
    var max_image_size: UInt32  # Maximum size of an image (both width and height).
    var max_thread_count: UInt32 # Maximum number of threads for asynchronous operations, including rendering.
    var reserved: InlineArray[UInt32, 4]  # Reserved, must be zero.
    var compiler_info: InlineArray[UInt8, 32]  # Identification of the C++ compiler used to build Blend2D.

    fn __init__(inout self):
        self.major_version = 0
        self.minor_version = 0
        self.patch_version = 0
        self.build_type = 0
        self.baseline_cpu_features = 0
        self.supported_cpu_features = 0
        self.max_image_size = 0
        self.max_thread_count = 0
        self.reserved = InlineArray[UInt32, 4](0)
        self.compiler_info = InlineArray[UInt8, 32](0)

@value
struct BLRuntimeSystemInfo:
    var cpuArch : UInt32 # Host CPU architecture, see `BLRuntimeCpuArch`
    var cpu_features : UInt32 # Host CPU features, see `BLRuntimeCpuFeatures`.
    var core_count : UInt32  # Number of cores of the host CPU/CPUs.
    var thread_count : UInt32  #  Number of threads of the host CPU/CPUs.
    var threadStackSize : UInt32  # Minimum stack size of a worker thread used by Blend2D.
    var removed : UInt32  # Removed field.
    var allocation_granularity : UInt32 # Allocation granularity of virtual memory (includes thread's stack).
    var reserved : InlineArray[UInt32, 5]  # Reserved for future use.
    var cpu_vendor: InlineArray[UInt8, 16]  # Host CPU vendor string such "AMD", "APPLE", "INTEL", "SAMSUNG", etc...
    var cpu_brand :  InlineArray[UInt8, 64]  # Host CPU brand string or empty string if not detected properly.

    fn __init__(inout self):
        self.cpuArch = 0
        self.cpu_features = 0
        self.core_count = 0
        self.thread_count = 0
        self.threadStackSize = 0
        self.removed = 0
        self.allocation_granularity = 0
        self.reserved = InlineArray[UInt32, 5](0)
        self.cpu_vendor = InlineArray[UInt8, 16](0) 
        self.cpu_brand = InlineArray[UInt8, 64](0)

@value
struct BLRuntime:
    var build_info   : BLRuntimeBuildInfo
    var system_info  : BLRuntimeSystemInfo
    var version      : String
    var build_type   : String
    var cpu_arch     : String

    fn __init__(inout self, owned build_info : BLRuntimeBuildInfo, owned system_info : BLRuntimeSystemInfo):      
        self.build_info = build_info
        self.system_info = system_info

        if build_info.build_type==BL_RUNTIME_BUILD_TYPE_DEBUG:
            self.build_type = String("Debug")
        elif build_info.build_type==BL_RUNTIME_BUILD_TYPE_RELEASE:
            self.build_type = String("Release")
        else:
            self.build_type = String("Unknown")

        if system_info.cpuArch==BL_RUNTIME_CPU_ARCH_X86:
            self.cpu_arch = String("x86")
        elif system_info.cpuArch==BL_RUNTIME_CPU_ARCH_ARM:
            self.cpu_arch = String("ARM")
        elif system_info.cpuArch==BL_RUNTIME_CPU_ARCH_MIPS:
            self.cpu_arch = String("MIPS")
        else:
            self.cpu_arch = String("Unknown")                  

        self.version     = String(build_info.major_version)+"."+String(build_info.minor_version)+"."+String(build_info.patch_version)

    @staticmethod
    fn new() -> Optional[Self]:
        var result = Optional[Self](None)  
        var _b2d = LibBlend2D.new()
        if _b2d: 
            var b2d = _b2d.take()
            var build_info = BLRuntimeBuildInfo()
            var ptr = UnsafePointer[BLRuntimeBuildInfo](build_info).bitcast[UInt8, AddressSpace.GENERIC]()
            var res = b2d._handle.get_function[blRuntimeQueryInfo]("blRuntimeQueryInfo")(BLRuntimeInfoType.build(), ptr)
            if res==BL_SUCCESS:
                var system_info = BLRuntimeSystemInfo()
                ptr = UnsafePointer[BLRuntimeSystemInfo](system_info).bitcast[UInt8, AddressSpace.GENERIC]()
                res = b2d._handle.get_function[blRuntimeQueryInfo]("blRuntimeQueryInfo")(BLRuntimeInfoType.system(), ptr)
                if res==BL_SUCCESS:
                    result = Optional[Self]( Self(build_info^, system_info^))
            if res!=BL_SUCCESS:
                print("BLRuntime failed with ",error_code(res))  
            b2d.close()
        return result


    @staticmethod
    fn validation() raises:
        var aaa = BLRuntime.new()
        assert_true(aaa)
        var runtime = aaa.take()
        if is_x86():
            assert_equal(runtime.cpu_arch,String("x86"))
        if is_apple_m1() or is_apple_m2() or is_apple_m3() or is_apple_silicon() or is_neoverse_n1():
            assert_equal(runtime.cpu_arch,String("ARM"))

    