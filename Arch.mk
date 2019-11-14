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

# PGI
# ---
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

   PYTHON := $(dir $(shell which python))../

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
   CFLAGS := -fPIC 
   export CFLAGS

   # Gentoo puts tiprc files in a weird place
   ifneq (,$(wildcard /etc/gentoo-release))
      INC_EXTRA += -I/usr/include/tirpc
      LIB_EXTRA += -ltirpc
   endif

   ifeq ($(SITE),NCCS)
      ENABLE_GPFS = --enable-gpfs
      LINK_GPFS = -lgpfs
   endif

   ifeq ($(FC),gfortran)
      FFLAGS += -fno-second-underscore
      FCFLAGS += -fno-second-underscore
      CPPFLAGS += -DgFortran
   endif

endif

