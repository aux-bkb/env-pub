
os=$(uname)
cwd=$(pwd)


die () { echo $@; exit 1; }

os_conf="tmux-${os}.conf" 

  rm -f $HOME/.tmux-common.conf
  ln -s $cwd/tmux-common.conf $HOME/.tmux-common.conf

  if [ -f "$os_conf" ] ; then
      rm -f $HOME/.tmux.conf
      ln -s $cwd/$os_conf $HOME/.tmux.conf
  else
     echo  "todo ' $os"
  fi

