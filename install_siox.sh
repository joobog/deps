#!/bin/bash

# squeeze
# CFLAGS += -static-libstdc++
# CPPFLAGS += -static-libstdc++
# Comment "find libpq and libpqxx" in CMakeLists.txt

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
	git clone https://github.com/JulianKunkel/siox.git ${SRCdir}
else
	echo "WARNING: ${NAME}-${VERSION} is already downloaded"
fi

#### COMPILE AND INSTALL ###
#${SRCdir}/configure --with-libpq=${INSTALL_ROOT_DIR}/postgresql --with-glib=${INSTALL_ROOT_DIR}/glib  --with-boost=${INSTALL_ROOT_DIR}/boost --prefix=${PREFIX} --build-dir=${BLDdir} --with-likwid=${INSTALL_ROOT_DIR}/likwid --build-wrappers &>> ${LOG}

#${SRCdir}/configure --with-libpq=${INSTALL_ROOT_DIR}/postgresql --with-glib=${INSTALL_ROOT_DIR}/glib  --with-boost=${INSTALL_ROOT_DIR}/boost --prefix=${PREFIX} --build-dir=${BLDdir} --with-likwid=${INSTALL_ROOT_DIR}/likwid --debug --build-wrappers 
set -x
#export PostgreSQL_LIBRARY=${INSTALL_ROOT_DIR}/postgresql/lib/libpq.so
${SRCdir}/configure --with-libpqxx=${INSTALL_ROOT_DIR}/libpqxx --with-libpq=${INSTALL_ROOT_DIR}/postgresql --with-glib=${INSTALL_ROOT_DIR}/glib  --with-boost=${INSTALL_ROOT_DIR}/boost --prefix=${PREFIX} --build-dir=${BLDdir} --debug --build-wrappers 
set +x

cd "${BLDdir}"
make -j${THREAD_NUM}
make install


### LINK ###
source ${SCRIPTPATH}/link
