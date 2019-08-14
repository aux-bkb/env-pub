#!/bin/sh

HELP='lowercase a string'

USAGE='string'

string="$1"

pl=$(which perl)

# ----

die () { echo $@; exit 0; }

[ -n "$string" ] || die "usage: $USAGE"

[ -f "$pl" ] || die "Err: could not find perl"


lowerstring="$($pl -e 'print(lc($ARGV[0]));' "$string")"
[ -n "$lowerstring" ] || die "Err: could not lower string $string"

echo $lowerstring


