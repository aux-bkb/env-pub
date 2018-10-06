

case a1 in
  [a-z])
    echo fffff
    ;;
  *)
    echo ssss
    ;;
esac

v='_199.33a'

if echo $v | egrep -q '_\d+\.\d+$' ; then
  echo mmmmmmm
else
  echo nnnn
fi

loop () {
  echo $1
  for d in $1/* ; do
    [ -d $d ] || continue
    cd $d 
    loop $d
  done
}

echo nnnowww
loop $(pwd)
   

