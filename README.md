# ESMA Baselibs

![Build Latest Release](https://github.com/GEOS-ESM/ESMA-Baselibs/workflows/Build%20Baselibs/badge.svg?event=release)

This git repository contains a simplified version of the "baselibs"
module first developed by Gerhard Theurich and later maintained by
Eugene Mirvis, Denis Nadeau, and Matthew Thompson. The current version
only includes a minimal set of libraries needed for building GEOS at
NASA/GSFC.

## Current State of Libraries

| Library                                                                  | Version      |
| ---                                                                      | ---          |
| [ESMF](https://github.com/esmf-org/esmf)                                 | v8.9.0b09    |
| [FMS](https://github.com/NOAA-GFDL/FMS/)                                 | 2024.03      |
| [netCDF](https://github.com/Unidata/netcdf-c)                            | 4.9.2        |
| [netCDF Fortran](https://github.com/Unidata/netcdf-fortran)              | 4.6.1        |
| [netCDF C++](https://github.com/Unidata/netcdf-cxx4)                     | 4.3.1        |
| [HDF5](https://portal.hdfgroup.org/display/support)                      | 1.14.5       |
| [HDF4](https://portal.hdfgroup.org/display/support)                      | 4.2.16-2     |
| [GFE](https://github.com/Goddard-Fortran-Ecosystem/GFE)                  | v1.19.0      |
| [xgboost](https://github.com/dmlc/xgboost)                               | v1.6.0       |
| [libyaml](https://github.com/yaml/libyaml.git)                           | 0.2.5        |
| [antlr2](https://www.antlr2.org/)                                        | 2.7.7        |
| [GSL](https://www.gnu.org/software/gsl/)                                 | 2.8          |
| [jpeg](http://www.ijg.org/)                                              | 9f           |
| [zlib](http://www.zlib.net/)                                             | 1.3.1        |
| [szip](https://support.hdfgroup.org/doc_resource/SZIP/)                  | 2.1.1        |
| [curl](https://curl.haxx.se/)                                            | 8.13.0       |
| [UDUNITS2](https://github.com/GMAO-SI-Team/UDUNITS-2.git)                | 2.2.28       |
| [NCO](http://nco.sourceforge.net/)                                       | 5.3.3        |
| [CDO](https://code.mpimet.mpg.de/projects/cdo)                           | 2.5.1        |
| [nccmp](https://gitlab.com/remikz/nccmp)                                 | 1.9.1.0      |
| [HDF-EOS2](https://wiki.earthdata.nasa.gov/display/DAS)                  | 3.0          |
| [HDF-EOS5](https://wiki.earthdata.nasa.gov/display/DAS)                  | 2.0          |
| [SDP Toolkit](https://wiki.earthdata.nasa.gov/display/DAS)               | 5.2.20       |

## Installation Instructions

### Requirements

- C compiler, preferably gcc

- Fortran compiler. Tested compilers are GNU, Intel, and NAG.
  PGI support was once available, but has not been tested in a while.

- The MPI library. On a Linux desktop/laptop, Open MPI is recommended.
  Make sure mpicc, mpifort, etc is on your path. Try compiling a simple
  "Hello, world!" program with mpicc and running it; sometimes you need
  to set your `LD_LIBRARY_PATH` so that the runtime MPI libraries can be
  found.

  Linux Note: many Linux distributions now have Open MPI packages.
              However these either lack Fortran altogether or
              use gfortran. You must have Open MPI with Fortran
              support, and the Fortran compiler used to build MPI
              must the Fortran compiler you will be using.

- on Linux, make sure "bison" and "flex" are installed; on generic Unix
  platforms, make sure you have "yacc" and "lex".

- on Darwin, GNU sed is needed for ESMF Applications. This sed must be
  visible as sed (and not, say, gsed as installed by Brew)

- CMake of a recent vintage

### Obtaining ESMA Baselibs

ESMA Baselibs can be obtained in two ways via a tarball or through git.

#### Tarball

Recent releases of ESMA Baselibs have a complete tarball uploaded as an
asset on the Releases page. These are the files denoted by:
```
ESMA-Baselibs-x.y.z.COMPLETE.tar.xz
```

The `COMPLETE` indicates that they have completed all the steps needed
to get Baselibs via git (see below). Note that to save space, this
tarball is tarred with `--exclude-vcs` so the libraries that are
normally git repositories, will not be in this tarball.

#### Git Clone

ESMA Baselibs is based on submodules so you need to clone with:

```
git clone --recurse-submodules -b <TAG> https://github.com/GEOS-ESM/ESMA-Baselibs.git
```

##### Download non-git Libraries

Note that there is an additional step needed for building a complete
ESMA Baselibs when retrieved via Git. There are six libraries that are not on git at present:

* GSL
* szlib
* CDO
* HDF-EOS
* HDF-EOS 5
* SDP Toolkit

to get these libraries, run:
```
make download
```
Note that this step will occur automatically the first time Baselibs is
built, but in case you want to build on a system without internet
access (say, a compute node), this command should be run first on a head
node.

### Build Instructions

If you are feeling lucky, building can be just as simple as

```
cd ESMA-Baselibs
make install ESMF_COMM=<mpistack> (prefix=<dir>)
make verify ESMF_COMM=<mpistack>
```
where `<mpistack>` is one of the ESMF MPI stack names, such as:

- mpt
- openmpi
- mpich
- mvapich2
- intelmpi

see `esmf/INSTALL` for more information.

You can optionally pass in a `prefix` to determine where Baselibs will
be built. If you don't, the system uses `config.guess` =>
`x86_64-pc-linux-gnu` (on most Linux) to install to:
```
../x86_64-pc-linux-gnu/$FC/Linux
```

### Customizing The Installation

If the Baselibs do not build out of the repository, then you will
need to customize a few things. For example, to choose the ifort
compiler under Linux, just enter this

- `BUILD=ESSENTIALS`

  Use this to only build the libraries essential for building and
  running GEOS GCM

- `BUILD=MAPL`

  Use this to only build the libraries essential for building and
  running MAPL

- `CONFIG_SETUP`

  This is to help detail what combination of compiler and
  MPI was used. If unspecified, the default is the value
  of `FC`

- `ROOTDIR`

  Root directory for installing the binaries; the installation directory
  will be at

  ```
  prefix = $(ROOTDIR)/$(SYSNAME)/$(CONFIG_SETUP)/$(ARCH)
  ```

  where $(ARCH) is the result of `uname -s`, e.g., Linux.

- `prefix`

  Bypass the definition above and install at this directory. It is no
  recommended that you specify this - specify ROOTDIR instead

### Using Baselibs in GEOS

For GEOS, if you have `BASEDIR` set in your environment which points to the location where
the `lib/`, `bin/`, etc. directories exist, you need do nothing else.
If not, you'll need to pass in the Baselibs as:

```
cmake .. -DBASEDIR=<BASEDIR_LOC> ...
```
where `BASEDIR_LOC` is such that `BASEDIR_LOC/lib`, etc. exists.

For additional information, contact Matthew.Thompson@nasa.gov


## Contributing

Please check out our [contributing guidelines](CONTRIBUTING.md).

## License

All files are currently licensed under the Apache-2.0 license, see [`LICENSE`](LICENSE).

Previously, the code was licensed under the [NASA Open Source Agreement, Version 1.3](LICENSE-NOSA).
