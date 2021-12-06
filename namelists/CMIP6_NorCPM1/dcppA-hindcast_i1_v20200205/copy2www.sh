#!/bin/sh -e

WWWPATH=/projects/NS9039K/www/dcpp/s2019
WWWPREF='http://ns9039k.web.sigma2.no/dcpp/s2019'

rm -f $WWWPATH/wget.sh
for FPATH in `find /projects/NS9034K/CMIP6/.cmorout/NorCPM1/dcppA-hindcast/v20200205/ -name "*s2019*" | sort`
do 
  FNAME=`basename $FPATH`
  VNAME=`echo $FNAME | cut -d_ -f1`
  TABLE=`echo $FNAME | cut -d_ -f2`
  RIPF=`echo $FNAME | cut -d_ -f5 | cut -d- -f2`
  FNAMEOUT=${VNAME}_${TABLE}_NorCPM1_20191101_${RIPF}.nc
  echo $FNAMEOUT
  cp -f $FPATH $WWWPATH/$FNAMEOUT
  echo "wget -c ${WWWPREF}/${FNAMEOUT}" >> $WWWPATH/wget.sh
done
