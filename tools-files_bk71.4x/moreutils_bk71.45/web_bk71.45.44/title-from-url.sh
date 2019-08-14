#!/bin/sh

HELP='retrieve html from url (via args or clipboard) with help from external tool, return clean title'

USAGE='[-n|--nonwhitespace] -l|--lowercase] [-exit0] url'


scriptname=$(basename $0)
scriptbase=${scriptname%.*}
here=$(dirname $0)

pyscript="$here/$scriptbase.py"

# ----

die () { echo $@; exit 1; }

py=
for p in /usr/local/bin /usr/bin ; do
  py=$p/python3
  [ -f "$py" ] && break
done
[ -f "$py" ] || die "err: no python3 in '$py'"

[ -f "$pyscript" ] || die "err: no python script in $pyscript"

url= nonwhitespace= lowercase= exit0=
while [ $# != 0 ] ; do
   case "$1" in
     -exit0) exit0=1 && shift ;;
     -n|--nonwhitespace) nonwhitespace=1 && shift ;;
     -l|--lowercase) lowercase=1 && shift ;;
     -h|--help) echo "Help: $HELP" && die "usage: $USAGE" ;;
     *)
       if [ -n "$url" ] ; then
         die "Err:  with args"
       else
         url=$1
         shift
       fi
       ;;
   esac
done


no_url="Err: no valid url in $url"
case "$url" in 
  http*://*.*|www*.*.*) : ;; 
  *)  
    if [ -n "$exit0" ] ; then
      echo  $no_url
      exit 0
    else
      die "$no_url"
    fi
    ;;
esac

htmltitle="$($py $pyscript "$url")"

[ -n "$htmltitle" ] || die "Err: could not retrieve title from html"

title="$(perl -e '$ARGV[0] =~ s/^\s+|\s+$//g;$ARGV[0] =~ s/[^A-Za-z0-9]+/ /g;print($ARGV[0]);' "$htmltitle")"

if [ -n "$nonwhitespace" ] ; then
   title="$(perl -e '$v=$ARGV[0]; $v =~ s/ /_/g;print($v);' "$title")"
fi

if [ -n "$lowercase" ] ; then
   title="$(perl -e '$v=$ARGV[0]; print(lc($v));' "$title")"
fi

echo "$title"


