
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

homebase=$HOME/base
redir=$homebase/redir
decdir=$HOME/dec
mynodes=$homebase/mynodes
unidecs=$homebase/unidecs
alldecs=$homebase/alldecs

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
rm -rf $alldecs
mkdir -p $alldecs

rm -f $redir/unidec
ln -s $unidecs $redir/unidec
rm -f $HOME/unidec
ln -s $unidecs $HOME/unidec

rm -f $redir/alldecs
ln -s $alldecs $redir/alldecs


linkit () {
  local decimal_path=$1
  local decimal=$2

  rm -f $alldecs/$decimal
  ln -s $decimal_path $alldecs/$unidec
}

handle_decimal () {
  local decimal_path="$1"
  local decimal="$2" 
  local nodeid_arg="$3"

  # eg abc_bk1x-2x.cd1o
  # eg cde_bk13.cd1o
  # eg fgh _bk18.56

  local decimal_id=${decimal##*_}  # eg: bk81.cd1o
  [ -n "$decimal_id" ] || die "Err: no decimal id in '$decimal_id'" 

  local nodeid=${decimal_id##*.}
  case "$nodeid" in 
    [a-z][a-z][0-9][a-z]) : ;;
     *) 
      if [ -n "$nodeid_arg" ] ; then
         nodeid=$nodeid_arg
      else
        die "Err: no nodeid and also no nodeid_arg"
      fi
  esac

   [ -n "$nodeid" ] || die "Err: invalid nodeid with '$nodeid' in decimal_id '$decimal_id' for '$decimal'"



  case "$decimal_id" in
    [a-z][a-z][0-9][0-9].[0-9][0-9].[a-z][a-z][0-9][a-z]) # ..._12.23.cd1o
        echo l1 lllinkit $unidec_path $unidec 
        ;;
    [a-z][a-z][0-9][0-9].[a-z][a-z][0-9][a-z]) # ..._38.cd1o
        echo l2 linkit $unidec_path $unidec 
       continue 
      for d in $unidec_path/*; do
         [ -L "$d" ] && continue
         [ -d "$d" ] || continue
         local bd=$(basename $d)
         local apdx=${bd##*.}
         handle_unidec $d $bd $unidec_nodeid
      done
      ;;
    [a-z][a-z][0-9]x*.[a-z][a-z][0-9][a-z])
      linkit $decimal_path $decimal
      find $decimal_path/* -maxdepth 4 -type d | while read xdec; do 
      # ../* is important, otherwise endless loop
       #for xdec in "$unidec_path"/* ; do
         [ -L "$xdec" ] && continue
         [ -d "$xdec" ] || continue
         local bxdec="$(basename $xdec)"
         case "$bxdec" in
           *.unison.tmp*) : ;;
           *_[a-z][a-z][0-9][0-9]|*_[0-9]*.*)
             # echo ehandle_unidec "$xdec" "$bxdec" "$unidec_nodeid"
               handle_decimal "$xdec" "$bxdec" "$nodeid"
             ;;
           *):
             #echo bbb $xdec
             ;;

         esac
       done
       ;;
    [0-9][0-9].[0-9][0-9])
      linkit $decimal_path $decimal.$nodeid
      ;;
    [0-9][0-9])
      echo l5 linkit $unidec_path $unidec.$unidec_nodeid
      ;;
    *)  
      :
       echo l6 echo xx-dec $decimal_id
      ;;

  esac
}

handle_node () {
  local node=$1

  local bn=$(basename $node)

   rm -f $mynodes/$bn
   ln -s $node $mynodes/$bn

   for decimal_path in $node/* ; do
     [ -L "$decimal_path" ] && continue
     [ -d "$decimal_path" ] || continue
     local decimal=$(basename $decimal_path)
     case  "$decimal" in
       *_[a-z][a-z][0-9][0-9]*.[a-z][a-z][0-9][a-z])
         :
         # echo  handle_unidec $unidec_path $unidec
         # linkit $unidec_path $unidec
         ;;
       *_[a-z][a-z][0-9]x*.[a-z][a-z][0-9][a-z]) #   x decs
         handle_decimal "$decimal_path" "$decimal"
          #linkit $unidec_path $unidec
         ;;
       *) 
         #echo "nodec $unidec"
         : 
         ;;
     esac
   done
}

for d in $dirbase/* ; do
  [ -d "$d" ] || continue
  bd=$(basename $d)
  case $bd in
    _*) : ;;
    usrdir_${user}_*_*)
      for n in $d/*; do
        [ -d "$n" ] || continue
        bn=$(basename $n)
        case "$bn" in
          *-*[0-9].*.*)
            handle_node $n
         ;;
          *-*[0-9]_*.*.*) # host nodes
            handle_node $n
         ;;
         *) 
           :
          # echo Nonode $n
          ;;
        esac
      done
      ;;
    *) : ;;
  esac
done

