#!/usr/bin/env bash
#
# needs bashf

# todo(pbcopy/pbpaste): only works on mac

HELP='writes into 2 directories: a webarc folder ~/webarchive and a webref file into nullbox'
USAGE='[-noninter(active)] [-tags tags] [ -title title]  url'

homebase=$HOME/base
infos_links=$homebase/infos_links

nullbox_home=$infos_links/nullbox

webarticles_home=$infos_links/webarticles
year=$(date +"%Y")
webarticles_year=$webarticles_home/webarticles_$year
webarc_userid='wa'

nullhist=$HOME/.nullhist
tagfile=$HOME/.tagfile

infotools="$HOME/tools/autoscripts/infotools"
moreutils="$HOME/tools/moreutils"
webtools="$moreutils/web"
stringtools="$moreutils/strings"

dump_mhtml="$webtools/dump-mhtml.sh"
title_from_url="$webtools/title-from-url.sh"
stamp_base26="$infotools/stamp-base26.sh"
strings_match_file=$stringtools/strings-match-file.pl
prefix_strings="$stringtools/prefix-strings.pl"
clean_string=$moreutils/strings/clean-string.sh
nonwhitespace_string=$moreutils/strings/nonwhitespace-string.sh
lynx=/usr/local/bin/lynx
perl=/usr/bin/perl
# ----

die () { echo $@; exit 0; }

[ -d "$webarticles_home" ] || die "Err: no webarticles home in $webarticles_home"

## sys-check
[ -d "$infotools" ] || die "Err: no infotools folder in $infotools"
[ -n "$year" ] || die 'err: no year for webarc dir'

for script in "lynx:$lynx" "stamp_base26:$stamp_base26" "title_from_url:$title_from_url" "clean_string:$clean_string" "nonwhitespace_string:$nonwhitespace_string" "string_match_file.pl:$strings_match_file" "perl:$perl" "prefix_strings:$prefix_strings" "dump_mhtml:$dump_mhtml"; do
  scriptname=${script%:*}
  scriptfile=${script##*:}
  [ -f "$scriptfile" ] || die "Err: could not find script $scriptname in $scriptfile"
done

## arg-check
url= noninteractive= tags= title=
while [ $# != 0 ] ; do
  case "$1" in
    -h|*-help) 
      echo "usage: $USAGE"
      echo ""
      die "Help: $HELP" ;;
    *-noninter*) noninteractive=1 ;;
    -t|*-tag|*-tags) shift && tags="$1" || die "Err: no tags"  ;;
    *-title) shift && title="$1" || die "Err: no title" ;;
    -*) die "Err: arg $1 invalid arg" ;;
    *) 
      if [ -n "$url" ]; then
        die "err: something wrong with args"
      else
        url=$1
      fi
      ;;
   esac
   shift
done


webarc_stamp=$(/bin/sh "$stamp_base26" $webarc_userid)
[ -n "$webarc_stamp" ] || die "err: could generate date stamp"

sleep 1

webref_stamp=$(/bin/sh "$stamp_base26")
[ -n "$webref_stamp" ] || die "err: could generate date stamp"

[ "$webarc_stamp" = "$webref_stamp" ] && die "err: stamps are identical (webarc/webref)"


mkdir -p $webarticles_year
mkdir -p $nullbox_home

# get and clean the title

tmp_mhtml="$(mktemp)"
[ -n "$url" ] || url=$(pbpaste)

if [ -n "$title" ] ; then
  err="$(/bin/sh "$dump_mhtml" "$url" "$tmp_mhtml")"
   [ "$?" = "0" ] || die "err: script $dump_mhtml failed: $err"
else
  # no title from arg
  title="$(/bin/sh "$dump_mhtml" "$url" "$tmp_mhtml")"
  [ "$?" = "0" ] || die "err($?): script $dump_mhtml failed: $title"
fi

[ -n "$title" ] || { # no title from arg
  title="$(/bin/sh $title_from_url "$url")"
 [ "$?" = "0" ] || die "err: script $title_from_url failed: $title"
}

[ -n "$title" ] || die "Err: no title"

clean_title="$(/bin/sh $clean_string "$title")"


# get tags
tag_words=
if [ -n "$tags" ] ;then
   tag_words="$(/bin/sh $clean_string "$tags")"
else
  # try to retrieve tag words from title and ~/.tagfile
  tag_words="$($perl $strings_match_file "$tagfile"  "$clean_title")"
fi


title_text= title_tags=
if [ -n "$noninteractive" ]; then
   text_title="$clean_title"
   title_tags="$tag_words"
else
   echo "--------"
   echo "Edit Title and Enter Tags Words after -- "
   echo "-----------"
   read  -i "$clean_title -- $tag_words"  -e title_w_tags 

   title_tags="$(perl -e '($title,$tags)=split(/\-\-/,$ARGV[0],2); print $tags if $tags;' "$title_w_tags")"
   text_title="$(perl -e '($title)=split(/\-\-/,$ARGV[0]); print $title;' "$title_w_tags")"
fi

dir_tags= comma_tags= xtags= dirtag_sep= filetag_sep=
if [ -n "$title_tags" ] ; then
   comma_tags="$($perl $prefix_strings '#'  "$title_tags" )"
   dir_tags="$($perl $prefix_strings -sep='_' 'x' "$title_tags"  )"
   xtags="$($perl $prefix_strings -ucfirst x  "$title_tags")"
   dirtag_sep='--'
   filetag_sep=' -- '
 else
   dirtag_sep='_'
   filetag_sep=''
   # try to retrieve xtags from title with ~/.xtags
   :
fi


# webarticles directory
title_dir="$(/bin/sh $clean_string -n -l "$title")"
webarc_dir="${title_dir::40}"
webarticles_dir="$webarticles_year/${webarc_dir}$dirtag_sep$dir_tags-${webarc_stamp}"
[ -d "$webarticles_dir" ] && die "Err: the archive dir $webarticles_dir already exists"

target_meta="$webarticles_dir/meta.txt"
target_mhtml="$webarticles_dir/index.mhtml"
[ -f "$target_mhtml" ] && die "Err: target_mhtml $target_mhtml exists"
[ -f "$target_meta" ] && die "Err: target_meta $target_meta exists"

mkdir -p "$webarticles_dir"

# webref file
webref_title="${text_title::40}"
webref_filename="webref - $webref_title$filetag_sep$xtags -$webref_stamp.txt"
webref_filepath="$nullbox_home/$webref_filename"
[ -f "$webref_filepath" ] && die "Err: the webref file $webref_filepath already exists"


{
   echo "webref: $text_title"
   echo ""
   echo "url: $url"
   echo ""
   [ -n "$comma_tags" ] && {
    echo "tags: $comma_tags"
    echo "xtags: $xtags"
    echo ""

    }
   echo "id: $webref_stamp"
   echo "waid: $webarc_stamp"
   echo ""
   echo "-------"
   echo ""
} > "$webref_filepath"

tmp_html="$(mktemp)"
$lynx -dump "$url" > $tmp_html

cat "$tmp_html" >> "$webref_filepath"

 echo "$webref_filepath" >> "$nullhist"
 echo "$webref_filepath"

 # write meta file
 
{
   echo "title: $text_title"
   echo ""
   echo "url: $url"
   echo ""
   [ -n "$comma_tags" ] && {
    echo "tags: $comma_tags"
    echo ""
    }
   echo "date: "$(date +"%Y.%m.%d")
   echo "id: $webarc_stamp"
   echo ""
   echo "-------"
   echo ""
} > "$webarticles_dir/meta.txt"
 cat "$tmp_html" >> "$target_meta"

 cat "$tmp_mhtml" > $target_mhtml
printf $target_mhtml | pbcopy

