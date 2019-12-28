#!/bin/bash

############################################################################
#VYAri
#
#”1つのデータ”に対して優位度判定を行うスクリプト
#2019/11/21(T.Sato)
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
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/VYAri.reg
xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit

cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;circle(106.50229,106.4978,19.968761);circle(130.90854,74.991553,19.968761);circle(146.2549,111.42836,19.968761);circle(121.91028,143.47697,19.968761);circle(82.157673,138.54642,19.968761);circle(67.057846,101.56725,19.968761);circle(91.402464,69.518637,19.968761);circle(170.59951,79.379748,19.968761);circle(161.35472,148.40753,19.968761);circle(97.873819,175.52558,19.968761);circle(42.713229,132.69138,19.968761);circle(52.26618,64.588082,19.968761);circle(115.74708,37.778185,19.968761);circle(185.69934,116.35891,19.968761);circle(137.62642,180.7643,19.968761);circle(58.121214,170.28687,19.968761);circle(27.613402,95.404053,19.968761);circle(75.994478,32.53947,19.968761);circle(155.19153,42.70874,19.968761)" "" | tail -21 | head -19
EOF
chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

#優位度判定
yuido.sh count.txt

rm -f funtools_result.sh
