#!/bin/bash
DIR="./temp_examples"

if [ -d "$DIR" ]; then
  rm -rf $DIR
fi

echo "remember, libblend2d.so should be in your library path"

mkdir $DIR
mojo package blend2d -I ./blend2d -o $DIR/blend2d.mojopkg

echo -e "Building binaries for all examples...\n"
mojo build examples/01-basics.mojo -o $DIR/01-basics
mojo build examples/02-basic_path.mojo -o $DIR/02-basic_path
mojo build examples/03-basic_text.mojo -o $DIR/03-basic_text
mojo build examples/04-basic_glyphs.mojo -o $DIR/04-basic_glyphs
mojo build examples/05-path.mojo -o $DIR/05-path

cd $DIR
./01-basics
./02-basic_path
./03-basic_text
./04-basic_glyphs
./05-path
