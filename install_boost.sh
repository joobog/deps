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
CACHEdir="${SCRIPTPATH}/cache_boost"
PREFIX="${ROOTdir}/lib/boost_`date +%Y%m%d%H%M`"
SRCdir="${CACHEdir}/boost_1_55_0"
LOG="${CACHEdir}/log"
export BZIP2_INCLUDE="${ROOTdir}/lib/bzip2/include"
export BZIP2_LIBRARY="${ROOTdir}/lib/bzip2/lib"
export BZIP2_BINARY="${ROOTdir}/lib/bzip2/bin"
export BZIP2_SOURCE="${ROOTdir}/lib/bzip2/src"

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
echo "boost cache dir: ${CACHEdir}"
echo "boost source dir: ${SRCdir}"
echo "boost prefix: ${PREFIX}"
echo "boost log: ${LOG}"

echo "boost bzlib2 include: ${BZLIB2_INCLUDE_DIR}"
echo "boost bzlib2 lib: ${BZLIB2_LIBRARY_DIR}"
echo "boost bzlib2 bin: ${BZLIB2_BINARY_DIR}"

echo "" > "$LOG"

### EXTRACT ###
if [ ! -d ${CACHEdir} ]
then 
	mkdir -p ${CACHEdir}
fi

cd ${CACHEdir}
if [ ! -e "${CACHEdir}/boost_1_55_0" ] 
then
	SOURCE="http://sourceforge.net/projects/boost/files/boost/1.55.0/boost_1_55_0.tar.bz2"
	wget $SOURCE
else
	echo "WARNING: Archive already exists"
fi

if [ ! -d "${SRCdir}" ] 
then
	bunzip2 "${CACHEdir}/boost_1_55_0.tar.bz2"  &>> $LOG
	tar -xvf "${CACHEdir}/boost_1_55_0.tar" &>> $LOG
else
	echo "WARNING: A copy of archive is already extracted"
fi

### COMPILE ###
cd ${SRCdir}

#${SRCdir}/bootstrap.sh  --prefix=$PREFIX --with-mpi &>> $LOG
#${SRCdir}/b2 -j8 --with-mpi &>> $LOG
#${SRCdir}/b2 -j8 --build-type=complete --layout=tagged --with-mpi --prefix=${PREFIX} install &>> $LOG

${SRCdir}/bootstrap.sh  --prefix=$PREFIX  &>> $LOG
${SRCdir}/b2 -j16  &>> $LOG
${SRCdir}/b2 -j16 --build-type=complete --layout=tagged  --prefix=${PREFIX} install &>> $LOG
### LINK ###

cd "${ROOTdir}/lib"

if [ -d "${ROOTdir}/lib/boost" ]
then
	rm "${ROOTdir}/lib/boost"
fi
ln -s ${PREFIX} boost

