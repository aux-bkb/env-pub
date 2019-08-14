#!/bin/sh

HELP='Clean a string, so that we have only alphanumeric characters'

USAGE='[-n|--nonwhitespace -l|--lowercase] string'

pl=$(which perl)

# ----

die () { echo $@; exit 0; }


[ -f "$pl" ] || die "Err: could not find perl"

lowercase= string= nonwhitespace=
while [ $# != 0 ] ; do
  case "$1" in
    -l|--lowercase)
      lowercase=1
      shift
      ;;
    -n|--nonwhitespace)
      nonwhitespace=1
      shift
      ;;
    -h|--help)
      echo "$HELP"
      die "usage: $USAGE"
      ;;
    *)
      string="$1"
      shift
      ;;
  esac
done

[ -n "$string" ] || die "usage: $USAGE"

cleanstring=
if [ -n "$lowercase" ] && [ -n "$nonwhitespace" ] ; then
  cleanstring="$($pl -e '$ARGV[0] =~ s/^\s+|\s+$//g;$ARGV[0] =~ s/[^A-Za-z0-9]+/_/g;print(lc($ARGV[0]));' "$string")"
elif [ -n "$lowercase" ] ; then
  cleanstring="$($pl -e '$ARGV[0] =~ s/^\s+|\s+$//g;$ARGV[0] =~ s/[^A-Za-z0-9]+/ /g;print(lc($ARGV[0]));' "$string")"
elif [ -n "$nonwhitespace" ] ; then
  cleanstring="$($pl -e '$ARGV[0] =~ s/^\s+|\s+$//g;$ARGV[0] =~ s/[^A-Za-z0-9]+/_/g;print($ARGV[0]);' "$string")"
else
   cleanstring="$($pl -e '$ARGV[0] =~ s/^\s+|\s+$//g;$ARGV[0] =~ s/[^A-Za-z0-9]+/ /g;print($ARGV[0]);' "$string")"
fi

if [ -n "$cleanstring" ] ; then
  echo "$cleanstring"
else
  die "Err: could not create clean string out of string '$string'"
fi
