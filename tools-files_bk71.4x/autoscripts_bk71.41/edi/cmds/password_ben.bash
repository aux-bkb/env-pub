#!/bin/bash



token=$1

printpw=$2

dev=$HOME/dev

err () {
    echo "Err: $1"

    echo "Press key to continue ..."
    read -n 1 inp
    exit 1
}

script="$dev/secutils/passwords_bkbv151001.1.pl"

[ -f $script ] || err "password script $script not accessible"



echo "Twik Master please"
read  -s master
echo thanks

if [ -n "$token" ]; then 
    echo "Password for $token"
else
    echo "Token please"
    read token
fi

if [ -n "$printpw" ] ; then
    echo 'token ' . $token
    shift
    shift
    perl $script "$token" 'bkb.A_special25v151001.1' "$master" 
    echo "Press key to continue ..."
    read -n 1 inp
else
    perl $script "$token" 'bkb.A_special25v151001.1' "$master" | xsel -b 

    echo "Press key to continue ..."
    read -n 1 inp
fi


