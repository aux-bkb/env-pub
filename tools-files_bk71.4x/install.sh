#!/bin/sh

cwd=$(pwd)

tools=$HOME/tools
mkdir -p $tools

redir=$HOME/base/redir

mkdir -p $redir
rm -f $HOME/r
ln -s $redir $HOME/r

rm -f $redir/tools
ln -s $tools $redir/tools

for f in aliases.fish ; do
  rm -f $tools/$f
  ln -s $cwd/$f $tools/$f

  rm -f $redir/$f
  ln -s $cwd/$f $redir/$f
done

for t in *; do
   [ -d "$t" ] || continue

   bt=$(basename $t)
   btname=${bt%_*}

   rm -f $tools/$btname
   ln -s $cwd/$t $tools/$btname

   rm -f $redir/$btname
   ln -s $cwd/$t $redir/$btname
done

