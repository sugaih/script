#!/bin/sh

if [ $# -ne 3 ]; then
    echo "Usage: `basename $0` infile(qdp) ADC_low ADC_high"
    echo "  ex.: `basename $0` test.qdp 1000 3000 "
    exit
fi


#input file
infile=$1

#region of interest
ADC_low=$2
ADC_high=$3

#delete QDP header
sed -e "1,3d" ${infile} > tmp.dat

#ADC cut & sum
total=`cat tmp.dat | awk '{if($1 > '${ADC_low}' && $1 < '${ADC_high}')print $3}' | awk '{m+=$1} END{print m;}'`
total_err=`echo $total | awk '{print sqrt($1)}'`

#out
echo "Total counts = ${total} +/- ${total_err} in the ${ADC_low} - ${ADC_high} ADC"
