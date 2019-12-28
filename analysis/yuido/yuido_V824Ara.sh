#!/bin/bash

############################################################################
#V824Ara
#
#”1つのデータ”に対して優位度判定を行うスクリプト
#2019/12/12(T.Sato)
############################################################################

if [ -e *tgz ]; then
  gunzip -f *gz
  tar xf **.tar
  ls | grep -v -E 'tar$' | xargs rm -r
  tar xf **.tar
  gunzip -f *gz
else
  tar xf **.tar
  ls | grep -v -E 'tar$' | xargs rm -r
  tar xf **.tar
  gunzip -f **gz
fi

pwd=$PWD
dir=${pwd#*/MAXI/}
name=`echo $dir | sed 's#/#_#g'`
smooth=$'smooth.fits'

ds9 -tile **2.0-10.0keV_image.img -zoom to fit -view colorbar no &
sleep 3s
xpaset -p ds9 cmap value 1 .5
xpaset -p ds9 saveimage jpeg "$name".jpg 100
xpaset -p ds9 smooth
xpaset -p ds9 smooth radius 5
xpaset -p ds9 smooth sigma 2.5
xpaset -p ds9 saveimage jpeg "$name"_sm.jpg 100
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/V824Ara.reg
xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit

cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;circle(106.50141,106.50049,19.968761);-circle(163.88676,94.46005,13.312508);-circle(162.84109,136.83639,13.312508);-circle(123.38953,175.5143,13.312508);circle(126.02641,71.444243,19.968761);circle(85.645157,71.444243,19.968761);circle(66.563907,106.94424,19.968761);circle(86.532657,141.55674,19.968761);circle(46.595157,142.44424,19.968761);circle(45.707657,72.775493,19.968761);circle(106.05766,36.387993,19.968761);circle(65.232657,36.387993,19.968761);circle(26.182657,107.83174,19.968761);circle(145.99516,36.831743,19.968761);circle(67.451407,177.05674,19.968761)" ""| tail -14 | head -12
EOF
chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

#優位度判定
yuido.sh count.txt

rm -f funtools_result.sh

