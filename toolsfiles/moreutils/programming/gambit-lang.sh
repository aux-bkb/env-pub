#!/bin/sh

lang=$1

input=$2

rts_input=$3

die () { echo $@; exit 1; }

[ -f "$input" ] || die "usage: <lang> <prog.scm> [<rts.scm>]"

input_base=$(basename $input)
input_dir=$(dirname $input)
name=${input_base%.*}

input_name=$input_dir/$name

ext=
case "$lang" in
  php)
    ext=php
    ;;
  *)
    die "todo: lang $lang"
    ;;
esac

output=$input_dir/$name.$ext


rts=
if [ -f "$rts_input" ] ; then
  rts=$rts_input
else
  rts=$input_dir/rts-$lang.scm
fi

[ -f "$rts" ] || die "Err: no rts system for lang in $rts"

rts_name=${rts%.*}

gsc -:=. -target $ext -c $rts  # prod: rts.$ext
gsc -:=. -target $ext -link -l rts.$ext "$input" 
cat ${input_name}_.$ext $input_name.$ext $rts_name.$ext > $input_dir/out.$ext
