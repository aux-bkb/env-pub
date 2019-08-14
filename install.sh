#!/bin/sh

# sync tester

cwd=$(pwd)
cwdbase=$(basename $cwd)
cwdbase_name=${cwdbase%_*}

homebase=$HOME/base
rlinks=$homebase/rlinks
auxlinks=$homebase/auxlinks

mkdir -p "$rlinks" 
mkdir -p "$auxlinks" 

rm -f ~/aux
ln -s $auxlinks ~/aux

rm -f ~/r
ln -s $rlinks ~/r
rm -f ~/r/base
ln -s $homebase ~/r/base

rm -f $rlinks/$cwdbase_name
ln -s $cwd $rlinks/$cwdbase_name

rm -f $auxlinks/$cwdbase
ln -s $cwd $auxlinks/$cwdbase

rm -f $rlinks/aux
ln -s $auxlinks $rlinks/aux

sharedir=$HOME/share
mkdir -p $sharedir

rm -f $rlinks/share
ln -s $sharedir $rlinks/share

rm -f $sharedir/templates
ln -s $cwd/templates $sharedir/templates

rm -f $rlinks/homebase
ln -s $homebase $rlinks/homebase

for d in $homebase/*; do
  [ -d "$d" ] | continue
  bd=$(basename $d)
  rm -f $rlinks/$bd
   ln -s $d $rlinks/$bd
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


#link to rlinks
for d in  cheats cheatsheet.txt dotfiles_bk71.11 exotools; do
	[ -e "$d" ] || continue
	rm -f $rlinks/$d
	ln -s $cwd/$d $rlinks/$d
done

# link from ~/ to rlinks/
for d in hack Downloads local share Dropbox ; do
   [ -d "$HOME/$d" ] || continue
   rm -f $rlinks/$d
   ln -s $HOME/$d $rlinks/$d
done

rm -f $rlinks/boot.sh
ln -s $cwd/boot.sh $rlinks/


for d in toolsfiles dotfiles_bk71.11 vimfiles tmuxfiles ; do
   [ -d "$cwd/$d" ] && {
      bn=$(basename $d)
      rm -f $rlinks/$bn
      ln -s $cwd/$bn $rlinks/$bn
   
      cd "$cwd/$d" 
      sh ./install.sh
      cd $cwd
   }
 done


#for d in aux-*-site; do
#   [ -d "$d" ] || continue
#   nm=${d#*-}
#   rm -f $rlinks/aux/$nm
#   ln -s $cwd/$d $rlinks/aux/$nm
#
#   lang=${nm%-*}
#   mkdir -p $share/$lang
#   rm -f $share/$lang/site
#   ln -s $cwd/$d $share/$lang/site
#   rm -f $rlinks/$nm
#   ln -s $cwd/$d $rlinks/$nm
#done
