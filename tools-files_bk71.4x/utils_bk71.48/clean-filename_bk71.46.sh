


input="$1"

[ -f "$input" ] || { echo "usage: filename" ; exit 1; }

clean=$(perl -e '$ARGV[0] =~ s/ - /_/g;$ARGV[0] =~ s/[^A-Za-z0-9.]+/_/g; print(lc( $ARGV[0]));' "$input")


echo "$clean"

