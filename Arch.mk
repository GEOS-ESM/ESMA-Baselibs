# Baselibs Build System
#
#    System/site dependent options.

#
# REVISION HISTORY:
#
# 08Aug2008  da Silva  Moved here from GNUmakefile for better CM.
#
#-------------------------------------------------------------------------

#
#                            ----------------
#                               Compiler
#                            ----------------
#

# Intel
# -----
  ifneq ($(wildcard $(shell which ifort 2> /dev/null)),)
       CPPFLAGS += -DpgiFortran
  endif

  ifneq ($(wildcard $(shell which ifx 2> /dev/null)),)
       CPPFLAGS += -DpgiFortran
  endif

# PGI
# ---
  ifneq ($(wildcard $(shell which nvfortran 2> /dev/null)),)
       CPPFLAGS += -DpgiFortran
       PGI_FLAG = -PGI
  endif

  ifneq ($(wildcard $(shell which pgfortran 2> /dev/null)),)
       CPPFLAGS += -DpgiFortran
       PGI_FLAG = -PGI
  endif

#
#                            ----------------
#                                Modules
#                            ----------------
#
  ifneq ($(LMOD_CMD),)
     LMODULECMD = $(LMOD_CMD)
  else
     MODULECMD = $(shell which modulecmd 2> /dev/null)
  endif

#
#                            ----------------
#                                 Python
#                            ----------------
#

   PYTHON := $(dir $(shell which python3))../

#
#                            ----------------
#                                 Linux
#                            ----------------
#

ifeq ($(ARCH),Linux)
   SITE := $(patsubst discover%,NCCS,$(SITE))
   SITE := $(patsubst dali%,NCCS,$(SITE))
   SITE := $(patsubst borg%,NCCS,$(SITE))
   SITE := $(patsubst pfe%,NAS,$(SITE))
   SITE := $(patsubst afe%,NAS,$(SITE))
   SITE := $(patsubst athfe%,NAS,$(SITE))
   # This detects compute nodes at NAS
   ifneq ($(shell uname -n | egrep 'r[0-9]*i[0-9]*n[0-9]*'),)
      SITE := NAS
   endif
   ifneq ($(shell uname -n | egrep 'r[0-9]*c[0-9]*t[0-9]*n[0-9]*'),)
      SITE := NAS
   endif
   ifneq ($(shell uname -n | egrep 'x[0-9]*c[0-9]*s[0-9]*b[0-9]*n[0-9]*'),)
      SITE := NAS
   endif
   CFLAGS := -fPIC
   export CFLAGS

   # Gentoo and Fedora put tiprc files in a weird place
   ifneq (,$(wildcard /usr/include/tirpc/.))
      INC_EXTRA += -I/usr/include/tirpc
      LIB_EXTRA += -ltirpc
   endif

   ifeq ($(SITE),NCCS)
      ENABLE_GPFS = --enable-gpfs
      LINK_GPFS = -lgpfs

      # On SLES15 at NCCS we need to link to libtirpc
      OS_VERSION := $(shell grep VERSION_ID /etc/os-release | cut -d= -f2 | cut -d. -f1 | sed 's/"//g')
      ifeq ($(OS_VERSION),15)
         LIB_EXTRA += -ltirpc
      endif
   endif

   ifeq ($(findstring gfortran,$(notdir $(FC))),gfortran)
      FFLAGS += -fno-second-underscore
      FCFLAGS += -fno-second-underscore
      CPPFLAGS += -DgFortran
   endif

endif

