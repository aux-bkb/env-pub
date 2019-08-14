#!/bin/sh

HELP='Geneare an id with user id and a crockford version of date stamp'
USAGE='[-s|--sec]'

arg=$1

function die () { echo $@; exit 1; }

base26=$HOME/tools/moreutils/math/base10tobase26.sh
[ -f "$base26" ] || die "Err:cannot find base26 in $base26"

userid=$arg
[ -n "$userid" ] || userid=${USER::2}
[ -n "$userid" ] || die "err: could not detect user id" 

stamp=
if [ -n "$arg" ] ; then
  case "$arg" in
   -h|--help) die "help: $HELP" ;;
 esac
fi

stamp1=$(date +"%Y%m")
stamp2=$(date +"%d%H%M%S")
stamp_crock2=$(sh $base26 $stamp2)
[ -n "$stamp_crock2" ] || die "Err: no stamp-crock in $stamp_crock2"
stamp="$userid$stamp1$stamp_crock2"

echo "$stamp"

