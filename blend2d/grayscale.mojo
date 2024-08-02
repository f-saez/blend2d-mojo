from algorithm import parallelize
from .blimage import BLImage


@value
struct GrayscaleLensFilter:
	var value : Int

	@staticmethod
	fn none() -> Self:
		return Self(0)

	@staticmethod
	fn red() -> Self:
		return Self(1)

	@staticmethod
	fn red_yellow() -> Self:
		return Self(2)

	@staticmethod
	fn yellow() -> Self:
		return Self(3)

	@staticmethod
	fn green_yellow() -> Self:
		return Self(4)

	@staticmethod
	fn green() -> Self:
		return Self(5)

	@staticmethod
	fn blue_green() -> Self:
		return Self(6)

	@staticmethod
	fn blue() -> Self:
		return Self(7)

	@staticmethod
	fn purple() -> Self:
		return Self(8)

@value
struct Grayscale:

	var coef : SIMD[DType.int32,4]

	@staticmethod
	fn panchromatic(filter : GrayscaleLensFilter) -> Self:
		var coef = SIMD[DType.int32,4](342, 341, 341, 0)
		if filter.value==GrayscaleLensFilter.red().value:
			coef = SIMD[DType.int32,4](-1, 17, 1008, 0)
		elif filter.value==GrayscaleLensFilter.red_yellow().value:
			coef = SIMD[DType.int32,4](-18, 259, 783, 0)
		elif filter.value==GrayscaleLensFilter.yellow().value:
			coef = SIMD[DType.int32,4](7, 432, 585, 0)		
		elif filter.value==GrayscaleLensFilter.green_yellow().value:
			coef = SIMD[DType.int32,4](111, 511, 402, 0)
		elif filter.value==GrayscaleLensFilter.green().value:
			coef = SIMD[DType.int32,4](119, 727, 178, 0)
		elif filter.value==GrayscaleLensFilter.blue_green().value:
			coef = SIMD[DType.int32,4](419, 575, 30, 0)
		elif filter.value==GrayscaleLensFilter.blue().value:
			coef = SIMD[DType.int32,4](970, 54, 0, 0)
		elif filter.value==GrayscaleLensFilter.purple().value:
			coef = SIMD[DType.int32,4](417, 22, 585, 0)	
		return Self(coef)

	@staticmethod
	fn hyper_panchromatic(filter : GrayscaleLensFilter) -> Self:
		var coef = SIMD[DType.int32,4](348, 256, 420, 0)
		if filter.value==GrayscaleLensFilter.red().value:
			coef = SIMD[DType.int32,4](-1, 13, 1012, 0)
		elif filter.value==GrayscaleLensFilter.red_yellow().value:
			coef = SIMD[DType.int32,4](-20, 177, 867, 0)
		elif filter.value==GrayscaleLensFilter.yellow().value:
			coef = SIMD[DType.int32,4](5, 305, 714, 0)	
		elif filter.value==GrayscaleLensFilter.green_yellow().value:
			coef = SIMD[DType.int32,4](122, 370, 532, 0)
		elif filter.value==GrayscaleLensFilter.green().value:
			coef = SIMD[DType.int32,4](161, 588, 275, 0)
		elif filter.value==GrayscaleLensFilter.blue_green().value:
			coef = SIMD[DType.int32,4](488, 494, 42, 0)
		elif filter.value==GrayscaleLensFilter.blue().value:
			coef = SIMD[DType.int32,4](985, 39, 0, 0)
		elif filter.value==GrayscaleLensFilter.purple().value:
			coef = SIMD[DType.int32,4](386, 15, 623, 0)
		return Self(coef)

	@staticmethod
	fn orthochromatic(filter : GrayscaleLensFilter) -> Self:
		var coef = SIMD[DType.int32,4](594, 430, 0, 0)
		if filter.value==GrayscaleLensFilter.red().value:
			coef = SIMD[DType.int32,4](0, 1024, 0, 0)
		elif filter.value==GrayscaleLensFilter.red_yellow().value:
			coef = SIMD[DType.int32,4](0, 1024, 0, 0)
		elif filter.value==GrayscaleLensFilter.yellow().value:
			coef = SIMD[DType.int32,4](27, 997, 0, 0)
		elif filter.value==GrayscaleLensFilter.green_yellow().value:
			coef = SIMD[DType.int32,4](186, 838, 0, 0)
		elif filter.value==GrayscaleLensFilter.green().value:
			coef = SIMD[DType.int32,4](178, 846, 0, 0)
		elif filter.value==GrayscaleLensFilter.blue_green().value:
			coef = SIMD[DType.int32,4](570, 454, 0, 0)
		elif filter.value==GrayscaleLensFilter.blue().value:
			coef = SIMD[DType.int32,4](987, 37, 0, 0)
		elif filter.value==GrayscaleLensFilter.purple().value:
			coef = SIMD[DType.int32,4](987, 37, 0, 0)
		return Self(coef)

	@staticmethod
	fn pseudo_infrared() -> Self:
		return Self( SIMD[DType.int32,4](-122, 1433, -287) )
	
	@staticmethod
	fn luminance(filter : GrayscaleLensFilter) -> Self:
		var coef = SIMD[DType.int32,4](113, 604, 107, 0)
		if filter.value==GrayscaleLensFilter.red().value:
			coef = SIMD[DType.int32,4](0, 32, 992, 0)
		elif filter.value==GrayscaleLensFilter.red_yellow().value:
			coef = SIMD[DType.int32,4](-26, 479, 571, 0)
		elif filter.value==GrayscaleLensFilter.yellow().value:
			coef = SIMD[DType.int32,4](-25, 678, 371, 0)
		elif filter.value==GrayscaleLensFilter.green_yellow().value:
			coef = SIMD[DType.int32,4](2, 765, 257, 0)
		elif filter.value==GrayscaleLensFilter.green().value:
			coef = SIMD[DType.int32,4](11, 914, 99, 0)
		elif filter.value==GrayscaleLensFilter.blue_green().value:
			coef = SIMD[DType.int32,4](103, 897, 24, 0)
		elif filter.value==GrayscaleLensFilter.blue().value:
			coef = SIMD[DType.int32,4](602, 422, 0, 0)
		elif filter.value==GrayscaleLensFilter.purple().value:
			coef = SIMD[DType.int32,4](138, 38, 848, 0)
		return Self(coef)
