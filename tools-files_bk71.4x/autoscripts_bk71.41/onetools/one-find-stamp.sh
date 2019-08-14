#!/bin/sh


onebox=$HOME/onebox

die () { echo $@; exit 1; }

[ -d "$onebox" ] || die "Err no onebox"

read searchstring

stamp="$(perl -e '$ARGV[0] =~ /([a-z][a-z]\d\d\d\d\d\d[a-z]*)(\.\S+)?$/ and print $1;' "$searchstring")"

[ -n "$stamp" ] || die "Err: searchstring is not a valid stamp"


found=
for f in "$(find $onebox/ -iname "*${stamp}*")"; do
  if [ -n "$found" ] ; then 
   die "Err: already found something"
 else
   echo "$f"
   found=1
   fi
done

