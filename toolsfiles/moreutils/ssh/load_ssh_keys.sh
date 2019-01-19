#!/bin/sh

key=$1

sshdir=$HOME/.ssh

die(){ echo $@; exit 1; }

[ -e "$sshdir" ] || { echo "Err: no  sshdir under $sshdir" ; exit 1; }

if [ -n "$key" ] ; then

  case "$key" in
    *.pub)
      echo todo pubkeys
      ;;
    *)
      pubkey=$key.pub
      [ -f "$pubkey" ] || die "Err: pub key not exists"
      cmd="$(cat $pubkey | perl -sne '@l = split /\:\:/, $_; print $l[2];')"
      [ -n "$cmd" ] || die "Err: no cmd"

      ccmd="$cmd copyprint"

      echo "Fetch password with '$ccmd'"
      res=$(${cmd})
      if [ -n "$res" ] ; then
        echo "Great! Password is in Clipboard, you can paste it ...."
        ssh-add $key
      else
        die "Err: could not fetch pw"
      fi
      ;;
  esac
else
  for k in  $sshdir/*.pub; do
     bk=$(basename $k)
     bkname="${bk%.pub}"
     echo 'kkk ' . $bkname
  done
fi
