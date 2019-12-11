# Changelog

## [6.0.3] - 2019-12-11

### Updates

* netCDF-C 4.7.3
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
