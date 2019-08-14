#!/bin/sh

cwd=$(pwd)

homebase=$HOME/base
mkdir -p $homebase

auxlinks=$homebase/auxlinks
mkdir -p $auxlinks

rm -f ~/aux
ln -s $auxlinks ~/aux

mkdir -p ~/trash

trash=$HOME/trash
[ -d "$trash" ] || mkdir $trash
rm -f $auxdir/trash 
ln -s $trash $auxdir/trash


linkfiles (){
   local dir=$1

   for f in $dir/*; do
      bf=$(basename $f)
      if [ -d "$f" ];  then

      case $bf in
      *_files) 
         for ff in $f/*; do
            [ -e "$ff" ] || continue
            bff=$(basename $ff)
                     [ -z $bff ] && continue
            t="$trash"/$(date +"%Y%m%d%M%S")
            [ -d "$t" ] || mkdir -p  $t
            [ -e "$HOME/.$bff" ] && { mv $HOME/.$bff $t/ ; }
            rm -f $HOME/.$bff
            ln -s 	$ff $HOME/.$bff
         done
      ;;
      *_dir) 
         name=${bf%_*}
         rm -rf $HOME/.$name
           ln -s $f $HOME/.$name
      ;;
      *_config_indir)  # non destructive sub folders under ~/.config
         mname=${bf%_*}
         name=${mname%_*}

         homeconfig=$HOME/.config/$name

         [ -d "$homeconfig" ] || mkdir -p "$homeconfig"

         for ff in $f/*; do
               bff=$(basename $ff)
               [ -e "$ff" ] || continue
               rm -rf  $homeconfig/$bff
               ln -s 	$ff $homeconfig/$bff
           done

         ;;
      *_indir)  # non destructive sub folders
         name=${bf%_*}
         homedir=$HOME/.$name
         [ -d "$homedir" ] || mkdir $homedir 

           for ff in $f/*; do
               bff=$(basename $ff)
               [ -e "$ff" ] || continue
               rm -rf  $homedir/$bff
              ln -s 	$ff $homedir/$bff

           done
      ;;
      *_config)  # destructive sub folders under ~/.config
         name=${bf%_*}

         [ -d "$HOME/.config" ] || mkdir -p $HOME/.config

         homedir=$HOME/.config/$name

           rm -rf $homedir
           ln -s $f $homedir

      ;;
      *)
         echo "Warn: omit directory '$f'"
      ;;
      esac
   else
           [ "$bf" = 'install.sh' ] && continue
           [ "$bf" = 'README.txt' ] && continue

            rm -f $HOME/.$bf
            ln -s $f $HOME/.$bf

   fi
   done
}

linkfiles $cwd 

os=$(uname)
if [ -d "$os" ] ; then
   linkfiles "$cwd/$os"
fi

