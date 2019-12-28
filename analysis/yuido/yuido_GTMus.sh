#!/bin/bash

############################################################################
#GTMus
#head = how many circles
#tail = head+2
#
##histry##
#2019/04/16 (T.Sato)
#
#”1つのデータ”に対して優位度判定を行うスクリプト  2019/01/08 (T.Sato)
############################################################################

if [ -e *tgz ]; then
  gunzip -f *gz
  tar xf **.tar
  #ls | grep -v -E 'tar$' | xargs rm -r
  #tar xf **.tar
  gunzip -f *gz
else
  tar xf **.tar
  #ls | grep -v -E 'tar$' | xargs rm -r
  #tar xf **.tar
  gunzip -f **gz
fi

pwd=$PWD
dir=${pwd#*/yuido/}
#name=`echo $dir | sed 's#/#_#g'`
name="GTMus"
smooth=$'smooth.fits'

ds9 -tile **2.0-10.0keV_image.img -zoom to fit -view colorbar no &
sleep 5s
xpaset -p ds9 cmap value 1 .5
xpaset -p ds9 saveimage jpeg "$name".jpg 100
xpaset -p ds9 smooth
xpaset -p ds9 smooth radius 5
xpaset -p ds9 smooth sigma 2.5
xpaset -p ds9 saveimage jpeg "$name"_sm.jpg 100
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/GTMus.reg
xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit

cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;circle(106.5017,106.49688,19.968761);-circle(136.353,169.17289,13.312508);-circle(93.986853,152.20772,13.312508);-circle(58.037083,110.66277,13.312508);-circle(34.866342,134.91329,13.312508);circle(79.82529,76.589862,19.968761);circle(119.04729,68.497981,19.968761);circle(145.71758,98.756463,19.968761);circle(79.921414,36.621312,19.968761);circle(119.06406,28.525776,19.968761);circle(153.71141,48.586209,19.968761);circle(180.19189,78.471627,19.968761);circle(180.49642,118.44305,19.968761)" "" | tail -11 | head -9
EOF
chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

#優位度判定
yuido.sh count.txt

rm -f funtools_result.sh
