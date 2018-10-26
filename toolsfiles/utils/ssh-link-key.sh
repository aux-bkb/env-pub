#!/bin/sh

keypath=$1

keyname=$(basename $keypath)

cwd=$(pwd)
ssh=$HOME/.ssh

[ -d "$ssh" ] && {
   kkname=${keyname%_*}
   kname=${kkname%_*}

  echo linkit $kname

   rm -f $ssh/$kname
   rm -f $ssh/$kname.pub

   echo ln -s $cwd/$keypath $ssh/$kname
   echo ln -s $cwd/$keypath.pub $ssh/$kname.pub

   ln -s $cwd/$keypath $ssh/$kname
   ln -s $cwd/$keypath.pub $ssh/$kname.pub
}
