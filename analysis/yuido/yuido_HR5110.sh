#!/bin/bash

############################################################################
#HR5110
#
#”1つのデータ”に対して優位度判定を行うスクリプト
#2019/12/16(T.Sato)
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
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/HR5110.reg
xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit

cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;circle(106.50215,106.49448,19.968761);circle(145.1084,97.619475,19.968761);circle(134.01465,136.22573,19.968761);circle(94.964653,145.10073,19.968761);circle(67.895903,115.36948,19.968761);circle(79.433403,76.763225,19.968761);circle(118.4834,67.444476,19.968761);circle(157.5334,59.456976,19.968761);circle(173.06465,126.46322,19.968761);circle(122.9209,174.38823,19.968761);circle(55.470903,153.08823,19.968761);circle(40.383404,85.638226,19.968761);circle(90.083403,38.600725,19.968761);circle(129.57715,28.838225,19.968761);circle(184.1584,88.744475,19.968761);circle(161.9709,164.62573,19.968761);circle(82.539653,183.26323,19.968761);circle(27.958403,122.91323,19.968761);circle(51.477153,47.031975,19.968761)" "" | tail -21 | head -19
EOF

chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

#優位度判定
yuido.sh count.txt

rm -f funtools_result.sh


