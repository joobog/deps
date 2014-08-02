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

PREFIX="${ROOTdir}/lib/bzip2_`date +%Y%m%d%H%M`"
CACHEdir="${SCRIPTPATH}/cache_bzip2"
SRCdir="${CACHEdir}/bzip2-1.0.6"
LOGfile="${CACHEdir}/log"
LINK="${ROOTdir}/lib/bzip2"

echo "bzip2 root dir: ${ROOTdir}"
echo "bzip2 cache dir: ${CACHEdir}"
echo "bzip2 source dir: ${SRCdir}"
echo "bzip2 prefix: ${PREFIX}"
echo "bzip2 log: ${LOGfile}"
echo "bzip2 link: ${LINK}"

echo "" > "$LOGfile"

### FETCH AND EXTRACT ###
if [ ! -d ${CACHEdir} ]
then
	mkdir -p ${CACHEdir}
fi

cd ${CACHEdir}
if [ ! -e "${CACHEdir}/bzip2-1.0.6.tar.bz2" ] 
then
	SOURCE="http://bzip.org/1.0.6/bzip2-1.0.6.tar.gz"
	wget $SOURCE &>> $LOGfile

else
	echo "WARNING: Archive already exists"
fi

if [ ! -d "${SRCdir}" ] 
then
	gunzip "${CACHEdir}/bzip2-1.0.6.tar.gz" &>> $LOGfile

	tar -xvf "${CACHEdir}/bzip2-1.0.6.tar" &>> $LOGfile

else
	echo "WARNING: A copy of archive is already extracted"
fi

### COMPILE AND INSTALL ###
cd ${SRCdir}
make install PREFIX="${PREFIX}" &>> $LOGfile
mkdir -p "${PREFIX}/src"
cp -r ${SRCdir}/* "${PREFIX}/src"

### LINK ###
cd "${ROOTdir}/lib"
if [ -d ${LINK} ]
then
	rm ${LINK}
fi

ln -s ${PREFIX} bzip2
