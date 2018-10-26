#!/bin/sh

USAGE='<path/to/keydir> <keydomain: "clouds"/hostname>  <user> [date id]'

keydir=$1
keydomain=$2
user=$3
date=$4

die () { echo $@; exit 1; }

[ -n "$keydir" ] || die "usage: $USAGE"
[ -d "$keydir" ] || die "Err: invalid dir"

[ -n "$keydomain" ] || die "usage: $USAGE"
[ -n "$user" ] || die "usage: $USAGE"

[ -n "$date" ] || date=$(date +"%y%m%d")
[ -n "$date" ] || die "Err: invalid dir"

keyname= keytarget=
case $keydomain in
  clouds)
      keyname=clouds_${user}_${date}
      keytarget=clouds_${user}
    ;;
  *)
      keyname=host_${user}_${keydomain}_${date}
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
    pw_cmd="twikpw ssh/$keytarget $profile"
    ;;
  pwdhash)
    # ssh/ , slashes doesnt work on ipads Password
    #pw_cmd="pwdhash ssh/${keytarget}_${profile}"

    pw_cmd="pwdhash ssh,${keytarget}_${profile}"
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

[ -d "$HOME/.ssh" ] && {
   echo "OK: now linking to ~/.ssh/"
   rm -f $HOME/.ssh/$keytarget
   rm -f $HOME/.ssh/$keytarget.pub

   echo ln -s $cwd/$keypath $HOME/.ssh/$keytarget
   ln -s $cwd/$keypath $HOME/.ssh/$keytarget
   ln -s $cwd/$keypath.pub $HOME/.ssh/$keytarget.pub
}

