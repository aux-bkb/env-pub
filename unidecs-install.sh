
dirbase="$1"

cwd=$(pwd)

die () { echo $@; exit 1; }

[ -d "$dirbase" ] || die "usage: <dirs_base>"

hostname=$(hostname)
 
case "$dirbase" in
  *${hostname}*[0-9]) : ;;
  *) die "Err: invalid dirs base $dirbase $dirbase" ;;
esac

user=$(whoami)

homebase=$HOME/homebase
redir=$HOME/redir
decdir=$HOME/dec
mynodes=$homebase/mynodes
unidecs=$homebase/unidec

[ -f "unidec.conf" ] || die "Err: no unidec.conf"
rm -f $HOME/.unidec.conf
ln -s $cwd/unidec.conf $HOME/.unidec.conf

rm -f $redir/.unidec.conf
ln -s $cwd/unidec.conf $redir/.unidec.conf

mkdir -p $redir
rm -rf $mynodes
mkdir -p $mynodes
rm -rf $unidecs
mkdir -p $unidecs

rm -f $redir/unidec
ln -s $unidecs $redir/unidec

rm -f $HOME/unidec
ln -s $unidecs $HOME/unidec


linkit () {
  local unidec_path=$1
  local unidec=$2

  rm -f $unidecs/$unidec
  ln -s $unidec_path $unidecs/$unidec
}

handle_unidec () {
  local unidec_path=$1
  local unidec=$2
  local unidec_nodeid_arg=$3

  local unidec_id=${unidec##*_}  # 81.cd1o
  [ -n "$unidec_id" ] || die "Err: no unidec_id in decimal '$unidec_path'" 

  local unidec_nodeid=${unidec_id##*.}
  case "$unidec_nodeid" in
    [a-z][a-z][0-9][a-z]) : ;;
   *) 
    if [ -n "$unidec_nodeid_arg" ] ; then
     unidec_nodeid=$unidec_nodeid_arg
    else
     die "Err: no valid unidec_nodeid with '$unidec_nodeid' in unidec_id '$unidec_id' for '$unidec'"
    fi
    ;;
 esac
  [ -n "$unidec_nodeid" ] || die "Err: no unidec_nodeid"


         #local nunidec_nodeid=${unidec_id##*.}
#         echo $unidec_id
  case "$unidec_id" in
    [0-9][0-9].[0-9][0-9].[a-z][a-z][0-9][a-z]) # ..._12.23.cd1o
        linkit $unidec_path $unidec 
        ;;
    [0-9][0-9].[a-z][a-z][0-9][a-z]) # ..._38.cd1o
        linkit $unidec_path $unidec 
      for d in $unidec_path/*; do
         [ -L "$d" ] && continue
         [ -d "$d" ] || continue
         local bd=$(basename $d)
         local apdx=${bd##*.}
         handle_unidec $d $bd $unidec_nodeid
      done
      ;;
    *[0-9]x.[a-z][a-z][0-9][a-z])
        linkit $unidec_path $unidec
      find $unidec_path/* -maxdepth 4 -type d | while read xdec; do # ../* is important, otherwise endless loop
       #for xdec in "$unidec_path"/* ; do
         [ -L "$xdec" ] && continue
         [ -d "$xdec" ] || continue
         local bxdec=$(basename $xdec)
         case $bxdec in
           *.unison.tmp*) : ;;
           *_[0-9]*.*)
             #echo handle_unidec $unidec_path $bxdec $unidec_nodeid
             handle_unidec $xdec $bxdec $unidec_nodeid
             ;;
           *): ;;
         esac
       done
       ;;
    [0-9][0-9].[0-9][0-9])
      linkit $unidec_path $unidec.$unidec_nodeid
      ;;
    *)  
      :
      #echo xx-dec $unidec_id $unidec
      ;;

  esac
}

handle_node () {
  local node=$1

  local bn=$(basename $node)

   rm -f $mynodes/$bn
   ln -s $node $mynodes/$bn

   for unidec_path in $node/* ; do
     [ -L "$unidec_path" ] && continue
     [ -d "$unidec_path" ] || continue
     local unidec=$(basename $unidec_path)
     case  "$unidec" in
       *_[0-9][0-9]*.[a-z][a-z][0-9][a-z])
         handle_unidec $unidec_path $unidec
         linkit $unidec_path $unidec
         ;;
       *_[0-9]x*.[a-z][a-z][0-9][a-z])
         handle_unidec $unidec_path $unidec
         linkit $unidec_path $unidec
         ;;
       *) : ;;
     esac
   done
}

for d in $dirbase/* ; do
  [ -d "$d" ] || continue
  bd=$(basename $d)
  case $bd in
    _*) : ;;
    userdir_${user}_*_*)
      for n in $d/*; do
        [ -d "$n" ] || continue
        bn=$(basename $n)
        case "$bn" in
          *-*[0-9].*.*)
            handle_node $n
         ;;
          *-*[0-9]_*.*.*)
            handle_node $n
         ;;
         *) 
           :
#          echo Nonode $n
          ;;
        esac
      done
      ;;
    *) : ;;
  esac
done

