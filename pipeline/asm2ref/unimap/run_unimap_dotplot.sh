if [[ $# != 3 ]] ; then
	echo "Usage : $0 ref.fasta query.fasta outprex"
	exit 1
fi

ref=$1
qry=$2
outpre=$3
src=$(cd $(dirname $0);pwd)

# unimap
$src/unimap -cxasm5 --cs -t8 $ref $qry > $outpre.unimap.paf
# convert paf format to mashmap format (fake mashmap)
awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10/$11}' $outpre.unimap.paf > $outpre.unimap.fmash

if [ -e 'out.png' ]; then

	read -r -p "out.png esists, Are You Sure to overwrite it? [Y/n] " input

	case $input in
	    [yY][eE][sS]|[yY])
			echo "Yes"
			# plot
			perl $src/generateDotPlot png large $outpre.unimap.fmash 
			mv out.png $outpre.png
			;;

		[nN][oO]|[nN])
			echo "No"
			;;

		*)
			echo "Invalid input..."
			exit 1
			;;
	esac
else
	# plot
	perl $src/generateDotPlot png large $outpre.unimap.fmash 
	mv out.png $outpre.png
fi
