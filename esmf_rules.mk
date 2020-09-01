#
#  Implement esmf specific targets
#

#                          -----------
#                          Environment
#                          -----------

  ARCH    := $(shell uname -s)
  MACH    := $(shell uname -m)

  ifeq ($(ARCH), Darwin)
     ESMF_SED = sed -i.bak -E
  else
     ESMF_SED = sed -i.bak -r
  endif

ifndef ESMF_DIR
  ESMF_DIR := $(shell dirname `pwd`)/src/esmf
endif

  ESMF_BOPT              ?= O
  ESMF_INSTALL_PREFIX    ?= $(prefix)
  ESMF_INSTALL_HEADERDIR ?= $(prefix)/include/esmf
  ESMF_INSTALL_MODDIR    ?= $(prefix)/include/esmf
  ESMF_INSTALL_LIBDIR    ?= $(prefix)/lib
  ESMF_INSTALL_BINDIR    ?= $(prefix)/bin
  ESMF_COMPILER          ?= $(FC)
  ESMF_PIO               ?= internal
  ESMF_MACHINE           ?= $(MACH)
  ESMF_OS                ?= $(ARCH)
  ESMF_PYTHON            ?= $(PYTHON)/bin/python
  ESMF_ABI               ?= 64

# ifort
# -----
  ifeq ($(ESMF_COMPILER), ifort) 

      ifeq ($(CXX),icpc)
         ESMF_COMPILER = intel
      else
         ESMF_COMPILER = intelgcc
      endif

# PGI
# ---
  else
  ifeq ($(ESMF_COMPILER),pgfortran)
     ESMF_COMPILER = pgi

# NAG
# ---
  else
  ifeq ($(ESMF_COMPILER),nagfor)
     ESMF_COMPILER = nag

  endif # nag
  endif # pgi
  endif # intel

# Open MPI on desktops and laptops
# can need oversubscribe
# --------------------------
  ifeq ($(ESMF_COMM),openmpi)
    ifneq ($(SITE),NCCS)
      ifneq ($(SITE),NAS)
        ESMF_MPILAUNCHOPTIONS='-oversubscribe'
        export ESMF_MPILAUNCHOPTIONS
      endif
    endif
  endif 

# ESMF_COMM=mpt expects mpicxx to be icpc
# ---------------------------------------
  ifeq ($(ESMF_COMPILER), intel)
    ifeq ($(ESMF_COMM), mpt)
      MPICXX_CXX=icpc
      export MPICXX_CXX
    endif
  endif

# ESMF with GCC 10.1 needs extra flags
# ------------------------------------

  ifeq ($(GFORTRAN_VERSION_GTE_10),1)
     ESMF_F90COMPILEOPTS += $(ALLOW_ARGUMENT_MISMATCH) $(ALLOW_INVALID_BOZ)
  endif

# ESMF on Graviton2 needs help
# ----------------------------

  ifeq ($(MACH),aarch64)
     ESMF_ABI := 64
  endif

  $(warning Using $(ESMF_COMPILER) as the ESMF compiler (FC=$(FC)))
  $(warning Using $(ESMF_MACHINE)  as the ESMF machine)
  $(warning Using $(ESMF_OS)  as the ESMF OS)
  $(warning Using $(ESMF_PYTHON)  as the ESMF python)
  $(warning Using $(ESMF_SED)  as the ESMF sed)
  $(warning Using $(ESMF_F90COMPILEOPTS)  as the ESMF F90COMPILEOPTS)
  $(warning Using $(ESMF_ABI)  as the ESMF ABI)

#      ESMF_COMM 
#      ESMF_ABI
#      ESMF_OS

# ESMF NetCDF and PIO Building
# ----------------------------
  ifeq ($(ESMF_PIO),internal)
     ESMF_NETCDF := user
     ESMF_NETCDF_INCLUDE := $(ESMF_INSTALL_PREFIX)/include/netcdf
     ESMF_NETCDF_LIBPATH := $(ESMF_INSTALL_PREFIX)/lib

     LIB_NETCDF = $(shell $(prefix)/bin/nf-config --flibs)

     ESMF_NETCDF_LIBS := -L$(ESMF_INSTALL_PREFIX)/lib -lnetcdff -lnetcdf $(LIB_NETCDF)

     $(warning Building ESMF_PIO as $(ESMF_PIO))
     $(warning Using ESMF_NETCDF as $(ESMF_NETCDF))
     $(warning Using ESMF_NETCDF_INCLUDE as $(ESMF_NETCDF_INCLUDE))
     $(warning Using ESMF_NETCDF_LIBPATH as $(ESMF_NETCDF_LIBPATH))
     $(warning Using ESMF_NETCDF_LIBS as $(ESMF_NETCDF_LIBS))

     export ESMF_NETCDF ESMF_NETCDF_INCLUDE ESMF_NETCDF_LIBPATH ESMF_NETCDF_LIBS
  endif

export ESMF_DIR ESMF_BOPT ESMF_COMPILER ESMF_INSTALL_PREFIX ESMF_OS ESMF_INSTALL_HEADERDIR ESMF_INSTALL_MODDIR ESMF_INSTALL_LIBDIR ESMF_INSTALL_BINDIR ESMF_F90COMPILEOPTS ESMF_ABI

esmf.config config: 
	@echo "Customized ESMF build step $@..."
	@touch esmf.config

esmf.all all: esmf.config
	@echo "Customized ESMF build step $@..."
	@(cd $(ESMF_DIR); $(MAKE) -e all)

esmf.lib lib: esmf.config
	@echo "Customized ESMF build step $@..."
	@(cd $(ESMF_DIR); $(MAKE) -e lib)

esmf.info info:
	@echo "Customized ESMF build step $@..."
	@echo "ESMF configuration"
	@(cd $(ESMF_DIR); $(MAKE) -e info)

esmf.script_info script_info:
	@echo "Customized ESMF build step $@..."
	@(cd $(ESMF_DIR); $(MAKE) -e script_info)

esmf.check check:
	@echo "Customized ESMF build step $@..."
	@(cd $(ESMF_DIR); make -e check)
	@(cd $(ESMF_DIR)/src/addon/ESMPy; export PYTHONPATH=$(ESMF_INSTALL_PREFIX)/lib/python2.7/site-packages; $(ESMF_PYTHON) setup.py test)
	@touch esmf.check

esmf.examples:
	@echo "Running ESMF Examples..."
	@(cd $(ESMF_DIR); $(MAKE) -e examples)

esmf.clean clean:
	@echo "Customized ESMF build step $@..."
	@(cd $(ESMF_DIR); $(MAKE) -e clean)

esmf.distclean distclean:
	@echo "Customized ESMF build step $@..."
	@(cd $(ESMF_DIR); $(MAKE) -e distclean)

esmf.install install: esmf.config
	@echo "Customized ESMF build step $@..."
	@(cd $(ESMF_DIR); $(MAKE) -e lib)
	@(cd $(ESMF_DIR); $(MAKE) -e install)
	@(cd $(ESMF_DIR)/src/addon/ESMPy; $(ESMF_PYTHON) setup.py build --ESMFMKFILE=$(ESMF_INSTALL_LIBDIR)/esmf.mk; $(ESMF_PYTHON) setup.py install --prefix=$(ESMF_INSTALL_PREFIX))
	@cp -pr $(ESMF_DIR)/cmake/*    $(ESMF_INSTALL_HEADERDIR)
	@touch esmf.install

# There once was an Intel 16 bug fixed, the ESMF apps can be built separately
esmf.python python: esmf.install
	@echo "Customized ESMF build step $@..."
	@(cd $(ESMF_DIR)/src/addon/ESMPy; $(ESMF_PYTHON) setup.py build --ESMFMKFILE=$(ESMF_INSTALL_LIBDIR)/esmf.mk; $(ESMF_PYTHON) setup.py install --prefix=$(ESMF_INSTALL_PREFIX))
	@touch esmf.python

# There once was an Intel 16 bug fixed, the ESMF apps can be built separately
esmf.pythoncheck pythoncheck: esmf.install
	@echo "Customized ESMF build step $@..."
	@(cd $(ESMF_DIR)/src/addon/ESMPy; export PYTHONPATH=$(ESMF_INSTALL_LIBDIR)/python2.7/site-packages; $(ESMF_PYTHON) setup.py test)

%: 
	@echo "Customized ESMF build step $@..."
	@(cd $(ESMF_DIR); $(MAKE) -e $@)

