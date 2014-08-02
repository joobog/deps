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
PREFIX="${ROOTdir}/local"
SRCdir="${SCRIPTPATH}/bzip2-1.0.6"
LOG="${SCRIPTPATH}/install_bzip2.log"

echo "bzip2 root dir: ${ROOTdir}"
echo "bzip2 source dir: ${SRCdir}"
echo "bzip2 prefix: ${PREFIX}"
echo "bzip2 log: ${LOG}"

echo "" > "$LOG"

### EXTRACT ###

if [ -d "${PREFIX}" ] 
then
	echo "bzip2 is already installed"
	exit 0
else
	mkdir -p ${PREFIX}
fi

cd $SCRIPTPATH
if [ ! -e "${SCRIPTPATH}/boost_1_55_0.tar.bz2" ] 
then
	SOURCE="http://bzip.org/1.0.6/bzip2-1.0.6.tar.gz"
	wget $SOURCE
else
	echo "WARNING: Archive already exists"
fi

if [ ! -d "${SCRIPTPATH}" ] 
then
	gunzip "${SCRIPTPATH}/bzip2-1.0.6.tar.gz"
	tar -xvf "${SCRIPTPATH}/bzip2-1.0.6.tar"
else
	echo "WARNING: A copy of archive is already extracted"
fi

#### COMPILE ###
cd ${SRCdir}
make install PREFIX="${PREFIX}"
#cd ${SRCdir}
#${SRCdir}/bootstrap.sh --prefix=$PREFIX &>> $LOG
#${SRCdir}/b2 -j4 --build-type=complete --layout=tagged --prefix=${PREFIX} install &>> $LOG
