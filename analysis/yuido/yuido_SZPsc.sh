#!/bin/bash

############################################################################
#SZPsc
#
#”1つのデータ”に対して優位度判定を行うスクリプト
#2019/12/04(T.Sato)
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
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/SZPsc.reg
xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit


cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;circle(106.50084,106.49413,19.968761);circle(71.443199,178.6035,19.968761);circle(146.3048,103.66933,19.968761);circle(129.09922,139.6213,19.968761);circle(89.261965,142.6066,19.968761);circle(66.673096,109.46635,19.968761);circle(83.91197,73.502492,19.968761);circle(123.88832,70.530273,19.968761);circle(168.56078,136.6681,19.968761);circle(151.184,172.74847,19.968761);circle(111.25936,175.88025,19.968761);circle(48.990838,145.36663,19.968761);circle(27.053838,111.60513,19.968761);circle(44.375837,75.061838,19.968761);circle(62.433997,39.31531,19.968761);circle(101.87844,36.541872,19.968761);circle(141.63105,34.692914,19.968761);circle(163.81855,67.974164,19.968761);circle(186.62237,100.63909,19.968761)" "" | tail -21 | head -19
EOF
chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

#優位度判定
yuido.sh count.txt

rm -f funtools_result.sh
