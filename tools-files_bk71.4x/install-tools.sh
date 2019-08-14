
cwd=$(pwd)

redir=$HOME/base/redir

tools=$HOME/tools
mkdir -p  $tools

rm -f $redir/tools
ln -s $tools $redir/tools

for d in * ; do
  [ -d "$d" ] || continue
  based=$(basename $d)
  b=${based%%_*}

  mkdir -p  $tools/$b

  for dd in $d/*; do
    basedd=$(basename $dd)
    bb=${basedd%%_*}

    rm -f $tools/$b/$bb
   ln -s $cwd/$dd $tools/$b/$bb

   #rm -f $redir/$b
   #ln -s $cwd/$d $redir/$b
 done
done

