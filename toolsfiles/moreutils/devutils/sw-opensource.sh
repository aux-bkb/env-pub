#!/bin/sh

USAGE='<dir> [topic:build files]'

# Release OSS software: release the source tree and optionaly a selection of built files and te
# Please make sure the main build file has a similar name as the project
# - create a build of todays date, not for the entire source tree, but only for selected <STDIN> buildfiles
# - create a src.tar


dir=$1
shift
buildfiles="$@"

this=$(basename $(pwd))
project_name=${this%.*}

die () { echo $@; exit 1; }

[ -n "$dir" ] || die "usage: $USAGE"
[ -d "$dir" ] || die "Err: source directory '$dir' not exists";

rev=$(git rev-list --count HEAD)
[ -n "$rev" ] || die "Err: could not fetch revision nr with 'git rev-list --count HEAD'"

sw_base=$dir/../sw
sw_archive=$sw_base/archive

mkdir -p $sw_archive

devmk= readme= license= input=
for f in $dir/*; do
  [ -f "$f" ] || continue 
  bf=$(basename $f)
  case "$bf" in
    README*|readme*|Readme*) readme=$bf ;;
    LICENSE*|license*|License*) license=$bf ;;
  esac
done

[ -n "$readme" ] || die "Err: no readme found"
[ -n "$license" ] || die "Err: no license found"
[ -f "dev.mk" ] || die "Err: no dev.mk found"

make -f dev.mk prepare-build
[ "$?" = "0" ] || die "Err: 'make -f dev.mk sw-build' failed"

build_latest=${project_name}_build_latest
rm -rf $build_latest
mkdir -p $build_latest

today=$(date +"%F")
[ -n "$today" ] || die "Err: no date"
build_today=${project_name}_build_rev${rev}_${today}

tmp_today=$(mktemp)
tmp_latest=$(mktemp)

prn_tmp (){
  echo $@ >> $tmp_today
  echo $@ >> $tmp_latest
}
prn_latest (){ echo $@ >> $tmp_latest; }
prn_today (){ echo $@ >> $tmp_today; }

prn_tmp "## Files" 
prn_tmp " "
  prn_tmp "### Version rev${rev}, released $today"
  prn_tmp " "

[ -n "$buildfiles" ] && {

   zip_latest=$build_latest.zip
   zip_today=$build_today.zip

  prn_tmp "**build**: [$zip_latest]($zip_latest) " 
  prn_tmp " " 

  for f in $buildfiles; do
    file="${f##*:}"
    topic="${f%:*}"
    [ -f "$file" ] || continue
    bn=$(basename "$file")
    hasfiles=1
    cp "$file" $build_latest/$bn
    prn_tmp "- $topic: [$bn]($build_latest/$bn) " 
  done


  cp $readme $build_latest/
  prn_tmp "- [$readme]($build_latest/$readme)" 

  cp $license $build_latest/
  prn_tmp "- [$license]($build_latest/$license)" 



  rm -rf ${build_today}*
  cp -r $build_latest $build_today
  rm -f ${build_latest}.zip
  rm -f ${build_today}.zip
  zip -r $build_latest.zip $build_latest > /dev/null
  zip -r $build_today.zip $build_today
  rm -rf $sw_archive/${build_today}*
  rm -rf $sw_archive/${build_latest}*
  rm -rf $sw_base/${build_today}*
  rm -rf $sw_base/${build_latest}*
  cp -r ${build_latest}*  $sw_base/
  rm -f $sw_base/${build_today}.zip
  cp -r ${build_latest}* $sw_archive/
  rm -rf ${build_latest}*
  mv ${build_today}.zip $sw_archive/
}

make -f dev.mk prepare-source 
[ "$?" = "0" ] || die "Err: 'make -f dev.mk sw-src' failed"

sources_today=${project_name}_src_rev${rev}_${today}
sources_latest=${project_name}_src_latest

prn_tmp "" 
prn_tmp "**sources**: [$sources_latest.tar.gz]($sources_latest.tar.gz)" 
prn_tmp "" 
prn_tmp "" 
prn_tmp "### Archives" 
prn_tmp "" 
prn_tmp "" 
prn_latest "- latest build: [archive/$build_today.zip](archive/$build_today.zip)" 
prn_latest "- latest source: [archive/$sources_today.tar.gz](archive/$sources_today.tar.gz)" 

prn_today "- latest build: [$build_today.zip]($build_today.zip)" 
prn_today "- latest source: [$sources_today.tar.gz]($sources_today.tar.gz)" 

prn_tmp " " 
prn_tmp " " 
prn_latest "[archive/](archive)"
prn_today "[archive](.)"


write_index (){
  local target_dir=$1
  local target_file=$2
  local tmp_file=$3

  mkdir -p $target_dir
  local target_path=$target_dir/$target_file

  rm -f $target_path.txt
  { 
    cat "$readme" 
    cat $tmp_file
    echo ''
    echo '### License Text:'
    cat $license
    echo ''
    echo '---'
    echo ''
    date 
  } > $target_path.txt

   rm -f $target_path.html
   pandoc -s $target_path.txt >  $target_path.html
}

index_latest=index
write_index $sw_base $index_latest $tmp_latest


index_today=index_${today}
write_index $sw_archive $index_today $tmp_today


cd ..

rm -rf $sources_latest
rm -rf $sources_today
cp -r $this $sources_today
cp -r $this $sources_latest

rm -rf $sources_today.tar.gz
tar cfz $sources_today.tar.gz $sources_today > /dev/null

rm -rf $sources_latest.tar.gz
tar cfz $sources_latest.tar.gz $sources_latest > /dev/null

rm -rf $sources_latest
rm -rf $sources_today

rm -f sw/archive/$sources_latest.tar.gz
rm -f sw/archive/$sources_today.tar.gz

rm -f sw/$sources_latest.tar.gz
rm -f sw/archive/$sources_latest.tar.gz

mv $sources_today.tar.gz sw/archive/
cp $sources_latest.tar.gz sw/
mv $sources_latest.tar.gz sw/archive

