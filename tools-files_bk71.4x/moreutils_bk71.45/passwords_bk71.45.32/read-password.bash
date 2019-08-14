#!/bin/bash

# read a password or try to get it from a `pass` store

copy () {
  read pw

  local os=$(uname)
   case "$os" in
   Darwin)
    printf "$pw" | pbcopy 
      ;;
    Linux)
      printf "$pw" | DISPLAY=:0 xclip 
      ;;

   *)
     echo "Err: todo OS $os"
     exit 1
     ;;
 esac
 }

password=

echo "Enter Password:"
read -s password

  read -s password_manual

if [ -n "$interactive" ] ; then
  echo "$password" | copy
else
  echo "$password"
fi

