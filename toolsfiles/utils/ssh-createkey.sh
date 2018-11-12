#!/bin/sh

USAGE='<path/to/keydir> <keydomain: "clouds"/hostname>  <user> [link]'

keydir=$1
keydomain=$2
user=$3
link_yes=$4

die () { echo $@; exit 1; }

[ -n "$keydir" ] || die "usage: $USAGE"
[ -d "$keydir" ] || die "Err: invalid dir"

[ -n "$keydomain" ] || die "usage: $USAGE"
[ -n "$user" ] || die "usage: $USAGE"

stamp=$(date +"%Y%m%d%H%M")

keyname= keytarget=
case $keydomain in
  clouds)
      keyname=clouds_${user}_${stamp}
      keystring="clouds;${user}"
      keytarget=clouds_${user}
    ;;
  *)
      keyname=host_${user}_${keydomain}_${stamp}
      keystring="host;${user}"
      keytarget=host_${user}
    ;;
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

${pw_cmd}

if [ "$?" -eq "0" ] ; then 
   echo "Ok: Password successfully stored in clipboard"
 else
   echo  "WARN: could not fetch password with cmd '$pw_cmd'"
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

