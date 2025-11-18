#!/bin/bash -f

# --------------
# MAIN VARIABLES
# --------------

package_name='cdo'
tarball='cdo-2.5.4.tar.gz'
# NOTE NOTE The last node of this URL changes with each new version
base_url='https://code.mpimet.mpg.de/attachments/download/30128/'

export LMOD_SH_DBG_ON=0

# From http://stackoverflow.com/a/246128/1876449
# ----------------------------------------------
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
MAINDIR=$(dirname $SCRIPTDIR)

cd $SCRIPTDIR

# -----------------
# Detect usual bits
# -----------------

ARCH=$(uname -s)
MACH=$(uname -m)
NODE=$(uname -n)

case $ARCH in
   "Darwin")
      checksum='shasum -a 512 --check'
   ;;
   *)
      checksum='sha512sum -c'
   ;;
esac
sumfile=$SCRIPTDIR/${package_name}.sha512

if type curl > /dev/null ; then
  fetch='curl --output'
else
  fetch='wget -O'
fi

# ---------------
# Get the tarball
# ---------------
if [[ ! -f ${SCRIPTDIR}/${tarball} ]]
then
   $fetch $SCRIPTDIR/${tarball} ${base_url}${tarball}
fi

# ------------------
# Verify the tarball
# ------------------
$checksum $CURRDIR/$sumfile > /dev/null
retval=$?
if [[ $retval != 0 ]]
then
   echo "ERROR! Checksum for $tarball bad!"
   exit 1
fi

# ----------------
# Extract and link
# ----------------

# Get the name of the directory the tar command will make
tar_dir_name=$(tar tzf $SCRIPTDIR/$tarball | head -1 | cut -f1 -d"/")

# Untar to MAINDIR
if [[ ! -d $MAINDIR/$tar_dir_name ]]
then
   tar xf $SCRIPTDIR/$tarball -C $MAINDIR
fi

# Link untarred source to the name Baselibs expects

if [[ ! -L $MAINDIR/$package_name ]]
then
   if [[ ! -e $MAINDIR/$package_name ]]
   then
      cd $MAINDIR
      ln -s $tar_dir_name $package_name
   else
      echo "If you got here, this means you have a broken symlink, I think"
      exit 1
   fi
fi

exit 0
