#BIN = /home/xrt/bin
BIN = $(HOME)/bin
#CFITSIO=/usr/local/adsoft/lheasoft/5.2/src/cfitsio/
#CFITSIO=/home/ymaeda/work/suzaku/20070516/cfitsio
CFITSIO=/usr/local/xray/cfitsio/
NSL=/Developer/SDKs/MacOSX10.7.sdk/Developer/Headers/FlatCarbon/
libcfitsio=/usr/local/xray/cfitsio/lib/

CC = gcc
CFLAGS = -O -Wall
INCLUDE = -I$(CFITSIO)
#LIBS =-L$(CFITSIO) -L$(NSL) -lcfitsio -lm -lnsl
LIBS =-L$(CFITSIO) -L$(NSL) -L$(libcfitsio) -lcfitsio -lm 
#LIBS =-L$(CFITSIO) -lcfitsio -lm 
#LIBS =-L$(CFITSIO) -lm 

all: extract_part

extract_part: extract_part.c
	$(CC) $(CFLAGS) -o $@ $@.c  $(INCLUDE)  $(LIBS)

#install:
#	/bin/cp -f extract_part $(BIN)
#
#clean: 
#	rm -f extract_part

