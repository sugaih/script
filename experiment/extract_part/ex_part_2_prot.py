#! /usr/bin/python
#! /opt/anaconda3/bin
#-*- coding: utf-8 -*-

## This is the python3.7 version of ex_part.py
###
import re
import os
import numpy
import sys
import astropy.io.fits


###print "\n\n------Enter the fits file name------"
argvs = sys.argv
argc = len(argvs)
if argc != 6:
    print ("Usage:\n python SctiptName.py Input.fits Xmin Xmax Ymin Ymax")
    quit()
print (argvs[1])

##input
file_line = argvs[1]
filename1, kakutyosi = os.path.splitext(file_line)

if kakutyosi != ".fits":
    print ("Only .fits file can be loaded, quit")
    quit()
elif os.path.isfile(file_line):
    print ("fits file found. ")
else:
    print ("file does not exits. ")
    quit()

for vale in range(2,6):

    if isinstance(int(argvs[vale]),int):
        pass
    else:
        print ("argvs "+str(vale)+" must be int.")
        print (argvs[val])
        quit()
print (argvs[5])

##output
outfile1 , outkakutyosi = os.path.splitext(file_line)
if outkakutyosi != ".fits":
    print ("\nExtension is automatically replaced to .fits")
    outkakutyosi = ".fits"

outfile2 = outfile1 + "_cut"
file_out = outfile2 + outkakutyosi

outfile1 = ""
outkakutyosi = ""

#while outfile1 == "": 

print ("***************",outfile1 , outkakutyosi)


#    if outfile1 == "":
#        print "Please enter the new fits file name"
    
#    else:
outfile1 , outkakutyosi = os.path.splitext(file_out)
while os.path.isfile(file_out):
    print (file_out,"already exists. Change to", outfile1 +"_1"+ outkakutyosi)
    outfile1 = outfile1+"_1"
    file_out =outfile1 + outkakutyosi
    
###################
#parameter1

#########


###################
#size judgement

#print "\nHigh is", type(hi),",   Low is",type(lo)
#if isinstance(hi,type(None)) or isinstance(lo,type(None)):
#    print "\nType of the variable 'high' or 'low' is 'Nonetype'."
#    hi = float(input_line1)
#    lo = float(input_line2)
#    print "\tThen,put High=",hi , " put Low=",lo

#if hi <= lo:
#    print "\n[Error] *** Hi_limit must be larger than Lo_limit . Quit.*** "
#    quit()
    
#print "\n","***Successfully loading***","\n"
#print "\tHigh=", hi , "\tLow=", lo,"\tfile=",file_line


#######################################################################
#processing


hdulist = astropy.io.fits.open(file_line)

scidata= hdulist[0].data
xmin=int(argvs[2])
xmax=int(argvs[3])
ymin=int(argvs[4])
ymax=int(argvs[5])
scidata2=numpy.zeros(((ymax+1-ymin),(xmax+1-xmin)),dtype=int)
h = hdulist[0].header["NAXIS2"]
print (id(scidata))
print (id(scidata2))
if xmin<=0:
    if xmax+1>h:
        print ("min and xmax is out of lange. quit")
        quit()

        
detx_out=outfile1+"_detx.txt"
dety_out=outfile1+"_dety.txt"
fx=open(detx_out,"w")
fy=open(dety_out,"w")
fx.write("det_x\theight\n")
fy.write("det_y\theight\n")


for (j,xc) in zip(range(xmin,xmax+1),range(0,xmax+1-xmin)):
    d_xz=0
    for (y,yc) in zip(range(ymin,ymax+1),range(0,ymax+1-ymin)):
        z= scidata[y,j].copy()
        scidata2[yc,xc]=z
        d_xz= d_xz + z
    fx_str=str(j)+" "+str(d_xz)
    fx.writelines(fx_str + "\n")

for (y,yc) in zip(range(ymin,ymax+1),range(0,ymax+1-ymin)):
    d_yz=0
    for (j,xc) in zip(range(xmin,xmax+1),range(0,xmax+1-xmin)):
        zy= scidata[y,j].copy()
        d_yz= d_yz + zy
    fy_str=str(y)+" "+str(d_yz)
    fy.writelines(fy_str + "\n")
    
fx.close()
fy.close()
reversed_scidata = scidata2[::-1]

hdulist[0].data = scidata2
#######################################################################
#x,y diversion process









print( "\n\n###############")




hdulist.writeto(file_out)
hdulist.close()
print ("\n\n",file_out,"\tis successfully exported , End. ")
