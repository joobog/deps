#!/bin/bash

SCRIPT=$(readlink -f $0)
export SCRIPTPATH=`dirname ${SCRIPT}`

${SCRIPTPATH}/precheck

export NAME="bzip2"
export MAJOR="1"
export MINOR="0"
export REVISION="6"
export VERSION="$MAJOR.$MINOR.$REVISION"

source ${SCRIPTPATH}/config


### FETCH AND EXTRACT ###
if [ ! -d "${SRCdir}" ] 
then
	cd ${CACHEdir}
	wget "http://bzip.org/$VERSION/${NAME}-${VERSION}.tar.gz"

else
	echo "WARNING: ${NAME}-${VERSION} already exists"
fi


### EXTRACT ###
if [ ! -d "${SRCdir}" ] 
then
	#gunzip "${CACHEdir}/${NAME}-${VERSION}.tar.gz"
	tar -xzvf "${CACHEdir}/${NAME}-${VERSION}.tar.gz"

else
	echo "WARNING: A copy of archive is already extracted"
fi


### COMPILE AND INSTALL ###
cd ${SRCdir}
make install PREFIX="${PREFIX}" &>> $LOG
mkdir -p "${PREFIX}/src"
cp -r ${SRCdir}/* "${PREFIX}/src"


### LINK ###
source ${SCRIPTPATH}/link
