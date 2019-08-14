#!/bin/sh

USAGE='<tooldir/profiledir>  <keyuser> [link]'

keydir_path=$1
keyuser=$2
link_yes=$3

cwd=$(pwd)

die () { echo $@; exit 1; }

twikpw () { # cmd used below
  perl $HOME/tools/moreutils-bin/twikpw.pl $@
}

[ -n "$keydir_path" ] || die "usage: $USAGE"
[ -d "$keydir_path" ] || die "Err: invalid dir"

[ -n "$keyuser" ] || die "usage: $USAGE"

here=$(basename $cwd)
herename=${here%_*}
keydomain=
case "$here" in
  ssh-hostkeys_*) keydomain=hostkey;;
  ssh-cloudkeys_*) keydomain=cloudkey;;
  *) die "Err: unknown keydomain $here"
esac

keydir_base=$(basename $keydir_path)

decimal=${keydir_base##*_}

minute_stamp=$(date +"%Y%m%d%H%M")
zettel_stamp="$decimal.$minute_stamp"

keyname= keytarget=
case $keydomain in
  cloudkey)
      keyname=cloudkey_${keyuser}_${zettel_stamp}
      keytarget=cloudkey_${keyuser}
    ;;
  hostkey)
    hname=$(hostname)
      keyname=hostkey_${keyuser}_${hname}_${zettel_stamp}
      keytarget=hostkey_${keyuser}
    ;;
  *) die "Err: invalid directory root '$here'";;
esac

keydir=$(dirname $keydir_path)
keydir_dir_base=$(basename $keydir)

tool=${keydir_dir_base%_*}


keypath=$keydir_path/$keyname
#die keypath $keypath
[ -f "$keypath" ] && die "Err: key '$keypath' already exists"

profile=${keydir_base%_*}
pw_cmd=
case $tool in
  twikpw)
    pw_cmd="twikpw _ssh,$keytarget $profile"
    ;;
  pwdhash)
    # ssh/ , slashes doesnt work on ipads Password
    #pw_cmd="pwdhash ssh/${keytarget}_${profile}"

    pw_cmd="pwdhash _ssh,${keytarget}_${profile}"
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

#ssh-keygen -t rsa -b 4096 -C "in $here: $keydir/$keyname :: ~/.ssh/$keytarget" -f "$keypath" 
ssh-keygen -t rsa -b 4096 -C "$keyname.pub :: ~/.ssh/$keytarget.pub :: $pw_cmd" -f "$keypath" 

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

