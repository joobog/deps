#!/bin/bash

SCRIPT=$(readlink -f $0)
export SCRIPTPATH=`dirname ${SCRIPT}`

#source ${SCRIPTPATH}/precheck

module purge

export NAME="boost"
export MAJOR="1"
export MINOR="60"
export REVISION="0"
export VERSION="${MAJOR}_${MINOR}_${REVISION}"

source ${SCRIPTPATH}/config

SRCdir="${CACHEdir}/${NAME}_${VERSION}" 		# source directory

#export BZIP2_INCLUDE="${INSTALL_ROOT_DIR}/bzip2/include"
#export BZIP2_LIBRARY="${INSTALL_ROOT_DIR}/bzip2/lib"
#export BZIP2_BINARY="${INSTALL_ROOT_DIR}/bzip2/bin"
#export BZIP2_SOURCE="${INSTALL_ROOT_DIR}/bzip2/src"

#if [ ! -d ${BZIP2_INCLUDE} ]
#then
#  echo "${BZIP2_INCLUDE} not found"
#  exit 1;
#fi
#if [ ! -d ${BZIP2_LIB} ]
#then
#  echo "${BZIP2_LIB} not found"
#  exit 1;
#fi
#if [ ! -d ${BZIP2_BINARY} ]
#then
#  echo "${BZIP2_BINARY} not found"
#  exit 1;
#fi
#if [ ! -d ${BZIP2_SOURCE} ]
#then
#  echo "${BZIP2_SOURCE} not found"
#  exit 1;
#fi

#echo "boost bzlib2 include: ${BZLIB2_INCLUDE_DIR}"
#echo "boost bzlib2 lib: ${BZLIB2_LIBRARY_DIR}"
#echo "boost bzlib2 bin: ${BZLIB2_BINARY_DIR}"


FILE="${NAME}_${VERSION}.tar.bz2"
### FETCH ###
cd ${CACHEdir}
if [ ! -f "${FILE}" ] 
then
	wget "http://sourceforge.net/projects/boost/files/boost/${MAJOR}.${MINOR}.${REVISION}/${FILE}"
else
	echo "WARNING: ${FILE} already exists"
fi


### EXTRACT ###
if [ ! -d "${SRCdir}" ] 
then
	tar -xjvf "${CACHEdir}/${NAME}_${VERSION}.tar.bz2"
else
	echo "WARNING: A copy of archive is already extracted"
fi

### COMPILE AND INSTALL ###
cd ${SRCdir}
${SRCdir}/bootstrap.sh  --prefix=$PREFIX
${SRCdir}/b2 -j${THREAD_NUM}
${SRCdir}/b2 -j${THREAD_NUM} --build-type=complete \
	--with-atomic \
	--with-chrono \
	--with-container \
	--with-context \
	--with-coroutine \
	--with-coroutine2 \
	--with-date_time \
	--with-exception \
	--with-filesystem \
	--with-graph \
	--with-graph_parallel \
	--with-iostreams \
	--with-locale \
	--with-log \
	--with-math \
	--with-mpi \
	--with-program_options \
	--with-python \
	--with-random \
	--with-regex \
	--with-serialization \
	--with-signals \
	--with-system \
	--with-test \
	--with-thread \
	--with-timer \
	--with-type_erasure \
	--with-wave \
	--layout=tagged  \
	--prefix=${PREFIX} install


