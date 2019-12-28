#!/bin/bash
############################################################################
#lamda and
#
#2019/11/08(T.Sato)
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
xpaset -p ds9 regions load /home/tsato/script/yuido/yuido1.1/lamand.reg
xpaset -p ds9 saveimage jpeg "$name"_circle.jpg 100
xpaset -p ds9 save fits "$smooth"
xpaset -p ds9 exit

cat <<EOF > funtools_result.sh
#!/bin/bash
funds9 funcnts "ds9" "$smooth" "physical;circle(106.5001,106.49802,19.968761);-circle(140.36237,50.148957,13.312508);circle(140.6145,84.997343,19.968761);circle(142.04788,124.84526,19.968761);circle(108.50683,146.05925,19.968761);circle(72.959051,127.71201,19.968761);circle(70.952322,87.577424,19.968761);circle(105.06672,66.076751,19.968761);circle(176.16228,103.91794,19.968761);circle(177.30898,143.76585,19.968761);circle(143.76793,164.69317,19.968761);circle(109.94021,186.19384,19.968761);circle(74.392429,167.55993,19.968761);circle(38.84465,148.35266,19.968761);circle(37.411272,108.50475,19.968761);circle(35.404542,68.370156,19.968761);circle(69.805619,47.442835,19.968761);circle(103.92002,26.515513,19.968761)" "" | tail -19 | head -17
EOF

chmod 755 funtools_result.sh
./funtools_result.sh > count.txt

yuido.sh count.txt

rm -f funtools_result.sh
