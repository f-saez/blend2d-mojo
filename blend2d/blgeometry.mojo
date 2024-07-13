
alias BL_FLATTEN_MODE_DEFAULT:UInt32 = 0
alias BL_OFFSET_MODE_DEFAULT:UInt32 = 0

alias BL_GEOMETRY_TYPE_NONE:UInt32 = 0     # No geometry provided.
alias BL_GEOMETRY_TYPE_BOXI:UInt32 = 1 	# BLBoxI struct.
alias BL_GEOMETRY_TYPE_BOXD:UInt32 = 2 	# BLBox struct.
alias BL_GEOMETRY_TYPE_RECTI:UInt32 = 3 	# BLRectI struct.
alias BL_GEOMETRY_TYPE_RECTD:UInt32 = 4 	# BLRect struct.
alias BL_GEOMETRY_TYPE_CIRCLE:UInt32 = 5 	# BLCircle struct.
alias BL_GEOMETRY_TYPE_ELLIPSE:UInt32 = 6 	# BLEllipse struct.
alias BL_GEOMETRY_TYPE_ROUND_RECT:UInt32 = 7 # BLRoundRect struct.
alias BL_GEOMETRY_TYPE_ARC:UInt32 = 8 	# BLArc struct.
alias BL_GEOMETRY_TYPE_CHORD:UInt32 = 9 # BLArc struct representing chord.
alias BL_GEOMETRY_TYPE_PIE:UInt32 = 10 	# BLArc struct representing pie.
alias BL_GEOMETRY_TYPE_LINE:UInt32 = 11 # BLLine struct.
alias BL_GEOMETRY_TYPE_TRIANGLE:UInt32 = 12 	# BLTriangle struct.
alias BL_GEOMETRY_TYPE_POLYLINEI:UInt32 = 13 	# BLArrayView<BLPointI> representing a polyline.
alias BL_GEOMETRY_TYPE_POLYLINED:UInt32 = 14 	# BLArrayView<BLPoint> representing a polyline.
alias BL_GEOMETRY_TYPE_POLYGONI:UInt32 = 15 	# BLArrayView<BLPointI> representing a polygon.
alias BL_GEOMETRY_TYPE_POLYGOND:UInt32 = 16 	# BLArrayView<BLPoint> representing a polygon.
alias BL_GEOMETRY_TYPE_ARRAY_VIEW_BOXI:UInt32 = 17 # BLArrayView<BLBoxI> struct.
alias BL_GEOMETRY_TYPE_ARRAY_VIEW_BOXD:UInt32 = 18 	# BLArrayView<BLBox> struct.
alias BL_GEOMETRY_TYPE_ARRAY_VIEW_RECTI:UInt32 = 19 # BLArrayView<BLRectI> struct.
alias BL_GEOMETRY_TYPE_ARRAY_VIEW_RECTD:UInt32 = 20 # BLArrayView<BLRect> struct.
alias BL_GEOMETRY_TYPE_PATH:UInt32 = 21 	# BLPath (or BLPathCore). 

alias BL_GEOMETRY_DIRECTION_NONE:UInt32 = 0 # No direction specified.
alias BL_GEOMETRY_DIRECTION_CW:UInt32 = 1 # Clockwise direction.
alias BL_GEOMETRY_DIRECTION_CCW:UInt32 = 2 # Counter-clockwise direction. 

#============================================================================================================
#
#          The "enums" part
#
#============================================================================================================
@value
struct BLGeometry:
    var value : UInt32

    @staticmethod
    @always_inline
    fn none() -> Self:
        return Self(BL_GEOMETRY_TYPE_NONE)

    @staticmethod
    @always_inline
    fn boxI() -> Self:
        return Self(BL_GEOMETRY_TYPE_BOXI)

    @staticmethod
    @always_inline
    fn boxD() -> Self:
        return Self(BL_GEOMETRY_TYPE_BOXD)

    @staticmethod
    @always_inline
    fn rectI() -> Self:
        return Self(BL_GEOMETRY_TYPE_RECTI)

    @staticmethod
    @always_inline
    fn rectD() -> Self:
        return Self(BL_GEOMETRY_TYPE_RECTD)

    @staticmethod
    @always_inline
    fn circle() -> Self:
        return Self(BL_GEOMETRY_TYPE_CIRCLE)

    @staticmethod
    @always_inline
    fn elipse() -> Self:
        return Self(BL_GEOMETRY_TYPE_ELLIPSE)

    @staticmethod
    @always_inline
    fn round_rect() -> Self:
        return Self(BL_GEOMETRY_TYPE_ROUND_RECT)

    @staticmethod
    @always_inline
    fn arc() -> Self:
        return Self(BL_GEOMETRY_TYPE_ARC)

    @staticmethod
    @always_inline
    fn chord() -> Self:
        return Self(BL_GEOMETRY_TYPE_CHORD)

    @staticmethod
    @always_inline
    fn pie() -> Self:
        return Self(BL_GEOMETRY_TYPE_PIE)

    @staticmethod
    @always_inline
    fn line() -> Self:
        return Self(BL_GEOMETRY_TYPE_LINE)

    @staticmethod
    @always_inline
    fn triangle() -> Self:
        return Self(BL_GEOMETRY_TYPE_TRIANGLE)

    @staticmethod
    @always_inline
    fn polylineI() -> Self:
        return Self(BL_GEOMETRY_TYPE_POLYLINEI)

    @staticmethod
    @always_inline
    fn polylineD() -> Self:
        return Self(BL_GEOMETRY_TYPE_POLYLINED)

    @staticmethod
    @always_inline
    fn polygonI() -> Self:
        return Self(BL_GEOMETRY_TYPE_POLYGONI)

    @staticmethod
    @always_inline
    fn polygonD() -> Self:
        return Self(BL_GEOMETRY_TYPE_POLYGOND)



@value
struct BLGeometryDirection:
    var value : UInt32

    @staticmethod
    @always_inline
    fn none() -> Self:
        return Self(BL_GEOMETRY_DIRECTION_NONE)

    @staticmethod
    @always_inline
    fn cw() -> Self:
        return Self(BL_GEOMETRY_DIRECTION_CW)

    @staticmethod
    @always_inline
    fn ccw() -> Self:
        return Self(BL_GEOMETRY_DIRECTION_CCW)   

#============================================================================================================
#
#          The basic structs
#
#============================================================================================================

@value
struct BLSizeI(Stringable):
    var w: Int32
    var h: Int32

    fn __init__(inout self):
        self.w = 0
        self.h = 0  

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """        
        return String("w: ")+String(self.w)+String(" h: ")+String(self.h)

@value
struct BLPointI(Stringable):
    var x: Int32
    var y: Int32

    fn __init__(inout self):
        self.x = 0
        self.y = 0                  

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """        
        return String("x: ")+String(self.x)+String(" y: ")+String(self.y)

@value
struct BLRectI(Stringable):
    var x: Int32
    var y: Int32
    var w: Int32
    var h: Int32

    fn __init__(inout self):
        self.x = 0
        self.y = 0                  
        self.w = 0
        self.h = 0                  

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        return String("x: ")+String(self.x)+String(" y: ")+String(self.y)+String("w: ")+String(self.w)+String(" h: ")+String(self.h)

@value
struct BLRect(Stringable):
    var x: Float64
    var y: Float64
    var w: Float64
    var h: Float64

    fn __init__(inout self):
        self.x = 0
        self.y = 0                  
        self.w = 0
        self.h = 0                  

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        return String("x: ")+String(self.x)+String(" y: ")+String(self.y)+String("w: ")+String(self.w)+String(" h: ")+String(self.h)

@value
struct BLLine(Stringable):
    var x0: Float64
    var y0: Float64
    var x1: Float64
    var y1: Float64

    fn __init__(inout self):
        self.x0 = 0
        self.y0 = 0                  
        self.x1 = 0
        self.y1 = 0                  

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        return String("x0: ")+String(self.x0)+String(" y0: ")+String(self.y0)+String("x1: ")+String(self.x1)+String(" y1: ")+String(self.y1)

@value
struct BLTriangle(Stringable):
    var x0: Float64
    var y0: Float64
    var x1: Float64
    var y1: Float64
    var x2: Float64
    var y2: Float64

    fn __init__(inout self):
        self.x0 = 0
        self.y0 = 0                  
        self.x1 = 0
        self.y1 = 0                  
        self.x2 = 0
        self.y2 = 0                  

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        return String("x0: ")+String(self.x0)+String(" y0: ")+String(self.y0)+String("x1: ")+String(self.x1)+String(" y1: ")+String(self.y1)+String("x2: ")+String(self.x2)+String(" y2: ")+String(self.y2)

@value
struct BLRoundRect(Stringable):
    var x: Float64
    var y: Float64
    var w: Float64
    var h: Float64
    var rx: Float64
    var ry: Float64

    fn __init__(inout self):
        self.x = 0
        self.y = 0                  
        self.w = 0
        self.h = 0                  
        self.rx = 0
        self.ry = 0                  

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        return String("x: ")+String(self.x)+String(" y: ")+String(self.y)+String("w: ")+String(self.w)+String(" h: ")+String(self.h)+String("rx: ")+String(self.rx)+String(" ry: ")+String(self.ry)

@value
struct BLCircle(Stringable):
    var cx: Float64
    var cy: Float64
    var r: Float64

    fn __init__(inout self):
        self.cx = 0
        self.cy = 0                  
        self.r = 0

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        return String("x: ")+String(self.cx)+String(" y: ")+String(self.cy)+String("r: ")+String(self.r)

@value
struct BLElipse(Stringable):
    var cx: Float64
    var cy: Float64
    var rx: Float64
    var ry: Float64

    fn __init__(inout self):
        self.cx = 0
        self.cy = 0                  
        self.rx = 0
        self.ry = 0

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        return String("x: ")+String(self.cx)+String(" y: ")+String(self.cy)+String("rx: ")+String(self.rx)+String("ry: ")+String(self.ry)

@value
struct BLApproximationOptions:
    var flatten_mode : UInt8
    var offset_mode : UInt8
    var reserved_flags : InlineArray[UInt8, 6]
    var flatten_tolerance : Float64
    var simplify_tolerance : Float64
    var offset_parameter : Float64
    
    # This struct cannot be simply zeroed and then passed to functions that accept 
    # approximation options. 
    # We need to use blDefaultApproximationOptions to setup defaults and then alter values you want to change.
    # but, blDefaultApproximationOptions seems to be reserved to C/C++ and not really accessible from the outside
    # so, I've copied the values from the code (path_p.h) hoping they don't change too often
    fn __init__(inout self):
        self.flatten_mode = BL_FLATTEN_MODE_DEFAULT
        self.offset_mode = BL_OFFSET_MODE_DEFAULT                  
        self.reserved_flags = InlineArray[UInt8, 6](0)
        self.flatten_tolerance = 0.2
        self.simplify_tolerance = 0.05
        self.offset_parameter = 0.414213562

@value
struct BLArc(Stringable):
    var cx: Float64
    var cy: Float64
    var rx: Float64
    var ry: Float64
    var start: Float64
    var sweep: Float64

    fn __init__(inout self):
        self.cx = 0
        self.cy = 0                  
        self.rx = 0
        self.ry = 0
        self.start = 0
        self.sweep = 0

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        return String("x: ")+String(self.cx)+String(" y: ")+String(self.cy)+String("rx: ")+String(self.rx)+String("ry: ")+String(self.ry)+String("start:")+String(self.start)+String("sweep: ")+String(self.sweep)



@value
struct BLBox(Stringable):
    var x0: Float64
    var y0: Float64
    var x1: Float64
    var y1: Float64
    
    fn __init__(inout self):
        self.x0 = 0
        self.y0 = 0
        self.x1 = 0
        self.y1 = 0

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        return String("x0: ")+String(self.x0)+String(" y0: ")+String(self.y0)+String("x1: ")+String(self.x1)+String(" y1: ")+String(self.y1)

@value
struct BLBoxI(Stringable):
    var x0: Int32
    var y0: Int32
    var x1: Int32
    var y1: Int32
    
    fn __init__(inout self):
        self.x0 = 0
        self.y0 = 0
        self.x1 = 0
        self.y1 = 0

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        return String("x0: ")+String(self.x0)+String(" y0: ")+String(self.y0)+String("x1: ")+String(self.x1)+String(" y1: ")+String(self.y1)

@value
struct BLPoint(Stringable):
    var x: Float64
    var y: Float64
    
    fn __init__(inout self):
        self.x = 0
        self.y = 0

    @staticmethod
    fn new(x : Float64, y : Float64) -> BLPoint:
        """
          I frequently use stayic method "new" associated with Optional.
          here I don't need that but I keep using "new" just for coherence.
        """
        return Self(x,y)
        

    fn __str__(self) -> String:
        """
            just for debuging purpose.
        """
        return String("x: ")+String(self.x)+String(" y: ")+String(self.y)

