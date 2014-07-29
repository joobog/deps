#!/bin/bash

if hash module 2>/dev/null; then
	echo "load gcc 4.8.2"
	module load gcc/4.8.2
else
	true
fi

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`
LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${SCRIPTPATH}/.."

ROOTdir="/scratch/mpi/CIS/m215026"

# bunzip2 -c ${ARCHIVE} | tar -C ${ROOTdir}/lib_src/boost_1_55_0 -xf -
PREFIX="${ROOTdir}/lib/boost"
SRCdir=${ROOTdir}/lib_src/boost_1_55_0

LOG=boost_1_55_0_install.log
cd ${SRCdir}
${SRCdir}/bootstrap.sh --prefix=$PREFIX > $LOG
${SRCdir}/b2 -j4 --build-type=complete --layout=tagged --prefix=${PREFIX} install >> $LOG
