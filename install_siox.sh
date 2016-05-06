#!/bin/bash
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`

module purge
module load betke/glib/2.48.0
module load betke/openmpi/1.10.2
module load betke/boost/1_60_0
module load betke/hdf5/1.8.16
module load betke/netcdf/4.4.0

${SCRIPTPATH}/precheck

NAME="siox"
VERSION="git"
source ${SCRIPTPATH}/config
VERSION="$VERSION-${DATE}"
source ${SCRIPTPATH}/config


### FETCH ###
#if [ ! -d "${SRCdir}" ] 
#then
	cd ${CACHEdir}
	git clone https://github.com/JulianKunkel/siox.git ${SRCdir} 
#else
	#echo "WARNING: ${NAME}-${VERSION} is already downloaded"
#fi

### COMPILE AND INSTALL ###
${SRCdir}/configure \
	--with-libpq=${INSTALL_ROOT_DIR}/postgresql/9.1.15 \
	--with-glib=${INSTALL_ROOT_DIR}/glib/2.48.0  \
	--with-boost=${INSTALL_ROOT_DIR}/boost/1_60_0 \
	--prefix=${PREFIX} \
	--build-dir=${BLDdir} \
	--with-likwid=${INSTALL_ROOT_DIR}/likwid/3.1.3

cd "${BLDdir}"
make -j${THREAD_NUM}
make install

## INSTALL WRAPPERS ###
cd $SRCdir/tools/siox-skeleton-builder/layers/posix/
./waf configure --siox=${PREFIX}  --prefix=${PREFIX}
./waf install

cd $SRCdir/tools/siox-skeleton-builder/layers/mpi/
./waf configure --siox=${PREFIX}  --prefix=${PREFIX} --mpi-const
./waf install

cd $SRCdir/tools/siox-skeleton-builder/layers/hdf5/
./waf configure --siox=${PREFIX}  --prefix=${PREFIX} --hdf5="${INSTALL_ROOT_DIR}/hdf5/1.8.16"
./waf install

cd $SRCdir/tools/siox-skeleton-builder/layers/netcdf4/
./waf configure --siox=${PREFIX}  --prefix=${PREFIX} --netcdf=="${INSTALL_ROOT_DIR}/netcdf/4.4.0"
./waf install
