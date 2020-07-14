#!/bin/bash

pop=$1
popnum=$2
outdir="../data/$pop/pheno"
names="${outdir}/indi"
out="${outdir}/$pop"

if [ $popnum -eq 1 ]
then 
	awk '{print $1}' ${out}.fam | sort -R > ${names}-rand.txt
	
	total=$(cat ${names}-rand.txt | wc -l)
	train=$(( total / 100 * 80 ))

	head -n $train ${names}-rand.txt > ${names}-train.txt
	tail -n +$((train + 1)) ${names}-rand.txt > ${names}-val.txt
fi

for h2 in {0..9}
do
	data="../data/${pop}/pheno/${pop}-h2-${h2}-scaled"
	echo "partitioning h2: ${h2}"
	grep -F -wf ${names}-train.txt ${data}.phen > ${data}-train.phen
	grep -F -wf ${names}-val.txt ${data}.phen > ${data}-val.phen
done
