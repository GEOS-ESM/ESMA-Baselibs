# Changelog
 
## Unreleased

### Updates
### Fixed
### Changed
### Removed

## [6.2.0] - 2021-MM-DD

### Updates

* Updates to GFE libraries. NOTE: Change to CMake linkage (see below)
  * gFTL v1.3.1
  * gFTL-shared v1.2.0
  * pFUnit v4.2.1
  * fArgParse v1.1.0
  * yaFyaml v0.5.1
  * pFlogger v1.5.0
  * GFE libraries are now
    *called* in a different way in projects that use GFE. For example,
    before you used:
    ```cmake
    target_link_libraries (library PUBLIC gftl gftl-shared)
    ```
    you will now use a CMake namespace:
    ```cmake
    target_link_libraries (library PUBLIC GFTL::gftl GFTL_SHARED::gftl-shared)
    ```
## [6.1.0] - 2021-03-30

### Updates

* ESMF 8.1.0
* cURL 7.76.0
* NCO 4.9.8

### Fixed

* Added patch for building ESMF 8.1.0 with NAG on Darwin

## [6.0.31] - 2021-03-17

### Changed

* Updated submodule URL for hdf4 to https://github.com/HDFGroup/hdf4.git
  as that is now the official URL for hdf4

## [6.0.30] - 2021-03-11

### Updates

* gFTL v1.2.8

## [6.0.29] - 2021-02-10

### Changed

* Add new `BUILD=GFE` to build only GFE libraries.

### Fixed

* CDO with `clang++` requires a new flag

## [6.0.28] - 2021-02-08

### Updates

* cURL 7.75.0
* NCO 4.9.7
* CDO 1.9.10
* nccmp 1.8.9.0

### Fixed

* Removed use of `-fcommon` workaround for nccmp (fixed in 1.8.9.0)
* Remove cdo as buildable with NAG Fortran
* Fixes for NAG detection
* Fixes for install targets that could use MPI. For some reason
  triggered at Berkeley
* Fixes to allow Intel icc on macOS
* Add support for Rome nodes at NAS
* Fix esmf sub-make commands (missing `$(ESMF_COMPILER)`)
* Remove gFTL-shared.check as it does nothing

## [6.0.27] - 2020-12-21

### Fixed

- Use of ifort at NAS was broken by changes to make the GNU Make
  system more robust
- HDF5 at NCCS with MPT requires an extra flag to compile

## [6.0.26] - 2020-12-09

### Updates

* cURL 7.74.0
* yaFyaml v0.4.2

### Fixed

* Fixes for GitHub Actions

## [6.0.25] - 2020-12-08

### Updates

* NCO 4.9.6

### Fixed

* Add patch for using antlr2 GitHub as it seems to have a bug. The patch
  makes it match the previous tarball

### Changed

* Moved to use antlr2 from https://github.com/nco/antlr2 as the download
  link broke
* Disabled the Java, Python, and C# builds for antlr2 as unneeded for
  NCO/ncap2

## [6.0.24] - 2020-11-25

### Fixed

- Explicitly turn off nghttp2 and nghttp3 support in cURL. It can
  sometimes find it in a Brew installation, but that could lead to
  linking in Brew includes and libraries.
- Fixed bug with using clang as C compiler
- Updated GitHub Actions workflow with new build image and fixed issues
  with build

### Changed

- Turned off default ESMPy build on Darwin with `esmf.install` due to
  odd RPATH issues. ESMPy can be built separately if needed.

## [6.0.23] - 2020-11-25

### Fixed

- GNU Make system reworked to be more generic. Older system assumed
  modules, `CC`, `FC`, etc were defined like at NCCS

## [6.0.22] - 2020-11-17

### Updates

* CDO 1.9.9

## Fixed

* Fixed issue javac-check where some java output version to stderr and
  some to stdout

## [6.0.21] - 2020-11-12

### Updates

* pFUnit v4.1.14
* fArgParse v1.0.2

## [6.0.20] - 2020-11-09

### Updates

* pFUnit v4.1.13

## Fixed

* GNU Make issues with javac detection
* Use force flag with patch commands
* Actually fix issue with Clang and Curl on macOS

## [6.0.19] - 2020-11-05

## Fixed

* Fixed issue with Clang and Curl on macOS

## Changed

* Remove hdfeos and hdfeos5 from default "all" build on macOS

## [6.0.18] - 2020-11-04

### Updates

* nccmp 1.8.8.0

### Fixed

- Use `autoreconf` with cURL
- Added workaround for building HDF4 and UDUNITS with clang

## [6.0.17] - 2020-10-20

### Updates

* cURL 7.73.0
* HDF5 1.10.7
* NCO 4.9.5

### Fixed

* Add `-fcommon` when building nccmp with GCC 10+ (see [this post](https://gitlab.com/remikz/nccmp/-/issues/14#note_416196531))

### Changed

* Moved to use new GitHub remote for HDF5

## [6.0.16] - 2020-08-25

### Updates

* gFTL v1.2.7
* fArgParse v1.0.1
 
## [6.0.15] - 2020-08-25

### Updates

* cURL 7.72.0
* gFTL v1.2.6
* pFUnit v4.1.12
* pFlogger v1.4.5
* yaFyaml v0.4.1
* fArgParse v1.0.0

## [6.0.14] - 2020-08-12

### Updates

* cURL 7.71.1
* NCO 4.9.3
* pFUnit v4.1.11
* pFlogger v1.4.3
* yaFyaml v0.4.0

### Fixed

* The tirpc workaround in `Arch.mk` also needs to be used on Fedora, so
  the detection is generalized

### Changed

* Download URLs for HDF-EOS2, HDF-EOS5, and SDP Toolkit have changed due to changes in hosting.
 
## [6.0.13] - 2020-05-22

### Updates

* ESMF 8.0.1
* gFTL-shared v1.0.7
* pFUnit v4.1.8
* pFlogger v1.4.2
* fArgParse v0.9.5
* yaFyaml v0.3.3

### Fixed

* Fixes for GCC 10
  * Added patch for netcdf issue with GCC 10
  * Added flag for HDF4 when using GCC 10
  * Need to pass in extra flags to ESMF when using GCC 10
* Fix for detection for `--enable-dap` with netcdf

### Changed

* Move to use ESMF GitHub repo

### Removed

* Removed patching of ESMF with move to snapshot 13

## [6.0.12] - 2020-05-01

### Updates

* cURL 7.70.0
* netCDF-C 4.7.4
* nccmp 1.8.7.0
* pFlogger v1.4.1
* FLAP geos/v1.9.0

### Fixed

* Added `patches/` directory to contain two patches:
   * A patch for ESMF on macOS for intelclang
   * A patch for HDF5 when using NAG
   * Updates to `GNUmakefile` to use the patches

## [6.0.11] - 2020-04-17

### Updates

* pFlogger v1.4.0

## [6.0.10] - 2020-04-13

### Fixed

* Build pFlogger with `Release` flags

## [6.0.9] - 2020-04-13

### Updates

* yaFyaml v0.3.1
* pFlogger v1.3.5

## [6.0.8] - 2020-04-09

### Updates

* gFTL-shared v1.0.5
* pFlogger v1.3.4

## [6.0.7] - 2020-04-07

### Updates

* gFTL v1.2.5
* gFTL-shared v1.0.4
* fArgParse v0.9.3
* pFUnit v4.1.7
* yaFyaml v0.3.0
* pFlogger v1.3.3

## [6.0.6] - 2020-03-30

### Reverted

* NCO 4.9.1

## [6.0.5] - 2020-03-18

### Added

* yaFyaml 0.2.1

### Updates

* cURL 7.69.1
* HDF4 4.2.14
* NCO 4.9.2
* pFlogger 1.3.1

## [6.0.4] - 2019-12-30

### Updates

* HDF5 1.10.6
* netCDF-C 4.7.3
* NCO 4.9.1
* nccmp 1.8.6.5
* fArgParse v0.9.2
* pFUnit v4.1.5

## [6.0.3] - 2019-12-11

### Updates

* NCO 4.9.0
* pFUnit v4.1.3
* nccmp 1.8.6.0
* FLAP from mathomp4 git fork version geos/v1.5.0

## [6.0.2] - 2019-11-18

### Updates

* cURL v7.67.0
* gFTL v1.2.2
* pFUnit v4.1.1
* fArgParse v0.9.1
* FLAP from mathomp4 git fork version geos/v1.4.0

### Changed

* Converted GSL to a downloaded library due to issues on SCU14
* Fixes to various scripting

## [6.0.1] - 2019-11-01

### Updates

* CDO 1.9.8
* ESMF 8_0_1_beta_snapshot_02
* FLAP from mathomp4 git fork version geos/v1.3.0

## [6.0.0] - 2019-10-31

### Updates

* GSL 2.6
* cURL 7.66.0
* netCDF-C 4.7.2
* netCDF-Fortran 4.5.2
* netCDF-CXX4 4.3.1
* ESMF 8.0.0
* pFUnit 4.0.1
* gFTL 1.2.0
* FLAP from mathomp4 git fork version geos/v1.2.0

### Removed

* Remove CMOR, uuid, h5edit
   * CMOR was removed because the package is best installed
     via Anaconda per its developers
   * uuid was removed because it was only a prerequisite of
     CMOR and was in fact a version that CMOR could no longer
     use
   * h5edit is no longer maintained

## Older Versions

For older versions of Baselibs please consult [ChangeLog-preV6](ChangeLog-preV6)
