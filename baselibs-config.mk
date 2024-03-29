# C Version
# ---------

ifeq ($(findstring icc,$(notdir $(CC))),icc)
   CC_VERSION := $(shell $(CC) --version | awk '{ if(NR==1) print $$3}')
else
ifeq ($(findstring pgcc,$(notdir $(CC))),pgcc)
   CC_VERSION := $(shell $(CC) --version | awk '{ if(NR==2) print $$2}')
else
ifeq ($(findstring gcc,$(notdir $(CC))),gcc)
   CC_VERSION := $(shell $(CC) --version | awk '{ if(NR==1) print $$3}')
else
ifeq ($(findstring clang,$(notdir $(CC))),clang)
   CC_VERSION := $(shell $(CC) --version | awk '{ if(NR==1) print $$4}')
endif
endif
endif
endif

MPICC_COMPILER := $(shell $(MPICC) --version | awk '{ if(NR==1) print $$1}')
ifeq ($(MPICC_COMPILER),)
   MPICC_COMPILER := $(shell $(MPICC) --version | awk '{ if(NR==2) print $$1}')
endif

MPICC_VERSION := $(shell $(MPICC) --version | awk '{ if(NR==1) print $$3}')
ifeq ($(MPICC_VERSION),)
   MPICC_VERSION := $(shell $(MPICC) --version | awk '{ if(NR==2) print $$2}')
endif

# C++ Version
# -----------

ifeq ($(findstring icpc,$(notdir $(CXX))),icpc)
   CXX_VERSION := $(shell $(CXX) --version | awk '{ if(NR==1) print $$3}')
else
ifeq ($(findstring pg++,$(notdir $(CXX))),pg++)
   CXX_VERSION := $(shell $(CXX) --version | awk '{ if(NR==2) print $$2}')
else
ifeq ($(findstring clang++,$(notdir $(CXX))),clang++)
   CXX_VERSION := $(shell $(CXX) --version | awk '{ if(NR==1) print $$4}')
else
ifeq ($(findstring g++,$(notdir $(CXX))),g++)
   CXX_VERSION := $(shell $(CXX) --version | awk '{ if(NR==1) print $$3}')
endif
endif
endif
endif

MPICXX_COMPILER := $(shell $(MPICXX) --version | awk '{ if(NR==1) print $$1}')
ifeq ($(MPICXX_COMPILER),)
   MPICXX_COMPILER := $(shell $(MPICXX) --version | awk '{ if(NR==2) print $$1}')
endif

MPICXX_VERSION := $(shell $(MPICXX) --version | awk '{ if(NR==1) print $$3}')
ifeq ($(MPICXX_VERSION),)
   MPICXX_VERSION := $(shell $(MPICXX) --version | awk '{ if(NR==2) print $$2}')
endif

# Fortran Version
# ---------------

FORTRAN_VERSION := --version
ifeq ($(findstring nagfor,$(notdir $(FC))),nagfor)
   FC_VERSION := $(shell $(FC) -V 2>&1 >/dev/null | awk -F" " '{ if(NR==1) print $$5,$$6,$$7}')
   MPIFC_COMPILER := $(FC)
   MPIFC_VERSION := $(FC_VERSION)
   FORTRAN_VERSION := -V
else
ifeq ($(findstring ifort,$(notdir $(FC))),ifort)
   FC_VERSION := $(shell $(FC) --version | awk '{ if(NR==1) print $$3}')
else
ifeq ($(findstring pgfortran,$(notdir $(FC))),pgfortran)
   FC_VERSION := $(shell $(FC) --version | awk '{ if(NR==2) print $$2}')
else
ifeq ($(findstring gfortran,$(notdir $(FC))),gfortran)
   FC_VERSION := $(shell $(FC) --version | awk '{ if(NR==1) print $$4}')
endif
endif
endif
endif

# We should not do this if FC is nagfor
ifeq ($(findstring nagfor,$(notdir $(FC))),nagfor)
MPIFC_COMPILER := $(FC)
else
MPIFC_COMPILER := $(shell $(MPIFC) $(FORTRAN_VERSION) | awk '{ if(NR==1) print $$1}')
ifeq ($(MPIFC_COMPILER),)
   MPIFC_COMPILER := $(shell $(MPIFC) $(FORTRAN_VERSION) | awk '{ if(NR==2) print $$1}')
endif
endif

# ---------------------
# Make the sedfile body
# ---------------------

define CONFIG_SEDFILE_BODY
s?###CC###?$(CC)?g
s?###CC_VERSION###?$(CC_VERSION)?g

s?###CXX###?$(CXX)?g
s?###CXX_VERSION###?$(CXX_VERSION)?g

s?###FC###?$(FC)?g
s?###FC_VERSION###?$(FC_VERSION)?g
s?###FORTRAN_VERSION###?$(FORTRAN_VERSION)?g

s?###MPICC###?$(MPICC)?g
s?###MPICC_COMPILER###?$(MPICC_COMPILER)?g
s?###MPICC_VERSION###?$(MPICC_VERSION)?g

s?###MPICXX###?$(MPICXX)?g
s?###MPICXX_COMPILER###?$(MPICXX_COMPILER)?g
s?###MPICXX_VERSION###?$(MPICXX_VERSION)?g

s?###MPIFC###?$(MPIFC)?g
s?###MPIFC_COMPILER###?$(MPIFC_COMPILER)?g
s?###MPIFC_VERSION###?$(MPIFC_VERSION)?g


s?###prefix###?$(prefix)?g
s?###includedir###?$(prefix)/include?g
s?###bindir###?$(prefix)/bin?g
s?###VERSIONNUM###?$(VERSIONNUM)?g
s?###CONFIG_SETUP###?$(CONFIG_SETUP)?g
s?###ESMF_COMM###?$(ESMF_COMM)?g
endef

export CONFIG_SEDFILE_BODY
