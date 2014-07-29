#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`
LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${SCRIPTPATH}/.."

if hash module 2>/dev/null; then
	echo "load gcc 4.8.2"
	[ module load gcc/4.8.2 ] || { echo "module gcc/4.8.2 doen't exists"; exit 1; }
else
	true
fi

cd ${SCRIPTPATH}
cd ..
ROOTdir=${PWD}
SRCdir=${SCRIPTPATH}/Shark 		# source directory
BLDdir=${SRCdir}/build 			# build directory
PREFIX=${ROOTdir}/lib/shark		# install directory


echo "root dir: ${ROOTdir}"
echo "source dir: ${SRCdir}"
echo "build dir: ${BLDdir}"
echo "install dir: ${PREFIX}"


### FETCH ###

if [ ! -d "${SRCdir}" ] 
then
	cd ${SCRIPTPATH}
	svn co https://svn.code.sf.net/p/shark-project/code/trunk/Shark
else
	echo "WARNING: Shark is already downloaded"
fi


### PRE-CHECK ###


if [ -d "${PREFIX}" ] 
then
	echo "WARNING: Shark is already installed"
	exit 0
fi

if [ -d "${BLDdir}" ] 
then
	rm -rf ${BLDdir}
fi
mkdir -p ${BLDdir}

### COMPILE AND INSTALL ###
cd ${BLDdir}
cmake ${SRCdir} -DBoost_NO_SYSTEM_PATHS=TRUE -DBOOST_ROOT:Path=${ROOTdir}/lib/boost/  -DBOOST_INCLUDEDIR=${ROOTdir}/lib/boost/include -DBOOST_LIBRARYDIR=${ROOTdir}/lib/boost/lib -DATLAS_ROOT:Path=${ROOTdir}/lib/atlas -DOPT_ENABLE_ATLAS=ON -DOPT_ENABLE_OPENMP=ON -DOPT_COMPILE_EXAMPLES=OFF
make -j4

mv "${BLDdir}" "${PREFIX}"
