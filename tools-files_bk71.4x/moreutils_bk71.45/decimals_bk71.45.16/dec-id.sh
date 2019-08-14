#!/bin/sh

USAGE='input dir'

input=$1

cwd=$(pwd)

here=$(dirname $0)

realpath () {
   perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1
}

die () { echo $@; exit 1; }

[ -n "$input" ] || die "usage: $USAGE"

[ -d "$input" ] || die "Err: no a valid dir"

realdir=$(realpath $input)
thisbase=$(basename $realdir)
thislast=${thisbase##*_}

case "$thislast" in
  [a-z][a-z][1-9][1-9].[1-9][1-9]|[a-z][a-z][1-9][1-9].[1-9][1-9].*|[a-z][a-z][0-9][0-9].[0-9]*x) # bk11.11.*
    die "Err: dir is already a decimal"
    ;;
  *) : ;;
esac


parentdir=$(dirname $realdir)

getid () {
  local dec=$1
  local start=$2
  local end=$3
  local id=
  local already_used= aa
  for i in $(seq $start $end) ; do
    [ -n "$match" ] && break
    first=$(perl -e '$ARGV[0] =~ /\d(\d)/ && print $1;' $i)
    [ "$first" = "0" ] && continue
    sec=$(perl -e '$ARGV[0] =~ /(\d)\d/ && print $1;' $i)
    already_used=
    for d in $parentdir/*; do
      [ -d "$d" ] || continue
      bd=$(basename $d)
      case "$bd" in
         *_$dec.${i}x) already_used=1 ;;
         *_$dec.[1-9]x-[1-9]x) 
		 s=$(perl -e '$ARGV[0] =~ /(\d)x-(\d)x/ && print $1 . 0;' $bd)
		 e=$(perl -e '$ARGV[0] =~ /(\d)x-(\d)x/ && print(($2 + 1) * 10);' $bd)
			 #echo ssss $s eeee $e iiii $i
		 if [ $i -gt ${s} ] && [ $i -lt ${e} ] ; then
			 already_used=2
		 fi
		 ;;
         *_$dec.${sec}x) already_used=3 ;;
         *_$dec.$i) already_used=4 ;;
         *) : ;;
      esac
    done
    if [ -z "$already_used" ]; then 
	#die "test $already_used"
      id=$i
      break
    fi
  done

  if [ -n "$id" ] ; then
  	echo $id
  else
	die "Err: no id $i end $end -- $already_used"
  fi

    
}

parentbase=$(basename $parentdir)

parentlast=${parentbase##*_}
parentname=${parentbase%_*}

parent_dec=${parentlast%.*}
parent_float=${parentlast##*.}

if [ -f "$input" ] ; then
 case "$parentlast" in
   [a-z][a-z][0-9][0-9].[0-9]x|[a-z][a-z][1-9][1-9]*.[1-9][1-9])
     thisname=${thisbase%.*}
     thisext=${thisbase##*.}
     if [ "$thisname" = "$thisext" ] ; then
      echo ${thisname}_$parentlast
     else
      echo ${thisname}_$parentlast.${thisext}
     fi
     ;;
   *)
     die "Err: no valid parentdir for input $input"
     ;;
 esac

else

case "$parentlast" in
  [a-z][a-z][1-9][1-9].[a-z][0-9][a-z][a-z]) # bk11.c1do
    id=$(getid $parent_dec 11 99)
    echo ${thisbase}_$parent_dec.$id
    ;;
  [a-z][a-z][1-9][1-9].[1-9][1-9]) # bk11.11
    id=$(getid $parentlast 11 99)
    echo ${thisbase}_$parentlast.$id
    ;;
  [a-z][a-z][1-9][1-9].[1-9]x) # bk11.10
    starter=$(perl -e '$ARGV[0] =~ /(\d)x/ && print $1' $parent_float)
    [ -n "$starter" ] || die "Err: no starter for parent_float $parent_float"
    id=$(getid $parent_dec ${starter}1 ${starter}9)
    echo ${thisbase}_$parent_dec.$id
    ;;
  [a-z][a-z][1-9][1-9].[1-9]x-[1-9]x) # bk11.10
	  starter=$(perl -e '$ARGV[0] =~ /(\d)x\-(\d)x/ && print $1' $parent_float)
	  ender=$(perl -e '$ARGV[0] =~ /(\d)x\-(\d)x/ && print $2' $parent_float)
    [ -n "$starter" ] || die "Err: no starter for parent_float $parent_float"
    id=$(getid $parent_dec ${starter}1 ${ender}9)
    echo ${thisbase}_$parent_dec.$id
    ;;
  [a-z][a-z][1-9][1-9].[1-9][1-9].*) # bk11.11
    die yousass
    ;;
  *)
    die youdiss $parentlast
    ;;
esac
fi
