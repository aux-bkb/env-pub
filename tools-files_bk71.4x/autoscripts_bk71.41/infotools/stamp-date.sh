#!/bin/sh

spec=$1

HELP='creates a time stamp with a user based prefix'
USAGE='[-s|--sec]'

die () { echo $@; exit 1; }

userid=${USER::2}
[ -n "$userid" ] || die "err: could not detect user id"

stamp=
if [ -n "$spec" ] ; then
  case "$spec" in
    -s|-sec)
      stamp=$(date +"%Y%m%d%H.%M%S")
      ;;
    -h|-help)
      die "Help: $HELP"
      ;;
    *)
      die "usage: $USAGE"
      ;;
  esac
else
   stamp=$(date +"%Y%m%d%H%M")
fi


[ -n "$stamp" ] || die "err: could not detect datesconds " 


echo "$userid$stamp"
