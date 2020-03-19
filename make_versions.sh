#!/bin/sh

#########

if [[ $# -ne 1 ]]
then
   echo "$0 requires one argument"
   echo ""
   echo "   The argument is the prefix directory under"
   echo "   which are the etc/, bin/, include/, etc., "
   echo "   directories."
   exit 1
fi

PREFIX=$1
ETCDIR="$1/etc"

VERSION_RC_FILE="$ETCDIR/versions.rc"

if [[ -e $VERSION_RC_FILE ]]
then
   /bin/rm $VERSION_RC_FILE
fi

touch $VERSION_RC_FILE

echo_version () {
   echo "$1:$2 #Version Location: $3" >> $VERSION_RC_FILE
}

#########

ANTLR_VERSION_LOC="antlr/configure"
if [[ -e $ANTLR_VERSION_LOC ]]
then
   ANTLR_VERSION=$(awk -F= '/^PACKAGE_VERSION=/ {print $2}' $ANTLR_VERSION_LOC | sed "s/'//g")
   echo_version antlr "$ANTLR_VERSION" "$ANTLR_VERSION_LOC"
fi

GSL_VERSION_LOC="gsl/configure"
if [[ -e $GSL_VERSION_LOC ]]
then
   GSL_VERSION=$(awk -F= '/^PACKAGE_VERSION=/ {print $2}' $GSL_VERSION_LOC | sed "s/'//g")
   echo_version gsl "$GSL_VERSION" "$GSL_VERSION_LOC"
fi

JPEG_VERSION_LOC="jpeg/jversion.h"
if [[ -e $JPEG_VERSION_LOC ]]
then
   JPEG_VERSION=$(awk '/JVERSION/ {print $3, $4}' $JPEG_VERSION_LOC | sed 's/"//g')
   echo_version jpeg "$JPEG_VERSION" "$JPEG_VERSION_LOC"
fi

ZLIB_VERSION_LOC="zlib/zlib.h"
if [[ -e $ZLIB_VERSION_LOC ]]
then
   ZLIB_VERSION=$(awk '/#define ZLIB_VERSION/ {print $3}' $ZLIB_VERSION_LOC | sed 's/"//g')
   echo_version zlib "$ZLIB_VERSION" "$ZLIB_VERSION_LOC"
fi

SZLIB_VERSION_LOC="szlib/src/szlib.h"
if [[ -e $SZLIB_VERSION_LOC ]]
then
   SZLIB_VERSION=$(awk '/#define SZLIB_VERSION/ {print $3}' $SZLIB_VERSION_LOC | sed 's/"//g')
   echo_version szlib "$SZLIB_VERSION" "$SZLIB_VERSION_LOC"
fi

CURL_VERSION_LOC="curl/include/curl/curlver.h"
if [[ -e $CURL_VERSION_LOC ]]
then
   CURL_VERSION=$(awk '/#define LIBCURL_VERSION / {print $3}' $CURL_VERSION_LOC | sed 's/"//g')
   echo_version curl "$CURL_VERSION" "$CURL_VERSION_LOC"
fi

HDF4_VERSION_LOC="hdf4/README.txt"
if [[ -e $HDF4_VERSION_LOC ]]
then
   HDF4_VERSION=$(cat $HDF4_VERSION_LOC | head -1 | awk '{print $3}')
   echo_version hdf4 "$HDF4_VERSION" "$HDF4_VERSION_LOC"
fi

HDF5_VERSION_LOC="hdf5/README.txt"
if [[ -e $HDF5_VERSION_LOC ]]
then
   HDF5_VERSION=$(cat $HDF5_VERSION_LOC | head -1 | awk '{print $3}')
   echo_version hdf5 "$HDF5_VERSION" "$HDF5_VERSION_LOC"
fi

NETCDF_VERSION_LOC="netcdf/configure"
if [[ -e $NETCDF_VERSION_LOC ]]
then
   NETCDF_VERSION=$(awk -F= '/^PACKAGE_VERSION=/ {print $2}' $NETCDF_VERSION_LOC | sed "s/'//g")
   echo_version netcdf "$NETCDF_VERSION" "$NETCDF_VERSION_LOC"
fi

NETCDF_FORTRAN_VERSION_LOC="netcdf-fortran/configure"
if [[ -e $NETCDF_FORTRAN_VERSION_LOC ]]
then
   NETCDF_FORTRAN_VERSION=$(awk -F= '/^PACKAGE_VERSION=/ {print $2}' $NETCDF_FORTRAN_VERSION_LOC | sed "s/'//g")
   echo_version netcdf-fortran "$NETCDF_FORTRAN_VERSION" "$NETCDF_FORTRAN_VERSION_LOC"
fi

UDUNITS2_VERSION_LOC="udunits2/configure"
if [[ -e $UDUNITS2_VERSION_LOC ]]
then
   UDUNITS2_VERSION=$(awk -F= '/^PACKAGE_VERSION=/ {print $2}' $UDUNITS2_VERSION_LOC | sed "s/'//g")
   echo_version udunits2 "$UDUNITS2_VERSION" "$UDUNITS2_VERSION_LOC"
fi

NCO_VERSION_LOC="nco/doc/VERSION"
if [[ -e $NCO_VERSION_LOC ]]
then
   NCO_VERSION=$(cat ${NCO_VERSION_LOC})
   echo_version nco "$NCO_VERSION" "$NCO_VERSION_LOC"
fi

CDO_VERSION_LOC="cdo/configure"
if [[ -e $CDO_VERSION_LOC ]]
then
   CDO_VERSION=$(awk -F= '/^PACKAGE_VERSION=/ {print $2}' $CDO_VERSION_LOC | sed "s/'//g")
   echo_version cdo "$CDO_VERSION" "$CDO_VERSION_LOC"
fi

NCCMP_VERSION_LOC="nccmp/configure"
if [[ -e $NCCMP_VERSION_LOC ]]
then
   NCCMP_VERSION=$(awk -F= '/^PACKAGE_VERSION=/ {print $2}' $NCCMP_VERSION_LOC | sed "s/'//g")
   echo_version nccmp "$NCCMP_VERSION" "$NCCMP_VERSION_LOC"
fi

ESMF_VERSION_LOC="esmf/src/Infrastructure/Util/include/ESMC_Macros.h"
if [[ -e $ESMF_VERSION_LOC ]]
then
   ESMF_VERSION=$(awk '/ESMF_VERSION_STRING/ {print $3}' $ESMF_VERSION_LOC | sed 's/"//g')
   echo_version esmf "$ESMF_VERSION" "$ESMF_VERSION_LOC"
fi

PFUNIT_VERSION_LOC="pFUnit/CMakeLists.txt"
if [[ -e $PFUNIT_VERSION_LOC ]]
then
   PFUNIT_VERSION=$(grep -m1 '^ *VERSION' ${PFUNIT_VERSION_LOC} | awk '{print $2}')
   echo_version pFUnit "$PFUNIT_VERSION" "$PFUNIT_VERSION_LOC"
fi

GFTL_VERSION_LOC="gFTL/CMakeLists.txt"
if [[ -e $GFTL_VERSION_LOC ]]
then
   GFTL_VERSION=$(grep -m1 '^ *VERSION' ${GFTL_VERSION_LOC} | awk '{print $2}')
   echo_version gFTL "$GFTL_VERSION" "$GFTL_VERSION_LOC"
fi

GFTL_SHARED_VERSION_LOC="gFTL-shared/CMakeLists.txt"
if [[ -e $GFTL_SHARED_VERSION_LOC ]]
then
   GFTL_SHARED_VERSION=$(grep -m1 '^ *VERSION' ${GFTL_SHARED_VERSION_LOC} | awk '{print $2}')
   echo_version gFTL-shared "$GFTL_SHARED_VERSION" "$GFTL_SHARED_VERSION_LOC"
fi

PFLOGGER_VERSION_LOC="pFlogger/CMakeLists.txt"
if [[ -e $PFLOGGER_VERSION_LOC ]]
then
   PFLOGGER_VERSION=$(grep -m1 '^ *VERSION' ${PFLOGGER_VERSION_LOC} | awk '{print $2}')
   echo_version pFlogger "$PFLOGGER_VERSION" "$PFLOGGER_VERSION_LOC"
fi

YAFYAML_VERSION_LOC="yaFyaml/CMakeLists.txt"
if [[ -e $YAFYAML_VERSION_LOC ]]
then
   YAFYAML_VERSION=$(grep -m1 '^ *VERSION' ${YAFYAML_VERSION_LOC} | awk '{print $2}')
   echo_version yaFyaml "$YAFYAML_VERSION" "$YAFYAML_VERSION_LOC"
fi

FARGPARSE_VERSION_LOC="fArgParse/CMakeLists.txt"
if [[ -e $FARGPARSE_VERSION_LOC ]]
then
   FARGPARSE_VERSION=$(grep -m1 '^ *VERSION' ${FARGPARSE_VERSION_LOC} | awk '{print $2}')
   echo_version fArgParse "$FARGPARSE_VERSION" "$FARGPARSE_VERSION_LOC"
fi

FLAP_VERSION_LOC="FLAP/README.md"
if [[ -e $FLAP_VERSION_LOC ]]
then
   FLAP_VERSION=$(grep '^ *version' ${FLAP_VERSION_LOC} | awk '{print $3}' | sed "s/'//g")
   echo_version FLAP "$FLAP_VERSION" "$FLAP_VERSION_LOC"
fi

HDFEOS_VERSION_LOC="hdfeos/src/EHapi.c"
if [[ -e $HDFEOS_VERSION_LOC ]]
then
   HDFEOS_VERSION=$(awk '/HDFEOSVERSION1/ {print $3}' $HDFEOS_VERSION_LOC | sed 's/"//g')
   echo_version hdfeos "$HDFEOS_VERSION" "$HDFEOS_VERSION_LOC"
fi

HDFEOS5_VERSION_LOC="hdfeos5/include/HE5_HdfEosDef.h"
if [[ -e $HDFEOS5_VERSION_LOC ]]
then
   HDFEOS5_VERSION=$(awk '/HE5_HDFEOSVERSION/ {print $3}' $HDFEOS5_VERSION_LOC | sed 's/"//g')
   echo_version hdfeos5 "$HDFEOS5_VERSION" "$HDFEOS5_VERSION_LOC"
fi

SDPTK_VERSION_LOC="SDPToolkit/include/PGS_SMF.h"
if [[ -e $SDPTK_VERSION_LOC ]]
then
   SDPTK_VERSION=$(awk '/define PGSd_TOOLKIT_MAJOR_VERSION/ {print $3}' $SDPTK_VERSION_LOC | sed 's/"//g')
   echo_version SDPToolkit "$SDPTK_VERSION" "$SDPTK_VERSION_LOC"
fi
