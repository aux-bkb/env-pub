#!/bin/sh

read line 

#userid=${USER::2}


testline='xPerl xRegex bk201906afvojg.t'

perl -e '$ARGV[0] =~ /([a-z][a-z]\d\d\d\d\d\d[a-z]*)(\.\S+)?$/ and print $1;' "$line" $userid

