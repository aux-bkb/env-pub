cwd=$(pwd)

auxdir=$HOME/aux
mkdir -p $auxdir

for f in prelude.*; do
   [ -f "$f" ] || continue

   rm -f $HOME/.$f
   ln -s $cwd/$f $HOME/.$f

   rm -f $auxdir/.$f
   ln -s $cwd/$f $auxdir/.$f
done

