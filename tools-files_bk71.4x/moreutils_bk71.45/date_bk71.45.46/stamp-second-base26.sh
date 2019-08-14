#!/bin/sh


die () { echo $@; exit 1; }

base10tobase26=$HOME/tools/moreutils/math_bk71.45.29/base10tobase26.pl

[ -f "$base10tobase26" ] || die "Err: script base10tobase26 missing"

year_month=$(date +"%Y%m")
day_h_min_sec=$(date +"%d%H%M%S")

dhms_base=$(/usr/bin/env perl $base10tobase26 $day_h_min_sec)

echo "$year_month$dhms_base"
