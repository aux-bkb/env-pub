#!/bin/sh

input="$1"
lang="$2"

die (){ echo $@; exit 1; }

[ -f "$input" ] || die "usage: <file> <output lang>"
[ -n "$lang" ] || die "usage: <file> <output lang>"

indir=$(dirname "$input")
infile=$(basename "$input")

name=${infile%.*}
ext=${infile##*.}

upname=$(perl -e 'print ucfirst($ARGV[0])' "$name")

compile () {
  local haxelang="$1"
  local output="$2"

   echo "compile with ..."
   echo "haxe -m $upname $haxelang $output" 
   haxe -m "$upname" $haxelang "$output" 
}

case "$lang" in
  hl)
    outname=$name.hl
    output="$indir"/."$outname"
    [ "$output" -nt "$input" ] || compile '-hl' "$output"
    hl "$output"
    ;;
  php)
    outname=$name.hl
    outputdir="$indir"/$name
    output="$outputdir/index.php"
    [ "$output" -nt "$input" ] || compile '-php' "$outputdir"
    php "$output"
    ;;

  *)
    die "Err: unknown ext"
    ;;
esac
