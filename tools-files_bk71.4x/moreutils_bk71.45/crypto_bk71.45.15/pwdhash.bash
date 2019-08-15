#!/usr/bin/env bash

USAGE='<Input> <Masterpass>'

Input="$1"
Masterpass_arg="$2"

here=$(dirname $0)

passwordstore="$HOME/.password-store"

OS=$(uname)
die () { echo $@; exit 1; }

[ -n "$Input" ] || die "usage: $USAGE"


py=$(which python)
pwdhash_py=$HOME/tools/sw/pwdhash.py
[ -f "$pwdhash_py" ] || die "Err: no pwdhash.py in $pwdhash_py"


clipcopy (){
  case "$OS" in
    Darwin) printf $@ | pbcopy ;;
    *) die "TODO(clipcopy): for $OS" ;;
   esac
}

get_masterpass_version () {
  #token: 
  # from pwdhash 'apple,#kbd_u3a0-bkb'      
  # -> login_apple_kbd

  token=$(echo "$Input" | perl -pe 's/(\w+)_(u\d\w\d-\w+)/$1/g' | perl -pe 's/[^a-z0-9_\-\n]+/_/g')

  # version: jsdfjdfjfd_3u0a-bkb , or keepass,u3a0-bkb (legacy: keepass:3u0a-bkb)
  version=$(echo "$Input" | perl -pe 's/.+[_,:].*(u\d\w\d+\-\w+)+$/$1/g')

  [ -n "$version" ] || {
     echo "Err: could not extract version from token"
     exit 1
  }

  [ "$version" = "$Input" ] && die "Err: no valid version"

  pwdhash_version="pwdhash/$version"

  if [ -e "$passwordstore" ] ; then 
   # wrong mkdir -p "$passwordstore/$pwdhash_version"
    mkdir -p "$passwordstore/"
    echo $pwdhash_version
  else
   echo "Warn: no 'pwdhash' director in ~/.password-store"
 fi

}

Masterpass=
if [ -n "$Masterpass_arg" ] ; then
  Masterpass=$Masterpass_arg
else
  [ -n "$Masterpass" ] || {
    masterpass_version=$(get_masterpass_version)
    Masterpass=$(pass show "$masterpass_version")
    [ "$?" = 0 ] || Masterpass='' 
  }
fi


[ -n "$Masterpass" ] || {
    echo "Sorry: Please write Masterpass manually"
    read -s Masterpass
}


echo ${py} "$pwdhash_py" "$Input" "Masterpass"

pwhash=$(${py} "$pwdhash_py" "$Input" "$Masterpass")
[ -n "$pwhash" ] || die "Err: could not fetch hash from pwdhash"

length=$(perl -e 'print(scalar( (split "", $ARGV[0])))' "$Masterpass")

pwhash_cut=$(echo "$pwhash" | cut -c -$length)

#echo ppp $pwhash

if [ -n "$Masterpass_arg" ] ; then
   echo "$pwhash_cut"
 else
   clipcopy "$pwhash_cut"
 fi
