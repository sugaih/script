#!/bin/bash

############################################################################
#IIPeg
#
#”1つのデータ”に対して優位度判定を行うスクリプト
#2019/01/23(T.Sato)
#macではうまくsaveimage1が働かないらしい。
#2020/01/02(T.Sato)
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
#xpaset -p ds9 saveimage jpeg "$name".jpg 100
xpaset -p ds9 smooth
xpaset -p ds9 smooth radius 5
xpaset -p ds9 smooth sigma 2.5
#xpaset -p ds9 saveimage jpeg "$name"_sm.jpg 100
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/IIPeg.reg
#xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit


cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;;circle(106.49862,106.50426,19.96875);circle(140.7999,86.047953,19.96875);circle(141.39369,126.05346,19.96875);circle(107.02811,146.52672,19.96875);circle(72.069495,126.99652,19.96875);circle(71.573399,87.007113,19.96875);circle(105.95147,66.436117,19.96875);circle(175.73808,105.59117,19.96875);circle(176.28782,145.6353,19.96875);circle(141.95179,166.02793,19.96875);circle(107.62282,186.50935,19.96875);circle(72.67239,167.03543,19.96875);circle(37.627696,147.47548,19.96875);circle(37.115318,107.41704,19.96875);circle(36.690896,67.412091,19.96875);circle(71.080465,46.903298,19.96875);circle(105.52487,26.416589,19.96875);circle(140.50008,45.992903,19.96875);circle(175.27637,65.637212,19.96875)" "" | tail -21 | head -19
EOF
chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

#優位度判定
yuido.sh count.txt

rm -f funtools_result.sh
