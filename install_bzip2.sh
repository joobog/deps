#!/bin/bash

SCRIPT=$(readlink -f $0)
export SCRIPTPATH=`dirname ${SCRIPT}`

${SCRIPTPATH}/precheck

export NAME="bzip2"
export VERSION="1.0.6"

source ${SCRIPTPATH}/config


### FETCH AND EXTRACT ###
if [ ! -d "${SRCdir}" ] 
then
	cd ${CACHEdir}
	wget "http://bzip.org/1.0.6/${NAME}-${VERSION}.tar.gz"

else
	echo "WARNING: ${NAME}-${VERSION} already exists"
fi


### EXTRACT ###
if [ ! -d "${SRCdir}" ] 
then
	gunzip "${CACHEdir}/bzip2-1.0.6.tar.gz" &>> $LOG
	tar -xvf "${CACHEdir}/bzip2-1.0.6.tar" &>> $LOG

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
