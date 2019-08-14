indir=$1

die () { echo $@; exit 1; }

[ -n "$indir" ] || indir=$(pwd)
[ -d "$indir" ] || die invalid dir $indir 

homebase=$HOME/base
redir=$homebase/redir

intsdir=$homebase/intsdir
floatsdir=$homebase/floatsdir
decsdir=$homebase/decsdir

linkhome () {
  local name=$1
  local dir=$2

  mkdir -p $dir

  rm -f $HOME/$name
  ln -s $dir $HOME/$name

  rm -f $redir/$name
  ln -s $dir $redir/$name
}

linkhome ints $intsdir
linkhome floats $floatsdir
linkhome decs $decsdir

link_decs () {
  local dec=$1
  local target=$2
  local dir=$3

  rm -f $target/$dec

  echo "link: $dir -> $target/$dec"
  ln -s $dir $target/$dec
}

bindir=$(basename $indir)
case "$bindir" in
 *_[a-z][a-z][0-9][0-9].[0-9][0-9])
   echo link_decs $bindir $floatsdir $dir
   link_decs $bindir $decsdir $indir

   ;;
 *_[a-z][a-z][0-9][0-9].[a-z][a-z][0-9][a-z])
   case "$bindir" in
       *-*_[a-z][a-z][0-9][0-9].[a-z][a-z][0-9][a-z])
         first=${bindir%-*}
         mkdir -p $homebase/$first
         linkhome $first $homebase/$first
         link_decs $bindir $homebase/$first $indir
         ;;
     *) : ;;
   esac
   ;;
 *)
   echo nn $bindir
   ;;
esac


for dir in $indir/*; do
 [ -d "$dir" ] || continue
 bdir=$(basename $dir)
 case "$bdir" in
   *_[a-z][a-z][0-9][0-9].[0-9][0-9])
     echo link_decs $bdir $floatsdir $dir
     link_decs $bdir $floatsdir $dir
     ;;
   *)
     echo nn $bdir
     ;;
 esac
done 
