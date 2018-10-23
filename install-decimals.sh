#!/bin/sh

# sync test

cwd=$(pwd)

homebase=$HOME/homebase

die () { echo $@; exit 1 ; }

[ -d "$homebase" ] || dir "Err: no homebase '$homebase'"

redir=$homebase/redir
mkdir -p $redir

decimals=$homebase/decimals
topics=$decimals/_topics
items=$decimals/_items
before=$decimals/_before
after=$decimals/_after
category=$decimals/_category

link_it () {
   local name=$1
   local dir=$2

   rm -rf $dir
   mkdir -p $dir
  
   for i in  $HOME $redir ; do
      [ -d "$i" ] || continue
      rm -f $i/$name
      ln -s $dir $i/$name
   done
}

link_it topics $topics
link_it decimals $decimals
link_it items $items
link_it before $before
link_it category $category
link_it after $after

## ----------------

link_dir() {
  local base=$1
  local bdir=$2
  local dir=$3

   rm -f $base/$bdir
   ln -s $dir $base/$bdir
   
   rm -f $decimals/$bdir
   ln -s $dir $decimals/$bdir
}


handle_topic () {
  local bdir=$1
  local dir=$2

  local fulltopic=${bdir%%_*}
  local item=${bdir#*_}

  local topo=${fulltopic##*-}
  local topic=${topo}s

  case $bdir in
    *-*_*) 
      mkdir -p $topics/$topic
      rm -f $topics/$topic/$bdir
	    ln -s $dir $topics/$topic/$bdir

      rm -f $redir/$bdir
      ln -s $dir $redir/$bdir
   ;;
   *) : ;;
   esac 
}

handle_subtopic () {
  local bdir=$1
  local dir=$2

  local fulltopic=${bdir%%_*}
  local item=${bdir#*_}

  local topo=${fulltopic##*-}
  local topic=${topo}s

  case $bdir in
    *-*_*_*) 
      mkdir -p $topics/$topic
      rm -f $topics/$topic/$bdir
      ln -s $dir $topics/$topic/$bdir
   ;;
   *) : ;;
   esac 
}

dir_ls () {
  local dir=$1

  for d in $dir/* ; do
    [ -d "$d" ] || continue
    bd=$(basename $d)
    if echo $d | egrep -q 'backup'; then
      :
    elif echo $d | egrep -q '_archive'; then
      :
    elif echo $d | egrep -q '_meta'; then
      :
    else
      dir_filter $bd $d
    fi
  done
}


dir_filter () {
  local bdir=$1
  local dir=$2

  if echo $bdir | egrep -q '_\d+'  ; then


    if echo $bdir | egrep -q '_\d+$' ; then
      link_dir $before $bdir $dir
     handle_topic $bdir $dir
       dir_ls $dir
    elif echo $bdir | egrep -q '_\d+[a-z]$' ; then
      link_dir $before $bdir $dir
     handle_topic $bdir $dir
       dir_ls $dir
    elif echo $bdir | egrep -q '_\d+[a-z]\-\d+[a-z]$' ; then
      link_dir $before $bdir $dir
     handle_topic $bdir $dir
       dir_ls $dir
   elif echo $bdir | egrep -q '_\d+\.\d0$'  ; then
     link_dir $category $bdir $dir
      dir_ls $dir
   elif echo $bdir | egrep -q '_\d+\.\d\d$'  ; then
     link_dir $after $bdir $dir
      handle_subtopic $bdir $dir
      dir_ls $dir
   elif echo $bdir | egrep -q '_\d+\.\d0.\d\d$'  ; then
     link_dir $after $bdir $dir
      dir_ls $dir
   elif echo $bdir | egrep -q '_\d+\.\d\d\-\d\d$'  ; then
     link_dir $after $bdir $dir
      dir_ls $dir
   elif echo $bdir | egrep -q '_\d+\.\d\d\.\d\d\.\w+$'  ; then
     link_dir $items $bdir $dir
   elif echo $bdir | egrep -q '_\d+\.\d\d\.[0-9][a-z]+$'  ; then
     link_dir $items $bdir $dir
   fi
 fi

}

for d in $homebase/*; do
  bd=$(basename $d)
   case "$bd" in 
     *_*_*)
     for dd in $d/* ; do
       [ -d "$dd" ] || continue
       bdd=$(basename $dd)
       case "$bdd" in
         *.*.*) dir_ls $dd ;;
         *) : ;;
       esac
     done
    ;;
     *) : ;;
   esac
done


[ -d "$HOME/Documents" ] && {
  for t in $topics/* ; do
    bt=$(basename $t)
    rm -f $HOME/Documents/$bt
    ln -s $t $HOME/Documents/$bt
  done
}

[ -d "$redir" ] && {
  for t in $topics/* ; do
    bt=$(basename $t)
    rm -f $redir/$bt
    ln -s $t $redir/$bt
  done
}
