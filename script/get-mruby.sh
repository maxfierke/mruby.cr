# mruby.cr: script/get-mruby.sh
#
# Based on code from
# mrusty. mruby safe bindings for Rust
# Copyright (C) 2016  Dragoș Tiselice
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This script generates mruby-out.tar which is the mruby repository compiled to
# C files.
#
# Dependencies:
# * Ruby
# * Bison
# * compile, linker & archiver
# * unzip

VERSION=2.1.2
CURRENT=$PWD

# Checks is /tmp/mruby needs cleaning or creation.

if [ -d /tmp/mruby ]; then
  rm -rf /tmp/mruby/*
else
  mkdir /tmp/mruby
fi

cd /tmp/mruby

wget https://github.com/mruby/mruby/archive/$VERSION.zip
unzip -u $VERSION.zip

mkdir -p mruby-out/lib
mkdir -p mruby-out/src/mrblib
mkdir -p mruby-out/src/mrbgems

cd mruby-$VERSION

# minirake compiles the compiler and rb files to C.

./minirake

# Adds all .h files from include.

cp -R include ../mruby-out

# Adds src and C-compiled mrblib.

cp src/*.c ../mruby-out/src
cp src/*.h ../mruby-out/include
cp -R build/host/lib/* ../mruby-out/lib
cp build/host/mrblib/mrblib.c ../mruby-out/src/mrblib/mrblib.c

# Removes incompatible files.

find mrbgems -type f ! -name "*.c" -and ! -name "*.h" -and ! -name "*.def" -and ! -name "*.cstub"  -delete
find mrbgems -type d -empty -delete
find build/host/mrbgems -type f ! -name "*.c" -and ! -name "*.h" -and ! -name "*.cstub" -delete
find build/host/mrbgems -type d -empty -delete

# Removes incompatible gems.

rm -rf mrbgems/mruby-bin*
rm -rf build/host/mrbgems/mruby-bin*

rm -rf mrbgems/mruby-test
rm -rf build/host/mrbgems/mruby-test

# Copies all gems.

cp -R mrbgems/* ../mruby-out/src/mrbgems
cp -R build/host/mrbgems/* ../mruby-out/src/mrbgems

# Copies header files.

mkdir -p ../mruby-out/include/mruby/ext
find mrbgems -path '*/include/mruby/ext/*' -name '*.h' -exec cp {} ../mruby-out/include/mruby/ext \;
find mrbgems -path '*/include/mruby/*' -name '*.h' -exec cp {} ../mruby-out/include/mruby \;

cd ..

tar -cf $CURRENT/mruby-out.tar mruby-out

mkdir -p $CURRENT/build
tar -C $CURRENT/build -xf $CURRENT/mruby-out.tar
