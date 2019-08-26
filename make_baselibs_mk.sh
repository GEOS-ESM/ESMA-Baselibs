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

BASELIBS_MK_FILE="$ETCDIR/baselibs.mk"
VERSIONS_FILE="$ETCDIR/versions.rc"

if [[ -e $BASELIBS_MK_FILE ]]
then
   /bin/rm $BASELIBS_MK_FILE
fi

touch $BASELIBS_MK_FILE

echo_version () {
   echo "$1:$2 #Version Location: $3" >> $BASELIBS_MK_FILE
}

to_lowercase () {
   echo "$1" | tr '[:upper:]' '[:lower:]'
}

to_uppercase () {
   echo "$1" | tr '[:lower:]' '[:upper:]'
}

ALLDIRS=(gFTL gFTL-shared fArgParse)

#echo "# Baselibs: $PREFIX" >> $BASELIBS_MK_FILE
#echo "" >> $BASELIBS_MK_FILE

for library in "${ALLDIRS[@]}"
do

   # First we need to construct the library name with underscores
   # instead of dashes
   CAP_LIB=$( to_uppercase $library )
   CAP_LIB_NO_DASH=$( echo $CAP_LIB | sed -e 's/-/_/g' )

   # Now grab the version number in versions.rc 
   # Need to strip spaces with gsub below
   LIB_FULL_VER=$( grep -m1 $library $VERSIONS_FILE | awk -F '[:#]' '{gsub(/ /,"",$0);print $2}' )

   # The libraries now seem to only use major and minor
   LIB_VER=$( echo $LIB_FULL_VER | awk -F '.' '{print $1 FS $2}' )

   # Construct the library directory name
   LIB_DIR_NAME="${CAP_LIB_NO_DASH}-${LIB_VER}"

   # Include directory
   LIB_INC_DIR=$PREFIX/$LIB_DIR_NAME/include

   # Library directory
   LIB_LIB_DIR=$PREFIX/$LIB_DIR_NAME/lib

   if [[ -d $LIB_INC_DIR || -d $LIB_LIB_DIR ]]
   then
      echo "# Library: $library" >> $BASELIBS_MK_FILE
   fi

   if [[ -d $LIB_INC_DIR ]]
   then
      echo "INC_${CAP_LIB_NO_DASH} := $LIB_INC_DIR" >> $BASELIBS_MK_FILE
   fi

   # NOTE: This is very fragile as it assumes only one library created
   #       which might not be true. Probably true, but not required.
   #       and it says nothing about .so!
   if [[ -d $LIB_LIB_DIR ]]
   then
      LIB_LIB_NAME=$(find ${LIB_LIB_DIR} -name '*.a')
      echo "LIB_${CAP_LIB_NO_DASH} := $LIB_LIB_NAME" >> $BASELIBS_MK_FILE
   fi
done


exit
