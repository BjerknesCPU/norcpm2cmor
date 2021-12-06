#!/bin/sh -e

IDIR=$1
PROJECT=CMIP5
ESGFROOT=/esg/data/cmor/$PROJECT
NIRDROOT=/projects/NS9034K/$PROJECT

VERSION=`basename $IDIR | tail -9c`
FILELIST=$IDIR/links.txt
MAPFILE=$IDIR/links.map 
PROJECT=cmip5
MIP=output2
INS=NCC

echo "create new $MAPFILE"  
rm -f "$MAPFILE"
for NIRDPATH in `cat $FILELIST`
do
  FNAME=`basename $NIRDPATH`
  VAR=`echo $FNAME | cut -d_ -f1`
  TAB=`echo $FNAME | cut -d_ -f2`
  MOD=`echo $FNAME | cut -d_ -f3`
  EXP=`echo $FNAME | cut -d_ -f4`
  RIP=`echo $FNAME | cut -d_ -f5 | cut -d'.' -f1`
  FRQ=`ncdump -h $IDIR/$FNAME | grep "frequency =" | cut -d'"' -f2`
  RLM=`ncdump -h $IDIR/$FNAME | grep "modeling_realm =" | cut -d'"' -f2 | cut -d' ' -f1`
  DIR=$OBASE/$MOD/$EXP/$FRQ/$RLM/$TAB/$RIP/$VER/$VAR
  ESGFPATH=`echo $NIRDPATH | sed 's%projects/NS9034K%esg/data/cmor%'`  
  SHASUM=`sha256sum $NIRDPATH | awk '{print $1}'`
  MTIME=`stat -Lc %Y "$NIRDPATH"`.0 
  FSIZE=`stat -Lc %s "$NIRDPATH"`
  DATASET="${PROJECT}.${MIP}.${INS}.${MOD}.${EXP}.${FRQ}.${RLM}.${TAB}.${RIP}#${VERSION}"
  MAPENTRY="$DATASET | $ESGFPATH | $FSIZE | mod_time=$MTIME | checksum=$SHASUM | checksum_type=SHA256"
  echo $MAPENTRY
  echo "$MAPENTRY" >> "$MAPFILE"
done
chmod g+w "$MAPFILE"
echo SUCCESS 

#cmip5.output2.NCC.NorESM1-M.rcp85.mon.ocean.Omon.r1i1p1#20110901 | /esg/data/cmor/CMIP5/output2/NCC/NorESM1-M/rcp85/mon/ocean/Omon/r1i1p1/v20110901/agessc/agessc_Omon_NorESM1-M_rcp85_r1i1p1_200601-200912.nc | 1656436552 | mod_time=1306531098.000000 | checksum=1b19dde6edd36bf830fe5bf5219536273ee46b9d9299fcd2eb632f3cc1172492 | checksum_type=SHA256
