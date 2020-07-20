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
  ifeq ($(wildcard hdf5),hdf5)
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
  endif

# Issue with NCO and nccmp with mpiuni and gcc
# --------------------------------------------

  ifeq ($(CC), gcc)
    ifeq ($(ESMF_COMM),mpiuni)
      PTHREAD_FLAG = -pthread
    endif
  endif

# Testing with MVAPICH2 and ifort showed this flag was needed
# -----------------------------------------------------------
#
  ifeq ($(FC), ifort)
    ifeq ($(ESMF_COMM),mvapich2)
      PTHREAD_FLAG = -pthread
    endif
  endif

# netCDF has an issue with Intel 15+. It must be compiled with -g -O0 to
# avoid the problem (which manifests as a crash in ESMF_cfio where in a
# FPE is thrown in an NF90_DEF_VAR for time!).
# ----------------------------------------------------------------------

  ifeq ($(FC), ifort)
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
  ifeq ($(FC),pgfortran)
     NCO_CXXFLAGS = -gopt -O2
  endif

# From Tom Clune: NAG is different. It has a different version and FPIC
# flag. It also needs extra flags to compile code that is not as string
# as it would like.
# ---------------------------------------------------------------------
  FORTRAN_FPIC = -fPIC
  FORTRAN_VERSION = --version
  HDF5_ENABLE_F2003 = --enable-fortran2003
  ifeq ($(FC),nagfor)
     FORTRAN_FPIC = -PIC
     FORTRAN_VERSION = -V
     NAG_FCFLAGS = -fpp -mismatch_all
     NAG_DUSTY = -dusty
  endif

# Building with PGI on Darwin (Community Edition) does not quite work. 
# Fixes are needed. NDEBUG from netcdf list
# -------------------------------------------------------------------

  ifeq ($(FC),pgfortran)
     ifeq ($(ARCH),Darwin)
        NC_CPPFLAGS = -DNDEBUG
        FORTRAN_FPIC = -fpic
     endif
  endif

# HDF4 and netCDF-Fortran has a bug with GCC 10.1
# -----------------------------------------------

  ifeq ($(FC),gfortran)
     GFORTRAN_VERSION_GTE_10 := $(shell expr `$(FC) -dumpversion | cut -f1 -d.` \>= 10)
     export GFORTRAN_VERSION_GTE_10
     ifeq ($(GFORTRAN_VERSION_GTE_10),1)
        ALLOW_ARGUMENT_MISMATCH := -fallow-argument-mismatch
        ALLOW_INVALID_BOZ := -fallow-invalid-boz
        export ALLOW_ARGUMENT_MISMATCH ALLOW_INVALID_BOZ
     endif
  endif

#-------------------------------------------------------------------------

#                  --------------------------------
#                   Recurse Make in Sub-directories
#                  --------------------------------

ALLDIRS = antlr gsl jpeg zlib szlib curl hdf4 hdf5 netcdf netcdf-fortran netcdf-cxx4 \
          udunits2 nco cdo nccmp esmf \
          gFTL gFTL-shared fArgParse pFUnit yaFyaml pFlogger \
          FLAP hdfeos hdfeos5 SDPToolkit

ifeq ($(ARCH),Darwin)
   ALLDIRS := $(filter-out SDPToolkit,$(ALLDIRS))
endif

ESSENTIAL_DIRS = jpeg zlib szlib hdf4 hdf5 netcdf netcdf-fortran netcdf-cxx4 \
                 esmf gFTL gFTL-shared fArgParse pFUnit yaFyaml pFlogger FLAP

ifeq ('$(BUILD)','ESSENTIALS')
SUBDIRS = $(ESSENTIAL_DIRS)
INC_SUPP :=  $(foreach subdir, \
            / /zlib /szlib /jpeg /hdf5 /hdf /netcdf,\
            -I$(prefix)/include$(subdir) $(INC_EXTRA) )
else
SUBDIRS = $(ALLDIRS)
INC_SUPP :=  $(foreach subdir, \
            / /zlib /szlib /jpeg /hdf5 /hdf /netcdf /udunits2 /gsl /antlr,\
            -I$(prefix)/include$(subdir) $(INC_EXTRA) )
endif

TARGETS = all lib install

download: antlr.download gsl.download szlib.download cdo.download hdfeos.download hdfeos5.download SDPToolkit.download

dist: download
	tar -czf $(RELEASE_DIR)/$(RELEASE_FILE).tar.gz -C $(RELEASE_DIR) $(MKFILE_DIRNAME)

verify: javac-check
	@echo MKFILE_PATH = $(MKFILE_PATH)
	@echo MKFILE_DIR = $(MKFILE_DIR)
	@echo MKFILE_DIRNAME = $(MKFILE_DIRNAME)
	@echo SUBDIRS = $(SUBDIRS)
	@echo BUILD_DAP = $(BUILD_DAP)
	@echo GFORTRAN_VERSION_GTE_10 = $(GFORTRAN_VERSION_GTE_10)
	@echo ALLOW_ARGUMENT_MISMATCH = $(ALLOW_ARGUMENT_MISMATCH)
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

JAVACFOUND := $(shell command -v javac 2> /dev/null)

prelim: javac-check echo-compilers baselibs-config versions download

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

JAVACDIRS = antlr gsl

javac-check:
ifndef JAVACFOUND
	$(warning "javac is not available. Please install javac or add to path")
	$(warning "as antlr requires it. For now, we build without")
	$(warning "antlr, gsl, and disable ncap2")
	$(eval ALLDIRS := $(filter-out $(JAVACDIRS),$(ALLDIRS)))
	$(warning ALLDIRS: $(ALLDIRS))
   BUILD_NCAP2 = --disable-ncap2 --disable-gsl
else
   BUILD_NCAP2 = --enable-ncap2 --enable-gsl
endif

baselibs-config: baselibs-config.mk
	@echo "Building: $(SUBDIRS)"
	@echo "Doing preliminaries"
	@mkdir -p $(prefix)/etc
	@cp VERSION $(prefix)/etc
	@cp CHANGELOG.md $(prefix)/etc
	@cp ChangeLog-preV6 $(prefix)/etc
	@cp README.md $(prefix)/etc
	@$(if $(LOADEDMODULES),$(shell echo $(LOADEDMODULES) >& $(prefix)/etc/MODULES),echo "Modules not found")
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
	@/bin/rm -rf *.config *.install *.check
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
                      CFLAGS="$(CFLAGS)" FFLAGS="$(NAG_FCFLAGS) $(NAG_DUSTY) $(ALLOW_ARGUMENT_MISMATCH)" CC=$(CC) FC=$(FC) CXX=$(CXX) )
	touch $@

ifeq ($(FC),nagfor)
hdf5.config :: hdf5/README.txt
	@echo Patching HDF5 for NAG
	patch -p1 < ./patches/hdf5/nag.configure.patch
endif

hdf5.config :: hdf5/README.txt hdf4.install szlib.install zlib.install
	echo Configuring hdf5
	(cd hdf5; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export LDFLAGS="-lm" ;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/hdf5 \
                      --with-szlib=$(prefix)/include/szlib,$(prefix)/lib \
                      --with-zlib=$(prefix)/include/zlib,$(prefix)/lib \
                      --disable-shared --disable-cxx\
                      --enable-hl --enable-fortran --disable-sharedlib-rpath \
                      $(ENABLE_GPFS) $(H5_PARALLEL) $(HDF5_ENABLE_F2003) \
                      CFLAGS="$(CFLAGS)" FCFLAGS="$(NAG_FCFLAGS)" CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77) )
	touch $@

ifeq ($(FC),nagfor)
hdf5.config :: hdf5/README.txt
	@echo Unpatching HDF5 for NAG
	patch -p1 -R < ./patches/hdf5/nag.configure.patch
endif

ifneq ("$(wildcard $(prefix)/bin/curl-config)","")
BUILD_DAP = --enable-dap
LIB_CURL = $(shell $(prefix)/bin/curl-config --libs)	
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
          export LIBS="-L$(prefix)/lib -lmfhdf -ldf -lsz -ljpeg $(LINK_GPFS) $(LIB_CURL) -ldl -lm $(LIB_EXTRA)" ;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/netcdf \
                      --enable-hdf4 \
                      $(BUILD_DAP) \
                      $(NC_PAR_TESTS) \
                      --disable-shared \
                      --disable-examples \
                      --enable-netcdf-4 \
                      CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77) )
	@touch $@

LIB_NETCDF = $(shell $(prefix)/bin/nc-config --libs)
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
          export LIBS="-L$(prefix)/lib -lmfhdf -ldf -lsz -ljpeg $(LINK_GPFS) $(LIB_CURL) -ldl -lm" ;\
          autoreconf -f -v -i;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/udunits2 \
                      --disable-shared \
                      CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77) )
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
          export ANTLR_INC="$(prefix)/include/antlr"; \
          export GSL_ROOT="$(prefix)/"; \
          export GSL_LIB="$(prefix)/lib"; \
          export GSL_INC="$(prefix)/include/gsl"; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) $(INC_SUPP) -I$(prefix)/include/netcdf";\
          export CXXFLAGS="$(NCO_CXXFLAGS)";\
          export CFLAGS="$(CFLAGS) $(PTHREAD_FLAG)";\
          export LIBS="-L$(prefix)/lib $(LIB_HDF5) -lmfhdf -ldf -lsz  -ljpeg $(LINK_GPFS) $(LIB_CURL) -ldl -lm $(LIB_EXTRA)" ;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/nco \
                      --enable-ncoxx \
                      $(BUILD_NCAP2) \
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


curl.config : curl/buildconf zlib.install
	@echo "Configuring curl"
	@(cd curl; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(INC_SUPP)";\
          export LIBS="-lm";\
          ./buildconf;\
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
                      CFLAGS="$(CFLAGS)" CC=$(CC) CXX=$(CXX) FC=$(FC) )
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
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL) -lexpat -lmfhdf -ldf -lsz -ljpeg $(LINK_GPFS) -ldl -lm" ;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/cdo \
                      --with-szlib=$(prefix) \
                      --with-zlib=$(prefix) \
                      --with-hdf5=$(prefix) \
                      --with-netcdf=$(prefix) \
                      --with-udunits2=$(prefix) \
                      --disable-grib --disable-openmp \
                      --disable-shared --enable-static \
                      FCFLAGS="$(NAG_FCFLAGS)" CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77) )
	@touch $@

nccmp.config: nccmp/configure netcdf.install
	@echo "Configuring nccmp $*"
	@(cd nccmp; \
          chmod +x configure ;\
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) $(INC_SUPP)";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL) -lexpat -lmfhdf -ldf -lsz -ljpeg $(LINK_GPFS) -ldl -lm" ;\
          export CFLAGS="$(CFLAGS) $(PTHREAD_FLAG)";\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/nccmp \
                      --with-netcdf=$(MKFILE_DIR)/netcdf \
                      FCFLAGS="$(NAG_FCFLAGS)" CC=$(NC_CC) FC=$(NC_FC) CXX=$(NC_CXX) F77=$(NC_F77) )
	@touch $@

pFUnit.config: gFTL.install gFTL-shared.install fArgParse.install
	@echo "Configuring pFUnit"
	@mkdir -p ./pFUnit/build
	@(cd ./pFUnit/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) -DSKIP_OPENMP=YES .. )
	@touch $@

gFTL.config:
	@echo "Configuring gFTL"
	@mkdir -p ./gFTL/build
	@(cd ./gFTL/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) .. )
	@touch $@

gFTL-shared.config: gFTL.install
	@echo "Configuring gFTL-shared"
	@mkdir -p ./gFTL-shared/build
	@(cd ./gFTL-shared/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) .. )
	@touch $@

fArgParse.config: gFTL.install gFTL-shared.install
	@echo "Configuring fArgParse"
	@mkdir -p ./fArgParse/build
	@(cd ./fArgParse/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) .. )
	@touch $@

pFlogger.config: gFTL.install gFTL-shared.install yaFyaml.install
	@echo "Configuring pFlogger"
	@mkdir -p ./pFlogger/build
	@(cd ./pFlogger/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) -DCMAKE_BUILD_TYPE=Release .. )
	@touch $@

yaFyaml.config: gFTL.install gFTL-shared.install
	@echo "Configuring yaFyaml"
	@mkdir -p ./yaFyaml/build
	@(cd ./yaFyaml/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) .. )
	@touch $@

FLAP.config:
	@echo "Configuring FLAP"
	@mkdir -p $(prefix)/lib
	@mkdir -p ./FLAP/build
	@(cd ./FLAP/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) .. )
	@touch $@

antlr.download : scripts/download_antlr.bash
	@echo "Downloading antlr"
	@./scripts/download_antlr.bash
	@touch $@

antlr.config : antlr.download antlr/configure
	@echo "Configuring antlr"
	@mkdir -p ./antlr/build
	@(cd antlr/build; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(INC_SUPP)";\
          export LIBS="-lm";\
          ../configure --prefix=$(prefix) \
                       --includedir=$(prefix)/include/antlr \
                       --disable-shared \
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
	@$(MAKE) -e -f esmf_rules.mk  CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) config

hdfeos.download : scripts/download_hdfeos.bash
	@echo "Downloading hdfeos"
	@./scripts/download_hdfeos.bash
	@touch $@

hdfeos.config: hdfeos.download hdfeos/configure hdf4.install
	@echo "Configuring hdfeos $*"
	@(cd hdfeos; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) $(INC_SUPP) -Df2cFortran";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL) -lexpat -lmfhdf -ldf -lsz -ljpeg $(LINK_GPFS) -ldl -lm" ;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/hdfeos \
                      --with-jpeg=$(prefix)/include/jpeg,$(prefix)/lib \
                      --with-zlib=$(prefix)/include/zlib,$(prefix)/lib \
                      --with-szlib=$(prefix)/include/szlib,$(prefix)/lib \
                      --with-hdf4=$(prefix)/include/hdf,$(prefix)/lib \
                      --disable-shared --enable-static \
                      CFLAGS=$(CFLAGS) FCFLAGS="$(NAG_FCFLAGS)" CC="$(H4_CC) -Df2cFortran" FC=$(H4_FC) CXX=$(CXX) F77=$(H4_FC) )
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
          export CPPFLAGS="$(CPPFLAGS) $(INC_SUPP) -Df2cFortran";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL) -lexpat -lmfhdf -ldf -lsz -ljpeg $(LINK_GPFS) -ldl -lm" ;\
          ./configure --prefix=$(prefix) \
                      --includedir=$(prefix)/include/hdfeos5 \
                      --with-zlib=$(prefix)/include/zlib,$(prefix)/lib \
                      --with-szlib=$(prefix)/include/szlib,$(prefix)/lib \
                      --with-hdf5=$(prefix)/include/hdf5,$(prefix)/lib \
                      --disable-shared --enable-static \
                      CFLAGS=$(CFLAGS) FCFLAGS="$(NAG_FCFLAGS) $(NAG_DUSTY)" CC="$(H5_CC) -Df2cFortran" FC=$(H5_FC) CXX=$(NC_CXX) F77=$(H5_FC) )
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
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL) -lexpat -lmfhdf -ldf -lsz -ljpeg $(LINK_GPFS) -ldl -lm" ;\
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
          $(MAKE) install)
	@touch $@

ifeq ($(GFORTRAN_VERSION_GTE_10),1)
ifeq ("$(BUILD_DAP)","--enable-dap")
netcdf.install :: netcdf.config
	@echo Patching netCDF-C ocprint for GCC 10
	patch -p1 < ./patches/netcdf/netcdf.ocprint.patch
endif
endif

netcdf.install :: netcdf.config
	@echo "Installing netcdf $*"
	@(cd netcdf; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) $(NC_CPPFLAGS) $(INC_SUPP)";\
          export CFLAGS="$(CFLAGS) $(NC_CFLAGS) $(PTHREAD_FLAG)";\
          export LIBS="-L$(prefix)/lib -lmfhdf -ldf -lsz -ljpeg $(LINK_GPFS) $(LIB_CURL) -ldl -lm $(LIB_EXTRA)" ;\
          $(MAKE) install)
	@touch $@

ifeq ($(GFORTRAN_VERSION_GTE_10),1)
ifeq ("$(BUILD_DAP)","--enable-dap")
netcdf.install :: netcdf.config
	@echo Unpatching netCDF-C ocprint for GCC 10
	patch -p1 -R < ./patches/netcdf/netcdf.ocprint.patch
endif
endif

netcdf-fortran.install : netcdf-fortran.config
	@echo "Installing netcdf-fortran $*"
	@(cd netcdf-fortran; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) -I$(prefix)/include/netcdf $(INC_SUPP)";\
          export CFLAGS="$(CFLAGS) $(NC_CFLAGS) $(PTHREAD_FLAG)";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL)" ;\
          make -j1 install)
	@touch $@

netcdf-cxx4.install : netcdf-cxx4.config
	@echo "Installing netcdf-cxx4 $*"
	@(cd netcdf-cxx4/build; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          export CPPFLAGS="$(CPPFLAGS) -I$(prefix)/include/netcdf $(INC_SUPP)";\
          export LIBS="-L$(prefix)/lib $(LIB_NETCDF) $(LIB_CURL)" ;\
          $(MAKE) install)
	@touch $@

pFUnit.install: pFUnit.config
	@echo "Installing pFUnit"
	@(cd ./pFUnit/build; \
		$(MAKE) install )
	@touch $@

gFTL.install: gFTL.config
	@echo "Installing gFTL"
	@(cd ./gFTL/build; \
		$(MAKE) install )
	@touch $@

gFTL-shared.install: gFTL-shared.config
	@echo "Installing gFTL-shared"
	@(cd ./gFTL-shared/build; \
		$(MAKE) install )
	@touch $@

fArgParse.install: fArgParse.config
	@echo "Installing fArgParse"
	@(cd ./fArgParse/build; \
		$(MAKE) install )
	@touch $@

pFlogger.install: pFlogger.config
	@echo "Installing pFlogger"
	@(cd ./pFlogger/build; \
		$(MAKE) install )
	@touch $@

yaFyaml.install: yaFyaml.config
	@echo "Installing yaFyaml"
	@(cd ./yaFyaml/build; \
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
          export LIBS="-L$(prefix)/lib $(LIB_HDF5) -lmfhdf -ldf -lsz  -ljpeg $(LINK_GPFS) $(LIB_CURL) -ldl -lm" ;\
	  sed -i '' '/^SUBDIRS/s/doc//' Makefile ;\
	  $(MAKE) install ;\
	  cd src/nco ;\
	  ar r libnco.a *.o ;\
	  mv libnco.a .libs/ ;\
	  cd ../.. ;\
	  $(MAKE) install )
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
          export LIBS="-L$(prefix)/lib $(LIB_HDF5) -lmfhdf -ldf -lsz  -ljpeg $(LINK_GPFS) $(LIB_CURL) -ldl -lm" ;\
	  $(MAKE) install )
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

antlr.install: antlr.config
	@echo "Installing antlr"
	@mkdir -p $(prefix)/bin $(prefix)/lib $(prefix)/include/antlr
	@(cd antlr/build; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) all; \
          $(MAKE) -e install)
	touch $@

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
          $(MAKE) -C include install)
	touch $@

hdfeos5.install: hdfeos5.config
	@echo "Installing hdfeos5"
	@mkdir -p $(prefix)/bin $(prefix)/lib $(prefix)/include/hdfeos5
	@(cd hdfeos5; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) install ;\
          $(MAKE) -C include install)
	touch $@

SDPToolkit.install: SDPToolkit.config
	@echo "Installing SDPToolkit"
	@mkdir -p $(prefix)/bin $(prefix)/lib $(prefix)/include/SDPToolkit
	@(cd SDPToolkit; \
          export PATH="$(prefix)/bin:$(PATH)" ;\
          $(MAKE) ;\
          $(MAKE) install)
	touch $@

esmf.install : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk  CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) install

esmf.info : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk  CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) info

esmf.examples : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk  CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) examples

esmf.python : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk  CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) python

esmf.pythoncheck : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk  CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) pythoncheck


#                          Clean
#                          .....

esmf.clean : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk  CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) clean

esmf.distclean : esmf_rules.mk
	@$(MAKE) -e -f esmf_rules.mk  CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) distclean

netcdf-cxx4.clean: 
	@echo "Cleaning netcdf-cxx4"
	@rm -rf ./netcdf-cxx4/build

netcdf-cxx4.distclean: 
	@echo "Cleaning netcdf-cxx4"
	@rm -rf ./netcdf-cxx4/build

pFUnit.clean: 
	@echo "Cleaning pFUnit"
	@rm -rf ./pFUnit/build

pFUnit.distclean: 
	@echo "Cleaning pFUnit"
	@rm -rf ./pFUnit/build

gFTL.clean:
	@echo "Cleaning gFTL"
	@rm -rf ./gFTL/build

gFTL.distclean:
	@echo "Cleaning gFTL"
	@rm -rf ./gFTL/build

gFTL-shared.clean:
	@echo "Cleaning gFTL-shared"
	@rm -rf ./gFTL-shared/build

gFTL-shared.distclean:
	@echo "Cleaning gFTL-shared"
	@rm -rf ./gFTL-shared/build

fArgParse.clean:
	@echo "Cleaning fArgParse"
	@rm -rf ./fArgParse/build

fArgParse.distclean:
	@echo "Cleaning fArgParse"
	@rm -rf ./fArgParse/build

pFlogger.clean:
	@echo "Cleaning pFlogger"
	@rm -rf ./pFlogger/build

pFlogger.distclean:
	@echo "Cleaning pFlogger"
	@rm -rf ./pFlogger/build

yaFyaml.clean:
	@echo "Cleaning yaFyaml"
	@rm -rf ./yaFyaml/build

yaFyaml.distclean:
	@echo "Cleaning yaFyaml"
	@rm -rf ./yaFyaml/build

FLAP.clean:
	@echo "Cleaning FLAP"
	@rm -rf ./FLAP/build

FLAP.distclean:
	@echo "Cleaning FLAP"
	@rm -rf ./FLAP/build

antlr.clean: 
	@echo "Cleaning antlr"
	@rm -rf ./antlr/build

antlr.distclean: 
	@echo "Cleaning antlr"
	@rm -rf ./antlr/build

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
	@$(MAKE) -e -f esmf_rules.mk  CFLAGS="$(CFLAGS)" CC=$(ES_CC) CXX=$(ES_CXX) FC=$(ES_FC) PYTHON=$(PYTHON) ESMF_INSTALL_PREFIX=$(prefix) check

curl.check: curl.install
	@echo "Checking curl"
	@echo "We explicitly do not check cURL due to how long it takes"

pFUnit.check: pFUnit.install
	@echo "Checking pFUnit"
	@(cd ./pFUnit/build; \
		$(MAKE) tests )
	@touch $@

gFTL.check: gFTL.install pFUnit.install
	@echo "Checking gFTL"
	@echo "This could require a new CMake for pFUnit, so we remove old build"
	@rm -rf ./gFTL/build
	@mkdir -p ./gFTL/build
	@(cd ./gFTL/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) .. ;\
		$(MAKE) tests )
	@touch $@

gFTL-shared.check: gFTL-shared.install pFUnit.install
	@echo "Checking gFTL-shared"
	@echo "This could require a new CMake for pFUnit, so we remove old build"
	@rm -rf ./gFTL-shared/build
	@mkdir -p ./gFTL-shared/build
	@(cd ./gFTL-shared/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) .. ;\
		$(MAKE) tests )
	@touch $@

fArgParse.check: fArgParse.install pFUnit.install
	@echo "Checking fArgParse"
	@echo "This requires a new CMake, so we remove old build"
	@rm -rf ./fArgParse/build
	@mkdir -p ./fArgParse/build
	@(cd ./fArgParse/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) .. ;\
		$(MAKE) tests )
	@touch $@

pFlogger.check: pFlogger.install pFUnit.install
	@echo "Checking pFlogger"
	@echo "This could require a new CMake for pFUnit, so we remove old build"
	@rm -rf ./pFlogger/build
	@mkdir -p ./pFlogger/build
	@(cd ./pFlogger/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) -DCMAKE_BUILD_TYPE=Release .. ;\
		$(MAKE) tests )
	@touch $@

yaFyaml.check: yaFyaml.install pFUnit.install
	@echo "Checking yaFyaml"
	@echo "This could require a new CMake for pFUnit, so we remove old build"
	@rm -rf ./yaFyaml/build
	@mkdir -p ./yaFyaml/build
	@(cd ./yaFyaml/build; \
		cmake -DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) .. ;\
		$(MAKE) tests )
	@touch $@

FLAP.check: FLAP.install
	@echo "Not sure how to check FLAP"

antlr.check: antlr.install
	@echo "Checking antlr"
	@(cd antlr/build; \
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

