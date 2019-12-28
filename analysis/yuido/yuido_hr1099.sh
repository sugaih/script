#!/bin/bash

############################################################################
#HR1099
#
#”1つのデータ”に対して優位度判定を行うスクリプト
#2019/02/14(T.Sato)
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
name="HR1099"
#name=`echo $dir | sed 's#/#_#g'`""
smooth=$'smooth.fits'

ds9 -tile **2.0-10.0keV_image.img -zoom to fit -view colorbar no &
sleep 3s
xpaset -p ds9 cmap value 1 .5
xpaset -p ds9 saveimage jpeg "$name".jpg 100
xpaset -p ds9 smooth
xpaset -p ds9 smooth radius 5
xpaset -p ds9 smooth sigma 2.5
xpaset -p ds9 saveimage jpeg "$name"_sm.jpg 100
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/HR1099.reg
xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit

cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;circle(106.50057,106.50321,19.96875);circle(37.290938,107.49327,19.96875);circle(140.88514,86.054037,19.96875);circle(141.39392,125.97126,19.96875);circle(107.10158,146.45516,19.96875);circle(72.175743,126.97148,19.96875);circle(71.622571,87.017091,19.96875);circle(105.96946,66.571915,19.96875);circle(140.29407,46.082119,19.96875);circle(175.81073,105.61108,19.96875);circle(142.1894,166.55108,19.96875);circle(72.760022,166.9878,19.96875);circle(71.039448,47.072178,19.96875);circle(176.36099,145.57116,19.96875);circle(107.67967,186.61533,19.96875);circle(37.790676,147.52756,19.96875);circle(36.695049,67.490147,19.96875);circle(105.37636,26.529458,19.96875);circle(175.30922,65.55129,19.96875)" "" | tail -21 | head -19
EOF
chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

#優位度判定
yuido.sh count.txt

rm -f funtools_result.sh
