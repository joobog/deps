#!/bin/bash

ROOTdir=/scratch/mpi/CIS/m215026

SRCdir=${ROOTdir}/lib_src/Shark
#rm -rf $SRCdir
#cd ${ROOTdir}/lib_src
#svn co https://svn.code.sf.net/p/shark-project/code/trunk/Shark

BLDdir=${ROOTdir}/lib/shark
rm -r ${BLDdir}
mkdir -p ${BLDdir}
cd ${BLDdir}
cmake ${SRCdir} -DBoost_NO_SYSTEM_PATHS=TRUE -DBOOST_ROOT:Path=${ROOTdir}/lib/boost/  -DBOOST_INCLUDEDIR=${ROOTdir}/lib/boost/include -DBOOST_LIBRARYDIR=${ROOTdir}/lib/boost/lib -DATLAS_ROOT:Path=${ROOTdir}/lib/atlas -DOPT_ENABLE_ATLAS=ON -DOPT_ENABLE_OPENMP=ON -DOPT_COMPILE_EXAMPLES=OFF
make -j4
