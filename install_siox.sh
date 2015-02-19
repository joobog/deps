#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`

${SCRIPTPATH}/precheck

NAME="siox"
VERSION="dev"

source ${SCRIPTPATH}/config


### FETCH ###
if [ ! -d "${SRCdir}" ] 
then
	cd ${CACHEdir}
	git clone https://github.com/JulianKunkel/siox.git ${SRCdir} &>>${LOG} &>> "${LOG}"
else
	echo "WARNING: ${NAME}-${VERSION} is already downloaded"
fi

#### COMPILE AND INSTALL ###
${SRCdir}/configure --with-libpq=${INSTALL_ROOT_DIR}/postgresql --with-glib=${INSTALL_ROOT_DIR}/glib  --with-boost=${INSTALL_ROOT_DIR}/boost --prefix=${PREFIX} --build-dir=${BLDdir} --with-likwid=${INSTALL_ROOT_DIR}/likwid --build-wrappers &>> ${LOG}
cd "${BLDdir}" &>> "${LOG}"
make -j${THREAD_NUM} &>> "${LOG}"
make install &>> "${LOG}"


### LINK ###
source ${SCRIPTPATH}/link
