#flare.sh
#okamoto
#lc0.txt (flare_detectしたいLCのtext(time,time_error,flux,flux_error))





#dummydata作成

i=1
j=0
n=`expr $2 + 1`
m=$2

echo "read serror 1 2" > loop1.qdp
echo "@loop1.pco" >> loop1.qdp
echo "!" >> loop1.qdp

echo "skip single" > loop1.pco
echo "time off" >> loop1.pco

echo "read serror 1 2" > lc0.qdp
echo "@lc0.pco" >> lc0.qdp
echo "!" >> lc0.qdp
cat lc0.txt >> lc0.qdp

echo "read serror 1 2" > sigma1.qdp
echo "@sigma1.pco" >> sigma1.qdp
echo "!" >> sigma1.qdp

head -50 lc0.txt | awk '{print $3,$4}' > a.txt
tail -50 lc0.txt | awk '{print $3,$4}' > b.txt

while [ $i -lt $n ]
do
	echo "loop$i"
	awk '{print $3}' lc$j.txt > flux.txt
	awk '{print $4}' lc$j.txt > error.txt

	python boxcar.py 100 flux.txt ave_flux$i.txt $i	
	python boxcar.py 100 error.txt ave_error$i.txt $i

	paste lc$j.txt ave_flux$i.txt ave_error$i.txt > lc_ave$i.txt

	awk '{print $1,$2,$3-$5,$4-$6}' lc_ave$i.txt > lc_sig$i.txt
	awk '{if($3 ~ /\./ || $5 ~ /\./) print $1,$2,$3-$5,$4-$6}' lc_ave$i.txt > c.txt
	ave=`awk '{if($3 ~ /\./) print $3}' c.txt | awk '{sum+=$1} END{print sum/NR}'`
	sig=`awk '{if($3 ~ /\./) print $3}' c.txt | awk '{sum+=($1-'${ave}')**2} END{print (sum/NR)**0.5}'`
	sig1=`echo "$ave $sig" | awk '{print $1+$2}'`
	sig2=`echo "$ave $sig" | awk '{print $1+$2*2}'`
	sig3=`echo "$ave $sig" | awk '{print $1+$2*3}'`
	sig4=`echo "$ave $sig" | awk '{print $1+$2*4}'`
	sig5=`echo "$ave $sig" | awk '{print $1+$2*5}'`

	echo "[1-${i}回目]"  >> memo.txt
	echo "平均値"=$ave, "標準偏差"=$sig >> memo.txt
	echo "1σ"=$sig1, "2σ"=$sig2, "3σ"=$sig3, "4σ"=$sig4, "5σ"=$sig5 >> memo.txt
	echo "$i 0 $sig 0" >> sigma1.qdp

	echo "no no no no" >> lc_sig$i.txt 
	awk '{print $1,$2,'${sig1}',0}' lc_ave$i.txt >> lc_sig$i.txt
	echo "no no no no" >> lc_sig$i.txt 
	awk '{print $1,$2,'${sig2}',0}' lc_ave$i.txt >> lc_sig$i.txt
	echo "no no no no" >> lc_sig$i.txt 
	awk '{print $1,$2,'${sig3}',0}' lc_ave$i.txt >> lc_sig$i.txt
	echo "no no no no" >> lcsig$i.txt 
	awk '{print $1,$2,'${sig4}',0}' lc_ave$i.txt >> lc_sig$i.txt
	echo "no no no no" >> lc_sig$i.txt 
	awk '{print $1,$2,'${sig5}',0}' lc_ave$i.txt >> lc_sig$i.txt

	awk '{if($3-$5>'${sig3}') print $1,$2,$3,$4}' lc_ave$i.txt > flare$i.txt

	python sig.py $sig3 lc_ave$i.txt #flareと判定されたビンのfluxをNULLに

	paste flux_sig.txt error_sig.txt | tail -n +51 > e.txt
	len=`wc e.txt | awk '{print $1}'`
	end=`expr $len - 50`

	cat a.txt > d.txt
	head -$end e.txt >> d.txt
	cat b.txt >> d.txt
	paste lc$j.txt d.txt | awk '{print $1,$2,$5,$6}' > lc$i.txt

	echo "read serror 1 2 3" > lc_ave$i.qdp
	echo "@lc_ave.pco" >> lc_ave$i.qdp
	echo "!" >> lc_ave$i.qdp
	cat lc_ave$i.txt >> lc_ave$i.qdp

	echo "read serror 1 2" > lc_sig$i.qdp
	echo "@lc_sig.pco" >> lc_sig$i.qdp
	echo "!" >> lc_sig$i.qdp
	cat lc_sig$i.txt >>lc_sig$i.qdp

	echo "read serror 1 2" > lc$i.qdp
	echo "@lc0.pco" >> lc$i.qdp
	echo "!" >> lc$i.qdp
	cat lc$i.txt >> lc$i.qdp

	echo "read serror 1 2" > lc_flare$i.qdp
	echo "@lc_flare.pco" >> lc_flare$i.qdp
	echo "!" >> lc_flare$i.qdp
	cat lc$i.txt >> lc_flare$i.qdp
	echo "no no no no" >> lc_flare$i.qdp
	cat flare$i.txt >> lc_flare$i.qdp

	cat flare$i.txt >> loop1.qdp
	echo "no no no no" >> loop1.qdp

	s=$(( $j % 3 ))
	s=`expr $s + 2`

	echo "col $s on $i" >> loop1.pco

	i=`expr $i + 1`
	j=`expr $j + 1`

	rm -r flux_sig.txt error_sig.txt c.txt  d.txt e.txt

done

cat <<EOF> lc_ave.pco
r y 1.4e5 1.8e5
time off
lab f
lab x Time(from 2018-07-25) [day]
lab y Flux [counts s\u-1\d]
EOF

cat <<EOF> lc_sig.pco
skip single
time off
lab f
lab x Time(from 2018-07-25) [day]
lab y Flux [counts s\u-1\d]
EOF

cat <<EOF> lc0.pco
r y 1.4e5 1.8e5
time off
lab f
lab x Time(from 2018-07-25) [day]
lab y Flux [counts s\u-1\d]
EOF

cat <<EOF> lc_flare.pco
skip single
col 2 on 1
col 4 on 2
col 1 on 3
r y 1.4e5 1.8e5
time off
lab f
lab x Time(from 2018-07-25) [day]
lab y Flux [counts s\u-1\d]
EOF

cat <<EOF> sigma1.pco
lab f
time off
ma 17 on
lab x loopnum
lab y Flux(1σ) [coubts s\u-1\d]
EOF

echo "col 1 on $i" >> loop1.pco
echo "r y 1.4e5 1.7e5" >> loop1.pco
echo "lab f" >> loop1.pco
echo "lab x Time(from 2018-07-25) [day]" >> loop1.pco
echo "lab y Flux [counts s\u-1\d]" >> loop1.pco

cat lc$j.txt >> loop1.qdp



#定常光作成

l=0
i=1
j=0

starttime1=`head -1 lc0.txt | awk '{print $1}'`
starttime2=`tail -n +2 lc0.txt | head -1 | awk '{print $1}'`
endtime=`tail -2 lc0.txt | head -1 | awk '{print $1}'`
brank=`echo "scale=5; $starttime2 - $starttime1" | bc`
starttime=`echo "scale=5; $starttime1 - $brank * 51" | bc`

flux=`awk '{if($3 ~ /\./) print $3}' lc20.txt | awk '{sum+=$1} END{print sum/NR}'`
flux_e=`awk '{if($3 ~ /\./) print $4}' lc20.txt | awk '{sum+=$1} END{print sum/NR}'`

while [ $l -lt 50 ]
do

	starttime=`echo "scale=5; $starttime + $brank" | bc`
	endtime=`echo "scale=5; $endtime + $brank" | bc`

	echo $starttime 0 $flux $flux_e >> first.txt
	echo $endtime 0 $flux $flux_e >> last.txt

	l=`expr $l + 1`

done


cat first.txt > lc_0.txt
cat lc0.txt >> lc_0.txt
cat last.txt >> lc_0.txt

echo "skip single" > loop2.pco
echo "time off" >> loop2.pco

echo "read serror 1 2" > lc_0.qdp
echo "@lc_0.pco" >> lc_0.qdp
echo "!" >> lc_0.qdp
cat lc_0.txt >> lc_0.qdp

echo "read serror 1 2" > sigma2.qdp
echo "@sigma2.pco" >> sigma2.qdp
echo "!" >> sigma2.qdp

awk '{print $3,$4}' first.txt > a.txt
awk '{print $3,$4}' last.txt > b.txt

while [ $i -lt $n ]
do
	echo "loop_$i"
	awk '{print $3}' lc_$j.txt > flux.txt
	awk '{print $4}' lc_$j.txt > error.txt

	python boxcar.py 100 flux.txt ave_flux_$i.txt $i	
	python boxcar.py 100 error.txt ave_error_$i.txt $i

	paste lc$j.txt ave_flux$i.txt ave_error$i.txt > lc_ave$i.txt

	awk '{print $1,$2,$3-$5,$4-$6}' lc_ave_$i.txt > lc_sig_$i.txt
	awk '{if($3 ~ /\./ || $5 ~ /\./) print $1,$2,$3-$5,$4-$6}' lc_ave_$i.txt > c.txt
	ave=`awk '{if($3 ~ /\./) print $3}' c.txt | awk '{sum+=$1} END{print sum/NR}'`
	sig=`awk '{if($3 ~ /\./) print $3}' c.txt | awk '{sum+=($1-'${ave}')**2} END{print (sum/NR)**0.5}'`
	sig1=`echo "$ave $sig" | awk '{print $1+$2}'`
	sig2=`echo "$ave $sig" | awk '{print $1+$2*2}'`
	sig3=`echo "$ave $sig" | awk '{print $1+$2*3}'`
	sig4=`echo "$ave $sig" | awk '{print $1+$2*4}'`
	sig5=`echo "$ave $sig" | awk '{print $1+$2*5}'`

	echo "[2-${i}回目]"  >> memo.txt
	echo "平均値"=$ave, "標準偏差"=$sig >> memo.txt
	echo "1σ"=$sig1, "2σ"=$sig2, "3σ"=$sig3, "4σ"=$sig4, "5σ"=$sig5 >> memo.txt
	echo "$i 0 $sig 0" >> sigma2.qdp

	echo "no no no no" >> lc_sig_$i.txt 
	awk '{print $1,$2,'${sig1}',0}' lc_ave_$i.txt >> lc_sig_$i.txt
	echo "no no no no" >> lc_sig_$i.txt 
	awk '{print $1,$2,'${sig2}',0}' lc_ave_$i.txt >> lc_sig_$i.txt
	echo "no no no no" >> lc_sig_$i.txt 
	awk '{print $1,$2,'${sig3}',0}' lc_ave_$i.txt >> lc_sig_$i.txt
	echo "no no no no" >> lc_sig_$i.txt 
	awk '{print $1,$2,'${sig4}',0}' lc_ave_$i.txt >> lc_sig_$i.txt
	echo "no no no no" >> lc_sig_$i.txt 
	awk '{print $1,$2,'${sig5}',0}' lc_ave_$i.txt >> lc_sig_$i.txt

    awk '{if($3-$5>'${sig3}') print $1,$2,$3,$4}' lc_ave_$i.txt > flare_$i.txt

    python sig.py $sig3 lc_ave_$i.txt #flareと判定されたビンのfluxをNULLに

    paste flux_sig.txt error_sig.txt | tail -n +51 > e.txt
	len=`wc e.txt | awk '{print $1}'`
	end=`expr $len - 50`

	cat a.txt > d.txt
	head -$end e.txt >> d.txt
	cat b.txt >> d.txt
	paste lc$j.txt d.txt | awk '{print $1,$2,$5,$6}' > lc_$i.txt

	echo "read serror 1 2 3" > lc_ave_$i.qdp
	echo "@lc_ave.pco" >> lc_ave_$i.qdp
	echo "!" >> lc_ave_$i.qdp
	cat lc_ave_$i.txt >> lc_ave_$i.qdp

	echo "read serror 1 2" > lc_sig_$i.qdp
	echo "@lc_sig.pco" >> lc_sig_$i.qdp
	echo "!" >> lc_sig_$i.qdp
	cat lc_sig_$i.txt >>lc_sig_$i.qdp

	echo "read serror 1 2" > lc_$i.qdp
	echo "@lc_0.pco" >> lc_$i.qdp
	echo "!" >> lc_$i.qdp
	cat lc_$i.txt >> lc_$i.qdp

	echo "read serror 1 2" > lc_flare_$i.qdp
	echo "@lc_flare.pco" >> lc_flare_$i.qdp
	echo "!" >> lc_flare_$i.qdp
	cat lc_$i.txt >> lc_flare_$i.qdp
	echo "no no no no" >> lc_flare_$i.qdp
	cat flare_$i.txt >> lc_flare_$i.qdp

	cat flare_$i.txt >> loop2.qdp
	echo "no no no no" >> loop2.qdp

	s=$(( _$j % 3 ))
	s=`expr $s + 2`

	echo "col $s on _$i" >> lc_.pco

	i=`expr $i + 1`
	j=`expr $j + 1`

	rm -r flux_sig.txt error_sig.txt c.txt d.txt e.txt 

done

cat <<EOF> lc_0.pco
r y 1.4e5 1.8e5
time off
lab f
lab x Time(from 2018-07-25) [day]
lab y Flux [counts s\u-1\d]
EOF

cat <<EOF> sigma2.pco
lab f
time off
ma 17 on
lab x loopnum
lab y Flux(1σ) [coubts s\u-1\d]
EOF

echo "col 1 on _$i" >> loop2.pco
echo "r y 1.4e5 1.7e5" >> loop2.pco
echo "lab f" >> lopp2.pco
echo "lab x Time(from 2018-07-25) [day]" >> loop2.pco
echo "lab y Flux [counts s\u-1\d]" >> loop2.pco

cat lc_$j.txt >> loop2.qdp

rm -r first.txt last.txt a.txt b.txt




#spline近似
m=`wc lc_0.txt | awk '{print $1}'`
python spline.py lc_50.txt $m day_sp.txt flux_sp.txt

paste day_sp.txt flux_sp.txt | awk '{print $1,0,$2,0}' > spline.txt


#flare_detection
echo "read serror 1 2 3" > lc0_sp.qdp
paste lc_0.txt spline.txt | awk '{print $1,$2,$3,$4,$7,$8}' >> lc0_sp.qdp
paste lc_0.txt spline.txt | awk '{print $1,$2,$3,$4,$7,$8}' > lc0_sp.txt

awk '{print $1,$2,$3-$5,$4-$6}' lc0_sp.txt > lc_sig_sp.txt
echo "no no no no" >> lc_sig_sp.txt 
awk '{print $1,$2,'${sig1}',0}' lc0_sp.txt.txt >> lc_sig_sp.txt
echo "no no no no" >> lc_sig_sp.txt 
awk '{print $1,$2,'${sig2}',0}' lc0_sp.txt.txt >> lc_sig_sp.txt
echo "no no no no" >> lc_sig_sp.txt 
awk '{print $1,$2,'${sig3}',0}' lc0_sp.txt.txt >> lc_sig_sp.txt
echo "no no no no" >> lc_sig_sp.txt
awk '{print $1,$2,'${sig4}',0}' lc0_sp.txt.txt >> lc_sig_sp.txt
echo "no no no no" >> lc_sig_sp.txt 
awk '{print $1,$2,'${sig5}',0}' lc0_sp.txt.txt >> lc_sig_sp.txt
tail -n +2 lc0_sp.qdp | awk '{if($3 ~ /\./) print $1,$2,$3-$5,$4-$6}' | awk '{print $0,'${sig1}','${sig2}','${sig3}','${sig4}','${sig5}'}' > lc_sig_sp.txt

awk '{if($5 ~ /\./) print $1,$2,$3,$4,$3-$5,$4-$6}' lc0_sp.qdp | awk '{if($5>'${sig3}') print $0}' > flare.txt
awk '{if($5 ~ /\./) print $1,$2,$3,$4,$3-$5,$4-$6}' lc0_sp.qdp | awk '{if($5<'${sig3}') print $0}' > seq.txt

echo "read serror 1 2" > spline.qdp
echo "@spline.pco" >> spline.qdp
echo "!" >> spline.qdp
cat spline.txt >> spline.qdp

cat <<EOF> spline.pco
r y 1.4e5 1.45e5
time off
lab f
lab x Time(from 2018-07-25) [day]
lab y Flux [counts s\u-1\d]
EOF


echo "read serror 1 2" > lc_sig_sp.qdp
echo "@lc_sig.pco" >> lc_sig_sp.qdp
echo "!" >> lc_sig_sp.qdp
cat lc_sig_sp.txt >> lc_sig_sp.qdp



echo "read serror 1 2" > lc_sp.qdp
echo "@lc_sp.pco" >> lc_sp.qdp
echo "!" >> lc_sp.qdp
cat spline.txt >> lc_sp.qdp
echo "no no no no" >> lc_sp.qdp
cat lc_$j.txt >> lc_sp.qdp

cat <<EOF> lc_sp.pco
skip single
ma 20 on 1
time off
lab f
lab x Time(from 2018-07-25) [day]
lab y Flux [counts s\u-1\d]
EOF


echo "read serror 1 2" > lc_flare.qdp
echo "@lc_flare.pco" >> lc_flare.qdp
echo "!" >> lc_flare.qdp
awk '{print $1,$2,$3,$4}' flare.txt >> lc_flare.qdp
echo "no no no no no no" >> lc_flare.qdp
awk '{print $1,$2,$3,$4}' seq.txt >> lc_flare.qdp
echo "no no no no no no" >> lc_flare.qdp
awk '{print $1,$2,$5,$6}' flare.txt >> lc_flare.qdp
echo "no no no no no no" >> lc_flare.qdp
awk '{print $1,$2,$5,$6}' seq.txt >> lc_flare.qdp


cat <<EOF> lc_flare.pco
skip single
col 2 on 1 3
col 1 on 2 4
time off
lab f
lab x Time(from 2018-07-25) [day]
lab y Flux [counts s\u-1\d]
EOF

#./cut.sh

rm  -f error.txt flux.txt a.txt b.txt a1.txt a2.txt c.txt d.txt f.txt test1.txt test2.txt

headas
qdp lc_flare.qdp



