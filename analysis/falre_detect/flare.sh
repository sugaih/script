#okamoto
#2019/12/2
#flare.sh
#lowdataから移動平均をとる
#./flare.sh の後に移動平均を取りたいbin数とループ回数を入れる
#lowdata と移動平均を比較するqdpファイルを作る
#期待値と標準偏差を求める
#シグマクリッピングしたqdpファイルを作る  -①
#大きいフレアを取り除いて(3σ以上)再び期待値と標準偏差を求める
#①にシグマ線を入れたqdpファイルを作る


i=1
j=0
n=`expr $2 + 1`
m=$2

echo "read serror 1 2" > lc.qdp
echo "@lc.pco" >> lc.qdp
echo "!" >> lc.qdp


echo "skip single" > lc.pco
echo "time off" >> lc.pco


echo "read serror 1 2" > lc0.qdp
echo "@lc0.pco" >> lc0.qdp
echo "!" >> lc0.qdp
cat lc0.txt >> lc0.qdp


echo "read serror 1 2" > sigma.qdp
echo "@sigma.pco" >> sigma.qdp
echo "!" >> sigma.qdp


head -50 lc0.txt | awk '{print $3,$4}' > f.txt
tail -50 lc0.txt | awk '{print $3,$4}' > g.txt


while [ $i -lt $n ]
do

	tail -n +4 lc$j.qdp | awk '{print $0}' > lc$j.txt

	echo "$i-1"
	awk '{print $3}' lc$j.txt > flux.txt
	awk '{print $4}' lc$j.txt > error.txt

	echo "$i-2"
	python ave$1_flux.py ave_flux$i.txt $i
	python ave$1_error.py ave_error$i.txt $i

	echo "$i-3"
	paste lc$j.txt ave_flux$i.txt ave_error$i.txt | awk '{print $0}' > lc_ave$i.txt

	echo "$i-4"
	awk '{print $1,$2,$3-$5,$4-$6}' lc_ave$i.txt > a.txt

	echo "$i-5"
	ave=`awk '{if($3 ~ /\./) print $3}' a.txt | awk '{sum+=$1} END{print sum/NR}'`
	sig=`awk '{if($3 ~ /\./) print $3}' a.txt | awk '{sum+=($1-'${ave}')**2} END{print (sum/NR)**0.5}'`
	sig1=`echo "$ave $sig" | awk '{print $1+$2}'`
	sig2=`echo "$ave $sig" | awk '{print $1+$2*2}'`
	sig3=`echo "$ave $sig" | awk '{print $1+$2*3}'`
	sig4=`echo "$ave $sig" | awk '{print $1+$2*4}'`
	sig5=`echo "$ave $sig" | awk '{print $1+$2*5}'`

	echo "[${i}回目]"  >> memo.txt
	echo "平均値"=$ave, "標準偏差"=$sig >> memo.txt
	echo "1σ"=$sig1, "2σ"=$sig2, "3σ"=$sig3, "4σ"=$sig4, "5σ"=$sig5 >> memo.txt
	echo "$i 0 $sig 0" >> sigma.qdp

	echo "$i-6"
	awk '{if($3 ~ /\./) print $0}' a.txt | awk '{print $0,'${sig1}','${sig2}','${sig3}','${sig4}','${sig5}'}' > lc_sig$i.txt

	awk '{if($3-$5>'${sig3}') print $1,$2,$3,$4}' lc_ave$i.txt > flare$i.txt 

	echo "$i-7"
	tail -n +51 lc_ave$i.txt  > b.txt
	len=`wc b.txt | awk '{print $1}'`
	end=`expr $len - 50`
	head -$end b.txt > c.txt

	python sig.py $sig3 c.txt

	cat f.txt > h.txt
	paste d.txt e.txt >> h.txt
	cat g.txt >> h.txt
	paste lc$j.txt h.txt | awk '{print $1,$2,$5,$4}' > lc$i.txt


	echo "read serror 1 2 3" > lc_ave$i.qdp
	echo "@lc_ave$i.pco" >> lc_ave$i.qdp
	echo "!" >> lc_ave$i.qdp
	cat lc_ave$i.txt >> lc_ave$i.qdp

	echo "read serror 1 2" > lc_sig$i.qdp
	echo "@lc_sig$i.pco" >> lc_sig$i.qdp
	echo "!" >> lc_sig$i.qdp
	cat lc_sig$i.txt >>lc_sig$i.qdp

	echo "read serror 1 2" > lc$i.qdp
	echo "@lc$i.pco" >> lc$i.qdp
	echo "!" >> lc$i.qdp
	cat lc$i.txt >> lc$i.qdp

	cat flare$i.txt >> flare_1.txt

	echo "read serror 1 2" > lc_flare$i.qdp
	echo "@lc_flare$i.pco" >> lc_flare$i.qdp
	echo "!" >> lc_flare$i.qdp
	cat flare_1.txt >> lc_flare$i.qdp
	echo "no no no no" >> lc_flare$i.qdp
	cat flare$i.txt >> lc_flare$i.qdp
	echo "no no no no" >> lc_flare$i.qdp
	cat lc$i.txt >> lc_flare$i.qdp

	cat flare$i.txt >> lc.qdp
	echo "no no no no" >> lc.qdp

	cat <<EOF> lc_ave$i.pco
	r y 1.4e5 1.8e5
	time off
	lab f
	lab x Time(from 2018-07-25) [day]
	lab y Flux [counts s\u-1\d]
EOF

	cat <<EOF> lc_sig$i.pco
	time off
	lab f
	lab x Time(from 2018-07-25) [day]
	lab y Flux [counts s\u-1\d]
EOF

	cat <<EOF> lc$i.pco
	r y 1.4e5 1.8e5
	time off
	lab f
	lab x Time(from 2018-07-25) [day]
	lab y Flux [counts s\u-1\d]
EOF

	cat <<EOF> lc_flare$i.pco
	col 2 on 1
	col 4 on 2
	col 1 on 3
	r y 1.4e5 1.8e5
	time off
	lab f
	lab x Time(from 2018-07-25) [day]
	lab y Flux [counts s\u-1\d]
EOF


	s=$(( $j % 3 ))
	s=`expr $s + 2`

	echo "col $s on $i" >> lc.pco


	rm -f a.txt d.txt e.txt flux.txt error.txt

	i=`expr $i + 1`
	j=`expr $j + 1`

done


cat <<EOF> sigma.pco
lab f
time off
ma 17 on
lab x loopnum
lab y sigma
EOF


echo "col 1 on $i" >> lc.pco
echo "r y 1.4e5 1.7e5" >> lc.pco
echo "lab f" >> lc.pco
echo "lab x Time(from 2018-07-25) [day]" >> lc.pco
echo "lab y Flux [counts s\u-1\d]" >> lc.pco


cat lc$j.txt >> lc.qdp




tail -n +4 lc$j.qdp | awk '{print $0}' > lc$j.txt
awk '{print $3}' lc$j.txt > flux.txt
awk '{print $4}' lc$j.txt > error.txt
python ave$1_flux.py ave_flux$i.txt $i
python ave$1_error.py ave_error$i.txt $i
paste lc$j.txt ave_flux$i.txt ave_error$i.txt | awk '{print $0}' > lc_ave$i.txt
awk '{print $1,$2,$5,$6}' lc_ave$i.txt > a.txt


head -50 lc0.txt > lc$i.txt
tail -n +51 a.txt  > e.txt
len=`wc e.txt | awk '{print $1}'`
end=`expr $len - 50`
head -$end e.txt > f.txt
cat f.txt >> lc$i.txt
tail -50 lc0.txt >> lc$i.txt
awk '{if($3 ~ /\./) print $0}' lc$i.txt > a.txt

m=`wc lc$i.txt | awk '{print $1}'`
python spline.py a.txt $m day_sp.txt flux_sp.txt


paste day_sp.txt flux_sp.txt | awk '{print $1,0,$2,0}' > lc_sp.txt


echo "read serror 1 2 3" > lc_flare_sp.qdp
paste lc0.txt lc_sp.txt | awk '{print $1,$2,$3,$4,$7,$8}' >> lc_flare_sp.qdp


ave=`awk '{if($3 ~ /\./) print $3}' lc_sp.txt | awk '{sum+=$1} END{print sum/NR}'`
sig=`awk '{if($3 ~ /\./) print $3}' lc_sp.txt | awk '{sum+=($1-'${ave}')**2} END{print (sum/NR)**0.5}'`
sig1=`echo "$ave $sig" | awk '{print $1+$2}'`
sig2=`echo "$ave $sig" | awk '{print $1+$2*2}'`
sig3=`echo "$ave $sig" | awk '{print $1+$2*3}'`
sig4=`echo "$ave $sig" | awk '{print $1+$2*4}'`
sig5=`echo "$ave $sig" | awk '{print $1+$2*5}'`


echo "[定常光]"  >> memo.txt
echo "平均値"=$ave, "標準偏差"=$sig >> memo.txt
echo "1σ"=$sig1, "2σ"=$sig2, "3σ"=$sig3, "4σ"=$sig4, "5σ"=$sig5 >> memo.txt


awk '{if($3 ~ /\./) print $0}' lc_sp.txt | awk '{print $0,'${sig1}','${sig2}','${sig3}','${sig4}','${sig5}'}' > lc_sig$i.txt


awk '{if($3>'${sig3}') print $1,$2,$3,$4}' lc0.txt > flare.txt
awk '{if($3<'${sig3}') print $1,$2,$3,$4}' lc0.txt > seq.txt


echo "read serror 1 2 3" > lc_ave$i.qdp
echo "@lc_ave$i.pco" >> lc_ave$i.qdp
echo "!" >> lc_ave$i.qdp
cat lc_ave$i.txt >> lc_ave$i.qdp

cat <<EOF> lc_ave$i.pco
r y 1.4e5 1.7e5
time off
lab f
lab x Time(from 2018-07-25) [day]
lab y Flux [counts s\u-1\d]
EOF


echo "read serror 1 2" > lc_sp.qdp
echo "@lc_sp.pco" >> lc_sp.qdp
echo "!" >> lc_sp.qdp
cat lc_sp.txt >> lc_sp.qdp

cat <<EOF> lc_sp.pco
r y 1.4e5 1.45e5
time off
lab f
lab x Time(from 2018-07-25) [day]
lab y Flux [counts s\u-1\d]
EOF


echo "read serror 1 2" > lc_sig$i.qdp
echo "@lc_sp.pco" >> lc_sig$i.qdp
echo "!" >> lc_sig$i.qdp
cat lc_sig$i.txt >> lc_sig$i.qdp

cat <<EOF> lc_sig$i.pco
time off
lab f
lab x Time(from 2018-07-25) [day]
lab y Flux [counts s\u-1\d]
EOF


echo "read serror 1 2" > lc_flare.qdp
echo "@lc_flare.pco" >> lc_flare.qdp
echo "!" >> lc_flare.qdp
cat flare.txt >> lc_flare.qdp
echo "no no no no" >> lc_flare.qdp
cat seq.txt >> lc_flare.qdp

cat <<EOF> lc_flare.pco
skip single
time off
lab f
lab x Time(from 2018-07-25) [day]
lab y Flux [counts s\u-1\d]
EOF

rm error.txt flux.txt a.txt e.txt f.txt

qdp lc_flare.qdp
