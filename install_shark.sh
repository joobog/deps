#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`

${SCRIPTPATH}/precheck

NAME="Shark"
VERSION=""

source ${SCRIPTPATH}/config

SRCdir="${CACHEdir}/Shark"
BLDdir="${SRCdir}/build"

### FETCH ###

if [ ! -d "${SRCdir}" ] 
then
	cd ${CACHEdir}
	svn co https://svn.code.sf.net/p/shark-project/code/trunk/Shark &>> ${LOG}
else
	echo "WARNING: Shark is already downloaded"
fi


### COMPILE AND INSTALL ###

if [ -d "${BLDdir}" ] 
then
	rm -rf ${BLDdir}
fi
mkdir -p ${BLDdir}
cd ${BLDdir}

cmake ${SRCdir} -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBoost_NO_SYSTEM_PATHS=TRUE -DBOOST_ROOT:Path=${INSTALL_ROOT_DIR}/boost/  -DBOOST_INCLUDEDIR=${INSTALL_ROOT_DIR}/boost/include -DBOOST_LIBRARYDIR=${INSTALL_ROOT_DIR}/boost/lib -DATLAS_ROOT:Path=${INSTALL_ROOT_DIR}/atlas/ -DATLAS_INCLUDEDIR=${INSTALL_ROOT_DIR}/atlas/include -DATLAS_LIBRARYDIR=${INSTALL_ROOT_DIR}/atlas/lib -DOPT_ENABLE_ATLAS=OFF -DOPT_ENABLE_OPENMP=ON -DOPT_COMPILE_EXAMPLES=OFF &>> ${LOG}

make -j${THREAD_NUM} &>> ${LOG}
make install &>> ${LOG}


### LINK ###
source ${SCRIPTPATH}/link
