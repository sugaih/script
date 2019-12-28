#!/bin/bash

############################################################################
#ARPsc
#
#”1つのデータ”に対して優位度判定を行うスクリプト
#2019/11/29(T.Sato)
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
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/V841Cen.reg
xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit


cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;circle(106.49906,106.50068,15.975009);-circle(182.55794,96.934014,13.312508);-circle(157.84442,45.140027,13.312508);-circle(147.48417,83.455217,13.312508);-circle(126.44219,75.493543,13.312508);-circle(96.986235,76.590781,13.312508);-circle(38.857755,118.39968,13.312508);-circle(22.728204,142.52925,13.312508);circle(136.67406,117.59443,15.975009);circle(111.82406,137.56318,15.975009);circle(81.64906,126.91318,15.975009);circle(68.78031,97.181929,15.975009);circle(37.71781,88.306929,15.975009);circle(61.68031,66.119429,15.975009);circle(31.06156,56.800679,15.975009);circle(86.53031,45.263179,15.975009);circle(55.46781,34.613179,15.975009);circle(117.14906,34.169429,15.975009);circle(141.99906,148.65693,15.975009);circle(166.84906,128.68818,15.975009);circle(117.14906,169.06943,15.975009);circle(86.97406,157.97568,15.975009);circle(56.79906,147.32568,15.975009);circle(172.61781,159.75068,15.975009);circle(147.76781,179.71943,15.975009);circle(91.85531,189.03818,15.975009);circle(61.68031,178.83193,15.975009)"  ""| tail -22 | head -20
EOF
chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

#優位度判定
yuido.sh count.txt

rm -f funtools_result.sh

