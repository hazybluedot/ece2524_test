objects="accumulator.o main.o"
binname="acctest"

comp=0
for object in $objects; do
    src=$(echo $object | sed -r 's/\.o$/\.cc/')
    if [ ! -e $object -o $src -nt $object ]; then
	recipe="g++ -c $src"
	echo $recipe
	$recipe
    fi
done

for object in $objects; do
    [ $object -nt $binname ] && comp=1
done

(( $comp )) && ( recipe="g++ -o $binname $objects"; echo $recipe; $recipe )

