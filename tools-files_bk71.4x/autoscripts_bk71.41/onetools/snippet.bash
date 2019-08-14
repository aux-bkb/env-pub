#!/usr/bin/env bash
#
# needs bash

# todo(pbcopy/pbpaste): only works on mac

HELP='creates a snippet in onebox, url from cli, text when possible from clipboard'

USAGE='[-noninter(active)] [-tags] [-url] title'

homebase=$HOME/base
infodir=$homebase/infodir

onebox=$infodir/onebox

onehist=$HOME/.onehist
xtags_file=$HOME/.xtags

infotools="$HOME/tools/autoscripts/infotools"

moreutils="$HOME/tools/moreutils"
webtools="$moreutils/web"
stringtools="$moreutils/strings"

strings_match_file=$stringtools/strings-match-file.pl
stamp_base26="$infotools/stamp-base26.sh"

tags2xtags=$infotools/tags2xtags.pl
title_from_url="$webtools/title-from-url.sh"
clean_string=$moreutils/strings/clean-string.sh
nonwhitespace_string=$moreutils/strings/nonwhitespace-string.sh
lynx=/usr/local/bin/lynx
perl=/usr/bin/perl
# ----

die () { echo $@; exit 0; }

## sys-check
[ -d "$infotools" ] || die "Err: no infotools folder in $infotools"

for script in "lynx:$lynx" "stamp_base26:$stamp_base26" "title_from_url:$title_from_url" "clean_string:$clean_string" "nonwhitespace_string:$nonwhitespace_string" "string_match_file.pl:$strings_match_file" "perl:$perl" "tags2xtags:$tags2xtags"; do
  scriptname=${script%:*}
  scriptfile=${script##*:}
  [ -f "$scriptfile" ] || die "Err: could not find script $scriptname in $scriptfile"
done


snippet_stamp=$(/bin/sh "$stamp_base26")
[ -n "$snippet_stamp" ] || die "err: could generate date stamp"

## arg-check
url= noninteractive= tags= title=
while [ $# != 0 ] ; do
  case "$1" in
    -h|*-help) die "Help: $HELP" ;;
    *-noninter*) noninteractive=1 ;;
    *-tag|*-tags) shift && tags="$1" || die "Err: no tags"  ;;
    *-title) shift && title="$1" || die "Err: no tags"  ;;
    *-url) shift && url="$1" || die "Err: no url" ;;
    -*) die "Err: arg $1 invalid arg" ;;
    *) title="$title $1" ;;
   esac
   shift
done

mkdir -p $onebox

# get and clean the title
clean_title= body_text=
if [ -n "$title" ] ; then
   clean_title="$(/bin/sh $clean_string "$title")"
   body_text=$(/usr/bin/pbpaste)
else
   clean_title="$(/bin/sh $title_from_url "$url" -exit0)"
   if [ "$?" = "0" ] ; then
     if [ -n "$clean_title" ] ; then
         if [ -n "$url" ] ; then
           body_text=$(/usr/bin/pbpaste)
         else
           url=$(/usr/bin/pbpaste) 
         fi
     else 
       body_text=$(/usr/bin/pbpaste)
     fi
   else
     die "err: script $title_from_url failed with error $?: $clean_title"
   fi
fi

# get tags
xtags= 
if [ -n "$tags" ] ;then
   clean_tags="$(/bin/sh $clean_string "$tags")"
   xtags="$($perl "$tags2xtags" "$clean_tags")"
else
  # try to retrieve xtags from title and ~/.xtags
  match_tags="$($perl $strings_match_file "$xtags_file"  "$clean_title")"
  xtags="$($perl "$tags2xtags" "$match_tags")"
fi

text_title=
if [ -n "$noninteractive" ]; then
   text_title="$clean_title"
else
   echo "--------"
   echo "Edit Title and Enter xTags after -- "
   echo "-----------"
   if [ -n "$clean_title" ] ; then
      read  -i "$clean_title -- $xtags"  -e clean_title
   else
      read  clean_title
   fi

   newtags="$(perl -e '($title,$tags)=split(/\-\-/,$ARGV[0],2); print $tags if $tags;' "$clean_title")"
   text_title="$(perl -e '($title)=split(/\-\-/,$ARGV[0]); print $title;' "$clean_title")"
   xtags="$($perl "$tags2xtags" "$newtags")"
   clean_title="$text_title -- $xtags"
fi

file_tags= dir_tags= comma_tags=
if [ -n "$xtags" ] ; then
   comma_tags="$(/bin/sh $nonwhitespace_string "$xtags" ',')"
   dir_tags_="$(/bin/sh $nonwhitespace_string "$xtags" '_')"
   dir_tags="_$dir_tags_"
   file_tags=" - $xtags"
 else
   # try to retrieve xtags from title with ~/.xtags
   :
fi

filetitle="$(/bin/sh $nonwhitespace_string "$clean_title")"

short_title=${filetitle::50}

snippet_filename="snippet - $short_title$file_tags $snippet_stamp.txt"

onebox_filepath="$onebox/$snippet_filename"
if [ -f "$onebox_filepath" ] ;then 
  die "err: file $snippet_filename already exists"
else
  {
     echo "snippet: $text_title"
     echo ""
     echo "url: $url"
     echo ""
     [ -n "$comma_tags" ] && {
      echo "tags: $comma_tags"
      echo ""

      }
     echo "id: $snippet_stamp"
     echo ""
     echo "-------"
     echo ""
  } > "$onebox_filepath"

  if [ -n "$body_text" ] ; then
    echo $body_text >> "$onebox_filepath"
  else
    tmp_html=$(mktemp)
    $lynx -dump "$url" > $tmp_html
    cat "$tmp_html" >> "$onebox_filepath"
  fi

   echo "$onebox_filepath" >> "$onehist"
   echo "$onebox_filepath"

fi


