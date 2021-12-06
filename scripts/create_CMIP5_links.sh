#!/bin/sh -e 

IDIR=$1
VER=`basename $IDIR`
OBASE=/projects/NS9034K/CMIP5/output1/NCC
rm -f $IDIR/links.txt
for FNAME in `ls $IDIR`
do 
  VAR=`echo $FNAME | cut -d_ -f1`
  TAB=`echo $FNAME | cut -d_ -f2`
  MOD=`echo $FNAME | cut -d_ -f3`
  EXP=`echo $FNAME | cut -d_ -f4`
  RIP=`echo $FNAME | cut -d_ -f5 | cut -d'.' -f1`
  FRQ=`ncdump -h $IDIR/$FNAME | grep "frequency =" | cut -d'"' -f2`
  RLM=`ncdump -h $IDIR/$FNAME | grep "modeling_realm =" | cut -d'"' -f2 | cut -d' ' -f1`
  DIR=$OBASE/$MOD/$EXP/$FRQ/$RLM/$TAB/$RIP/$VER/$VAR
  echo $DIR
  mkdir -p $DIR 
  cd $DIR 
  ln -sf ../../../../../../../../../../.cmorout/$MOD/$EXP/$VER/$FNAME . 
  echo $DIR/$FNAME >> $IDIR/links.txt
done 
