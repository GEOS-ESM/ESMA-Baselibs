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
  ifneq ($(wildcard $(shell which nagfor 2> /dev/null)),)
        FC := nagfor
        ES_FC := $(FC)
        ESMF_COMPILER := nag
        FLAP_COMPILER := nag
  else
  ifneq ($(wildcard $(shell which ifort 2> /dev/null)),)
        FC := ifort
        ES_FC := $(FC)
        ESMF_COMPILER := ifort
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

  F77 := $(FC)
  F90 := $(FC)

# C compiler detection
# --------------------
  ifneq ($(wildcard $(shell which gcc 2> /dev/null)),)
        CC := gcc
  else
  ifneq ($(wildcard $(shell which icc 2> /dev/null)),)
        CC := icc
  else
  ifneq ($(wildcard $(shell which pgcc 2> /dev/null)),)
        CC := pgcc
  else
        CC := UNKNOWN
  endif
  endif
  endif

# C++ compiler detection
# ----------------------
  ifneq ($(wildcard $(shell which g++ 2> /dev/null)),)
        CXX := g++
  else
  ifneq ($(wildcard $(shell which icpc 2> /dev/null)),)
        CXX := icpc
  else
  ifneq ($(wildcard $(shell which pgc++ 2> /dev/null)),)
        CXX := pgc++
  else
        CXX := UNKNOWN
  endif
  endif
  endif

# ESMF C compiler detection
# -------------------------
  ifneq ($(wildcard $(shell which icc 2> /dev/null)),)
        ES_CC := icc
  else
  ifneq ($(wildcard $(shell which pgcc 2> /dev/null)),)
        ES_CC := pgcc
  else
  ifneq ($(wildcard $(shell which gcc 2> /dev/null)),)
        ES_CC := gcc
  else
        ES_CC  := UNKNOWN
  endif
  endif
  endif

# ESMF C++ compiler detection
# ---------------------------
  ifneq ($(wildcard $(shell which icpc 2> /dev/null)),)
        ES_CXX := icpc
  else
  ifneq ($(wildcard $(shell which pgc++ 2> /dev/null)),)
        ES_CXX := pgc++
  else
  ifneq ($(wildcard $(shell which g++ 2> /dev/null)),)
        ES_CXX := g++
  else
        ES_CXX := UNKNOWN
  endif
  endif
  endif

# MPI CC compiler detection
# --------------------
  ifeq ($(ESMF_COMM),intelmpi)
    ifeq ($(ES_CC),gcc)
      MPICC := mpigcc
    else
      MPICC := mpiicc
    endif
  else
  ifneq ($(wildcard $(shell which mpicc 2> /dev/null)),)
    MPICC := mpicc
  else
    MPICC := $(CC)
  endif
  endif

# MPI CXX compiler detection
# --------------------
  ifeq ($(ESMF_COMM),intelmpi)
    ifeq ($(ES_CC),g++)
      MPICXX := mpigxx
    else
      MPICXX := mpiicpc
    endif
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

# MPI FC compiler detection
# -------------------------
  ifeq ($(ESMF_COMM),intelmpi)
    ifeq ($(FC),gfortran)
      MPIFC := mpifc
    else
      MPIFC := mpiifort
      CPPDEFS += -DpgiFortran
    endif
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

  ifeq ($(ESMF_COMM),UNKNOWN)
     $(error Cannot detect ESMF MPI stack; please set ESMF_COMM)
  endif

# Where to install stuff
# ----------------------

  CONFIG_SETUP = $(FC)
  prefix := $(ROOTDIR)/$(SYSNAME)/$(CONFIG_SETUP)/$(ARCH)

