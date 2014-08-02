#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`
LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${SCRIPTPATH}/.."

#if hash module 2>/dev/null; then
	#echo "load gcc 4.8.2"
	#[ module load gcc/4.8.2 ] || { echo "module gcc/4.8.2 doen't exists"; }
#else
	#true
#fi

cd ${SCRIPTPATH}
cd ..
ROOTdir=${PWD}

# source location
SRCdir=${SCRIPTPATH}/ATLAS
# build location
BLDdir=${SRCdir}/build
# install location
PREFIX=${ROOTdir}/lib/atlas_3_10_2

echo "atlas source dir: $SRCdir"
echo "atlas build dir: $BLDdir"
echo "atlas prefix: $PREFIX"

### PRE-CLEANUP ###
if [ -d "${PREFIX}" ] 
then
	echo "Atlas is already installed"
	exit 0
fi

### FETCH AND EXTRACT ###
cd ${SCRIPTPATH}
if [ ! -f atlas3.10.2.tar.bz2 ] 
then
	wget http://sourceforge.net/projects/math-atlas/files/Stable/3.10.2/atlas3.10.2.tar.bz2
else
	echo "Warning: Atlas is already downloaded"
fi

if [ ! -d "./ATLAS" ]
then
	bunzip2 -c "./atlas3.10.2.tar.bz2" | tar -xf -
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
$SRCdir/configure -b 64 --prefix=${PREFIX}
make build -j4
make check -j4
make ptchec -j4
make time -j4
make install

ln -s $PREFIX atlas

### CLEANUP ###
rm -r ${SRCdir}
