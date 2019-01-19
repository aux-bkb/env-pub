#!/bin/sh

cwd=$(pwd)

auxdir=$HOME/aux

mkdir -p $auxdir

rm -rf $HOME/.vim
rm -f $auxdir/vim
ln -s $cwd/vim $HOME/.vim
ln -s $cwd/vim $auxdir/vim

rm -rf $HOME/.vimrc.d
rm -f $auxdir/vimrc.d
ln -s $cwd/vimrc.d $HOME/.vimrc.d
ln -s $cwd/vimrc.d $auxdir/vimrc.d

rm -f $HOME/.vimrc
rm -f $auxdir/vimrc
ln -s $cwd/vimrc $HOME/.vimrc
ln -s $cwd/vimrc $auxdir/vimrc

