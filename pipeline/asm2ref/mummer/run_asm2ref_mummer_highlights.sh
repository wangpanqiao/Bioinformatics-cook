# find NGS scaffolds which have SNP markers
if [[ $# != 3  ]] ; then
	echo "Usage : $0 ref.fasta query.fasta prefix"
	exit 1
fi
ref=$1
que=$2
pre=$3
src=$(cd $(dirname $0);pwd)
$src/mummer4/bin/nucmer --maxmatch -t 10 -l 100 -c 500 -p $pre $ref $que
$src/mummer4/bin/dnadiff -d $pre.delta -p $pre.diff

# circos
python3 $src/preCircosHighlight.sort.py -1c  $pre.diff.1coords -mc  $pre.diff.mcoords
[ -e circos.conf ] || ln -s $src/confs/run_asm2ref_mummer_highlights.conf ./circos.conf
circos -conf circos.conf
