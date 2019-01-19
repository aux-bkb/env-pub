
os=$(uname)
cwd=$(pwd)

auxdir=$HOME/aux

die () { echo $@; exit 1; }

os_conf="tmux-${os}.conf" 

for d in $HOME $auxdir ; do
  rm -f $d/.tmux-common.conf
  ln -s $cwd/tmux-common.conf $d/.tmux-common.conf

  if [ -f "$os_conf" ] ; then
      rm -f $d/.tmux.conf
      ln -s $cwd/$os_conf $d/.tmux.conf
  else
     echo  "todo ' $os"
  fi
done

