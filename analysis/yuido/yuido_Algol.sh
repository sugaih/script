#!/bin/bash
############################################################################
#Algol
#
#2019/10/25(T.Sato)
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
sleep 2s
xpaset -p ds9 cmap value 1 .5
#xpaset -p ds9 save fits "$nosmooth" image
xpaset -p ds9 saveimage jpeg "$name".jpg 100
xpaset -p ds9 smooth
xpaset -p ds9 smooth radius 5
xpaset -p ds9 smooth sigma 2.5
xpaset -p ds9 saveimage jpeg "$name"_sm.jpg 100
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/Algol.reg
xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit

cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;circle(106.5022,106.5047,15.975009);-circle(77.493404,114.39481,13.312508);-circle(51.151309,147.73039,13.312508);circle(105.6147,138.72012,15.975009);circle(133.78718,123.26802,15.975009);circle(134.67884,91.168046,15.975009);circle(107.39387,74.404729,15.975009);circle(75.828896,80.11139,15.975009);circle(133.30999,155.38585,15.975009);circle(161.25049,139.49634,15.975009);circle(161.96382,107.5747,15.975009);circle(162.57015,75.474728,15.975009);circle(135.3575,58.701502,15.975009);circle(107.73484,42.407477,15.975009);circle(76.179285,48.077615,15.975009);circle(48.075119,63.978658,15.975009);circle(47.705327,95.780741,15.975009);circle(27.53541,120.90587,15.975009);circle(105.19514,170.70507,15.975009);circle(73.694285,176.42491,15.975009);circle(132.75741,187.48907,15.975009);circle(161.3497,171.4697,15.975009);circle(190.1047,124.0772,15.975009);circle(190.26741,91.757408,15.975009);circle(163.57338,43.35661,15.975009);circle(135.7897,26.634698,15.975009)" "" | tail -26 | head -24
EOF
chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

yuido.sh count.txt

rm -f funtools_result.sh
