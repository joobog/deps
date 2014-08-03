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

PREFIX="${ROOTdir}/lib/muparser_`date +%Y%m%d%H%M`"
CACHEdir="${SCRIPTPATH}/cache_muparser"
SRCdir="${CACHEdir}/muparser_v2_2_3"
LOGfile="${CACHEdir}/log"
LINK="${ROOTdir}/lib/muparser"

echo "muparser root dir: ${ROOTdir}"
echo "muparser cache dir: ${CACHEdir}"
echo "muparser source dir: ${SRCdir}"
echo "muparser prefix: ${PREFIX}"
echo "muparser log: ${LOGfile}"
echo "muparser link: ${LINK}"

echo "" > "$LOGfile"

### FETCH AND EXTRACT ###
if [ ! -d ${CACHEdir} ]
then
	mkdir -p ${CACHEdir}
fi

cd ${CACHEdir}
if [ ! -e "${CACHEdir}/muparser_v2_2_3.zip" ] 
then
wget "https://doc-14-58-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/jr6bs5b2731i0ig1cd6s10neno49j4j7/1407067200000/10606444718388524723/*/0BzuB-ydOOoduZjlFOEFRREZrT2s?h=16653014193614665626&e=download" -O muparser_v2_2_3.zip
else
	echo "WARNING: Archive already exists"
fi

if [ ! -d "${SRCdir}" ] 
then
	mkdir -p ${SRCdir}
	unzip -x "${CACHEdir}/muparser_v2_2_3.zip" -d $CACHEdir  &>> $LOGfile
else
	echo "WARNING: A copy of archive is already extracted"
fi

cd $SRCdir
mkdir build
cd build
../configure --enable-shared=no --prefix=$PREFIX
make
make install

### COMPILE AND INSTALL ###

### LINK ###
cd "${ROOTdir}/lib"
if [ -d ${LINK} ]
then
	rm ${LINK}
fi

ln -s ${PREFIX} muparser
