#!/bin/sh

HELP='make a website dump into mhtml with chrome'
USAGE='url outdir'

here=$(dirname $0)
cwd=$(pwd)

url="$1"
target="$2"

outdir="$(dirname "$target")"

node=$HOME/local/bin/node
script=$here/dump_mhtml.js

die () { echo $@; exit 1; }

[ -n "$target" ] || die "no target. usage: $USAGE"
[ -n "$url" ] || die "no url. usage: $USAGE"

[ -f "$node" ] || node=$(/usr/bin/which node)
[ -f "$node" ] || die "Err: no node in $node"
[ -f "$script" ] || die "Err: no script"

#case "$target" in
#  *.mhtml) : ;;
#  *) die "Err: doesnt look like a mhtml target: $target" ;;
#esac

#[ -f "$target" ] && die "Err: target already exists"

case "$url" in
  http*|www*) : ;;
  *) die "Err: doesnt look like url .$url." ;;
esac


case "$url" in
  http*|www*) : ;;
  *) die "Err: doesnt look like url $url" ;;
esac

mkdir -p $outdir

title="$($node $script "$url" "$target")"
if [ "$?" -eq "0" ] ; then
  if [ -f "$target" ] ; then
    echo  "$title"
  else
    die "Err: no file $target could not dump $url"
  fi
else
    die "Err: errcode $?,  could not dump $url"
fi

