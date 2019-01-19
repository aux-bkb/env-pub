#!/bin/sh

dir=$1

[ -n "$dir" ] || dir=$(pwd)


devdir=$HOME/dev

redir=$HOME/redir

mkdir -p $devdir
mkdir -p $redir

rm -f $redir/dev
ln -s $devdir $redir/dev

parent_dir=$(dirname $dir)
parent_name=$(basename $parent_dir)

dir_name=$(basename $dir)

devname=$dir_name.$parent_name

rm -f $devdir/$devname
ln -s $dir $devdir/$devname



