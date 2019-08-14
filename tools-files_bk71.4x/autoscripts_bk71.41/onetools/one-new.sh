#!/bin/sh

HELP='create a new item in the onebox directory. Special remark when writing the title: you can also add tags after "--"'
USAGE='[note] [mark|bookmark] [snip|snippet] [web|webref] [-noninter(active)] [-help] title'

here=$(dirname $0)

labelinput=$1
shift
titleinput="$@"

onebox=$HOME/onebox

onehist=$HOME/.onehist

tagfile=$HOME/.tagfile

infotools=$HOME/tools/autoscripts/infotools
moreutils=$HOME/tools/moreutils
stringutils=$moreutils/strings


die () { echo $@; exit 1; }

[ -d "$onebox" ] || die "err: no onebox in ~/onebox"

strings_match_file=$stringutils/strings-match-file.pl
[ -f "$strings_match_file" ] || die "err: no strings_match_file script"

stamp_base=$infotools/stamp-base26.sh
[ -f "$stamp_base" ] || die "err: no stamp-base script"

[ -f "$tagfile" ] || die "err: no tagfile"

clean_string=$stringutils/clean-string.sh
 
noninteractive=
while [ $# != 0 ] ; do
  case "$1" in
    -h|*-help) 
      echo "usage: $USAGE"
      echo ""
      die "Help: $HELP" ;;
    -noninter*) noninteractive=1 ;;
    #-t|*-tag|*-tags) shift && tags="$1" || die "Err: no tags"  ;;
    -*)
      die "Err: unknown option. usage: $usage"
      ;;
  esac
  shift
done

label= url=
if [ -n "$labelinput" ] ; then
  case "$labelinput" in
    bookmark|mark) 
      label='bookmark'
      url=$1
      shift
      case "$url" in
        http*|www*) : ;;
        *) die "err: '$url' no valid url";;
      esac
      ;;
    snippet|snip) label='snippet';;
    *) die "Err: unknown label $label" ;; 
  esac
else
   read -p "Label: (bm bookmark, )" label 
fi
[ -n "$label" ] || die "err: no label"


[ -n "$titleinput" ] || read -p "Title/Filname: "  titleinput
[ -n "$titleinput" ] || die "err: no title"

splitcode='@t=split(/\-\-/, $ARGV[0]); die "Err: toomuch --" if (@t>2)'
title="$(perl -e "$splitcode; print \$t[0];" "$titleinput")"
titletags="$(perl -e "$splitcode; print \$t[1];" "$titleinput")"


cleantitle="$(sh $clean_string "$title")"
[ "$?" = "0" ] || die "Err: problem with clean-string $?: $cleantitle"

cleantags=
[ -n "$titletags" ] && {
  cleantags="$(sh $clean_string "$titletags")"
   [ "$?" = "0" ] || die "Err: problem with clean-string $?: $cleantags"
}

[ -n "$cleantags" ] || {
   tags="$(perl $strings_match_file $tagfile "$title")"
   [ -n "$tags" ] && cleantags="$(sh $clean_string "$tags")"
}

die xxcleantitle $cleantags 



stamp=$(sh $stamp_base)

filename="$label $title $stamp.txt"
filepath="$onebox/$filename"
if [ -f "$filepath" ] ;then 
  die "err: file $filename already exists"
else
  label_title="$label: $title"
  {
     echo "$label_title"
     echo ""
     echo "$stamp"
     echo ""
     [ -n "$url" ] && {
       echo "url: $url"
         echo ""
       }
     echo "-------"
     echo ""
  } > "$filepath"

   echo "onebox file path in ~/.onehist: $filepath"
   echo "$filepath" >> "$onehist"
fi


