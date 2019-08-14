#!/bin/sh


infolder=$1
get_id=$2

get_id_default=$HOME/tools/moreutils/decimals_bk71.45.16/dec-id.sh

die () { echo $@; exit 1; }

[ -d "$infolder" ] || infolder=$(pwd)

[ -f "$get_id" ] || get_id=$get_id_default
[ -f "$get_id" ] || die "Err: no script get_id in $get_id"

for d in $infolder/*; do
  [ -d "$d" ] || [ -f "$d" ] || continue
  bd=$(basename $d)
  dd=$(dirname $d)

  name=$(sh $get_id $d)
  if [ "$?" = "0" ] ; then
   mv $d $dd/$name
  fi
done


