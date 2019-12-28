#!/bin/bash

############################################################################
#UXAri
#head = how many circles
#tail = head-2
#
##histry##
#result file is outputed    2017/06/29 (R.Sasaki)
#set UXAri region	    2018/11/05 (T.Sato)
#add smoothing before yuido
#
#”1つのデータ”に対して優位度判定を行うスクリプト  2019/01/08 (T.Sato)
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
#xpaset -p ds9 save fits "$nosmooth" image
xpaset -p ds9 saveimage jpeg "$name".jpg 100
xpaset -p ds9 smooth
xpaset -p ds9 smooth radius 5
xpaset -p ds9 smooth sigma 2.5
xpaset -p ds9 saveimage jpeg "$name"_sm.jpg 100
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/UXAri.reg
xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit

cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;;circle(106.50469,106.49921,19.96875);-circle(24.055494,140.22453,13.3125);circle(67.976363,36.202044,19.96875);circle(146.43552,107.35431,19.96875);circle(125.72349,141.56758,19.96875);circle(85.750496,140.65337,19.96875);circle(66.57011,105.59856,19.96875);circle(87.303451,71.346033,19.96875);circle(127.23221,72.251893,19.96875);circle(108.04045,37.125776,19.96875);circle(167.20216,73.086309,19.96875);circle(165.68812,142.43542,19.96875);circle(104.99891,175.78203,19.96875);circle(64.945474,174.91647,19.96875);circle(144.99603,176.69169,19.96875);circle(186.48026,108.17561,19.96875);circle(47.356495,70.510987,19.96875);circle(26.545858,104.74465,19.96875);circle(147.94901,37.978671,19.96875)" "" | tail -20 | head -18
EOF
chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

#優位度判定
yuido.sh count.txt

rm -f funtools_result.sh
