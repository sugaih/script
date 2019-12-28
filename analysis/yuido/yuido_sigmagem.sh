#!/bin/bash

############################################################################
#Sigmagem
#
#”1つのデータ”に対して優位度判定を行うスクリプト
#2019/12/10(T.Sato)
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
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/sigmagem.reg
xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit

cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;circle(106.50034,106.5065,19.968761);circle(132.23784,75.887747,19.968761);circle(145.99409,113.16275,19.968761);circle(120.70034,144.669,19.968761);circle(81.206588,137.569,19.968761);circle(66.562838,100.294,19.968761);circle(93.187838,69.231497,19.968761);circle(119.36909,38.168997,19.968761);circle(171.73159,82.543997,19.968761);circle(160.19409,150.8815,19.968761);circle(94.962838,175.28775,19.968761);circle(41.269088,132.244,19.968761);circle(53.694088,62.131497,19.968761);circle(158.86284,44.825247,19.968761);circle(185.93159,119.37525,19.968761);circle(134.90034,182.38775,19.968761);circle(55.912838,169.519,19.968761);circle(27.069088,94.081497,19.968761);circle(79.431588,31.068997,19.968761)" ""| tail -21 | head -19
EOF
chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

#優位度判定
yuido.sh count.txt

rm -f funtools_result.sh

