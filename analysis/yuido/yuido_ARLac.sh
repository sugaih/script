#!/bin/bash

############################################################################
#ARLac
#
#”1つのデータ”に対して優位度判定を行うスクリプト
#2019/11/20(T.Sato)
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
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/ARLac.reg
xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit


cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;circle(106.5007,106.49666,19.968761);circle(138.09403,81.999159,19.968761);circle(143.41566,121.47664,19.968761);circle(111.85069,146.26496,19.968761);circle(74.935725,131.10664,19.968761);circle(69.58573,91.338339,19.968761);circle(100.9367,66.692694,19.968761);circle(175.10361,97.060409,19.968761);circle(180.20223,136.54223,19.968761);circle(148.97685,161.3462,19.968761);circle(117.24611,185.74958,19.968761);circle(80.121646,170.71309,19.968761);circle(43.314029,155.40041,19.968761);circle(37.979032,115.72749,19.968761);circle(32.378696,75.997407,19.968761);circle(64.074244,51.595999,19.968761);circle(95.588371,26.994343,19.968761);circle(132.41236,42.331241,19.968761)" "" | tail -20 | head -18
EOF
chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

#優位度判定
yuido.sh count.txt

rm -f funtools_result.sh
