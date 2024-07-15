from blend2d.blimage import BLImage,  BLFileFormat, BLFormat, BLImageScaleFilter
from blend2d.blcontext import BLCompOp
from blend2d.blerrorcode import error_code
from time.time import now
from pathlib import Path

@always_inline
def convert_to_ms(x : Int) -> Int:
    return x // 1000000

# for readability, I will assume every optional and function if good
def main():
    # I choose to use an image big enough to feel some differences
    # in processing time    
    # source of the image : https://en.wikipedia.org/wiki/Blue_poison_dart_frog
    # https://upload.wikimedia.org/wikipedia/commons/d/dd/Dendrobates_azureus_qtl1.jpg
    filename = Path("..").joinpath("examples").joinpath("Dendrobates_azureus_qtl1.jpg")
    a = BLImage.from_file(filename)
    img_src = a.take()  
    # here we got a 2432x1664 image. Not a big one by today standards
    # but still big enough for me to show you some things

    w = 820.0
    h = w * img_src.get_height_f64() / img_src.get_width_f64()
    aaa = BLImage.new(w.cast[DType.int32]().value, h.cast[DType.int32]().value, img_src.get_format()) # more or less the same aspect/ratio
    # why 820x563 ? If Ii've reduced the image to, let's say, 4000x2749, the downsize will not had been 
    # enough to show some difference between the filters. If we can choose between 4 filters, 
    # it's for the obvious reason that they produce different results at differents speeds
    # it's usually the the uglier the fastest, but, as always, it's not so simple.
    # keep in mind that these results are only valid for blend2d and the way it implements
    # them. Any other software will have a different implmentation and, thus, different 
    # results (better quality but slower or ...)
    # the main point of Blend2D is being fast beacuse it is design for GUI and it is fast.
    img_downsized = aaa.take()

    file_format = BLFileFormat.qoi()
    # let's start
    tic = now()
    _ = img_src.scale_to_existing(img_downsized, BLImageScaleFilter.nearest())
    toc = now() - tic
    print("time downsize / Nearest neighbor: ", convert_to_ms(toc), "ms")
    _ = img_downsized.to_file(Path("01_nearest_neighbor.qoi"), file_format)

    tic = now()
    _ = img_src.scale_to_existing(img_downsized, BLImageScaleFilter.bilinear())
    toc = now() - tic
    print("time downsize / bilinear: ", convert_to_ms(toc), "ms")
    _ = img_downsized.to_file(Path("02_bilinear.qoi"), file_format)

    tic = now()
    _ = img_src.scale_to_existing(img_downsized, BLImageScaleFilter.bicubic())
    toc = now() - tic
    print("time downsize / bicubic: ", convert_to_ms(toc), "ms")       
    _ = img_downsized.to_file(Path("03_bicubic.qoi"), file_format)

    tic = now()
    _ = img_src.scale_to_existing(img_downsized, BLImageScaleFilter.lanczos())
    toc = now() - tic
    print("time downsize / Lanczos: ", convert_to_ms(toc), "ms")       
    _ = img_downsized.to_file(Path("04_lanczos.qoi"), file_format)
    # usually, for downsizing, bilinear is the best ratio speed/quality

    # now let's upscale. Usually, nobody do an upscaling that big with these kind of filters
    # or this kind of software, except when you need real-time reactivity.
    # For quality, there are far better solutions like SUPIR (https://github.com/Fanghua-Yu/SUPIR)
    # or CCSR (https://github.com/csslc/CCSR) or many others ... but the are waaayyyy slower.
    # last image was Lanczos and it wasn't the worst
    tic = now()
    _ = img_downsized.scale_to_existing(img_src, BLImageScaleFilter.nearest())
    toc = now() - tic
    print("time upscale / Nearest neighbor: ", convert_to_ms(toc), "ms")
    _ = img_src.to_file(Path("05_nearest_neighbor.qoi"), file_format)

    tic = now()
    _ = img_downsized.scale_to_existing(img_src, BLImageScaleFilter.bilinear())
    toc = now() - tic
    print("time upscale / bilinear: ", convert_to_ms(toc), "ms")
    _ = img_src.to_file(Path("06_nearest_neighbor.qoi"), file_format)

    tic = now()
    _ = img_downsized.scale_to_existing(img_src, BLImageScaleFilter.bicubic())
    toc = now() - tic
    print("time upscale / bicubic: ", convert_to_ms(toc), "ms")
    _ = img_src.to_file(Path("07_bicubic.qoi"), file_format)

    tic = now()
    _ = img_downsized.scale_to_existing(img_src, BLImageScaleFilter.lanczos())
    toc = now() - tic
    print("time upscale / Lanczos: ", convert_to_ms(toc), "ms")
    _ = img_src.to_file(Path("08_lanczos.qoi"), file_format)

    # obviously, it was fast.
    # obviously, you'll want to compare with the original, with a 100 % zoom.
    # and obviously, it will hurt your eyes.