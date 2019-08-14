
USAGE='upload_folder devonthink_folder'

upload_folder="$1"
devonthink_folder="$2"

[ -d "$upload_folder" ] || { echo "usage : $USAGE" ; exit 1; }
[ -d "$devonthink_folder" ] || { echo "usage : $USAGE" ; exit 1; }

trash=$upload_folder/trash

mkdir -p $trash

check_remove () {
  local stamp="$1"
  local bname="$2"
  local pdf_file="$3"

#  echo find "$devonthink_folder" -name "*$stamp.pdf"
  found=$(find "$devonthink_folder" -name "*$stamp.pdf")
  
  if [ -n "$found" ] ; then
    rm -f $trash/"$bname"
    mv "$pdf_file" "$trash/$bname"
  else
    echo "could not find '$bname'"
  fi
}

for pdf in $upload_folder/*.pdf ; do
   [ -f "$pdf" ] || continue
   bname=$(basename "$pdf")
   dname=$(dirname "$pdf")
   stamp=$(perl -e '$ARGV[0] =~ /.*(-\w\w\d{14})\.pdf/ && print $1 ' "$bname")
   if [ -n "$stamp" ] ; then 
      check_remove "$stamp" "$bname" "$pdf"
   else
     stamp=$(perl -e '$ARGV[0] =~ /(.*)[-|_]\s*(\w\w\d{8})\.(\d\d)\.(\d\d)\.(\d\d)\.pdf/ && print "$1-$2$3$4$5"; ' "$bname")
   if [ -n "$stamp" ] ; then 
     newfile="$dname/$stamp.pdf"
     mv "$pdf" "$newfile"
     check_remove "$stamp" "$bname" "$newfile"
   else
     stamp=$(perl -e 'my %m;@m{ qw(Jan Feb Mar Apr May Jun Jul Aug Sept Oct Nov Dec)}=("01".."11");$ARGV[0] =~ /Scan (\d*\d) (\w*) (\d\d\d\d) at (\d\d)\.(\d\d)\.pdf/ && (exists $m{$2}) && print "$3$m{$2}$1$4$5"; ' "$bname")
      if [ -n "$stamp" ] ; then 
       newfile="$dname/Scan -ja${stamp}01.pdf"
       mv "$pdf" "$newfile"
       check_remove "$stamp" "$bname" "$newfile"
      else
         echo "not a valid name $pdf"
      fi
   fi
   fi
 done


