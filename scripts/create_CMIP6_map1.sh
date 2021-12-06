#!/bin/sh -e

PROJECT=CMIP6
ESGFROOT=/esg/data/cmor/$PROJECT
NIRDROOT=/projects/NS9034K/$PROJECT

VERSION=20190914
#FILELIST=/projects/NS9034K/CMIP6/DCPP/NCC/NorCPM1/dcppA-hindcast/.new_files_v${VERSION}.txt
#MAPFILE=/projects/NS9034K/CMIP6/DCPP/NCC/NorCPM1/dcppA-hindcast/.new_files_v${VERSION}.map
FILELIST=/projects/NS9034K/CMIP6/CMIP/NCC/NorCPM1/abrupt-4xCO2/.r1i1p1f1_v${VERSION}.txt
MAPFILE=/projects/NS9034K/CMIP6/CMIP/NCC/NorCPM1/abrupt-4xCO2/.r1i1p1f1_v${VERSION}.map

if [ $VERSION ] 
then 
  VTAG=v$VERSION
else
  VTAG=
fi

echo "create new $MAPFILE"  
rm -f "$MAPFILE"
for FNAME in `cat $FILELIST`
do
  echo $FNAME
  MIP=DCPP
  INS=NCC
  RIP=`echo $FNAME | cut -d_ -f5`
  MOD=`echo $FNAME | cut -d_ -f3`
  EXP=`echo $FNAME | cut -d_ -f4`
  TABLE=`echo $FNAME | cut -d_ -f2`
  FIELD=`echo $FNAME | cut -d_ -f1`
  GRID=`echo $FNAME | cut -d_ -f6 | cut -d. -f1` 
  NIRDPATH="$NIRDROOT/$MIP/$INS/$MOD/$EXP/$RIP/$TABLE/$FIELD/$GRID/$VTAG/$FNAME"
  ESGFPATH="$NIRDROOT/$MIP/$INS/$MOD/$EXP/$RIP/$TABLE/$FIELD/$GRID/$VTAG/$FNAME"
  SHASUM=`sha256sum $NIRDPATH | awk '{print $1}'`
  MTIME=`stat -Lc %Y "$NIRDPATH"`.0 
  FSIZE=`stat -Lc %s "$NIRDPATH"`
  DATASET="${PROJECT}.${MIP}.${INS}.${MOD}.${EXP}.${RIP}.${TABLE}.${FIELD}.${GRID}#${VERSION}"
  MAPENTRY="$DATASET | $ESGFPATH | $FSIZE | mod_time=$MTIME | checksum=$SHASUM | checksum_type=SHA256"
  echo "$MAPENTRY" >> "$MAPFILE"
done
chmod g+w "$MAPFILE"
echo SUCCESS 
