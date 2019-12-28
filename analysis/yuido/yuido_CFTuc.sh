#!/bin/bash

############################################################################
#SZPsc
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
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/CFTuc.reg
xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit

cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;circle(106.5013,106.49412,19.968761);-circle(83.799278,121.4658,13.312508);circle(112.27005,146.43162,19.968761);circle(144.22005,121.58162,19.968761);circle(138.4513,81.644115,19.968761);circle(101.1763,66.556616,19.968761);circle(68.782546,90.075366,19.968761);circle(63.901297,49.694116,19.968761);circle(97.182547,26.619116,19.968761);circle(134.0138,42.150366,19.968761);circle(170.84505,57.681616,19.968761);circle(176.17005,96.731617,19.968761);circle(181.9388,135.78162,19.968761);circle(150.43255,160.63162,19.968761);circle(118.9263,185.48162,19.968761);circle(80.763797,172.16912,19.968761);circle(31.951297,74.544116,19.968761);circle(36.832547,114.03787,19.968761);circle(43.932547,153.08787,19.968761)" "" | tail -20 | head -18
EOF
chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

#優位度判定
yuido.sh count.txt

rm -f funtools_result.sh

