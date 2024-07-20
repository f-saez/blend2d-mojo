#!/bin/bash
DIR="./temp_examples"

if [ -d "$DIR" ]; then
  rm -rf $DIR
fi

echo "remember, libblend2d.so should be in your library path"

mkdir $DIR
mojo package blend2d -I ./blend2d -o $DIR/blend2d.mojopkg

echo -e "Executing all the examples...\n"
cp  examples/*.mojo $DIR

cd $DIR
rm -f __init__.mojo
for i in $(ls -1 *.mojo); do mojo $i; done
