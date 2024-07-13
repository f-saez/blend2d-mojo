from blend2d.helpers import *

from testing import assert_equal,assert_false,assert_true
from pathlib import Path

def validation_change_extension():
    t = Path("name.txt")
    assert_equal(Path("name.xz"), set_extension(t,"xz") )
    t = Path("name")
    assert_equal(Path("name.xz"), set_extension(t,"xz") )
    t = Path("name.xz.tgz")
    assert_equal(Path("name.xz.xz"), set_extension(t,"xz") )
    t = Path("name.")
    assert_equal(Path("name.xz"), set_extension(t,"xz") )


def validation_get_file_path():
    filename = Path("temp/tsts/stuff/filename.txt") 
    assert_equal(get_file_path(filename), Path("temp/tsts/stuff"))
    filename = Path("filename.txt") 
    assert_equal(get_file_path(filename), Path(""))


def validation():
    validation_get_file_path()
    validation_change_extension()
