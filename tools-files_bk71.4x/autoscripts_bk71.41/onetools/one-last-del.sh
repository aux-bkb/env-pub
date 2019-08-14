#!/bin/sh


die () { echo $@; exit 1; }

onehist=$HOME/.onehist

[ -f "$onehist" ] || die "err no onehist file"

awk=$(which awk)

path=$($awk '/./{line=$0} END{print line}' "$onehist")

[ -n "$path" ] || die "err: no path in onehist file"
[ -f "$path" ] || die "err: no valid path in onehist file in path $path"

mkdir -p ~/trash

waidln="$(grep waid: "$path")"

mv "$path" ~/trash/

if [ -n "$waidln" ] ; then
  waid=$(perl -e '$ARGV[0]=~/waid\:\s*(.*)/;print $1;' "$waidln") 
  waid_path="$(mdfind "kMDItemFSName = *$waid")"
  [ -n "$waid_path" ] && {
   [ -d "$waid_path" ] && {
      echo "There is an webarc, delete? [y]"
      read answ
      [ "$answ" = "y" ] && {
        rm -rf "$waid_path"
      }
    }
  }
else
  :
fi

