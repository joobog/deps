#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`
LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${SCRIPTPATH}/.."

ARCHIVE=$(readlink -f $1)
ARCHIVEBASE=$(basename $ARCHIVE)
ARCHIVEPATH=$(dirname ${ARCHIVE})

echo "archive: ${ARCHIVE}"
echo "archive base: ${ARCHIVEBASE}"
echo "archive path: ${ARCHIVEPATH}"

ROOTdir="/scratch/mpi/CIS/m215026"

# source location
SRCdir=${ROOTdir}/lib_src/ATLAS
# build location
BLDdir=${SRCdir}/build
# install location
PREFIX=${ROOTdir}/lib/atlas
rm -r ${PREFIX}
mkdir -p ${PREFIX}

echo "atlas source dir: $SRCdir"
echo "atlas build dir: $BLDdir"
echo "atlas prefix: $PREFIX"

# bunzip2 -c ${ARCHIVE} | tar -xf -
mv ATLAS ${SRCdir}
mkdir -p ${BLDdir}
cd ${BLDdir}
$SRCdir/configure -b 64 --prefix=${PREFIX}
make build -j4
make check -j4
make ptchec -j4
make time -j4
make install

# cleanup
rm -r ${SRCdir}
