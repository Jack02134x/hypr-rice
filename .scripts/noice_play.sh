noice=$1

ffplay -f lavfi -i anoisesrc=c=$1 -loop 0

