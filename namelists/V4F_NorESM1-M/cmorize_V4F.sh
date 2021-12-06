#!/bin/sh -e

EXP=rcp45VolcConst

NTHREADS=20
VARS='ua va hus zg ta evspsbl ps psl  hfls hfss rlds rldscs rlus rlut rsus rsut rsds rsdscs'
CMORBASE=/nird/home/ingo/cmor/noresm2cmor
CASEPREF=volcanoes4future
PWDDIR=`pwd`

MEM1=124
MEMN=140
OFFS=0  
case $EXP in 
  const60a)
    OFFS=20
    EXPID=rcp45VolcConst
    ;;
  const60b)
    OFFS=80
    EXPID=rcp45VolcConst
    ;;
  sens6)
    OFFS=60
    EXPID=rcp45Volc
    ;;
  cont60a)
    OFFS=60
    EXPID=rcp45NoVolc
    ;;
  *)
    OFFS=0
    EXPID=$EXP
esac


cd $CMORBASE/bin
ls
n=0
for v in $VARS
do 
  for m in `seq $MEM1 $MEMN`
  do 
    CNAM=${CASEPREF}_${EXP}_${m}
    NMLFILE=noresm2cmor_${EXP}_${v}_${m}.nml 
    LOGFILE=noresm2cmor_${EXP}_${v}_${m}.log
    cp -f $PWDDIR/noresm2cmor_V4F_${EXPID}_template.nml $NMLFILE 
    sed -i -e "s/casename      = .*/casename      = '${CNAM}',/" $NMLFILE
    sed -i -e "s/realization   = .*/realization   = `expr ${m} + $OFFS`,/" $NMLFILE 
    if [ $n -lt $NTHREADS ] 
    then 
      n=`expr $n + 1`
    else
      n=0 
      wait
    fi 
    echo `pwd`/$LOGFILE
    ./noresm2cmor $NMLFILE $NMLFILE $NMLFILE $NMLFILE $v >& $LOGFILE & 
  done 
  wait
done 


