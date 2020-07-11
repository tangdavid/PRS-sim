#!/bin/bash

if [ $# -eq 0 ]
then
	echo "Usage: ./batch.sh [population]"
	exit 1
fi

mkdir ../data/${1}
mkdir ../data/${1}/pheno
mkdir ../data/${1}/grm
mkdir ../data/${1}/blup
mkdir ../data/${1}/prs

if [ $1 != "sim" ]
then
	echo $1
#	qsub ./filter.sh $1
fi 

# phenotype simulations
qsub -hold_jid job-filter ./pheno-sim.sh $1
# grm
qsub -hold_jid job-pheno-sim ./grm.sh $1
# blup
qsub -hold_jid job-grm ./blup.sh $1
# prs using gcta
qsub -hold_jid job-blup ./gcta-prs.sh $1
# calculate the correlations
qsub -hold_jid job-gcta-prs ./corr.sh $1