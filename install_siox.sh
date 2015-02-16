#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`
LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${SCRIPTPATH}/.."

cd ${SCRIPTPATH}
cd ..
NAME="siox"
VERSION="dev"

ROOTdir=${PWD}
CACHEdir="${SCRIPTPATH}/cache_${NAME}"
SRCdir="${CACHEdir}/${NAME}-${VERSION}" 		# source directory

BLDdir="${SRCdir}/build" 			# build directory
PREFIX="${ROOTdir}/lib/${NAME}_`date +%Y%m%d%H%M`"		# install directory
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
	git clone https://github.com/JulianKunkel/siox.git ${SRCdir} &>>${LOG} &>> "${LOG}"
else
	echo "WARNING: Siox is already downloaded"
fi

#### COMPILE AND INSTALL ###

#${SRCdir}/configure --with-libpq=$ROOTdir/lib/postgresql --with-glib=$ROOTdir/lib/glib --with-likwid=$ROOTdir/lib/likwid --with-boost=$ROOTdir/lib/boost --prefix=${PREFIX} --build-dir=${BLDdir} --build-wrappers 
${SRCdir}/configure --with-libpqxx=$ROOTdir/lib/libpqxx --with-libpq=$ROOTdir/lib/postgresql --with-glib=$ROOTdir/lib/glib  --with-boost=$ROOTdir/lib/boost --prefix=${PREFIX} --build-dir=${BLDdir} &>> ${LOG}
cd "${BLDdir}" &>> "${LOG}"

make -j1 &>> "${LOG}"
make -j1 install &>> "${LOG}"

### LINK ###
cd "${ROOTdir}/lib"
if [ -d "${ROOTdir}/lib/${NAME}" ]
then
	rm "${ROOTdir}/lib/${NAME}"
fi
ln -s $PREFIX ${NAME}

