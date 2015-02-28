#!/bin/bash

SCRIPT=$(readlink -f $0)
export SCRIPTPATH=`dirname ${SCRIPT}`

${SCRIPTPATH}/precheck

export NAME="atlas"
export VERSION="3.10.2"

source ${SCRIPTPATH}/config


SRCdir="$CACHEdir/ATLAS"

### FETCH AND EXTRACT ###
cd ${CACHEdir}
if [ ! -f atlas3.10.2.tar.bz2 ] 
then
	wget http://sourceforge.net/projects/math-atlas/files/Stable/3.10.2/atlas3.10.2.tar.bz2 
else
	echo "Warning: ${NAME}${VERSION} is already downloaded"
fi


### EXTRACT
if [ ! -d "./ATLAS" ]
then
	bunzip2 -c "./${NAME}${VERSION}.tar.bz2" | tar -xvf -
else
	echo "Warning: ${NAME}${VERSION} is already extracted"
fi


### COMPILE AND INSTALL ###
mkdir -p ${BLDdir}
cd ${BLDdir}
$SRCdir/configure -b 64 --prefix=${PREFIX} 
make build -j${THREAD_NUM} 
make check -j${THREAD_NUM}
make ptchec -j${THREAD_NUM}
make time -j${THREAD_NUM}
make install 


### LINK ###
source ${SCRIPTPATH}/link

