# Changelog

## [Unreleased]

### Updates
### Fixed

- Fix for building HDF5 with nvhpc

### Changed
### Removed
### Added

## [7.13.0] - 2023-05-24

### Updated

- esmf v8.5.0b22
- curl 8.1.1
- HDF5 1.10.10
- netCDF-C 4.9.2
- netCDF-Fortran 4.6.1
- CDO 2.2.0

## [7.12.0] - 2023-04-18

### Updates

- GFE v1.10.0
  - gFTL v1.10.0
  - gFTL-shared v1.6.0
  - fArgParse v1.5.0
  - pFUnit v4.7.0
  - yaFyaml v1.1.0
  - pFlogger v1.10.0
- curl 8.0.1
- NCO 5.1.5

### Fixed

- Fixed URL for CDO 2.1.1

## [7.11.0] - 2023-03-08

### Updates

- ESMF v8.5.0b18

## [7.10.0] - 2023-02-27

### Updates

- GFE v1.9.0
  - gFTL v1.8.3
  - gFTL-shared v1.5.1
  - fArgParse v1.4.2
  - pFUnit v4.6.3
  - yaFyaml v1.0.7
  - pFlogger v1.9.3
- curl 7.88.1
- Update `config.guess` to a newer version (for support for Graviton3 in future testing)

## [7.9.0] - 2023-01-25

### Updates

- ESMF v8.5.0b13
  - NOTE: This is a non-zero-diff change for GEOSgcm to precision changes in grid generation.

## [7.8.0] - 2023-01-20

### Updates

- curl 7.87.0
- NCO 5.1.4
- CDO 2.1.1
  - NOTE: CDO now requires C++17 so this means if you are building with Intel C++ (Classic), you should use GCC 11.1 or higher as
    the backing GCC compiler [per the Intel docs](https://www.intel.com/content/www/us/en/develop/documentation/cpp-compiler-developer-guide-and-reference/top/compiler-reference/compiler-options/language-options/std-qstd.html)

## [7.7.0] - 2022-11-17

### Updates

- GFE v1.8.0
  - fArgParse v1.4.1
  - pFUnit v4.6.1

## [7.6.1] - 2022-11-14

### Changed

- Restore HDF4 in the essential libraries

## [7.6.0] - 2022-11-04

### Updates

- ESMF v8.4.0
- zlib 1.2.13
- curl 7.86.0
- netCDF-C 4.9.0
- netCDF-Fortran 4.6.0
- NCO 5.1.1
- CDO 2.1.0

### Fixed

- CDO 2.1.0 requires `-std=c++17` to build with clang

## [7.5.1] - 2022-08-22

### Fixed

- Fixed issue with tarfile installer. Use `submodules: recursive` to get *all* submodules

### Changed

- Renamed tarfile GitHub Action for consistency
- Remove HDF4 from the essential libraries

## [7.5.0] - 2022-07-01

### Updates

- Reverted curl to 7.83.1
  - This is due to a bug compiling 7.84.0 with Intel `icc`

## [7.4.0] - 2022-07-01

### Updates

* GFE v1.4.0
* curl 7.84.0

## [7.3.1] - 2022-06-10

### Fixed

- Fixed issue with building ESMF with MPT

## [7.3.0] - 2022-06-09

### Updates

- ESMF v8.3.0

## [7.2.0] - 2022-06-03

### Added

* xgboost v1.6.0

### Updates

* GFE v1.3.1
* curl 7.83.1
* HDF5 1.10.9
* NCO 5.0.7
* CDO 2.0.5

### Removed

- Removed NAG HDF5 patch as 1.10.9 does not seem to need it anymore

## [7.1.0] - 2022-05-10

### Updates

- GFE v1.2.0

### Added

- Added preliminary ifx support to `Arch.mk` and `Base.mk`

## [7.0.0] - 2022-04-21

### Removed

- Remove separate GFE repos for omnibus GFE repo. Packages removed:
  - gFTL
  - gFTL-shared
  - fArgParse
  - pFlogger
  - pFUnit
  - yaFyaml

### Added

- GFE v1.1.0
  - gFTL v1.7.0
  - gFTL-shared v1.4.1
  - fArgParse v1.2.0
  - pFlogger v1.8.0
  - pFUnit v4.2.7
  - yaFyaml v1.0-beta8
    - NOTE: This update to yaFyaml is *incompatible* to previous versions. This has caused the tick in the major number for Baselibs

## [6.2.13] - 2022-03-09

### Updates

* ESMF v8.3.0b09 (fix for macOS)
* gFTL v1.5.5
* yaFyaml v1.0-beta5

## [6.2.12] - 2022-03-04

### Updates

* ESMF v8.3.0b08 (fix for NVHPC)
* jpeg 9e
* nco 5.0.6
* CDO 2.0.4
* FLAP geos/v1.10.0 (fix for NVHPC)

### Fixed

* Remove SDPToolkit as buildable with NVHPC

## [6.2.11] - 2022-01-26

### Updates

* netCDF-Fortran 4.5.4
* nco 5.0.5
* CDO 2.0.3
* gFTL v1.5.4

## [6.2.10] - 2021-12-15

### Fixed

- CDO 2 now requires C++14 standard on Darwin when using `clang++`

## [6.2.9] - 2021-12-06

### Updates

* curl 7.80.0
* HDF5 1.10.8
* nco 5.0.4
* ESMF 8_2_0
* CDO 2.0.1
* nccmp 1.9.1.0
* gFTL v1.5.3
* gFTL-shared v1.3.6
* yaFyaml v1.0-beta4
* pFUnit v4.2.2
* pFlogger v1.6.1
* fArgParse v1.1.2

### Added

- Added release tarball GitHub Action
- Added `.editorconfig` file

## [6.2.8] - 2021-10-07

### Updates

* curl 7.79.1
* netCDF-C 4.8.1
* nco 5.0.3
* ESMF 8_2_0_beta_snapshot_20
* gFTL v1.5.1
* gFTL-shared v1.3.2
* yaFyaml v1.0-beta3
* pFlogger v1.6.0

### Fixed

* Added a fix to remove `-pthread` when compiling with NAG

### Changed

* When installing ESMF, don't make success or failure of ESMPy required to touch the `esmf.install` file. This is because ESMPy is
  very twitchy and might not work on all platforms (e.g., AWS with limited Python). If ESMPy builds successfully, then an
  `esmf.python` file will be touched. (NOTE: It is much easier to get ESMPy via conda than via Baselibs in almost all
  circumstances.)

## [6.2.7] - 2021-08-03

### Updates

* GSL 2.7
* jpeg 9d
* curl 7.78.0
* netCDF-C 4.8.0
* ESMF 8_2_0_beta_snapshot_14
* nccmp 1.9.0.1

### Fixed

- Update Make System to support NVHPC (preliminary, not working)

### Changed

- Convert colons to spaces when making `MODULES` file for ease of re-use

### Removed

- Removed the ocprint patch used for netCDF-C and GCC 10 as it isn't needed with netCDF-C 4.8.0

## [6.2.6] - 2021-07-09

### Fixed

* Fixed bug with `-mmacosx-version-min` passed into curl. Now it tries to figure out what your macOS version is and use that
  (major.minor)

## [6.2.5] - 2021-06-08

### Fixed

* Fixed bug with ESMF and dynamic libraries. The "fix" is to run `make install` for ESMF twice until ESMF itself can be fixed.

## [6.2.4] - 2021-06-02

### Fixed

* Fixed bug with cURL as [7.77.0 now requires an SSL library to be explicitly chosen](https://daniel.haxx.se/blog/2021/04/23/please-select-your-tls/), or none at all.
  * On Linux, we supply `--with-openssl` as this works at NCCS, NAS, and on GMAO Desktops.
  * On macOS, there is no guarantee of OpenSSL (and even with Brew might be in a non-standard location)
    * If Clang is the C compiler, we can use SecureTransport and build with `--with-secure-transport`
    * If GCC is the C compiler, there is a [bug with the Security Framework](https://gcc.gnu.org/bugzilla/show_bug.cgi?id=93082), so we build without SSL, `--without-ssl`
* Disable netcdf-cxx4 build on Darwin. Has issues and is not a required-by-GEOS library
* cURL 7.77.0 on macOS 11.0 needs a different `-mmacosx-version-min`

### Changed

* Added a check to make sure the `prefix` Baselibs installs to ends in the `uname -s` "arch". This is still required by some GEOS scripts

## [6.2.3] - 2021-06-02

### Fixed

* Fixed make bug with SDPToolkit and new hdf-eos2 (was not installing some needed include files)

## [6.2.2] - 2021-06-02

### Updates

* ESMF 8_2_0_beta_snapshot_10
  * This beta is being used due to it fixing two bugs
    1. Fix for errors with alarms during replay
    2. Fix for regridding very-high resolution files
* cURL 7.77.0
* NCO 4.9.9
* HDF-EOS2 v3.0
* HDF-EOS5 v2.0

## [6.2.1] - 2021-04-26

### Updates

* ESMF 8.1.1
* cURL 7.76.1

### Fixed

* Updated URL for GSL download

### Changed

* Removed patch for building ESMF with NAG on Darwin (fixed in ESMF 8.1.1)

## [6.2.0] - 2021-04-26

### Updates

* Updates to GFE libraries. NOTE: Change to CMake linkage (see below)
  * gFTL v1.4.1
  * gFTL-shared v1.3.0
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

## [6.1.1] - 2021-05-12

### Fixed

* Updated URL for GSL download

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
