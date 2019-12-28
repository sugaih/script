#!/bin/bash

######################################
#
#Bkgregのcount、標準偏差をtxtfileに保存する
#
#######################################

awk '{print $2}' count.txt | sed 1d > bkgcount.txt
echo "back grount counts"
cat bkgcount.txt
rm bkgcount.txt
awk '{print $2}' count.txt | sed 1d >> ../bkgcount.txt

awk '{print $3}' yuido.txt | awk 'NR==3' > bkgsigma.txt
echo "back ground sigma"
cat bkgsigma.txt
rm bkgsigma.txt
awk '{print $3}' yuido.txt | awk 'NR==3' >> ../bkgsigma.txt
