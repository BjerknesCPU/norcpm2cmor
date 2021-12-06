#!/bin/sh -e

NINS=10
NMEM=14
RUNS='1987-04 1987-05 1987-09 1989-06'
NMLDIR=`dirname \`readlink -f $0\``
PREFIX=`basename $NMLDIR` 
RUNDIR=$NMLDIR/../../../bin

export I_MPI_WAIT_MODE=1

cd $RUNDIR
for RUN in $RUNS
do 
    SYEAR=`echo $RUN | cut -d"-" -f1`
    MEM=`echo $RUN | cut -d"-" -f2`
    YEAR1=`echo $PERIOD | cut -d"-" -f1` 
    YEARN=`echo $PERIOD | cut -d"-" -f2` 
    LOGFILE=log_${PREFIX}_${MEM}_${SYEAR}.txt
    $NMLDIR/exp.sh $SYEAR $MEM > exp_${PREFIX}.nml
    mpirun -n $NINS ./noresm2cmor3_mpi $NMLDIR/sys.nml $NMLDIR/mod.nml exp_${PREFIX}.nml $NMLDIR/var.nml >& $LOGFILE
done
