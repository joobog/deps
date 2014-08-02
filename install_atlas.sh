#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`
LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${SCRIPTPATH}/.."


cd ${SCRIPTPATH}
cd ..
ROOTdir=${PWD}

#
CACHEdir="${SCRIPTPATH}/cache_atlas"
# source location
SRCdir=${CACHEdir}/ATLAS
# build location
BLDdir=${SRCdir}/build
# install location
PREFIX="${ROOTdir}/lib/atlas_`date +%Y%m%d%M%H`"

LOGfile="${CACHEdir}/log"
echo "" > ${LOGfile}

echo "atlas cache dir: $CACHEdir"
echo "atlas source dir: $SRCdir"
echo "atlas build dir: $BLDdir"
echo "atlas prefix: $PREFIX"

### FETCH AND EXTRACT ###
if [ ! -d ${CACHEdir} ]
then
	mkdir -p ${CACHEdir}
fi

cd ${CACHEdir}
if [ ! -f atlas3.10.2.tar.bz2 ] 
then
	wget http://sourceforge.net/projects/math-atlas/files/Stable/3.10.2/atlas3.10.2.tar.bz2 &>> $LOGfile
else
	echo "Warning: Atlas is already downloaded"
fi

if [ ! -d "./ATLAS" ]
then
	bunzip2 -c "./atlas3.10.2.tar.bz2" | tar -xf - &>> $LOGfile
else
	echo "Warning: Atlas is alread extracted"
fi

### COMPILE AND INSTALL ###
if [ ! -d "${SRCdir}" ] 
then
	echo "$Error: {SRCdir} doen't exists"
	exit 1
fi

mkdir -p ${BLDdir}
cd ${BLDdir}
$SRCdir/configure -b 64 --prefix=${PREFIX} &>> $LOGfile
make build -j4 &>> $LOGfile
make check -j4 &>> $LOGfile
make ptchec -j4 &>> $LOGfile
make time -j4 &>> $LOGfile
make install &>> $LOGfile

### LINK ###
cd "${ROOTdir}/lib"
if [ -d "${ROOTdir}/lib/atlas" ]
then
	rm "${ROOTdir}/lib/atlas"
fi
ln -s $PREFIX atlas

### CLEANUP ###
rm -rf ${SRCdir}
