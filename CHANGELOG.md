# Changelog
 
## Unreleased

### Updates
### Fixed

- Use `autoreconf` with cURL

### Changed

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
