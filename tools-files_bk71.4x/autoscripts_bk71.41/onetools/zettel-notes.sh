#!/bin/sh


input=$1


[ -n "$input" ] || input=$(pwd) 

echo iii $input
for f in $input/* ; do
  [ -f "$f" ] || continue
  bf=$(basename "$f")
  df=$(dirname "$f")

  case "$bf" in 
    *_bk*.txt|*_bk*.md) 
      ;;
    *_5v*.txt|*_5v*.md) # catching old formats
      mm=$(perl -e '$ARGV[0] =~ /.*_(5v\S*)\.txt/ and print $1' "$f" )
      file=$(perl -e '$ARGV[0] =~ /(.*)_(5v\S*)\.txt/ and print $1' "$bf" )
      [ -n "$mm" ] && {
        echo "mmm $mm"
        dc=$($HOME/aux/utils/decrockstamp "$mm")
        zid=$($HOME/aux/utils/crock-stamp "$dc")
        mv "$f" "$df/$file _bk$zid.txt"
      }
      ;;
    *.txt)
      file=$(perl -e '$ARGV[0] =~ /(.*).txt/ and print $1' "$bf" )
      echo generating a zid, wait for 60s
      sleep 63 
        zid=$($HOME/aux/utils/crock-stamp )
        mv "$f" "$df/$file _bk$zid.txt"

     echo ffff  $file
      ;;
    *)
      : 
      ;;
  esac
done
