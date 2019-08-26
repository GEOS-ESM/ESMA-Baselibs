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

  ESMF_BOPT           ?= O
  ESMF_INSTALL_PREFIX ?= $(prefix)
  ESMF_COMPILER       ?= $(FC)
  ESMF_PIO            ?= internal
  ESMF_MACHINE        ?= $(MACH)
  ESMF_OS             ?= $(ARCH)
  ESMF_PYTHON         ?= $(PYTHON)/bin/python

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

  $(warning Using $(ESMF_COMPILER) as the ESMF compiler (FC=$(FC)))
  $(warning Using $(ESMF_MACHINE)  as the ESMF machine)
  $(warning Using $(ESMF_OS)  as the ESMF OS)
  $(warning Using $(ESMF_PYTHON)  as the ESMF python)
  $(warning Using $(ESMF_SED)  as the ESMF sed)

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

export ESMF_DIR ESMF_BOPT ESMF_COMPILER ESMF_INSTALL_PREFIX ESMF_OS

esmf.config config: 
	@echo "Customized ESMF build..."
	@touch esmf.config

esmf.all all: esmf.config
	@echo "Customized ESMF build..."
	@(cd $(ESMF_DIR); $(MAKE) -e all)

esmf.lib lib: esmf.config
	@echo "Customized ESMF build..."
	@(cd $(ESMF_DIR); $(MAKE) -e lib)

esmf.info info:
	@echo "ESMF configuration"
	@(cd $(ESMF_DIR); $(MAKE) -e info)

esmf.script_info script_info:
	@echo "ESMF configuration"
	@(cd $(ESMF_DIR); $(MAKE) -e script_info)

esmf.check check:
	@echo "ESMF configuration"
	@(cd $(ESMF_DIR); $(MAKE) -e check)
	@(cd $(ESMF_DIR)/src/addon/ESMPy; export PYTHONPATH=$(ESMF_INSTALL_PREFIX)/lib/python2.7/site-packages; $(ESMF_PYTHON) setup.py test)
	@touch esmf.check

esmf.examples:
	@echo "Running ESMF Examples..."
	@(cd $(ESMF_DIR); $(MAKE) -e examples)

esmf.clean clean:
	@echo "Customized ESMF build..."
	@(cd $(ESMF_DIR); $(MAKE) -e clean)

esmf.distclean distclean:
	@echo "Customized ESMF build..."
	@(cd $(ESMF_DIR); $(MAKE) -e distclean)

# Do installation from here to avoid ESMF's weird directory names
esmf.install install: esmf.config
	@echo "Customized ESMF build..."
	@(cd $(ESMF_DIR); $(MAKE) -e lib)
	@mkdir -p                          $(ESMF_INSTALL_PREFIX)/lib	
	-@cp -pr $(ESMF_DIR)/lib/*/*/*     $(ESMF_INSTALL_PREFIX)/lib
	@$(ESMF_SED) 's#(ESMF_APPSDIR=).*#\1$(ESMF_INSTALL_PREFIX)/lib#' $(ESMF_INSTALL_PREFIX)/lib/esmf.mk
	@$(ESMF_SED) 's#(ESMF_LIBSDIR=).*#\1$(ESMF_INSTALL_PREFIX)/lib#' $(ESMF_INSTALL_PREFIX)/lib/esmf.mk
	@rm $(ESMF_INSTALL_PREFIX)/lib/esmf.mk.bak
	@mkdir -p                          $(ESMF_INSTALL_PREFIX)/include/esmf
	-@cp -pr $(ESMF_DIR)/mod/*/*/*     $(ESMF_INSTALL_PREFIX)/include/esmf
	-@cp -pr $(ESMF_DIR)/src/include/* $(ESMF_INSTALL_PREFIX)/include/esmf
	@(cd $(ESMF_DIR); $(MAKE) -e build_apps ESMF_LDIR=$(ESMF_INSTALL_PREFIX)/lib ESMF_LIBDIR=$(ESMF_INSTALL_PREFIX)/lib ESMF_MODDIR=$(ESMF_INSTALL_PREFIX)/include/esmf)
	@mkdir -p                          $(ESMF_INSTALL_PREFIX)/bin
	-@cp -pr $(ESMF_DIR)/apps/*/*/*    $(ESMF_INSTALL_PREFIX)/bin
	@(cd $(ESMF_DIR)/src/addon/ESMPy; $(ESMF_PYTHON) setup.py build --ESMFMKFILE=$(ESMF_INSTALL_PREFIX)/lib/esmf.mk; $(ESMF_PYTHON) setup.py install --prefix=$(ESMF_INSTALL_PREFIX))
	@touch esmf.install

# There once was an Intel 16 bug fixed, the ESMF apps can be built separately
esmf.apps apps: esmf.install
	@(cd $(ESMF_DIR); $(MAKE) -e build_apps ESMF_LDIR=$(ESMF_INSTALL_PREFIX)/lib ESMF_LIBDIR=$(ESMF_INSTALL_PREFIX)/lib ESMF_MODDIR=$(ESMF_INSTALL_PREFIX)/include/esmf)
	@mkdir -p                          $(ESMF_INSTALL_PREFIX)/bin
	-@cp -pr $(ESMF_DIR)/apps/*/*/*    $(ESMF_INSTALL_PREFIX)/bin

# There once was an Intel 16 bug fixed, the ESMF apps can be built separately
esmf.python python: esmf.install
	@(cd $(ESMF_DIR)/src/addon/ESMPy; $(ESMF_PYTHON) setup.py build --ESMFMKFILE=$(ESMF_INSTALL_PREFIX)/lib/esmf.mk; $(ESMF_PYTHON) setup.py install --prefix=$(ESMF_INSTALL_PREFIX))
	@touch esmf.python

# There once was an Intel 16 bug fixed, the ESMF apps can be built separately
esmf.pythoncheck pythoncheck: esmf.install
	@(cd $(ESMF_DIR)/src/addon/ESMPy; export PYTHONPATH=$(ESMF_INSTALL_PREFIX)/lib/python2.7/site-packages; $(ESMF_PYTHON) setup.py test)

%: 
	@echo "Customized ESMF build..."
	@(cd $(ESMF_DIR); $(MAKE) -e $@)

