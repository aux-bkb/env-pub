#!/bin/sh

onehist=$HOME/.onehist

die () { echo $@; exit 1; }

trash=$HOME/trash
mkdir -p $trash


[ -f "$onehist" ] || die "err no onehist file"

awk=$(which awk)

onepath=$($awk '/./{line=$0} END{print line}' "$onehist")
[ -n "$onepath" ] || die "err: no path in onehist file"


if [ -f "$onepath" ] ; then
   echo "$onepath"
else
  echo "Last line in ~/.onehist contains an invalid path, delete [y|N]:"
  echo "$onepath"
  echo "-----"
  read answ
  [ "$answ" = "y" ] && {
    tmp=$(mktemp)
   [ -f "$tmp" ] || die "Err: could not create tmp file in $tmp"
   
   sed '$d' "$onehist" > $tmp
    echo "Put ~/.onehist in ~/trash"
    mv $onehist $trash/
   cat $tmp > $onehist
  }
fi



