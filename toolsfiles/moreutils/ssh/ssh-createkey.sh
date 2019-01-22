#!/bin/sh

USAGE='<path/to/keydir>  <user> [link]'

keydir=$1
user=$2
link_yes=$3

die () { echo $@; exit 1; }

twikpw () { # cmd used below
  perl $HOME/tools/moreutils/crypto/twikpw.pl $@
}

[ -n "$keydir" ] || die "usage: $USAGE"
[ -d "$keydir" ] || die "Err: invalid dir"

[ -n "$user" ] || die "usage: $USAGE"

stamp=$(date +"%Y%m%d%H%M")

here=$(pwd)
this=$(basename $here)
keydomain=
case "$this" in
  sshkeys-host_*) keydomain=host;;
  sshkeys-clouds_*) keydomain=clouds;;
esac



keyname= keytarget= keystring=
case $keydomain in
  clouds)
      keyname=clouds_${user}_${stamp}
      keystring="clouds_${user}"
      keytarget=clouds_${user}
    ;;
  host)
    hname=$(hostname)
      keyname=host_${user}_${hname}_${stamp}
      keystring="host_${user}"
      keytarget=host_${user}
    ;;
  *) die "Err: invalid directory root '$this'";;
esac


tool=$(dirname $keydir)

profile=$(basename $keydir)

cwd=$(pwd)

keypath=$keydir/$keyname
[ -f "$keypath" ] && die "Err: key '$keypath' already exists"

pw_cmd=
case $tool in
  twikpw)
    pw_cmd="twikpw _ssh,$keystring $profile"
    ;;
  pwdhash)
    # ssh/ , slashes doesnt work on ipads Password
    #pw_cmd="pwdhash ssh/${keytarget}_${profile}"

    pw_cmd="pwdhash _ssh,${keystring}_${profile}"
    ;;
  *)
    die "Err: no tool $tool"
    ;;
esac


echo ${pw_cmd}
${pw_cmd}

if [ "$?" -eq "0" ] ; then 
   echo "Ok: Password successfully stored in clipboard"
 else
   die  "WARN: could not fetch password with cmd '$pw_cmd'"
fi
echo ""

ssh-keygen -t rsa -b 4096 -C "$keydir/$keyname :: ~/.ssh/$keytarget :: $pw_cmd" -f "$keypath" 

echo "OK: key successfully generated" 

[ -n "$link_yes" ] && {
  [ -d "$HOME/.ssh" ] && {
     echo "OK: now linking to ~/.ssh/"
     rm -f $HOME/.ssh/$keytarget
     rm -f $HOME/.ssh/$keytarget.pub

     echo ln -s $cwd/$keypath $HOME/.ssh/$keytarget
     ln -s $cwd/$keypath $HOME/.ssh/$keytarget
     ln -s $cwd/$keypath.pub $HOME/.ssh/$keytarget.pub
  }
}

