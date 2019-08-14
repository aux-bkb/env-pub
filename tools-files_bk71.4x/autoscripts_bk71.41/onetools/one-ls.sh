#!/bin/sh


die () { echo $@; exit 1; }

onehist=$HOME/.onehist

[ -f "$onehist" ] || die "err no onehist file"

awk=$(which awk)

path=$($awk '/./{line=$0} END{print line}' "$onehist")

[ -n "$path" ] || die "err: no path in onehist file"
[ -f "$path" ] || die "err: no valid path in onehist file in path $path"


echo "$path"/
ls "$path"/

