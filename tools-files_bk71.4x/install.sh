#!/bin/sh

cwd=$(pwd)

rlinks=$HOME/base/rlinks
mkdir -p $rlinks
rm -f $HOME/r
ln -s $rlinks $HOME/r

toolslinks=$HOME/base/toolslinks
mkdir -p $toolslinks
rm -f ~/tools
ln -s $toolslinks ~/tools

for f in aliases.fish ; do
  rm -f ~/tools/$f
  ln -s $cwd/$f ~/tools/$f

  rm -f ~/r/$f
  ln -s $cwd/$f ~/r/$f
done

for t in *; do
   [ -d "$t" ] || continue

   bt=$(basename $t)
   btname=${bt%_*}

   rm -f ~/tools/$btname
   ln -s $cwd/$t ~/tools/$btname

   rm -f ~/r/$btname
   ln -s $cwd/$t ~/r/$btname
done

