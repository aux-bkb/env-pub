#!/bin/sh

HELP='Geneare an id with user id and a crockford version of date stamp'
USAGE='[-s|--sec]'

arg=$1

function die () { echo $@; exit 1; }

base26=$HOME/tools/moreutils/math_bk71.45.29/base10tobase26.sh

[ -f "$base26" ] || die "Err:cannot find base26 in $base26"

userid=$arg
[ -n "$userid" ] || userid=${USER::2}
[ -n "$userid" ] || die "err: could not detect user id" 

[ "$userid" = "-" ] && userid=''

stamp=
if [ -n "$arg" ] ; then
  case "$arg" in
   -h|--help) die "help: $HELP" ;;
 esac
fi

stamp_minute=$(date +"%Y%m%d%H%M")
stamp_base=$(sh $base26 $stamp_minute)
[ -n "$stamp_base" ] || die "Err: no stamp-base in $stamp_base"
stamp="$userid$stamp_base"

echo "$stamp"

