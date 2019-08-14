#!/bin/sh

HELP='Geneare an id with user id and a crockford version of date stamp'
USAGE='[-s|--sec]'

arg=$1

function die () { echo $@; exit 1; }

stamp_crock_script=$HOME/tools/moreutils/math/base-crockford.py
[ -f "$stamp_crock_script" ] || die "Err:cannot find stamp-crock in $stamp_crock_script"

py=$(which python3)
[ -n "$py" ] || die "Err: no python interp"
[ -f "$py" ] || die "Err: no python interp"

userid=$arg

stamp=
if [ -n "$arg" ] ; then
  case "$arg" in
   -h|--help) die "help: $HELP" ;;
 esac
fi

stamp_minute=$(date +"%d%H%M%S%Y%m")
stamp_crock=$($py $stamp_crock_script $stamp_minute)
[ -n "$stamp_crock" ] || die "Err: no stamp-crock in $stamp_crock"
stamp="$userid$stamp_crock"

echo "$stamp"

