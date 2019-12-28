#!/bin/bash

############################################################################
#IMPeg
#
#”1つのデータ”に対して優位度判定を行うスクリプト
#2019/12/11 (T.Sato)
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
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/IMPeg.reg
xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit

cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;circle(106.50562,106.49744,19.968761);circle(145.11187,93.184944,19.968761);circle(137.56812,132.23494,19.968761);circle(99.849369,145.54744,19.968761);circle(68.343119,119.80994,19.968761);circle(125.14312,58.128694,19.968761);circle(55.918119,81.203694,19.968761);circle(85.649369,54.134944,19.968761);circle(176.17437,119.80994,19.968761);circle(167.74312,158.85994,19.968761);circle(130.02437,171.72869,19.968761);circle(92.305619,185.48494,19.968761);circle(61.686869,159.74744,19.968761);circle(30.624369,133.56619,19.968761);circle(183.71812,79.872444,19.968761);circle(163.74937,44.816194,19.968761);circle(109.61187,20.853694,19.968761)" "" | tail -19 | head -17
EOF
chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

#優位度判定
yuido.sh count.txt

rm -f funtools_result.sh



