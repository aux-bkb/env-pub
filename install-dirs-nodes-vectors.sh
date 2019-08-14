
[ -d "$1" ] || { echo "usage dir root"; exit 1; }

dirroot="$1"

hb=$HOME/base
dirs=$hb/dirs
nodes=$hb/nodes
vectors=$hb/vectors

mkdir -p $hb

redir=$hb/redir
mkdir -p $redir
rm -f $HOME/r
ln -s $redir $HOME/r

linkdir () {
  local name="$1"
  local dir="$2"
   mkdir -p $dir
   rm -f $redir/$name
   ln -s $dir $redir/$name
   rm -f $HOME/$name
   ln -s $dir $HOME/$name
}

linkdir dirs $dirs
linkdir nodes $nodes
linkdir vectors $vectors


for dir in $dirroot/* ; do 
   [ -d "$dir" ] || continue
   bdir=$(basename $dir)
   case $bdir in
     *_backup)
       echo omit backup $bdir
       ;;
     usrdir* | grpdir* )
       rm -f $dirs/$bdir
       ln -s $dir $dirs/$bdir
       for node in "$dir"/* ; do
         [ -d "$node" ] || continue
         bnode=$(basename "$node")
         case $bnode in
           *[0-9]-data.*.*|*[0-9]-store.*.*)
            rm -f $nodes/$bnode
            ln -s $node $nodes/$bnode
            for vector in "$node"/* ; do
               [ -d "$vector" ] || continue
               bvector=$(basename "$vector")
               case $bvector in
                  *_[a-z][a-z][0-9]*.[a-z][0-9][a-z][a-z])
                    rm -f $vectors/$bvector
                    ln -s $vector $vectors/$bvector
                    ;;
                  *) : ;;
                esac
              done
             ;;
           *) : ;;
         esac
       done
      ;; 
    *)
      echo omit $bdir
      ;;
  esac
done

#                     for float in "$int"/* ; do
#                        [ -d "$float" ] || continue
#                        bfloat=$(basename "$float")
#                        case $bfloat in
#                           *_[a-z][a-z][0-9][0-9].[0-9][0-9])
#                              rm -f $floats/$bfloat
#                              ln -s $float $floats/$bfloat
#                           ;;
#                           *) : ;;
#                        esac
#                     done
