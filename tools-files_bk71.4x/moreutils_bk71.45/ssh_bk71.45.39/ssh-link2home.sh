#!/bin/sh


dir_arg=$1

cwd=$(pwd)
cwdbase=$(basename $cwd)

die () { echo $@; exit 1; }

[ -d "$dir_arg" ] || die "Err: is not a dir: '$dir_arg' "

dir=
case "$dir_arg" in 
  /*) dir="$dir_arg";;
  *) dir="$cwd/$dir_arg";;
esac

[ -d "$dir" ] || die "Err: is not a dir: '$dir' "



sshdir=$HOME/.ssh

hname=$(hostname)


keytype=
case "$cwdbase" in
  sshkeys-clouds_*)
    keytype=clouds
    ;;
  sshkeys-host_*)
    keytype=host
    ;;
  *)
    die "Err: could not detect keytype in '$cwdbase'";
    ;;
esac
    


for pubkey in "$dir"/*.pub; do
   [ -f "$pubkey" ] || continue

   basepubkey=$(basename "$pubkey")
   baseprivkey=${basepubkey%.*}

   privkey=$dir/$baseprivkey
   [ -f "$privkey" ] || die "Err: no private key for '$privkey'"

   chmod 0600 $privkey
   chmod 0644 $pubkey

   if [ "$keytype" = 'host' ]; then
     hostkey=host_${USER}
     case $baseprivkey in
       ${hostkey}_${hname}_*)
        rm -f "$sshdir/$hostkey"
        ln -s $privkey $sshdir/$hostkey

        rm -f "$sshdir/$hostkey".pub
        ln -s $pubkey $sshdir/$hostkey.pub
        ;;
      *)
        die "Err: something wrong with the key format '$baseprivkey'"
        ;;
    esac
  else
    keyname=${baseprivkey%_*} 
   case "$keyname" in
     clouds_*)
       rm -f $sshdir/$keyname
       ln -s $privkey $sshdir/$keyname

       rm -f $sshdir/$keyname.pub
       ln -s $pubkey $sshdir/$keyname.pub
       ;;
     *)
       die "Err: this key format should be: 'clouds_[name]_[stamp]'"
       ;;
   esac
  fi
done

 
# final linking
sshdir=$HOME/.ssh
mkdir -p "$sshdir"

redir=$HOME/redir
mkdir -p $redir

auxdir=$HOME/aux
mkdir -p $auxdir

rm -f $redir/.ssh
ln -s $sshdir $redir/.ssh

rm -f $auxdir/ssh
ln -s $sshdir $auxdir/ssh
