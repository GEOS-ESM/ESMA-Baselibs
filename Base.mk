# Baselibs Build System
#
# Compiler and other general defaults. Do not enter system dependent options
# in here; use Arch.mk instead.
#
# REVISION HISTORY:
#
# 08Aug2008  da Silva  Moved here from GNUmakefile for better CM.
#
#-------------------------------------------------------------------------


#                          -----------
#                          Environment
#                          -----------

# System idenfication
# -------------------
  SHELL   := /bin/sh
  ROOTDIR := $(shell dirname `pwd`)
  SYSNAME := $(shell ./config.guess)
  ARCH    := $(shell uname -s)
  SITE    := $(shell uname -n)
  MACH    := $(shell uname -m)
  INSTALL_OPT := /usr/bin/install -c
  VERSIONNUM := $(shell cat VERSION)

#                       ------------------
#                       Compiler Detection
#                       ------------------

# Fortran compiler detection
# --------------------------
  FC_FROM_ENV := FALSE
  ifneq ($(origin FC),undefined)
    ifeq ($(findstring nagfor,$(notdir $(FC))),nagfor)
      ES_FC := $(FC)
      ESMF_COMPILER := nag
      FLAP_COMPILER := nag
      FC_FROM_ENV := TRUE
    else
    ifeq ($(findstring ifort,$(notdir $(FC))),ifort)
      ES_FC := $(FC)
      ESMF_COMPILER := intel
      FLAP_COMPILER := intel
      FC_FROM_ENV := TRUE
    else
    ifeq ($(findstring pgfortran,$(notdir $(FC))),pgfortran)
      ES_FC := $(FC)
      ESMF_COMPILER := pgi
      FLAP_COMPILER := pgi
      FC_FROM_ENV := TRUE
    else
    ifeq ($(findstring gfortran,$(notdir $(FC))),gfortran)
      ES_FC := $(FC)
      EXCEPTIONS := -fexceptions
      ESMF_COMPILER := gfortran
      FLAP_COMPILER := gnu
      FC_FROM_ENV := TRUE
    endif
    endif
    endif
    endif
  else
  ifneq ($(wildcard $(shell which nagfor 2> /dev/null)),)
    FC := nagfor
    ES_FC := $(FC)
    ESMF_COMPILER := nag
    FLAP_COMPILER := nag
  else
  ifneq ($(wildcard $(shell which ifort 2> /dev/null)),)
    FC := ifort
    ES_FC := $(FC)
    ESMF_COMPILER := intel
    FLAP_COMPILER := intel
  else
  ifneq ($(wildcard $(shell which pgfortran 2> /dev/null)),)
    FC := pgfortran
    ES_FC := $(FC)
    ESMF_COMPILER := pgi
    FLAP_COMPILER := pgi
  else
  ifneq ($(wildcard $(shell which gfortran 2> /dev/null)),)
    FC := gfortran
    ES_FC := $(FC)
    EXCEPTIONS := -fexceptions
    ESMF_COMPILER := gfortran
    FLAP_COMPILER := gnu
  else
    FC := UNKNOWN
    ES_FC := $(FC)
  endif
  endif
  endif
  endif
  endif

  F77 := $(FC)
  F90 := $(FC)

# C compiler detection
# --------------------
  CC_IS_CLANG := FALSE
  CC_FROM_ENV := FALSE
  ifneq ($(origin CC),undefined)
    ifeq ($(findstring gcc,$(notdir $(CC))),gcc)
      TEST_FOR_CC_CLANG := $(findstring clang, $(shell $(CC) --version))
      ifeq ($(TEST_FOR_CC_CLANG),clang)
         CC_IS_CLANG := TRUE
      endif
      ES_CC := $(CC)
      CC_FROM_ENV := TRUE
    else
    ifeq ($(findstring icc,$(notdir $(CC))),icc)
      ES_CC := $(CC)
      CC_FROM_ENV := TRUE
    else
    ifeq ($(findstring clang,$(notdir $(CC))),clang)
      ES_CC := $(CC)
      CC_FROM_ENV := TRUE
      CC_IS_CLANG := TRUE
    else
    ifeq ($(findstring pgcc,$(notdir $(CC))),pgcc)
      ES_CC := $(CC)
      CC_FROM_ENV := TRUE
    endif
    endif
    endif
    endif
  else
  ifneq ($(wildcard $(shell which gcc 2> /dev/null)),)
    CC := gcc
    TEST_FOR_CC_CLANG := $(findstring clang, $(shell $(CC) --version))
    ifeq ($(TEST_FOR_CC_CLANG),clang)
      CC_IS_CLANG := TRUE
    endif
    ifneq (,$(findstring clang,$(ESMF_COMPILER)))
      CC := clang
      CC_IS_CLANG := TRUE
    endif
    ES_CC := $(CC)
  else
  ifneq ($(wildcard $(shell which icc 2> /dev/null)),)
    CC := icc
    ES_CC := $(CC)
  else
  ifneq ($(wildcard $(shell which clang 2> /dev/null)),)
    CC := clang
    ES_CC := $(CC)
    CC_IS_CLANG := TRUE
  else
  ifneq ($(wildcard $(shell which pgcc 2> /dev/null)),)
    CC := pgcc
    ES_CC := $(CC)
  else
    CC := UNKNOWN
  endif
  endif
  endif
  endif
  endif

# C++ compiler detection
# ----------------------
  CXX_IS_CLANG := FALSE
  CXX_FROM_ENV := FALSE
  ifneq ($(origin CXX),undefined)
    ifeq ($(findstring g++,$(notdir $(CXX))),g++)
      TEST_FOR_CXX_CLANG := $(findstring clang, $(shell $(CXX) --version))
      ifeq ($(TEST_FOR_CXX_CLANG),clang)
         CXX_IS_CLANG := TRUE
      endif
      ES_CXX := $(CXX)
      CXX_FROM_ENV := TRUE
    else
    ifeq ($(findstring icpc,$(notdir $(CXX))),icpc)
      ES_CXX := $(CXX)
      CXX_FROM_ENV := TRUE
    else
    ifeq ($(findstring clang++,$(notdir $(CXX))),clang++)
      ES_CXX := $(CXX)
      CXX_FROM_ENV := TRUE
      CXX_IS_CLANG := TRUE
    else
    ifeq ($(findstring pgc++,$(notdir $(CXX))),pgc++)
      ES_CXX := $(CXX)
      CXX_FROM_ENV := TRUE
    endif
    endif
    endif
    endif
  else
  ifneq ($(wildcard $(shell which g++ 2> /dev/null)),)
    CXX := g++
    TEST_FOR_CXX_CLANG := $(findstring clang, $(shell $(CXX) --version))
    ifeq ($(TEST_FOR_CXX_CLANG),clang)
      CXX_IS_CLANG := TRUE
    endif
    ifneq (,$(findstring clang,$(ESMF_COMPILER)))
      CXX := clang++
      CXX_IS_CLANG := TRUE
    endif
    ES_CXX := $(CXX)
  else
  ifneq ($(wildcard $(shell which icpc 2> /dev/null)),)
    CXX := icpc
    ES_CXX := $(CXX)
  else
  ifneq ($(wildcard $(shell which pgc++ 2> /dev/null)),)
    CXX := pgc++
    ES_CXX := $(CXX)
  else
    CXX := UNKNOWN
    ES_CXX := $(CXX)
  endif
  endif
  endif
  endif

# MPI CC compiler detection
# --------------------
  ifeq ($(ESMF_COMM),intelmpi)
    ifeq ($(findstring gcc,$(notdir $(CC))),gcc)
      MPICC := mpigcc
    else
      MPICC := mpiicc
    endif
  else
  ifeq ($(ESMF_COMM),openmpi)
    MPICC := mpicc
  else
  ifneq ($(wildcard $(shell which mpicc 2> /dev/null)),)
    MPICC := mpicc
  else
    MPICC := $(CC)
  endif
  endif
  endif

# MPI CXX compiler detection
# --------------------
  ifeq ($(ESMF_COMM),intelmpi)
    ifeq ($(findstring g++,$(notdir $(CXX))),g++)
      MPICXX := mpigxx
    else
      MPICXX := mpiicpc
    endif
  else
  ifeq ($(ESMF_COMM),openmpi)
    MPICXX := mpic++
  else
  ifneq ($(wildcard $(shell which mpic++ 2> /dev/null)),)
    MPICXX := mpic++
  else
  ifneq ($(wildcard $(shell which mpicxx 2> /dev/null)),)
    MPICXX := mpicxx
  else
    MPICXX := $(CXX)
  endif
  endif
  endif
  endif

# MPI FC compiler detection
# -------------------------
  ifeq ($(ESMF_COMM),intelmpi)
    ifeq ($(findstring gfortran,$(notdir $(FC))),gfortran)
      MPIFC := mpifc
    else
      MPIFC := mpiifort
      CPPDEFS += -DpgiFortran
    endif
  else
  ifeq ($(ESMF_COMM),openmpi)
    MPIFC := mpifort
  else
  ifneq ($(wildcard $(shell which mpifort 2> /dev/null)),)
    MPIFC := mpifort
  else
  ifneq ($(wildcard $(shell which mpif90 2> /dev/null)),)
    MPIFC := mpif90
  else
    MPIFC := $(FC)
  endif
  endif
  endif
  endif

# ESMF_COMPILER Fixup
# -------------------

ifeq ($(ESMF_COMPILER),intel)
  ifeq ($(CXX_IS_CLANG),TRUE)
    ESMF_COMPILER := intelclang
  else
  ifeq ($(findstring g++,$(notdir $(CXX))),g++)
    ESMF_COMPILER := intelgcc
  endif
  endif
endif

ifeq ($(ESMF_COMPILER),gfortran)
  ifeq ($(CXX_IS_CLANG),TRUE)
    ESMF_COMPILER := gfortranclang
  endif
endif

# MPT CC and CXX fixup
# --------------------

  ifeq ($(ESMF_COMM),mpt)
    MPICC := mpicc
    ifeq ($(findstring ifort,$(notdir $(FC))),ifort)
      CC := gcc
      CC_FROM_ENV := FALSE
    endif
  endif
  ifeq ($(ESMF_COMM),mpt)
    MPICXX := mpicxx
    ifeq ($(findstring ifort,$(notdir $(FC))),ifort)
      CXX := g++
      CXX_FROM_ENV := FALSE
    endif
  endif

# Make sure we have compilers
# ---------------------------
  ifeq ($(FC),UNKNOWN)
     $(error Cannot detect a Fortran compiler; please set FC)
  endif

  ifeq ($(CC),UNKNOWN)
     $(error Cannot detect a Fortran compiler; please set CC)
  endif

  ifeq ($(CXX),UNKNOWN)
     $(error Cannot detect a C++ compiler; please set CXX)
  endif

#                       ------------------
#                         Other Defaults
#                       ------------------

# ESMF default options
# --------------------
  ESMF_DIR  := $(shell pwd)/esmf
  ESMF_COMM ?= UNKNOWN
  ESMF_OS   := $(ARCH)

  ifeq (,$(filter $(MAKECMDGOALS),download dist))
  ifeq ($(ESMF_COMM),UNKNOWN)
     $(error Cannot detect ESMF MPI stack; please set ESMF_COMM)
  endif
  endif

# Where to install stuff
# ----------------------

  CONFIG_SETUP = $(notdir $(FC))
  prefix := $(ROOTDIR)/$(SYSNAME)/$(CONFIG_SETUP)/$(ARCH)

# Check to make sure prefix has ARCH because GEOS requires it still
# -----------------------------------------------------------------

  LAST_NODE_IN_PREFIX = $(lastword $(subst /, ,$(prefix)))
  ifneq ($(findstring $(ARCH),$(LAST_NODE_IN_PREFIX)),$(ARCH))
     $(error The last directory of the installation prefix $(prefix) must be $(ARCH) due to limitations in GEOS)
  endif

