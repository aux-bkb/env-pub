#!/bin/sh

# sync test

cwd=$(pwd)
cwdbase=$(basename $cwd)
cwdbase_name=${cwdbase%_*}

homebase=$HOME/homebase
redir=$HOME/redir
auxdir=$HOME/aux

mkdir -p "$redir" 
mkdir -p "$auxdir" 

rm -f $auxdir/env-pub
ln -s $cwd $auxdir/env-pub

share=$HOME/share
mkdir -p $HOME/share
rm -f $redir/share
ln -s $HOME/share $redir/share

exohome=$HOME/.exo
mkdir -p "$exohome" 

rm -f $redir/homebase
ln -s $homebase $redir/homebase

for d in $homebase/*; do
  [ -d "$d" ] | continue
  bd=$(basename $d)
  rm -f $redir/$bd
   ln -s $d $redir/$bd
   case "$bd" in 
     *_*_*)
     for dd in $d/* ; do
       [ -d "$dd" ] || continue
       bdd=$(basename $dd)
       case "$bdd" in
         *.*.*)
           rm -f $dirs/$bdd
           ln -s $dd $dirs/$bdd
           ;;
         *) : ;;
       esac
     done
       ;;
     *) : ;;
   esac
done

rm -f ~/r
ln -s $redir ~/r

rm -f $redir/aux
ln -s $auxdir $redir/aux


rm -f $exohome/tools
ln -s $cwd/exotools $exohome/tools

#link to redir
for d in  cheats cheatsheet.txt dotfiles exotools; do
	[ -e "$d" ] || continue
	rm -f $redir/$d
	ln -s $cwd/$d $redir/$d
done

# exotools
exohome=$HOME/.exo
mkdir -p $exohome/log
rm -f $exohome/tools
ln -s $cwd/exotools $exohome/tools


rm -f $redir/.exo
ln -s $exohome $redir/.exo
rm -f $redir/exotools
ln -s $cwd/exotools $redir/

# link from ~/ to redir/
for d in hack Downloads local share Dropbox ; do
   [ -d "$HOME/$d" ] || continue
   rm -f $redir/$d
   ln -s $HOME/$d $redir/$d
done

rm -f $redir/boot.sh
ln -s $cwd/boot.sh $redir/

for d in toolsfiles dotfiles vimfiles tmuxfiles ; do
   [ -d "$d" ] && {
      bn=$(basename $d)
      rm -f $redir/$bn
      ln -s $cwd/$bn $redir/$bn
   
      cd "$d" 
      sh ./install.sh
      cd $cwd
   }
 done


#for d in aux-*-site; do
#   [ -d "$d" ] || continue
#   nm=${d#*-}
#   rm -f $redir/aux/$nm
#   ln -s $cwd/$d $redir/aux/$nm
#
#   lang=${nm%-*}
#   mkdir -p $share/$lang
#   rm -f $share/$lang/site
#   ln -s $cwd/$d $share/$lang/site
#   rm -f $redir/$nm
#   ln -s $cwd/$d $redir/$nm
#done
