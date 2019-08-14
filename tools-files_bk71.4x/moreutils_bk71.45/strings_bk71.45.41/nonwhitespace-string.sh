#!/bin/sh

HELP='replace nonwhitespace with char (default _)'

USAGE='string [char]'

string="$1"
char="$2"

pl=$(which perl)

# ----

die () { echo $@; exit 0; }

[ -n "$string" ] || die "usage: $USAGE"

[ -f "$pl" ] || die "Err: could not find perl"


nwstring=
if [ -n "$char" ] ; then
  nwstring="$($pl -e '$ARGV[0] =~ s/^\s+|\s+$//g;$ARGV[0] =~ s/\s+/$ARGV[1]/g;print($ARGV[0]);' "$string" "$char")"
else
  nwstring="$($pl -e '$ARGV[0] =~ s/^\s+|\s+$//g;$ARGV[0] =~ s/\s+/_/g;print($ARGV[0]);' "$string")"
fi

if [ -n "$nwstring" ] ; then
  echo "$nwstring"
else
  die "Err: could not replace whitespace in string $string"
fi
