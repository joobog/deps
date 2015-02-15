#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`
LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${SCRIPTPATH}/.."


cd ${SCRIPTPATH}
cd ..
ROOTdir=${PWD}
CACHEdir="${SCRIPTPATH}/cache_shark"
SRCdir="${CACHEdir}/Shark" 		# source directory

BLDdir="${SRCdir}/build" 			# build directory
PREFIX="${ROOTdir}/lib/shark_`date +%Y%m%d%H%M`"		# install directory
LOG="${CACHEdir}/log"


echo "root dir: ${ROOTdir}"
echo "cache dir: ${CACHEdir}" 
echo "source dir: ${SRCdir}"
echo "build dir: ${BLDdir}"
echo "install dir: ${PREFIX}"

if [ ! -d ${CACHEdir} ]
then
	mkdir -p ${CACHEdir}
fi

echo "" &> ${LOG}

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
cmake ${SRCdir} -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBoost_NO_SYSTEM_PATHS=TRUE -DBOOST_ROOT:Path=${ROOTdir}/lib/boost/  -DBOOST_INCLUDEDIR=${ROOTdir}/lib/boost/include -DBOOST_LIBRARYDIR=${ROOTdir}/lib/boost/lib -DATLAS_ROOT:Path=${ROOTdir}/lib/atlas/ -DATLAS_INCLUDEDIR=${ROOTdir}/lib/atlas/include -DATLAS_LIBRARYDIR=${ROOTdir}/lib/atlas/lib -DOPT_ENABLE_ATLAS=ON -DOPT_ENABLE_OPENMP=ON -DOPT_COMPILE_EXAMPLES=OFF &>> ${LOG}

make -j16 &>> ${LOG}
make -j16 install &>> ${LOG}


### LINK ###
cd "${ROOTdir}/lib"
if [ -d "${ROOTdir}/lib/shark" ]
then
	rm "${ROOTdir}/lib/shark"
fi
ln -s $PREFIX shark

