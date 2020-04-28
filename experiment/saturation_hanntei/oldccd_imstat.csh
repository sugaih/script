#! /bin/csh -f

rm -f aaa.txt

foreach infile ($argv[1-$#argv])

set max = `imstat "${infile}[1:1024,1:1024]" |grep maximum`
set flag = `echo $max | awk '$4>4050{print "Satulation"}'`

echo $infile $max $flag

if ($flag == "Satulation") then
echo -n "$infile " >> aaa.txt
endif

#imstat "${infile}[100:1140,100:1052]" |grep sum | awk '{printf("%d %d ",'$i',$5)}'
#/usr/local/funtools/bin/funcnts $infile "physical;box(620,576,500,500,0)" | grep "   1 " | head -1 | awk '{print $2}'

end

echo "--------- Satulation file ---------"
cat aaa.txt
echo
rm -f aaa.txt
