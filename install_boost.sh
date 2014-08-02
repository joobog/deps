#!/bin/bash

#if hash module 2>/dev/null
#then
	#echo "load gcc 4.8.2"
	#module unload gcc
	#module load gcc >/dev/null 2>&1 || { echo >&2 "module gcc/4.8.2 doesn't exists"; }
#else
	#echo true
#fi


### PATHS AND FILES ###
echo "Generate paths"
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`
cd "$SCRIPTPATH/.."
ROOTdir="$PWD"
PREFIX="${ROOTdir}/lib/boost"
SRCdir="${SCRIPTPATH}/boost_1_55_0"
LOG="${SCRIPTPATH}/install_boost.log"
export BZIP2_INCLUDE="${ROOTdir}/local/include"
export BZIP2_LIBRARY="${ROOTdir}/local/lib"
export BZIP2_BINARY="${ROOTdir}/local/bin"
export BZIP2_SOURCE="${ROOTdir}/lib_src/bzip2-1.0.6"

if [ ! -d ${BZIP2_INCLUDE} ]
then
	echo "${BZIP2_INCLUDE} not found"
	exit 1;
fi
if [ ! -d ${BZIP2_LIB} ]
then
	echo "${BZIP2_LIB} not found"
	exit 1;
fi
if [ ! -d ${BZIP2_BINARY} ]
then
	echo "${BZIP2_BINARY} not found"
	exit 1;
fi
if [ ! -d ${BZIP2_SOURCE} ]
then
	echo "${BZIP2_SOURCE} not found"
	exit 1;
fi


echo "boost root dir: ${ROOTdir}"
echo "boost source dir: ${SRCdir}"
echo "boost prefix: ${PREFIX}"
echo "boost log: ${LOG}"

echo "boost bzlib2 include: ${BZLIB2_INCLUDE_DIR}"
echo "boost bzlib2 lib: ${BZLIB2_LIBRARY_DIR}"
echo "boost bzlib2 bin: ${BZLIB2_BINARY_DIR}"

echo "" > "$LOG"

### EXTRACT ###
if [ -d "${PREFIX}" ] 
then
	echo "boost is already installed"
	#exit 0
else
	mkdir -p ${PREFIX}
fi

cd $SCRIPTPATH
if [ ! -e "${SCRIPTPATH}/boost_1_55_0.tar.bz2" ] 
then
	SOURCE="http://sourceforge.net/projects/boost/files/boost/1.55.0/boost_1_55_0.tar.bz2"
	wget $SOURCE
else
	echo "WARNING: Archive already exists"
fi

if [ ! -d "${SRCdir}" ] 
then
	bunzip2 "${SCRIPTPATH}/boost_1_55_0.tar.bz2" 
	tar -xvf "${SCRIPTPATH}/boost_1_55_0.tar"
else
	echo "WARNING: A copy of archive is already extracted"
fi

### COMPILE ###
cd ${SRCdir}
#${SRCdir}/bootstrap.sh --includedir="${BZLIB2_INCLUDE_DIR}" --libdir="${BZLIB2_LIBRARY_DIR}" --prefix=$PREFIX &>> $LOG
#${SRCdir}/b2 -j4 --build-type=complete --layout=tagged --includedir="${BZLIB2_INCLUDE_DIR}" --libdir="${BZLIB2_LIBRARY_DIR}" --prefix=${PREFIX} install &>> $LOG
${SRCdir}/bootstrap.sh  --prefix=$PREFIX &>> $LOG

${SRCdir}/b2 -j8 &>> $LOG
${SRCdir}/b2 -j8 --build-type=complete --layout=tagged --prefix=${PREFIX} install &>> $LOG
