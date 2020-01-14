#! /bin/bash

#scp without password
#https://qiita.com/hnishi/items/5dec4c7fca9b5121430f

#ImageJ from commandline
#https://seesaawiki.jp/w/imagej/d/ImageJ%A5%DE%A5%CB%A5%E5%A5%A2%A5%EB%A1%A7Mac%20OS%20X%A4%D8%A4%CE%A5%A4%A5%F3%A5%B9%A5%C8%A1%BC%A5%EB
#https://seesaawiki.jp/w/imagej/d/ImageJ%A5%DE%A5%CB%A5%E5%A5%A2%A5%EB%A1%A7ImageJ%A5%DE%A5%AF%A5%ED%B8%C0%B8%EC#cli

#openJDK for ImageJ commandline
#http://jdk.java.net/

if [ $# -lt 2 ]
then
    echo "usage: ./spec_macro.csh date(yymmdd) .tif_directry"
    exit 1
fi

args=$*

mkdir -p $2/tif
mkdir -p $2/fits
mkdir -p spec_ana/$2

#scp from club-tsuboi witout pass
#sshpass -p "pass(itsumono)" scp Owner@club-tsuboi:C:/NinjaSat/collimator/$1/*.tif ./$2
scp Owner@club-tsuboi:C:/NinjaSat/collimator/$2/*.tif ./$2/tif
echo "scp successful!"

#execute ImageJ from commandline (requires jdk)
java -jar /Applications/ImageJ.app/Contents/Java/ij.jar -ijpath /Applications/ImageJ.app -batch ./spec_ana/savefits3.txt $2
echo ".tif -> .fits successful!"

#dark subtraction
./farith_ver2.csh $1/*.fits $2/fits/*.fits
echo "dark subtraction successful!"
mv $2/fits/*_ds.fits spec_ana/$2

#grade judgment & making spectrum
./spec_ana/anaccd_phcnt2.csh spec_ana/$2/*.fits
mv -f all_result.head spec_ana/$2
mv -f *.evts spec_ana/$2
mv -f *.pha spec_ana/$2
mv -f *.txt spec_ana/$2
mv -f *.qdp spec_ana/$2
mv -f *.pco spec_ana/$2
mv -f *.ps spec_ana/$2
fv spec_ana/$2/kese-grade0234.evts &
./spec_ana/CalcTotalCounts.sh spec_ana/$2/*.qdp 1000 3000