from blend2d.blimage import BLImage,  BLFileFormat, BLFormat, GrayscaleLensFilter, Grayscale
from blend2d.blmipmap import BLMipmap
from blend2d.blgeometry import BLRectI, BLRect, BLPoint
from blend2d.blcolor import BLRgba32  
from blend2d.blpath import BLPath 
from blend2d.blerrorcode import BL_SUCCESS, error_code
from pathlib import Path

def main():    
    file_format = BLFileFormat.qoi() # Blend2D is able to read a JPEG file but not to encode a JPEG file
    filename = Path("..").joinpath("examples").joinpath("woman.jpg")
    aaa = BLImage.from_file(filename)
    img = aaa.take()       

    filter = Grayscale.luminance( GrayscaleLensFilter.yellow() )
    aaa = img.grayscale(filter, 8)
    if aaa:
        img2 = aaa.take()            
        _ = img2.to_file(Path("14-luminance"), file_format)

    filter = Grayscale.panchromatic( GrayscaleLensFilter.green() )
    aaa = img.grayscale(filter, 8)
    if aaa:
        img2 = aaa.take()
        _ = img2.to_file(Path("14-panchromatic"), file_format)
      
    filter = Grayscale.orthochromatic( GrayscaleLensFilter.red_yellow() )
    aaa = img.grayscale(filter, 8)
    if aaa:
        img2 = aaa.take()
        _ = img2.to_file(Path("14-orthochromatic"), file_format)      