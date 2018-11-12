#!/bin/sh

keypath=$1

keyname=$(basename $keypath)

cwd=$(pwd)
cwdbase=$(basename $cwd)
cwdname=${cwdbase%_*}

ssh=$HOME/.ssh

[ -d "$ssh" ] && {
   kkname=${keyname%_*}

   kname=
   case $cwdname in 
     ssh-clouds)
       kname=$kkname
       ;;
     ssh-host)
      kname=${kkname%_*}
       ;;
     *)
       echo "todo $cwdname"
       exit 1
       ;;
   esac

  echo kname $kname

   rm -f $ssh/$kname
   rm -f $ssh/$kname.pub

   echo ln -s $cwd/$keypath $ssh/$kname
   echo ln -s $cwd/$keypath.pub $ssh/$kname.pub

   ln -s $cwd/$keypath $ssh/$kname
   ln -s $cwd/$keypath.pub $ssh/$kname.pub
   

   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/$kname

   for f in authorized_keys known_hosts config ; do
      [ -f "$HOME/.ssh/$f" ] && chmod 644 "$HOME/.ssh/$f" 
   done
}
