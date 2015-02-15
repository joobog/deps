#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`
LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${SCRIPTPATH}/.."


cd ${SCRIPTPATH}
cd ..
ROOTdir=${PWD}
CACHEdir="${SCRIPTPATH}/cache_siox"
SRCdir="${CACHEdir}/siox" 		# source directory

BLDdir="${SRCdir}/build" 			# build directory
PREFIX="${ROOTdir}/lib/siox_`date +%Y%m%d%H%M`"		# install directory
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
	git clone https://github.com/JulianKunkel/siox.git ${SRCdir} &>>${LOG}
else
	echo "WARNING: Siox is already downloaded"
fi


#./configure --with-boost=$GIT/../lib/boost --with-glib=$GIT/../lib/glib --with-libpq=$GIT/../lib/postgresql --with-libpqxx=$GIT/../lib/libpqxx

#PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:$GIT/../lib/glib/lib/pkgconfig

./configure \\
--with-libpq=$ROOTdir/lib/postgresql \\
--with-glib=$ROOTdir/lib/glib \\
--with-likwid=/opt/likwid/3.0 \\
--with-boost=$ROOTdir/lib/boost \\
--prefix=${PREFIX} \\
--build-wrappers 

# Dependencies
#cmake 2.8
#Boost 1.49
#GCC 4.7 (for C++0x support)
#PostgreSQL 9.2
#Berkeley DB 12.1.6.0.20


### COMPILE AND INSTALL ###

#if [ -d "${BLDdir}" ] 
#then
	#rm -rf ${BLDdir}
#fi
#mkdir -p ${BLDdir}

#cd ${BLDdir}
#cmake ${SRCdir} -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBoost_NO_SYSTEM_PATHS=TRUE -DBOOST_ROOT:Path=${ROOTdir}/lib/boost/  -DBOOST_INCLUDEDIR=${ROOTdir}/lib/boost/include -DBOOST_LIBRARYDIR=${ROOTdir}/lib/boost/lib -DATLAS_ROOT:Path=${ROOTdir}/lib/atlas/ -DATLAS_INCLUDEDIR=${ROOTdir}/lib/atlas/include -DATLAS_LIBRARYDIR=${ROOTdir}/lib/atlas/lib -DOPT_ENABLE_ATLAS=ON -DOPT_ENABLE_OPENMP=ON -DOPT_COMPILE_EXAMPLES=OFF &>> ${LOG}

#make -j16 &>> ${LOG}
#make -j16 install &>> ${LOG}


#### LINK ###
#cd "${ROOTdir}/lib"
#if [ -d "${ROOTdir}/lib/shark" ]
#then
	#rm "${ROOTdir}/lib/shark"
#fi
#ln -s $PREFIX shark

