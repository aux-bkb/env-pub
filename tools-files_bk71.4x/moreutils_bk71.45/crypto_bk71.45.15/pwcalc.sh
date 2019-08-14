#!/bin/sh

# Calculates a simple hash

USAGE='<input>'

input=$1

die () { echo $@; exit 1; }

# length
# printf "${Password}${String}" | shasum | xxd -r -p | base64 | cut -c1-${Length}

printf "${input}" | shasum | xxd -r -p | base64 
