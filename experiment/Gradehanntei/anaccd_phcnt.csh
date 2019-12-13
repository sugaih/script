#! /bin/csh -f

# extract events from dark subtracted efits files
# Time-stamp: <2003-02-08 20:56:54 hiro>
# usage: mkevent.csh file1 [file2] ...

## modeified for beamline fits image YMAEDA 20080314


echo "Do not forget xraysetup asca"   # for yayoi

set bin_dir = ~/yoshino	# for yoshino
#set bin_dir = ~/bin	# for yoake
#set bin_dir = ./	# for yoake
#set bin_dir = /home/hiro/Hard/CCD/analysis/bin/ccd # for NFS
set dir = `pwd`

if ( $1 =~ -h* || $# == 0 ) then
   echo "extract events from dark subtracted fits files"
   echo "usage: anaccd_phcnt.csh evnt_th splt_th evnt_up bin_size file1 [file2] ..."
   exit
endif

##set def_xsize = `head -c 320 $1 | tail -c 80 | tr -s " " | cut -d " " -f 3`
##set def_ysize = `head -c 400 $1 | tail -c 80 | tr -s " " | cut -d " " -f 3`

## default values ##
#set ximage_max = 270
#set ximage_min = 20
#set yimage_max = 260
#set yimage_min = 10
#set ximage_max = 500
#set ximage_min = 50
#set yimage_max = 500
#set yimage_min = 10
set evnt_th = 10
set splt_th = 5
set evnt_up = 4000
set gain = 16.3
set out_root = "kese"
set phabinsize = 1
set xerror = 0.5
#set ebinsize = 3.65

	    echo "event threshold? [$evnt_th]"
	    set par = $<
	    if ($par !~ ^ *) then
		set evnt_th = $par
	    endif
	    echo "split threshold? [$splt_th]"
	    set par = $<
	    if ($par !~ ^ *) then
		set splt_th = $par
	    endif
	    echo "event upper discri? [$evnt_up]"
	    set par = $<
	    if ($par !~ ^ *) then
		set evnt_up = $par
	    endif
	    echo "PHA bin size ? [1]"
	    set par = $<
	    if ($par !~ ^ *) then
		set phabinsize = $par
		$xerror = $phabinsize*0.5
	    endif
	    echo "event and pha file root name ? [kese]"
	    set par = $<
	    if ($par !~ ^ *) then
		set out_root = $par
	    endif

echo "event threshold = $evnt_th"
echo "split threshold = $splt_th"
echo "event upper discri = $evnt_up"
#echo "event threshold = $evnt_th" > $dir/all_result.head
#echo "split threshold = $splt_th" >> $dir/all_result.head
#echo "event upper discri = $evnt_up" >> $dir/all_result.head
echo "even_th $evnt_th / Event threshold in unit of ADU" > $dir/all_result.head
echo "splt_th $splt_th / Split threshold in unit of ADU" >> $dir/all_result.head
echo "u_discri $evnt_up / Upper level discri  in unit of ADU" >> $dir/all_result.head
echo "history Input frame data are $*" >> $dir/all_result.head

#set im_xsize = `echo "$ximage_max - $ximage_min" | bc -l `
#set im_ysize = `echo "$yimage_max - $yimage_min" | bc -l `

echo ""
echo "     ####  extract events  ####"
echo ""


$bin_dir/event_extract_wh $evnt_th $splt_th $evnt_up $*  > $dir/all_result.txt


fcreate cdfile=$bin_dir/event_extract_wh_tablelist  datafile=$dir/all_result.txt outfile=$out_root.evts clobber=yes headfile=$dir/all_result.head

#fcalc infile=$out_root.evts outfile=$out_root.evts clname=ENERGY expr="$gain*PHA" clobber=yes

fselect infile=$out_root.evts outfile=$out_root-grade0234.evts expr="GRADE==0||GRADE==2||GRADE==3||GRADE==4" clobber=yes
#fselect infile=$out_root.evts outfile=$out_root-grade0234.evts expr="GRADE==0" clobber=yes

fhisto infile=$out_root.evts outfile=$out_root.pha column=PHA binsz=$phabinsize lowval=-100 highval=3996 clobber=yes outcolx=PHA outcoly=COUNTS

fcalc infile=$out_root.pha outfile=$out_root.pha clname=BINSIZE expr=$xerror clobber=yes

fhisto infile=$out_root-grade0234.evts outfile=$out_root-grade0234.pha column=PHA binsz=1  lowval=-100 highval=3996 clobber=yes outcolx=PHA outcoly=COUNTS

fcalc infile=$out_root-grade0234.pha outfile=$out_root-grade0234.pha clname=BINSIZE expr=$xerror clobber=yes

fplot infile=$out_root-grade0234.pha xparm="PHA[BINSIZE]" yparm="COUNTS[Error]" rows=- device="/xw" pltcmd="-"


	    echo "CCD gain [eV/ADU]? [16.3]"
	    set par = $<
	    if ($par !~ ^ *) then
		set gain = $par
	    endif

#	    echo "ENERGY bin size ? [3.65]"
#	    set par = $<
#	    if ($par !~ ^ *) then
#		set ebinsize = $par
#	    endif

fcalc infile=$out_root.evts outfile=$out_root.evts clname=ENERGY expr="$gain*PHA" clobber=yes

fselect infile=$out_root.evts outfile=$out_root-grade0234.evts expr="GRADE==0||GRADE==2||GRADE==3||GRADE==4" clobber=yes


fcalc infile=$out_root.pha outfile=$out_root-e.pha clname=ENERGY expr="PHA*$gain" clobber=yes

fcalc infile=$out_root-e.pha outfile=$out_root-e.pha clname=EBINSIZE expr="BINSIZE*$gain" clobber=yes



fcalc infile=$out_root-grade0234.pha outfile=$out_root-grade0234-e.pha clname=ENERGY expr="PHA*$gain" clobber=yes

fcalc infile=$out_root-grade0234-e.pha outfile=$out_root-grade0234-e.pha clname=EBINSIZE expr="BINSIZE*$gain" clobber=yes


fplot infile=$out_root-grade0234-e.pha xparm="ENERGY[EBINSIZE]" yparm="COUNTS[Error]" rows=- device="/xw" pltcmd="-"
