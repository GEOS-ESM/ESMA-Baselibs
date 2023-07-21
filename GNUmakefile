#
# RecursiveGNU makefile for Baselibs.
#
# NOTE: If you would like to add new packages, look at module
#       supplibs under the opengrads CVS repository on sourceforge:
#
#            http://sourceforge.net/cvs/?group_id=161773
#
# Packages such as NetCDF-4, HDF-5 and OPeNDAP have already been implemented
# there in a structure very similar to this one.
#
# !REVISION HISTORY:
#
#  25Jul2007  da Silva  First implementation
#  11Aug2008  da Silva  Aded Base.mk/Arch.mk to simplify CM.
#
#-------------------------------------------------------------------------

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))
MKFILE_DIRNAME := $(shell basename $(MKFILE_DIR))

PACKAGE = ESMA-Baselibs
VERSION = $(shell cat VERSION)
DATE = $(shell date +"%Y%b%d")
RELEASE_DIR = $(shell dirname $(MKFILE_DIR))
RELEASE_FILE = $(MKFILE_DIRNAME)-$(DATE)

# System dependent defauls
# ------------------------
  include Base.mk
  include Arch.mk
  include baselibs-config.mk

# Use these in recursive Makefiles
# --------------------------------
  export prefix
  export CC CXX F77 F90 FC MPICC MPICXX MPIFC ES_CC ES_CXX ES_FC
  export ESMF_COMM ESMF_DIR ESMF_OS

# When HDF-5 is available, build NetCDF-4 with it,
# otherwise perform a vanilla NetCDF-4 build
# -----------------------------------------------
  NC_LIBS = -lm
  NC_CC  = $(CC)
  NC_CXX = $(CXX)
  NC_FC  = $(FC)
  NC_F77 = $(FC)
  H4_CC  = $(prefix)/bin/h4cc-hdf4
  H4_FC  = $(prefix)/bin/h4fc-hdf4
  H5_PARALLEL=--enable-parallel
  ifeq ($(ESMF_COMM),mpiuni)
     H5_PARALLEL=--disable-parallel
  endif
  INC_HDF5 = $(prefix)/include/hdf5
  LIB_HDF5 = $(wildcard $(foreach lib, hdf5_hl hdf5 z sz,\
     $(prefix)/lib/lib$(lib).a) )
  NC_ENABLE_HDF5 = --enable-netcdf-4 --with-hdf5=$(prefix)
  NC_LIBS = $(LIB_HDF5) $(LINK_GPFS) -lm
  ifeq ($(H5_PARALLEL),--enable-parallel)
     NC_CC  = $(MPICC)
     NC_FC  = $(MPIFC)
     NC_F77 = $(MPIFC)
     NC_CXX = $(MPICXX)
     NC_PAR_TESTS = --enable-parallel-tests
     H5_CC  = $(prefix)/bin/h5pcc
     H5_FC  = $(prefix)/bin/h5pfc
  endif

  ifeq ($(H5_PARALLEL),--disable-parallel)
     H5_CC  = $(prefix)/bin/h5cc
     H5_FC  = $(prefix)/bin/h5fc
  endif

# Issue with NCO and nccmp with mpiuni and gcc
# --------------------------------------------

  ifeq ($(findstring gcc,$(notdir $(CC))),gcc)
    ifeq ($(ESMF_COMM),mpiuni)
      PTHREAD_FLAG = -pthread
    endif
  endif

# Testing with MVAPICH2 and ifort showed this flag was needed
# -----------------------------------------------------------
#
  ifeq ($(findstring ifort,$(notdir $(FC))),ifort)
    ifeq ($(ESMF_COMM),mvapich2)
      PTHREAD_FLAG = -pthread
    endif
  endif

# netCDF has an issue with Intel 15+. It must be compiled with -g -O0 to
# avoid the problem (which manifests as a crash in ESMF_cfio where in a
# FPE is thrown in an NF90_DEF_VAR for time!).
# ----------------------------------------------------------------------

  ifeq ($(findstring ifort,$(notdir $(FC))),ifort)
     NC_CFLAGS = -g -O0
  endif

# HDF5, MVAPICH2 2.1rc1 (at least), and SLES 11 SP3 have an issue. Aaron
# Knister of NCCS determined that:
#
#    If you set the environment variable RTLD_DEEPBIND to 0 then the
#    segfault disappears. I'm trying to better understand this, but works by
#    altering the behaviour of glibc when loading NSS modules. The symbol
#    resolution order seems to change with it set (for the better in this
#    case).
#
# So, we test if we are using mvapich2 and are on SP3.
# ---------------------------------------------------------------------

  ifeq ($(ESMF_COMM), mvapich2)
    IS_SLES11_SP3 = $(shell cat /etc/SuSE-release | awk '/PATCH/ {print $3}')
       ifeq ($(findstring 3, $(IS_SLES11_SP3)), 3)
          HDF5_DEEPBIND = "export RTLD_DEEPBIND=0"
       endif
  endif

# PGI 17.7+ has issues with ncap2. To correct,
# pass in -gopt -O2 instead of the usual -g -O2
# ---------------------------------------------
  NCO_CXXFLAGS = -g -O2
  ifeq ($(findstring pgfortran,$(notdir $(FC))),pgfortran)
     NCO_CXXFLAGS = -gopt -O2
  endif

# From Tom Clune: NAG is different. It has a different version and FPIC
# flag. It also needs extra flags to compile code that is not as string
# as it would like.
# ---------------------------------------------------------------------
  FORTRAN_FPIC := -fPIC
  FORTRAN_VERSION := --version
  HDF5_ENABLE_F2003 := --enable-fortran2003
  ifeq ($(findstring nagfor,$(notdir $(FC))),nagfor)
     FORTRAN_FPIC := -PIC
     FORTRAN_VERSION := -V
     NAG_FCFLAGS := -fpp -mismatch_all
     NAG_DUSTY := -dusty
  endif

# Building with PGI on Darwin (Community Edition) does not quite work.
# Fixes are needed. NDEBUG from netcdf list
# -------------------------------------------------------------------

  ifeq ($(findstring pgfortran,$(notdir $(FC))),pgfortran)
     ifeq ($(ARCH),Darwin)
        NC_CPPFLAGS = -DNDEBUG
        FORTRAN_FPIC = -fpic
     endif
  endif

# HDF4 and netCDF-Fortran has a bug with GCC 10.1
# -----------------------------------------------

  ifeq ($(findstring gfortran,$(notdir $(FC))),gfortran)
     GFORTRAN_VERSION_GTE_10 := $(shell expr `$(FC) -dumpversion | cut -f1 -d.` \>= 10)
     export GFORTRAN_VERSION_GTE_10
     ifeq ($(GFORTRAN_VERSION_GTE_10),1)
        ALLOW_ARGUMENT_MISMATCH := -fallow-argument-mismatch
        ALLOW_INVALID_BOZ := -fallow-invalid-boz
        COMMON_FLAG := -fcommon
        export ALLOW_ARGUMENT_MISMATCH ALLOW_INVALID_BOZ
        CMAKE_ALLOW_ARGUMENT_MISMATCH := "-DCMAKE_Fortran_FLAGS='$(ALLOW_ARGUMENT_MISMATCH)'"
        export CMAKE_ALLOW_ARGUMENT_MISMATCH
     endif
  endif

# Clang has issues with some libraries due to strict C99
# ------------------------------------------------------

  ifeq ($(CC_IS_CLANG),TRUE)
     NO_IMPLICIT_FUNCTION_ERROR := -Wno-error=implicit-function-declaration
     export NO_IMPLICIT_FUNCTION_ERROR

     ifeq ($(ARCH),Darwin)
        # There is an issue with clang and curl, need to pass in a macos version min
        MACOS_VERSION := $(shell sw_vers -productVersion | awk -F . '{print $$1 "." $$2}')
        export MACOS_VERSION
        MMACOS_MIN := -mmacosx-version-min=$(MACOS_VERSION)
        export MMACOS_MIN

        # There is an issue with clang++ and cdo
        CLANG_STDC17 := -std=c++17
        export CLANG_STDC17
     endif
  endif

# HDF5 and MPT at NCCS have an "issue" that needs an extra flag
# -------------------------------------------------------------

  ifeq ($(SITE),NCCS)
    ifeq ($(ESMF_COMM),mpt)
       HDF5_NCCS_MPT_CFLAG := -Wno-error=redundant-decls
    endif
  endif

# Intel C on Darwin needs extra CFLAGS
# http://intel.ly/3ioNecp
# ------------------------------------

  ifeq ($(findstring icc,$(notdir $(CC))),icc)
     ifeq ($(ARCH),Darwin)
        CFLAGS += -diag-error=147 -stdlib=libc++
        export CFLAGS
     endif
  endif

# cURL is now more complicated with SSL
# -------------------------------------

  ifeq ($(ARCH),Linux)
    # On Linux, assume standard OpenSSL (works at NCCS, NAS, GMAO)
    CURL_SSL := --with-openssl
    export CURL_SSL
  endif

  ifeq ($(ARCH),Darwin)
    # On Darwin, you can't assume an Open SSL exists
    ifeq ($(CC_IS_CLANG),TRUE)
      # If we are using Clang we can use SecureTransport
      CURL_SSL := --with-secure-transport
      export CURL_SSL

      DARWIN_ST_LIBS := -framework CoreFoundation -framework SystemConfiguration -framework Security
      export DARWIN_ST_LIBS
    else
      # There is a bug with gcc and Apple Security Framework:
      # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=93082
      # so we don't do SSL
      CURL_SSL := --without-ssl
      export CURL_SSL

      DARWIN_ST_LIBS := -framework CoreFoundation -framework SystemConfiguration
      export DARWIN_ST_LIBS
    endif
  endif

#-------------------------------------------------------------------------

#                  --------------------------------
#                   Recurse Make in Sub-directories
#                  --------------------------------

ALLDIRS = antlr2 gsl jpeg zlib szlib curl hdf4 hdf5 netcdf netcdf-fortran netcdf-cxx4 \
          udunits2 nco cdo nccmp libyaml FMS esmf xgboost \
          GFE \
          FLAP hdfeos hdfeos5 SDPToolkit

GFE_DIRS = GFE

ESSENTIAL_DIRS = jpeg zlib szlib hdf4 hdf5 netcdf netcdf-fortran libyaml FMS esmf xgboost \
                 $(GFE_DIRS) FLAP

ifeq ($(ARCH),Darwin)
   NO_DARWIN_DIRS = netcdf-cxx4 hdfeos hdfeos5 SDPToolkit
   ALLDIRS := $(filter-out $(NO_DARWIN_DIRS),$(ALLDIRS))
endif

# NAG cannot build cdo
#    https://code.mpimet.mpg.de/boards/1/topics/9337
# or FMS due to cray pointers
ifeq ($(findstring nagfor,$(notdir $(FC))),nagfor)
   NO_NAG_DIRS = cdo FMS
   ALLDIRS := $(filter-out $(NO_NAG_DIRS),$(ALLDIRS))
   ESSENTIAL_DIRS := $(filter-out $(NO_NAG_DIRS),$(ESSENTIAL_DIRS))
endif

# NVHPC seems to have issues with SDPToolkit
ifeq ($(findstring nvfortran,$(notdir $(FC))),nvfortran)
   NO_NVHPC_DIRS = SDPToolkit
   ALLDIRS := $(filter-out $(NO_NVHPC_DIRS),$(ALLDIRS))
endif

ifeq ($(MACH),aarch64)
   NO_ARM_DIRS = hdf4 hdfeos hdfeos5 SDPToolkit
   ALLDIRS := $(filter-out $(NO_ARM_DIRS),$(ALLDIRS))
   ESSENTIAL_DIRS := $(filter-out hdf4,$(ESSENTIAL_DIRS))
endif

ifeq ('$(BUILD)','ESSENTIALS')
SUBDIRS = $(ESSENTIAL_DIRS)
INC_SUPP :=  $(foreach subdir, \
            / /zlib /szlib /jpeg /hdf5 /hdf /netcdf,\
            -I$(prefix)/include$(subdir) $(INC_EXTRA) )
else
ifeq ('$(BUILD)','GFE')
SUBDIRS = $(GFE_DIRS)
else
SUBDIRS = $(ALLDIRS)
INC_SUPP :=  $(foreach subdir, \
            / /zlib /szlib /jpeg /hdf5 /hdf /netcdf /udunits2 /gsl /antlr2,\
            -I$(prefix)/include$(subdir) $(INC_EXTRA) )
endif
endif

ifeq ($(findstring hdf4,$(SUBDIRS)),hdf4)
   ENABLE_HDF4 = --enable-hdf4
   LIB_HDF4 = -lmfhdf -ldf
else
   ENABLE_HDF4 = --disable-hdf4
   LIB_HDF4 =
   # Also need to remove hdfeos if no hdf4
   SUBDIRS := $(filter-out hdfeos,$(SUBDIRS))
endif

TARGETS = all lib install

download: gsl.download szlib.download cdo.download hdfeos.download hdfeos5.download SDPToolkit.download

dist: download
	tar -czf $(RELEASE_DIR)/$(RELEASE_FILE).tar.gz -C $(RELEASE_DIR) $(MKFILE_DIRNAME)

verify:
	@echo MKFILE_PATH = $(MKFILE_PATH)
	@echo MKFILE_DIR = $(MKFILE_DIR)
	@echo MKFILE_DIRNAME = $(MKFILE_DIRNAME)
	@echo SUBDIRS = $(SUBDIRS)
	@echo BUILD_DAP = $(BUILD_DAP)
	@echo GFORTRAN_VERSION_GTE_10 = $(GFORTRAN_VERSION_GTE_10)
	@echo MACOS_VERSION = $(MACOS_VERSION)
	@echo MMACOS_MIN = $(MMACOS_MIN)
	@echo ALLOW_ARGUMENT_MISMATCH = $(ALLOW_ARGUMENT_MISMATCH)
	@echo CMAKE_ALLOW_ARGUMENT_MISMATCH = $(CMAKE_ALLOW_ARGUMENT_MISMATCH)
	@echo CC_IS_CLANG = $(CC_IS_CLANG)
	@echo NO_IMPLICIT_FUNCTION_ERROR = $(NO_IMPLICIT_FUNCTION_ERROR)
	@echo NAG_FCFLAGS = $(NAG_FCFLAGS)
	@echo FC_FROM_ENV = $(FC_FROM_ENV)
	@echo CC_FROM_ENV = $(CC_FROM_ENV)
	@echo CXX_FROM_ENV = $(CXX_FROM_ENV)
	@echo FC = $(FC)
	@echo CC = $(CC)
	@echo CXX = $(CXX)
	@echo MPIFC = $(MPIFC)
	@echo MPICC = $(MPICC)
	@echo MPICXX = $(MPICXX)
	@echo NC_FC = $(NC_FC)
	@echo NC_CC = $(NC_CC)
	@echo NC_CXX = $(NC_CXX)
	@echo ES_FC = $(ES_FC)
	@echo ES_CC = $(ES_CC)
	@echo ES_CXX = $(ES_CXX)
	@echo FORTRAN_VERSION = $(FORTRAN_VERSION)
	@echo ESMF_COMM = $(ESMF_COMM)
	@echo ESMF_COMPILER = $(ESMF_COMPILER)
	@echo ENABLE_HDF4 = $(ENABLE_HDF4)
	@echo LIB_HDF4 = $(LIB_HDF4)
	@ argv="$(SUBDIRS)" ;\
        ( echo "-------+---------+---------+--------------" );  \
        ( echo "Config | Install |  Check  |   Package" );      \
        ( echo "-------+---------+---------+--------------" );  \
	  for d in $$argv; do			      \
            if test -e $$d.config ; then              \
               cfg='  ok  '                          ;\
            else                                      \
               cfg='  --  '                          ;\
            fi                                       ;\
            if test -e $$d.install ; then             \
               inst='  ok   '                        ;\
            else                                      \
               inst='  --   '                        ;\
            fi                                       ;\
            if test -e $$d.check ; then               \
               chck='  ok   '                        ;\
            else                                      \
               chck='  --   '                        ;\
            fi                                       ;\
            ( echo "$$cfg | $$inst | $$chck | $$d" ); \
	  done ;                                      \
          ( echo "-------+---------+---------+--------------" )


.PHONY: $(TARGETS) baselibs-config versions prelim

.NOTPARALLEL: baselibs-config

prelim: echo-compilers baselibs-config versions download

echo-compilers:
	@mkdir -p $(prefix)/etc
	$(warning Using $(FC) for Fortran compiler)
	$(warning Using $(MPIFC) for MPI Fortran compiler)
	$(warning Using $(ES_FC) for ESMF Fortran compiler)
	$(warning Using $(CC) for C compiler)
	$(warning Using $(MPICC) for MPI C compiler)
	$(warning Using $(ES_CC) for ESMF C compiler)
	$(warning Using $(CXX) for C++ compiler)
	$(warning Using $(MPICXX) for MPIC++ compiler)
	$(warning Using $(ES_CXX) for ESMF C++ compiler)

baselibs-config: baselibs-config.mk
	@echo "Building: $(SUBDIRS)"
	@echo "Doing preliminaries"
	@mkdir -p $(prefix)/etc
	@cp VERSION $(prefix)/etc
	@cp CHANGELOG.md $(prefix)/etc
	@cp ChangeLog-preV6 $(prefix)/etc
	@cp README.md $(prefix)/etc
	@$(if $(LOADEDMODULES),$(shell echo $(LOADEDMODULES) | tr ':' ' ' >& $(prefix)/etc/MODULES),echo "Modules not found")
	@rm -f $(prefix)/etc/CONFIG
	@echo "CC: $(CC)" >> $(prefix)/etc/CONFIG
	@echo "CC --version: $(shell $(CC) --version 2>&1)" >> $(prefix)/etc/CONFIG
	@echo "CXX: $(CXX)" >> $(prefix)/etc/CONFIG
	@echo "CXX --version: $(shell $(CXX) --version 2>&1)" >> $(prefix)/etc/CONFIG
	@echo "FC: $(FC)" >> $(prefix)/etc/CONFIG
	@echo "FC --version: $(shell $(FC) $(FORTRAN_VERSION) 2>&1)" >> $(prefix)/etc/CONFIG
	@echo "F77: $(F77)" >> $(prefix)/etc/CONFIG
	@echo "F77 --version: $(shell $(F77) $(FORTRAN_VERSION) 2>&1)" >> $(prefix)/etc/CONFIG
	@echo "FC: $(FC)" >> $(prefix)/etc/CONFIG
	@echo "FC --version: $(shell $(FC) $(FORTRAN_VERSION) 2>&1)" >> $(prefix)/etc/CONFIG
	@echo "" >> $(prefix)/etc/CONFIG
	@echo "MPICC: $(MPICC)" >> $(prefix)/etc/CONFIG
	@echo "MPICXX: $(MPICXX)" >> $(prefix)/etc/CONFIG
	@echo "MPIFC: $(MPIFC)" >> $(prefix)/etc/CONFIG
	@echo "" >> $(prefix)/etc/CONFIG
	@echo "ESMF_COMM: $(ESMF_COMM)" >> $(prefix)/etc/CONFIG
	@echo "ESMF_COMPILER: $(ESMF_COMPILER)" >> $(prefix)/etc/CONFIG
	@echo "ES_CC: $(ES_CC)" >> $(prefix)/etc/CONFIG
	@echo "ES_CXX: $(ES_CXX)" >> $(prefix)/etc/CONFIG
	@echo "ES_FC: $(ES_FC)" >> $(prefix)/etc/CONFIG
	@echo "FLAP_COMPILER: $(FLAP_COMPILER)" >> $(prefix)/etc/CONFIG
	@echo "" >> $(prefix)/etc/CONFIG
	@echo "CONFIG_SETUP: $(CONFIG_SETUP)" >> $(prefix)/etc/CONFIG
	@echo "SYSNAME: $(SYSNAME)" >> $(prefix)/etc/CONFIG
	@echo "ARCH: $(ARCH)" >> $(prefix)/etc/CONFIG
	@echo "SITE: $(SITE)" >> $(prefix)/etc/CONFIG
	@echo "MACH: $(MACH)" >> $(prefix)/etc/CONFIG
	@echo "Kernel: $(shell uname -r)" >> $(prefix)/etc/CONFIG
	@echo "Hostname: $(shell hostname)" >> $(prefix)/etc/CONFIG
	@echo "USER: $(USER)" >> $(prefix)/etc/CONFIG
	@echo "Making baselibs-config script"
	@sed -e "$$CONFIG_SEDFILE_BODY" baselibs-config.bsub > $(prefix)/etc/baselibs-config
	@chmod +x $(prefix)/etc/baselibs-config

versions: make_versions.sh
	$(shell ./make_versions.sh $(prefix))

make_baselibs_mk: make_baselibs_mk.sh versions
	$(shell ./make_baselibs_mk.sh $(prefix))

$(TARGETS): prelim
	@ t=$@; argv="$(SUBDIRS)" ;\
	  for d in $$argv; do			      \
            ( echo Building $$t ... );                \
            ( $(MAKE) $$d.config    );                \
            ( $(MAKE) $$d.$$t       );                \
	  done
	$(MAKE) make_baselibs_mk

clean:
	@ t=$@; argv="$(SUBDIRS)" ;\
	  for d in $$argv; do			      \
	    ( $(MAKE) $$d.$$t ) \
	  done

distclean:
	@/bin/rm -rf *.config *.install *.check *.python
	@ t=$@; argv="$(SUBDIRS)" ;\
	  for d in $$argv; do			      \
	    ( $(MAKE) $$d.$$t ) \
	  done

check:
	@ t=$@; argv="$(SUBDIRS)" ;\
	  for d in $$argv; do			      \
            ( echo Checking $$d ... ); \
            ( $(MAKE) $$d.$$t       ); \
	  done

realclean:
	@$(MAKE) distclean
	@/bin/rm -rf $(prefix)

#                      ----------------
#                      Customized rules
#                      ----------------


#                         Config
#                         ......


jpeg.config: jpeg/configure
	@echo "Configuring jpeg"
	@(cd jpeg; \
	  export PATH="$(prefix)/bin:$(PATH)" ;\
	  export CPPFLAGS="$(INC_SUPP)";\
	  export LIBS="-lm";\
	  ./configure --prefix=$(prefix) \
		      --includedir=$(prefix)/include/jpeg \
		      --disable-shared \
		      CFLAGS="$(CFLAGS)" CC=$(CC) CXX=$(CXX) FC=$(FC) )
	@touch $@

hdf4.config: hdf4/README.txt jpeg.install zlib.install szlib.install
	@echo Configuring hdf4
	@(cd hdf4; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(INC_SUPP)";\
          export LDFLAGS="-lm $(LIB_EXTRA)" ;\
          ./configure --prefix=$(prefix) \
                      --program-suffix="-hdf4"\
                      --includedir=$(prefix)/include/hdf \
                      --with-jpeg=$(prefix)/include/jpeg,$(prefix)/lib \
                      --with-szlib=$(prefix)/include/szlib,$(prefix)/lib \
                      --with-zlib=$(prefix)/include/zlib,$(prefix)/lib \
                      --disable-netcdf \
                      CFLAGS="$(CFLAGS) $(NO_IMPLICIT_FUNCTION_ERROR)" FFLAGS="$(NAG_FCFLAGS) $(NAG_DUSTY) $(ALLOW_ARGUMENT_MISMATCH)" CC=$(CC) FC=$(FC) CXX=$(CXX) )
	touch $@

hdf5.config :: hdf5/README.md szlib.install zlib.install
	echo Configuring hdf5
	(cd hdf5; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export LIBS="-lm" ;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/hdf5 \
                      --with-szlib=$(prefix)/include/szlib,$(prefix)/lib \
                      --with-zlib=$(prefix)/include/zlib,$(prefix)/lib \
                      --disable-shared --disable-cxx\
                      --enable-hl --enable-fortran --disable-sharedlib-rpath \
                      $(ENABLE_GPFS) $(H5_PARALLEL) $(HDF5_ENABLE_F2003) \
                      CFLAGS="$(CFLAGS) $(HDF5_NCCS_MPT_CFLAG)" FCFLAGS="$(NAG_FCFLAGS)" CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77) )
	touch $@

ifneq ("$(wildcard $(prefix)/bin/curl-config)","")
BUILD_DAP = --enable-dap
LIB_CURL = $(shell $(prefix)/bin/curl-config --libs) $(DARWIN_ST_LIBS)
ifeq ($(findstring nagfor,$(notdir $(FC))),nagfor)
LIB_CURL := $(filter-out -pthread,$(LIB_CURL))
endif
else
BUILD_DAP = --disable-dap
LIB_CURL =
endif
netcdf.config : netcdf/configure
	@echo "Configuring netcdf $*"
	@(cd netcdf; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) $(NC_CPPFLAGS) $(INC_SUPP)";\
          export CFLAGS="$(CFLAGS) $(NC_CFLAGS) $(PTHREAD_FLAG)";\
          export LIBS="-L$(prefix)/lib -lsz -ljpeg $(LINK_GPFS) $(LIB_CURL) -ldl -lm $(LIB_EXTRA)" ;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/netcdf \
                      $(ENABLE_HDF4) \
                      $(BUILD_DAP) \
                      $(NC_PAR_TESTS) \
                      --disable-shared \
                      --disable-examples \
                      --enable-netcdf-4 \
                      CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77) )
	@touch $@

LIB_NETCDF = $(shell $(prefix)/bin/nc-config --libs)
ifeq ($(findstring nagfor,$(notdir $(FC))),nagfor)
LIB_NETCDF := $(filter-out -pthread,$(LIB_NETCDF))
endif
netcdf-fortran.config : netcdf-fortran/configure netcdf.install
	@echo "Configuring netcdf-fortran $*"
	@(cd netcdf-fortran; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) -I$(prefix)/include/netcdf $(INC_SUPP)";\
          export CFLAGS="$(CFLAGS) $(NC_CFLAGS) $(PTHREAD_FLAG)";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL)" ;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/netcdf \
                      $(NC_PAR_TESTS) \
                      --disable-shared \
                      --enable-f90 \
                      FFLAGS="$(FORTRAN_FPIC) $(NAG_FCFLAGS) $(ALLOW_ARGUMENT_MISMATCH)" FCFLAGS="$(FORTRAN_FPIC) $(NAG_FCFLAGS) $(ALLOW_ARGUMENT_MISMATCH)" \
                      CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77) )
	@touch $@

netcdf-cxx4.config : netcdf-cxx4/configure netcdf.install
	@echo "Configuring netcdf-cxx4 $*"
	@mkdir -p ./netcdf-cxx4/build
	@(cd netcdf-cxx4/build; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) -I$(prefix)/include/netcdf $(INC_SUPP)";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL)" ;\
          ../configure --prefix=$(prefix) \
                       --includedir=$(prefix)/include/netcdf \
                       --disable-shared \
                       CXXFLAGS="-fPIC" CFLAGS="-fPIC" \
                       CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77) )
	@touch $@

udunits2.config : udunits2/configure.ac
	@echo "Configuring udunits2 $*"
	@(cd udunits2; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) $(INC_SUPP)";\
          export LIBS="-L$(prefix)/lib $(LIB_HDF4) -lsz -ljpeg $(LINK_GPFS) $(LIB_CURL) -ldl -lm" ;\
          autoreconf -f -v -i;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/udunits2 \
                      --disable-shared \
                      CFLAGS="$(CFLAGS) $(NO_IMPLICIT_FUNCTION_ERROR)" CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77) )
	@touch $@

INC_HDF5 = $(prefix)/include/hdf5
LIB_HDF5 = $(wildcard $(foreach lib, hdf5_hl hdf5 z sz curl,\
           $(prefix)/lib/lib$(lib).a) )
nco.config : nco/configure
	@echo "Configuring nco $*"
	@(cd nco; \
          export NETCDF_ROOT="$(prefix)/"; \
          export NETCDF_LIB="$(prefix)/lib"; \
          export NETCDF_INC="$(prefix)/include/netcdf"; \
          export ANTLR_ROOT="$(prefix)/"; \
          export ANTLR_LIB="$(prefix)/lib"; \
          export ANTLR_INC="$(prefix)/include/antlr2"; \
          export GSL_ROOT="$(prefix)/"; \
          export GSL_LIB="$(prefix)/lib"; \
          export GSL_INC="$(prefix)/include/gsl"; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) $(INC_SUPP) -I$(prefix)/include/netcdf";\
          export CXXFLAGS="$(NCO_CXXFLAGS)";\
          export CFLAGS="$(CFLAGS) $(PTHREAD_FLAG)";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_HDF5) $(LIB_HDF4) -lsz  -ljpeg $(LINK_GPFS) $(LIB_CURL) -ldl -lm $(LIB_EXTRA)" ;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/nco \
                      --enable-ncoxx \
                      --enable-ncap2 --enable-gsl \
                      --disable-shared --enable-static \
                      --disable-nco_cplusplus \
                      --disable-mpi \
                      --enable-openmp \
                      --enable-netcdf4  \
                      --disable-doc  \
                      CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77)  )
	@touch $@

szlib.download : scripts/download_szlib.bash
	@echo "Downloading szlib"
	@./scripts/download_szlib.bash
	@touch $@

szlib.config : szlib.download szlib/configure
	@echo "Configuring szlib"
	@(cd szlib; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(INC_SUPP)";\
          export LIBS="-lm";\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/szlib \
                      --disable-shared \
                      CFLAGS="$(CFLAGS)" CC=$(CC) CXX=$(CXX) FC=$(FC) )
	@touch $@

zlib.config : zlib/configure
	@echo Configuring zlib
	@(cd zlib; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/zlib \
                      --libdir=$(prefix)/lib )
	touch $@


curl.config : curl/configure.ac zlib.install
	@echo "Configuring curl"
	@(cd curl; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(INC_SUPP)";\
          export LIBS="-lm";\
          autoreconf -f -v -i;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/ \
                      --libdir=$(prefix)/lib \
                      --with-zlib=$(prefix) \
                      --disable-ldap \
                      --enable-manual \
                      --disable-shared \
                      --enable-static \
                      --without-libidn \
                      --without-libidn2 \
                      --without-nghttp2 \
                      --without-nghttp3 \
                      $(CURL_SSL) \
                      CFLAGS="$(CFLAGS) $(MMACOS_MIN)" CC=$(CC) CXX=$(CXX) FC=$(FC) )
	@touch $@

cdo.download : scripts/download_cdo.bash
	@echo "Downloading cdo"
	@./scripts/download_cdo.bash
	@touch $@

cdo.config: cdo.download cdo/configure netcdf.install udunits2.install
	@echo "Configuring cdo $*"
	@(cd cdo; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) $(INC_SUPP)";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL) -lexpat $(LIB_HDF4) -lsz -ljpeg $(LINK_GPFS) -ldl -lm" ;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/cdo \
                      --with-szlib=$(prefix) \
                      --with-zlib=$(prefix) \
                      --with-hdf5=$(prefix) \
                      --with-netcdf=$(prefix) \
                      --with-udunits2=$(prefix) \
                      --disable-grib --disable-openmp \
                      --disable-shared --enable-static \
                      CXXFLAGS="$(CLANG_STDC17)" FCFLAGS="$(NAG_FCFLAGS)" CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77) )
	@touch $@

nccmp.config: nccmp/configure netcdf.install
	@echo "Configuring nccmp $*"
	@(cd nccmp; \
          autoreconf -f -v -i;\
          chmod +x configure ;\
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) $(INC_SUPP)";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL) -lexpat $(LIB_HDF4) -lsz -ljpeg $(LINK_GPFS) -ldl -lm" ;\
          export CFLAGS="$(CFLAGS) $(PTHREAD_FLAG)";\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/nccmp \
                      --with-netcdf=$(MKFILE_DIR)/netcdf \
                      FCFLAGS="$(NAG_FCFLAGS)" CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77) )
	@touch $@

xgboost.config:
	@echo "Configuring xgboost"
	@mkdir -p ./xgboost/build
	@(cd ./xgboost/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) .. )
	@touch $@

GFE.config:
	@echo "Configuring GFE"
	@mkdir -p ./GFE/build
	@(cd ./GFE/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) -DSKIP_OPENMP=YES .. )
	@touch $@

libyaml.config:
	@echo "Configuring libyaml"
	@mkdir -p ./libyaml/build
	@(cd ./libyaml/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) .. )
	@touch $@

FMS.config: netcdf.install netcdf-fortran.install libyaml.install
	@echo "Configuring FMS"
	@mkdir -p ./FMS/build
	@(cd ./FMS/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix)/FMS -DCMAKE_PREFIX_PATH=$(prefix) -D32BIT=ON -D64BIT=ON -DFPIC=ON -DCONSTANTS=GEOS -DNetCDF_ROOT=$(prefix) -DNetCDF_INCLUDE_DIR=$(prefix)/include/netcdf $(CMAKE_ALLOW_ARGUMENT_MISMATCH) .. )
	@touch $@

FLAP.config:
	@echo "Configuring FLAP"
	@mkdir -p $(prefix)/lib
	@mkdir -p ./FLAP/build
	@(cd ./FLAP/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) .. )
	@touch $@

antlr2.config : antlr2/configure
	@echo "Configuring antlr2"
	@mkdir -p ./antlr2/build
	@(cd antlr2/build; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(INC_SUPP)";\
          export LIBS="-lm";\
          ../configure --prefix=$(prefix) \
                       --includedir=$(prefix)/include/antlr2 \
                       --disable-shared \
                       --disable-java \
                       --disable-python \
                       --disable-csharp \
                       CFLAGS="$(CFLAGS)" CC=$(CC) CXX=$(CXX) FC=$(FC) )
	@touch $@

gsl.download : scripts/download_gsl.bash
	@echo "Downloading gsl"
	@./scripts/download_gsl.bash
	@touch $@

gsl.config : gsl.download gsl/configure
	@echo "Configuring gsl"
	@(cd gsl; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(INC_SUPP)";\
          export LIBS="-lm";\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/gsl \
                      --disable-shared \
                      CFLAGS="$(CFLAGS)" CC=$(CC) CXX=$(CXX) FC=$(FC) )
	@touch $@

esmf.config : esmf_rules.mk netcdf-fortran.install
	@$(MAKE) -e -f esmf_rules.mk ESMF_COMPILER=$(ESMF_COMPILER) CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) config

hdfeos.download : scripts/download_hdfeos.bash
	@echo "Downloading hdfeos"
	@./scripts/download_hdfeos.bash
	@touch $@

hdfeos.config: hdfeos.download hdfeos/configure hdf4.install
	@echo "Configuring hdfeos $*"
	@(cd hdfeos; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) $(INC_SUPP)";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL) -lexpat $(LIB_HDF4) -lsz -ljpeg $(LINK_GPFS) -ldl -lm" ;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/hdfeos \
                      --disable-shared --enable-static \
                      --enable-fortran \
                      CFLAGS=$(CFLAGS) FCFLAGS="$(NAG_FCFLAGS)" CC="$(H4_CC)" FC=$(H4_FC) F77=$(H4_FC) )
	@touch $@

hdfeos5.download : scripts/download_hdfeos5.bash
	@echo "Downloading hdfeos5"
	@./scripts/download_hdfeos5.bash
	@touch $@

INC_HDF5 = $(prefix)/include/hdf5
LIB_HDF5 = $(wildcard $(foreach lib, hdf5_hl hdf5 z sz curl,\
           $(prefix)/lib/lib$(lib).a) )

hdfeos5.config: hdfeos5.download hdfeos5/configure hdf5.install
	@echo "Configuring hdfeos5 $*"
	@(cd hdfeos5; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) $(INC_SUPP)";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL) -lexpat $(LIB_HDF4) -lsz -ljpeg $(LINK_GPFS) -ldl -lm" ;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/hdfeos5 \
                      --disable-shared --enable-static \
                      --enable-fortran \
                      CFLAGS=$(CFLAGS) FCFLAGS="$(NAG_FCFLAGS) $(NAG_DUSTY)" CC="$(H5_CC)" FC=$(H5_FC) F77=$(H5_FC) )
	@touch $@

INC_SUPP_SDP :=  $(foreach subdir, \
            / /zlib /szlib /jpeg /hdf5 /hdf /hdfeos /hdfeos5,\
            -I$(prefix)/include$(subdir) $(INC_EXTRA) )

SDPToolkit.download : scripts/download_SDPToolkit.bash
	@echo "Downloading SDPToolkit"
	@./scripts/download_SDPToolkit.bash
	@touch $@

SDPToolkit.config: SDPToolkit.download SDPToolkit/configure hdfeos5.install
	@echo "Configuring SDPToolkit $*"
	@(cd SDPToolkit; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) $(INC_SUPP_SDP)";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL) -lexpat $(LIB_HDF4) -lsz -ljpeg $(LINK_GPFS) -ldl -lm" ;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/SDPToolkit \
                      --with-zlib=$(prefix)/include/zlib,$(prefix)/lib \
                      --with-szlib=$(prefix)/include/szlib,$(prefix)/lib \
                      --with-hdf4=$(prefix)/include/hdf,$(prefix)/lib \
                      --with-hdf5=$(prefix)/include/hdf5,$(prefix)/lib \
                      --with-hdfeos2=$(prefix)/include/hdfeos,$(prefix)/lib \
                      --with-hdfeos5=$(prefix)/include/hdfeos5,$(prefix)/lib \
                      --enable-fortran \
                      --disable-shared --enable-static \
                      CFLAGS=$(CFLAGS) FCFLAGS="$(NAG_FCFLAGS) $(NAG_DUSTY)" CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77) )
	@touch $@


#                         Install
#                         .......


hdf5.install: hdf5.config
	@(cd hdf5; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          "$(HDF5_DEEPBIND)" ;\
          $(MAKE) install CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77))
	@touch $@

netcdf.install : netcdf.config
	@echo "Installing netcdf $*"
	@(cd netcdf; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) $(NC_CPPFLAGS) $(INC_SUPP)";\
          export CFLAGS="$(CFLAGS) $(NC_CFLAGS) $(PTHREAD_FLAG)";\
          export LIBS="-L$(prefix)/lib $(LIB_HDF4) -lsz -ljpeg $(LINK_GPFS) $(LIB_CURL) -ldl -lm $(LIB_EXTRA)" ;\
          $(MAKE) install CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77))
	@touch $@

netcdf-fortran.install : netcdf-fortran.config
	@echo "Installing netcdf-fortran $*"
	@(cd netcdf-fortran; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) -I$(prefix)/include/netcdf $(INC_SUPP)";\
          export CFLAGS="$(CFLAGS) $(NC_CFLAGS) $(PTHREAD_FLAG)";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL)" ;\
          make -j1 install CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77))
	@touch $@

netcdf-cxx4.install : netcdf-cxx4.config
	@echo "Installing netcdf-cxx4 $*"
	@(cd netcdf-cxx4/build; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) -I$(prefix)/include/netcdf $(INC_SUPP)";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL)" ;\
          $(MAKE) install CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77))
	@touch $@

cdo.install: cdo.config
	@echo "Installing cdo $*"
	@(cd cdo; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) install CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77))
	@touch $@

nccmp.install: nccmp.config
	@echo "Installing nccmp $*"
	@(cd nccmp; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) install CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77))
	@touch $@

xgboost.install: xgboost.config
	@echo "Installing xgboost"
	@(cd ./xgboost/build; \
		$(MAKE) install )
	@touch $@

GFE.install: GFE.config
	@echo "Installing GFE"
	@(cd ./GFE/build; \
		$(MAKE) install )
	@touch $@

libyaml.install: libyaml.config
	@echo "Installing libyaml"
	@(cd ./libyaml/build; \
		$(MAKE) install )
	@touch $@

FMS.install: FMS.config
	@echo "Installing FMS"
	@(cd ./FMS/build; \
		$(MAKE) install )
	@touch $@

FLAP.install: FLAP.config
	@echo "Installing FLAP with CMake"
	@(cd ./FLAP/build; \
      $(MAKE) -j1 install )
	@touch $@

# MAT: Note that on Mac machines there seems to be an issue with the libtool setup
#      in nco. If you just run nco, it never makes the libnco.a library, or at least
#      does not make it correctly. As the nco/m4/libtool.m4 and, say, the
#      netcdf/m4/libtool.m4 files are nearly the same, this seems to be an issue in
#      NCO. Until NCO can solve this issue the solution is a three-part run:
#
#      1. Make install
#      2. After it crashes, go into nco/src/nco and run:
#         $ ar r libnco.a *.o
#         $ mv libnco.a .libs/
#      3. Run make install again to build the rest of nco
#
#      Also, on Macs, the makeinfo installed is too old to build the info files
#      for NCO. As we do not really need them, we remove the doc from the Makefile

ifeq ($(ARCH),Darwin)
nco.install: nco.config
	@echo "Installing nco with hack for Darwin"
	@(cd nco; \
          export NETCDF_ROOT="$(prefix)/"; \
          export NETCDF_LIB="$(prefix)/lib"; \
          export NETCDF_INC="$(prefix)/include/netcdf"; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) $(INC_SUPP) -I$(prefix)/include/netcdf";\
          export LIBS="-L$(prefix)/lib $(LIB_HDF5) $(LIB_HDF4) -lsz  -ljpeg $(LINK_GPFS) $(LIB_CURL) -ldl -lm" ;\
	  sed -i '' '/^SUBDIRS/s/doc//' Makefile ;\
	  $(MAKE) install ;\
	  cd src/nco ;\
	  ar r libnco.a *.o ;\
	  mv libnco.a .libs/ ;\
	  cd ../.. ;\
	  $(MAKE) install CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77) )
	@touch $@
else
nco.install: nco.config
	@echo "Installing nco"
	@(cd nco; \
          export NETCDF_ROOT="$(prefix)/"; \
          export NETCDF_LIB="$(prefix)/lib"; \
          export NETCDF_INC="$(prefix)/include/netcdf"; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) $(INC_SUPP) -I$(prefix)/include/netcdf";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_HDF5) $(LIB_HDF4) -lsz  -ljpeg $(LINK_GPFS) $(LIB_CURL) -ldl -lm" ;\
	  $(MAKE) install CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77) )
	@touch $@
endif

jpeg.install: jpeg.config
	@echo "Installing jpeg"
	@mkdir -p $(prefix)/bin $(prefix)/lib $(prefix)/include/jpeg
	@(cd jpeg; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) all ;\
          $(MAKE) -e install)
	touch $@

antlr2.install :: antlr2.config
	@echo Patching antlr2
	patch -f -p1 < ./patches/antlr2/strings.patch

antlr2.install :: antlr2.config
	@echo "Installing antlr2"
	@mkdir -p $(prefix)/bin $(prefix)/lib $(prefix)/include/antlr2
	@(cd antlr2/build; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) all; \
          $(MAKE) -e install)
	touch $@

antlr2.install :: antlr2.config
	@echo Unpatching antlr2
	patch -f -p1 -R < ./patches/antlr2/strings.patch

gsl.install: gsl.config
	@echo "Installing gsl"
	@mkdir -p $(prefix)/bin $(prefix)/lib $(prefix)/include/gsl
	@(cd gsl; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) all; \
          $(MAKE) -e install)
	touch $@

hdfeos.install: hdfeos.config
	@echo "Installing hdfeos"
	@mkdir -p $(prefix)/bin $(prefix)/lib $(prefix)/include/hdfeos
	@(cd hdfeos; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) install ;\
          $(MAKE) -C include install CC=$(H4_CC) FC=$(H4_FC) F77=$(H4_FC) ;\
          cp include/*.h $(prefix)/include/hdfeos)
	touch $@

hdfeos5.install: hdfeos5.config
	@echo "Installing hdfeos5"
	@mkdir -p $(prefix)/bin $(prefix)/lib $(prefix)/include/hdfeos5
	@(cd hdfeos5; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) install ;\
          $(MAKE) -C include install CC=$(H5_CC) FC=$(H5_FC) F77=$(H5_FC))
	touch $@

SDPToolkit.install: SDPToolkit.config
	@echo "Installing SDPToolkit"
	@mkdir -p $(prefix)/bin $(prefix)/lib $(prefix)/include/SDPToolkit
	@(cd SDPToolkit; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) ;\
          $(MAKE) install CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77))
	touch $@

esmf.install : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk ESMF_COMPILER=$(ESMF_COMPILER) CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) install

esmf.info : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk ESMF_COMPILER=$(ESMF_COMPILER) CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) info

esmf.examples : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk ESMF_COMPILER=$(ESMF_COMPILER) CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) examples

esmf.python : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk ESMF_COMPILER=$(ESMF_COMPILER) CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) python

esmf.pythoncheck : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk ESMF_COMPILER=$(ESMF_COMPILER) CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) pythoncheck


#                          Clean
#                          .....

esmf.clean : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk ESMF_COMPILER=$(ESMF_COMPILER) CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) clean

esmf.distclean : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk ESMF_COMPILER=$(ESMF_COMPILER) CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) distclean

netcdf-cxx4.clean:
	@echo "Cleaning netcdf-cxx4"
	@rm -rf ./netcdf-cxx4/build

netcdf-cxx4.distclean:
	@echo "Cleaning netcdf-cxx4"
	@rm -rf ./netcdf-cxx4/build

xgboost.clean:
	@echo "Cleaning xgboost"
	@rm -rf ./xgboost/build

xgboost.distclean:
	@echo "Cleaning xgboost"
	@rm -rf ./xgboost/build

GFE.clean:
	@echo "Cleaning GFE"
	@rm -rf ./GFE/build

GFE.distclean:
	@echo "Cleaning GFE"
	@rm -rf ./GFE/build

libyaml.clean:
	@echo "Cleaning libyaml"
	@rm -rf ./libyaml/build

libyaml.distclean:
	@echo "Cleaning libyaml"
	@rm -rf ./libyaml/build

FMS.clean:
	@echo "Cleaning FMS"
	@rm -rf ./FMS/build

FMS.distclean:
	@echo "Cleaning FMS"
	@rm -rf ./FMS/build

FLAP.clean:
	@echo "Cleaning FLAP"
	@rm -rf ./FLAP/build

FLAP.distclean:
	@echo "Cleaning FLAP"
	@rm -rf ./FLAP/build

antlr2.clean:
	@echo "Cleaning antlr2"
	@rm -rf ./antlr2/build

antlr2.distclean:
	@echo "Cleaning antlr2"
	@rm -rf ./antlr2/build

# MAT There seems to be some issue in curl with distclean
#     as it goes into some sort of infinite loop?
curl.distclean:
	@echo "Cleaning curl"
	@(cd curl; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) clean)
#                          Check
#                          .....

esmf.check : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk ESMF_COMPILER=$(ESMF_COMPILER) CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) check

esmf.all_tests : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk ESMF_COMPILER=$(ESMF_COMPILER) CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) all_tests

curl.check: curl.install
	@echo "Checking curl"
	@echo "We explicitly do not check cURL due to how long it takes"

xgboost.check: xgboost.install
	@echo "Not sure how to check xgboost"

libyaml.check: libyaml.install
	@echo "Checking libyaml"
	@echo "We do not check libyaml not sure how."

FMS.check: FMS.install
	@echo "Checking FMS"
	@echo "We do not check FMS."

GFE.check: GFE.install
	@echo "Checking GFE"
	@echo "This requires a re-CMake to enable testing"
	@rm -rf ./GFE/build
	@mkdir -p ./GFE/build
	@(cd ./GFE/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) -DSKIP_OPENMP=YES .. ;\
		$(MAKE) tests)
	@touch $@

FLAP.check: FLAP.install
	@echo "Not sure how to check FLAP"

antlr2.check: antlr2.install
	@echo "Checking antlr2"
	@(cd antlr2/build; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) test)
	@touch $@
#                        -------------
#                        Generic rules
#                        -------------

%.config : %/configure
	@echo "Configuring generic $*"
	@(cd $*; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(INC_SUPP)";\
          export LIBS="-lm";\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/$* \
                      --disable-f90 --disable-shared --enable-static \
                      CC=$(CC) CXX=$(CXX) FC=$(FC) )
	@touch $@

%.all: %.config
	@(cd $*; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) all)

%.install: %.config
	@(cd $*; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) install)
	@touch $@

%.check: %.install
	@(cd $*; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) check)
	@touch $@

%.clean: %
	@(cd $<; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) clean)

%.distclean: %
	@(cd $<; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) distclean)


#                        ------------
#                        Dependencies
#                        ------------

#------------------------------------------------------------------------

