#########################################################################
# 軌道位相確認スクリプト
#                                   2012/09/11 M.Nakajima
#									2018/07/04 W.IWakiri
#########################################################################
#! /bin/bash 

# 軌道パラメータ(主極小、軌道周期)

export T_ZERO=52499.71 # MJD
export P_ORBIT=2.867315 # day

#export YY=` date -u "+%Y" `
#export MM=` date -u "+%m" `
#export DD=` date -u "+%d" `

MJD=$1
#YY=$1
#MM=$2
#DD=$3

#export MJD=` echo $YY $MM $DD | awk '{printf("%lf\n", int(365.25*$1) + int($1/400) - int($1/100) + int(30.59*($2-2)) + $3 - 678912 )}' `

echo $MJD $T_ZERO $P_ORBIT | \
awk '{printf("%lf\n", ($1-$2)/$3 - int(($1-$2)/$3) )}'
#awk '{printf("%lf\n", ($2-$1)/$3 - int(($2-$1)/$3) )}'
