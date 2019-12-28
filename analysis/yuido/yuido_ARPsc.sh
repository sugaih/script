#!/bin/bash

############################################################################
#ARPsc
#
#”1つのデータ”に対して優位度判定を行うスクリプト
#2019/11/29(T.Sato)
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
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/ARPsc.reg
xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit


cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;circle(106.50643,106.49658,19.968761);circle(108.56083,146.30054,19.968761);circle(140.34853,84.752829,19.968761);circle(142.00643,124.62048,19.968761);circle(73.122459,128.06776,19.968761);circle(71.068061,88.006995,19.968761);circle(104.96563,66.692615,19.968761);circle(175.84237,103.67178,19.968761);circle(177.38317,143.21895,19.968761);circle(143.7424,164.53333,19.968761);circle(110.09135,186.28527,19.968761);circle(74.663258,167.87172,19.968761);circle(39.22489,149.38214,19.968761);circle(36.985596,109.45491,19.968761);circle(35.506429,69.517412,19.968761);circle(68.787679,48.069495,19.968761);circle(102.75715,27.001642,19.968761);circle(138.3496,44.607834,19.968761);circle(174.55837,63.097418,19.968761)" "" | tail -21 | head -19
EOF
chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

#優位度判定
yuido.sh count.txt

rm -f funtools_result.sh