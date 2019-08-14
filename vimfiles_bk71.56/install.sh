#!/bin/sh

cwd=$(pwd)

rlinks=$HOME/base/rlinks
rm -f ~/r
ln -s $rlinks ~/r


for n in  vim_bk71.56.11 vimrc vimrc-all vimrc.d_bk71.56.12 ; do

    if [ -d "$n" ] ; then
		bn=${n%_*}
		case "$n" in
			${n}_[a-z][a-z][0-9][0-9].*)
				rm -f $HOME/.$bn
				ln -s $cwd/$n $HOME/.$bn

				rm -f $rlinks/.$bn
				ln -s $cwd/$n $rlinks/.$bn
			;;
	      *) : ;;
	    esac
    elif [ -f "$n" ] ; then
	    rm -f $HOME/.$n
	    ln -s $cwd/$n $HOME/.$n

	    rm -f $rlinks/.$n
	    ln -s $cwd/$n $rlinks/.$n
    else
	    continue
    fi
done
