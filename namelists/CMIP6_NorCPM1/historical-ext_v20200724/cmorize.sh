#!/bin/sh -e

NINS=10
MEM1=$1
MEMN=$2
PERIODS='2015-2018 2019-2030' 
NMLDIR=`dirname \`readlink -f $0\``
PREFIX=`basename $NMLDIR` 
RUNDIR=$NMLDIR/../../../bin

export I_MPI_WAIT_MODE=1


cd $RUNDIR
for PERIOD in `echo $PERIODS`
do 
  for MEM in `seq -w $MEM1 $MEMN`
  do 


    # determine new case name 
    MM=`echo 0$MEM | tail -3c`
    CASEOLD=`cat $NMLDIR/exp.nml | grep casename | cut -d"'" -f2`
    CASENEW=`echo $CASEOLD | sed -e "s/_19601015/_${SYR}1015/" -e "s/_mem01/_mem${MM}/"`
    echo $CASENEW 

    # parent rip and variant label 
    R=`expr $MEM + 0`
    PRIPOLD=`cat $NMLDIR/exp.nml | grep parent_experiment_rip | cut -d"'" -f2`
    PRIPNEW=`echo $PRIPOLD | sed "s/r1/r${R}/"`
    echo $PRIPNEW 
    PVAROLD=`cat $NMLDIR/exp.nml | grep parent_variant_label | cut -d"'" -f2`
    PVARNEW=`echo $PVAROLD | sed "s/r1/r${R}/"`
    echo $PVARNEW

    YEAR1=`echo $PERIOD | cut -d"-" -f1` 
    YEARN=`echo $PERIOD | cut -d"-" -f2` 
    LOGFILE=log_${PREFIX}_${MEM}_${PERIOD}.txt
    CASEPREFIX=`basename \`cat $NMLDIR/exp.nml | grep casename | cut -d"'" -f2\` 01`

    sed \
      -e "s%casename      = .*%casename      = '${CASENEW}',%" \
      -e "s%parent_experiment_rip = .*%parent_experiment_rip = '${PRIPNEW}',%" \
      -e "s%parent_variant_label = .*%parent_variant_label = '${PVARNEW}',%" \
      -e "s%realization   = .*%realization   = ${R},%" \
      -e "s/year1         = .*/year1         = ${YEAR1},/" \
      -e "s/yearn         = .*/yearn         = ${YEARN},/" \
      $NMLDIR/exp.nml > exp_${PREFIX}_${MEM}.nml

    mpirun -n $NINS ./noresm2cmor3_mpi $NMLDIR/sys.nml $NMLDIR/mod.nml exp_${PREFIX}_${MEM}.nml $NMLDIR/var.nml >& $LOGFILE  

  done
  wait 
done
