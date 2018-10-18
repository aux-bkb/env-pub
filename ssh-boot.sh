
die () { echo $@ ; exit 1; }

sshome="$HOME/.ssh" 

[ -d "$sshome" ] || die "Err: no ssh dir"


for k in $sshome/*.pub ; do
  [ -f "$k" ] || continue
  bk=$(basename $k)
  pk=${bk%.*}
  $HOME/tools/utils/load-ssh $sshome/$pk
  keychain --eval --quiet -Q $sshome/$pk
done

# source $HOME/.config/fish/config.fish
