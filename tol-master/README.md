# TOL = Time-Oriented Language

**TOL** is a powerful mathematical and statistical programming language designed for time series analysis, econometric modeling, and scientific computing. This repository contains the complete TOL ecosystem including the core interpreter, GUI applications, and comprehensive testing framework.

## 🚀 **Quick Start**

### **Linux Users**
```bash
# Install dependencies
curl -fsSL https://raw.githubusercontent.com/m-marinucci/Tol/master/scripts/install-deps-ubuntu.sh | bash

# Build TOL
git clone https://github.com/m-marinucci/Tol.git
cd Tol && mkdir build && cd build
cmake .. && make -j$(nproc)

# Test installation
make test
```

### **Windows Users**
See `windows/README.md` for Windows-specific build instructions.

## 📚 **Documentation**

### **User Documentation**
- **[Linux Build Guide](LINUX_BUILD_GUIDE.md)** - Complete Linux build instructions
- **[Dependencies Guide](LINUX_DEPENDENCIES.md)** - System requirements and dependencies
- **[Troubleshooting Guide](LINUX_TROUBLESHOOTING.md)** - Common issues and solutions

### **Developer Documentation**
- **[Developer Guide](LINUX_DEVELOPER_GUIDE.md)** - Development environment setup
- **[Testing Framework](tol_tests/COMPREHENSIVE_TESTING_FRAMEWORK.md)** - Comprehensive testing system
- **[Platform Examples](tol_tests/PLATFORM_EXAMPLES.md)** - Platform-specific usage examples

### **Testing and Quality Assurance**
- **[Testing Guide](tol_tests/DEVELOPER_GUIDE.md)** - How to add and modify tests
- **[Performance Benchmarks](tol_tests/performance_tests/)** - Performance validation tests
- **[Cross-Platform Tests](tol_tests/platform_tests/)** - Platform compatibility validation

## 🏗️ **Project Status**

### **Build Status**
- **Linux**: ✅ 100% build success (Ubuntu, CentOS, Fedora, Debian)
- **Windows**: ✅ Full compatibility maintained
- **macOS**: ✅ Native support with Homebrew integration

### **Testing Coverage**
- **Unit Tests**: ✅ Comprehensive module coverage
- **Integration Tests**: ✅ Cross-module functionality
- **Performance Tests**: ✅ Benchmarking and regression detection
- **Platform Tests**: ✅ Cross-platform compatibility validation

### **Quality Metrics**
- **Code Coverage**: 80%+ target with measurement framework
- **Performance**: Linux within 5% of Windows performance
- **Memory**: Leak detection and monitoring integrated
- **Documentation**: Comprehensive guides for all user types

## 🧪 **Testing Framework**

TOL includes a state-of-the-art cross-platform testing framework (NUM-11):

```bash
# Run all tests
make test

# Run specific test categories
make test_unit          # Unit tests
make test_performance   # Performance benchmarks
make test_integration   # Integration tests
make test_platform      # Platform-specific tests

# Generate comprehensive reports
make test_reports       # JSON, XML, HTML, JUnit XML formats
```

## Codebase Structure

```
.
├── CMakeLists.txt
├── CPackOptions.cmake.in
├── NSIS
│   ├── EnvVarUpdate.nsh
│   ├── NSIS.template.in
│   ├── README.md
│   ├── nsis_tol.bmp
│   ├── tolbase-install.ico
│   └── tolbase-uninstall.ico
├── README.md
├── TestCMake
│   ├── README.md
│   ├── TestFileDownload
│   │   └── CMakeLists.txt
│   └── TestLAPACK
│       └── CMakeLists.txt
├── TolJava
│   ├── README.md
│   ├── TOLJava
│   │   ├── README.md
│   │   ├── build.xml
│   │   ├── manifest.mf
│   │   ├── nbproject
│   │   └── src
│   ├── TOLJava-Ejemplos
│   │   ├── README.md
│   │   ├── build.xml
│   │   ├── manifest.mf
│   │   ├── nbproject
│   │   └── src
│   ├── TOLJavaJNI
│   │   ├── Makefile
│   │   ├── README.md
│   │   ├── nbproject
│   │   ├── toljavajni.cpp
│   │   └── toljavajni.h
│   └── WebTOLJavaDEMO
│       ├── README.md
│       ├── build.xml
│       ├── nbproject
│       ├── src
│       └── web
├── building
│   ├── Linux
│   │   ├── build.sh
│   │   ├── build_contrib.sh
│   │   ├── build_installer.sh
│   │   ├── build_package.sh
│   │   ├── current_version.sh
│   │   ├── download_default_packages.sh
│   │   └── produce_package.sh
│   ├── MinGW
│   │   ├── build.bat
│   │   ├── build_installer.bat
│   │   ├── build_package.bat
│   │   ├── cmake_prepare.bat
│   │   ├── download_default_packages.bat
│   │   ├── path_cmake_readme.txt
│   │   ├── produce_package.bat
│   │   └── start.bat
│   ├── README.md
│   └── produce_package.tol
├── cpack
│   ├── README.md
│   └── rpm_post_install.sh.in
├── doc
│   ├── README.md
│   ├── bugzilla
│   │   ├── report-1.1.6.es.ods
│   │   ├── report-1.1.6.ods
│   │   ├── report-2006-12-07.odt
│   │   └── report-2008-10-17.ods
│   ├── general
│   │   ├── Manual basico de TOL.pdf
│   │   ├── TOL User Manual.pdf
│   │   ├── comoDesarrolloDeTOL.lyx
│   │   ├── comoDesarrolloDeTOL.pdf
│   │   ├── guiatol.lyx
│   │   ├── mole-spec
│   │   └── tolguide.lyx
│   ├── kernel
│   │   ├── MemoryHandlers
│   │   ├── OIS
│   │   ├── Time
│   │   └── matrix
│   ├── modeling
│   │   ├── AIA
│   │   ├── ARIMA_Estimate
│   │   ├── BSR
│   │   ├── BVAR
│   │   ├── CLR.pdf
│   │   ├── Extensión de los modelos multiplicativos.odt
│   │   ├── Extensión de los modelos multiplicativos.pdf
│   │   ├── GibbsMA1.nb.pdf
│   │   ├── MCMC_convergence_diagnosis_with_CODA.pdf
│   │   ├── MultiTryMetropolis
│   │   └── best95coda.pdf
│   └── performance
│       ├── TOLCleaningDic05
│       ├── tol_performance_test_0001.es.ods
│       └── tol_performance_test_0001.ods
├── installer
│   ├── CMakeLists.txt
│   ├── README.md
│   ├── linux
│   │   ├── CMakeLists.txt
│   │   ├── cpack_generator.cmake
│   │   └── rpm_post_install.sh.in
│   └── windows
│       ├── CMakeLists.txt
│       └── NSIS
├── linux
│   ├── README.md
│   ├── shflags
│   └── uptol
├── revision_alias.txt
├── rtol
│   ├── CMakeLists.txt
│   ├── README.md
│   ├── cmake
│   │   ├── README.md
│   │   └── modules
│   └── source
│       ├── CMakeLists.txt
│       └── tolRlink.cpp
├── tol
│   ├── AUTHORS
│   ├── CMakeLists.txt
│   ├── COPYING
│   ├── CentOS5.4_Install.txt
│   ├── CentOS6.x_Install.txt
│   ├── ChangeLog
│   ├── INSTALL
│   ├── Jamroot
│   ├── LoadDynLib
│   │   ├── CMakeLists.txt
│   │   ├── Jamfile
│   │   ├── LoadDynLib.cpp
│   │   ├── Makefile.am
│   │   ├── README.md
│   │   └── tol_LoadDynLib.h
│   ├── Makefile.am
│   ├── NEWS
│   ├── NEWS.es
│   ├── OIS
│   │   ├── CMakeLists.txt
│   │   ├── Jamfile
│   │   ├── Makefile.am
│   │   ├── README.md
│   │   ├── ois.cpp
│   │   ├── oisapitol.cpp
│   │   ├── oiscompress.cpp
│   │   ├── oiscreator.cpp
│   │   ├── oisindex.cpp
│   │   ├── oisinteractive.cpp
│   │   ├── oisloader.cpp
│   │   ├── oisstream.cpp
│   │   ├── oisstream_dir.cpp
│   │   ├── oisstream_zip.cpp
│   │   ├── oisxml.cpp
│   │   ├── tol_ois.h
│   │   ├── tol_ois_macros.h
│   │   ├── tol_oiscreator.h
│   │   ├── tol_oisloader.h
│   │   ├── tol_oisstream.h
│   │   ├── tol_oisstream_dir.h
│   │   └── tol_oisstream_zip.h
│   ├── PackArchive
│   │   ├── CMakeLists.txt
│   │   ├── Jamfile
│   │   ├── Makefile.am
│   │   ├── PackArchive.cpp
│   │   ├── README.md
│   │   ├── StoreZipArchive.cpp
│   │   ├── tol_PackArchive.h
│   │   └── tol_StoreZipArchive.h
│   ├── README
│   ├── README.md
│   ├── THANKS
│   ├── TODO
│   ├── TestUseTol.cpp
│   ├── aclocal.m4
│   ├── bbasic
│   │   ├── CMakeLists.txt
│   │   ├── Jamfile
│   │   ├── Makefile.am
│   │   ├── README.md
│   │   ├── StringMatch.cpp
│   │   ├── atm.cpp
│   │   ├── bfsmem.cpp
│   │   ├── bobject.cpp
│   │   ├── classify.cpp
│   │   ├── cor.cpp
│   │   ├── dir.cpp
│   │   ├── dircomma.cpp
│   │   ├── dirtext.cpp
│   │   ├── dte.cpp
│   │   ├── dtealgeb.cpp
│   │   ├── list.cpp
│   │   ├── lst.cpp
│   │   ├── lstalgeb.cpp
│   │   ├── lsttext.cpp
│   │   ├── opt.cpp
│   │   ├── optargtx.cpp
│   │   ├── opttext.cpp
│   │   ├── out.cpp
│   │   ├── qfile.cpp
│   │   ├── seed.cpp
│   │   ├── sys.cpp
│   │   ├── timer.cpp
│   │   ├── tol_barray.h
│   │   ├── tol_batom.h
│   │   ├── tol_bcore.h
│   │   ├── tol_bdate.h
│   │   ├── tol_bdir.h
│   │   ├── tol_bexc.h
│   │   ├── tol_bfsmem.h
│   │   ├── tol_blist.h
│   │   ├── tol_bobject.h
│   │   ├── tol_bopt.h
│   │   ├── tol_bout.h
│   │   ├── tol_bqfile.h
│   │   ├── tol_bseed.h
│   │   ├── tol_bsys.h
│   │   ├── tol_btext.h
│   │   ├── tol_btimer.h
│   │   ├── tol_butil.h
│   │   ├── tol_classify.h
│   │   ├── tol_hash_map.h
│   │   ├── tol_list.h
│   │   ├── tol_memhandler.h
│   │   ├── tol_tree.h
│   │   ├── tree.cpp
│   │   ├── txt.cpp
│   │   ├── txtalgeb.cpp
│   │   ├── unix_findexe.c
│   │   └── win_findexe.c
│   ├── bin
│   │   ├── CMakeLists.txt
│   │   ├── README.md
│   │   ├── confenv.sh
│   │   └── tolcon.sh
│   ├── bjam-gcc-debug
│   ├── bjam-gcc-release
│   ├── bjam-gcc-vtune
│   ├── bmath
│   │   ├── CMakeLists.txt
│   │   ├── Jamfile
│   │   ├── Makefile.am
│   │   ├── README.md
│   │   ├── barith
│   │   ├── bfunct
│   │   ├── blinalg
│   │   ├── bprdist
│   │   ├── bstat
│   │   ├── csparse
│   │   ├── dcdflib
│   │   ├── fftw
│   │   ├── gsl_ext
│   │   ├── matfun.cpp
│   │   ├── mathobjects
│   │   └── tol_bmatfun.h
│   ├── bootstrap
│   ├── bparser
│   │   ├── CMakeLists.txt
│   │   ├── Jamfile
│   │   ├── Makefile.am
│   │   ├── README.md
│   │   ├── fil.cpp
│   │   ├── par.cpp
│   │   ├── scn.cpp
│   │   ├── tok.cpp
│   │   ├── tol_bfilter.h
│   │   ├── tol_bparser.h
│   │   ├── tol_bscanner.h
│   │   └── tol_btoken.h
│   ├── btol
│   │   ├── CMakeLists.txt
│   │   ├── Jamfile
│   │   ├── Makefile.am
│   │   ├── README.md
│   │   ├── bdb
│   │   ├── bgrammar
│   │   ├── bgsl
│   │   ├── bkfilter
│   │   ├── bmodel
│   │   ├── bmonte
│   │   ├── code_type
│   │   ├── complex_type
│   │   ├── cseries_type
│   │   ├── ctime_type
│   │   ├── ctimeset_type
│   │   ├── date_type
│   │   ├── delay_init.cpp
│   │   ├── matrix_type
│   │   ├── polmat_type
│   │   ├── polynomial_type
│   │   ├── ratio_type
│   │   ├── real_type
│   │   ├── serie_type
│   │   ├── set_type
│   │   ├── text_type
│   │   ├── timeset_type
│   │   ├── tol_bsparse.h
│   │   ├── tol_delay_init.h
│   │   └── vmatrix_type
│   ├── cmake
│   │   ├── README.md
│   │   ├── linux-i686.toolchain.cmake
│   │   ├── mingw-m32-O3-mtune_native.toolchain.cmake
│   │   ├── mingw-m32.toolchain.cmake
│   │   ├── mingw-m64-O3-mtune_native.toolchain.cmake
│   │   ├── mingw-m64-Ofast-mtune_native.toolchain.cmake
│   │   ├── mingw-m64.toolchain.cmake
│   │   └── modules
│   ├── common-build
│   ├── config
│   │   ├── README.md
│   │   ├── acinclude.m4
│   │   ├── bys.m4
│   │   ├── compile
│   │   ├── config.guess
│   │   ├── config.sub
│   │   ├── depcomp
│   │   ├── install-sh
│   │   ├── ltmain.sh
│   │   ├── missing
│   │   └── mkinstalldirs
│   ├── config.h
│   ├── config.h.in
│   ├── config.h.in.bak
│   ├── config.jam
│   ├── configure
│   ├── configure.in
│   ├── contrib
│   │   ├── ANN
│   │   ├── CMakeLists.txt
│   │   ├── Jamfile
│   │   ├── Makefile.am
│   │   ├── README.md
│   │   ├── ZipArchive
│   │   ├── alglib
│   │   ├── atlas
│   │   ├── cint
│   │   ├── clusterlib
│   │   ├── excel
│   │   ├── kmlocal
│   │   ├── optimal_bw
│   │   └── tpp
│   ├── cvs_log_news.bat
│   ├── dbdrivers
│   │   ├── AUTHORS
│   │   ├── CMakeLists.txt
│   │   ├── ChangeLog
│   │   ├── Jamfile
│   │   ├── Makefile.am
│   │   ├── NEWS
│   │   ├── README
│   │   ├── README.md
│   │   ├── bootstrap
│   │   ├── common-build
│   │   ├── config
│   │   ├── configure.in
│   │   ├── libtol_seed_.c
│   │   ├── libtolbdb.h
│   │   ├── libtolmysql.c
│   │   ├── libtolodbc.c
│   │   ├── libtolpgsql.c
│   │   ├── libtolsqlite.c
│   │   ├── listDRV.c
│   │   ├── listDSN.c
│   │   ├── sqlite
│   │   ├── testOCnn.c
│   │   └── tests
│   ├── debian_install.txt
│   ├── init.cpp
│   ├── lang
│   │   ├── CMakeLists.txt
│   │   ├── Jamfile
│   │   ├── Makefile.am
│   │   ├── README.md
│   │   ├── exportfu.cpp
│   │   ├── language.cpp
│   │   ├── tol_blanguag.h
│   │   └── tol_exportfu.h
│   ├── libltdl
│   │   ├── COPYING.LIB
│   │   ├── Makefile.am
│   │   ├── Makefile.in
│   │   ├── Makefile.inc
│   │   ├── README
│   │   ├── README.md
│   │   ├── aclocal.m4
│   │   ├── argz.c
│   │   ├── argz_.h
│   │   ├── config
│   │   ├── config-h.in
│   │   ├── configure
│   │   ├── configure.ac
│   │   ├── libltdl
│   │   ├── loaders
│   │   ├── lt__alloc.c
│   │   ├── lt__dirent.c
│   │   ├── lt__strl.c
│   │   ├── lt_dlloader.c
│   │   ├── lt_error.c
│   │   ├── ltdl.c
│   │   ├── ltdl.h
│   │   ├── m4
│   │   ├── slist.c
│   │   └── stamp-mk
│   ├── libtool.m4
│   ├── ltdl.m4
│   ├── prj-config.jam.CentOS6x
│   ├── prj-config.jam.centos54
│   ├── prj-config.jam.tpl
│   ├── replace
│   │   ├── Makefile.am
│   │   ├── README.md
│   │   ├── canon-host.c
│   │   ├── dirname.c
│   │   ├── dirname.h
│   │   ├── error.c
│   │   ├── gettext.c
│   │   ├── lstat.c
│   │   ├── malloc.c
│   │   ├── memset.c
│   │   ├── mkdir.c
│   │   ├── mountlist.c
│   │   ├── mountlist.h
│   │   ├── realloc.c
│   │   ├── stat.c
│   │   ├── strdup.c
│   │   ├── strftime.c
│   │   └── strtod.c
│   ├── stdlib
│   │   ├── DefaultPackages
│   │   ├── Makefile.am
│   │   ├── README.md
│   │   ├── TolConfigManager
│   │   ├── TolPackage
│   │   ├── _init_project.tol
│   │   ├── _init_stdlib.tol
│   │   ├── _tolcore.tol
│   │   ├── arima
│   │   ├── system
│   │   └── various
│   ├── sudo_install
│   ├── tai
│   │   ├── Makefile.am
│   │   ├── README.md
│   │   ├── caldate.3
│   │   ├── caldate.h
│   │   ├── caldate_fmjd.c
│   │   ├── caldate_fmt.c
│   │   ├── caldate_mjd.3
│   │   ├── caldate_mjd.c
│   │   ├── caldate_norm.c
│   │   ├── caldate_scan.c
│   │   ├── caldate_ster.c
│   │   ├── caltime.3
│   │   ├── caltime.h
│   │   ├── caltime_fmt.c
│   │   ├── caltime_scan.c
│   │   ├── caltime_tai.3
│   │   ├── caltime_tai.c
│   │   ├── caltime_utc.c
│   │   ├── check.c
│   │   ├── easter.c
│   │   ├── leapsecs.3
│   │   ├── leapsecs.c
│   │   ├── leapsecs.dat
│   │   ├── leapsecs.h
│   │   ├── leapsecs_add.c
│   │   ├── leapsecs_init.c
│   │   ├── leapsecs_read.c
│   │   ├── leapsecs_sub.c
│   │   ├── nowutc.c
│   │   ├── tai.3
│   │   ├── tai.h
│   │   ├── tai_add.c
│   │   ├── tai_common.h
│   │   ├── tai_now.3
│   │   ├── tai_now.c
│   │   ├── tai_pack.3
│   │   ├── tai_pack.c
│   │   ├── tai_sub.c
│   │   ├── tai_unpack.c
│   │   ├── taia.3
│   │   ├── taia.h
│   │   ├── taia_add.c
│   │   ├── taia_approx.c
│   │   ├── taia_fmtfrac.c
│   │   ├── taia_frac.c
│   │   ├── taia_half.c
│   │   ├── taia_less.c
│   │   ├── taia_now.3
│   │   ├── taia_now.c
│   │   ├── taia_pack.3
│   │   ├── taia_pack.c
│   │   ├── taia_sub.c
│   │   ├── taia_tai.c
│   │   ├── taia_unpack.c
│   │   ├── uint64.h
│   │   └── yearcal.c
│   ├── test-it.tol
│   ├── tol
│   │   ├── Makefile.am
│   │   └── README.md
│   ├── tol.cpp
│   ├── tol_bcommon.h
│   ├── tol_bmethodhook.h
│   ├── tol_build_svn_info.prefix
│   ├── tol_build_svn_info.sufix
│   ├── tol_init.h
│   ├── tol_version_def.h
│   ├── tolcon.cpp
│   ├── toldll.cpp
│   ├── win-VC8
│   │   ├── README.md
│   │   ├── ReadMe.txt
│   │   ├── StdAfx.cpp
│   │   ├── StdAfx.h
│   │   ├── TestUseTol.vcproj
│   │   ├── build_date_gen
│   │   ├── config.h
│   │   ├── gnutol.sln
│   │   ├── inttypes.h
│   │   ├── libtolmysql
│   │   ├── libtolodbc
│   │   ├── libtolpgsql
│   │   ├── postbuild.bat
│   │   ├── stdint.h
│   │   ├── tolcon.vcproj
│   │   ├── toldll.cpp
│   │   ├── tollib.vcproj
│   │   └── win_tolinc.h
│   └── win-VC9
│       ├── README.md
│       ├── ReadMe.txt
│       ├── StdAfx.cpp
│       ├── StdAfx.h
│       ├── TestUseTol.vcproj
│       ├── build_date_gen
│       ├── config.h
│       ├── gnutol.sln
│       ├── inttypes.h
│       ├── libtolmysql
│       ├── libtolodbc
│       ├── libtolpgsql
│       ├── libtolsqlite
│       ├── postbuild.bat
│       ├── stdint.h
│       ├── tolcon.vcproj
│       ├── toldll.cpp
│       ├── tollib.vcproj
│       └── win_tolinc.h
├── tol_tests
│   ├── README.md
│   ├── gsl
│   │   └── ticket_001398
│   ├── how_to.html
│   ├── notas_sobre_tests.txt
│   ├── run_all_tests.bat
│   ├── run_all_tests.sh
│   ├── tol
│   │   ├── ARIMA
│   │   ├── BSR
│   │   ├── BooleanAlgebra
│   │   ├── Bugzilla
│   │   ├── CreationAndCopy
│   │   ├── ImportExport
│   │   ├── KMeans
│   │   ├── LinearAlgebra
│   │   ├── NameBlock
│   │   ├── NumCalc
│   │   ├── OIS
│   │   ├── SetAlgebra
│   │   ├── Statistics
│   │   ├── Text
│   │   ├── _bsrTester.tol
│   │   ├── _tolTester.tol
│   │   ├── _tolTester_knownbugs.tol
│   │   ├── database
│   │   ├── kernel
│   │   ├── known_bugs
│   │   ├── performance
│   │   ├── random_generation
│   │   ├── remind
│   │   ├── stdlib
│   │   ├── system
│   │   └── test_template.tol
│   ├── toldb
│   │   ├── _tolTester.tol
│   │   ├── by_engine
│   │   ├── dbt.engine.type.bst
│   │   └── dbt.tol
│   └── toltcl
│       ├── Bugzilla
│       ├── _toltclTester.tol
│       ├── toltcl_test_template.tcl
│       └── toltcl_test_template.tol
├── tolbase
│   ├── AUTHORS
│   ├── CMakeLists.txt
│   ├── COPYING
│   ├── ChangeLog
│   ├── INSTALL
│   ├── Makefile.in
│   ├── NEWS
│   ├── README
│   ├── README.md
│   ├── THANKS
│   ├── TODO
│   ├── ThirdParty
│   │   ├── CMakeLists.txt
│   │   ├── Img-Source-1.4.6.tar.gz
│   │   ├── README.md
│   │   ├── Tktable2.10.tar.gz
│   │   ├── rbc0.1.zip
│   │   ├── tclodbc2.5_bayes.tar.gz
│   │   └── tktreectrl-2.4.1.tar.gz
│   ├── aclocal.m4
│   ├── bin
│   │   ├── CMakeLists.txt
│   │   ├── README.md
│   │   ├── tolbase.sh
│   │   └── tolbase.tcl
│   ├── cmake
│   │   ├── README.md
│   │   ├── linux-i686.toolchain.cmake
│   │   └── modules
│   ├── conf.tcl
│   ├── config.log
│   ├── config.status
│   ├── configure
│   ├── configure.in
│   ├── doc
│   │   ├── AUTHORS
│   │   ├── COPYING
│   │   ├── NEWS
│   │   ├── README.md
│   │   └── THANKS
│   ├── generic
│   │   ├── CMakeLists.txt
│   │   ├── README.md
│   │   ├── tkAppInit.c
│   │   ├── tolbase-gnu.rc
│   │   ├── tolbase-msvc.rc
│   │   └── tolbase.c
│   ├── lib
│   │   ├── CMakeLists.txt
│   │   ├── README.md
│   │   ├── autoscroll
│   │   ├── byswidget
│   │   ├── markupparser
│   │   ├── markupviewer
│   │   ├── mimetex
│   │   ├── mkWidgets1.3
│   │   ├── nbdbmanager
│   │   ├── notebookdb
│   │   ├── pkgIndex.tcl.in
│   │   ├── renderpane
│   │   ├── rmtps_client
│   │   ├── toltk
│   │   ├── trycatch
│   │   └── wtree
│   ├── pkgIndex.tcl
│   ├── pkgIndex.tcl.in
│   ├── tclconfig
│   │   ├── ChangeLog
│   │   ├── README.md
│   │   ├── README.txt
│   │   ├── install-sh
│   │   ├── missing
│   │   ├── mkinstalldirs
│   │   ├── tcl.m4
│   │   └── tolbase.m4
│   ├── tests
│   │   ├── 030926.tol
│   │   ├── 031008.tol
│   │   └── README.md
│   ├── tolbase_version.tcl
│   ├── win
│   │   ├── INSTALL
│   │   ├── README.md
│   │   ├── bayes.ico
│   │   ├── resource.h
│   │   ├── tolbase.dsp
│   │   ├── tolbase.rc
│   │   └── tolbase.vcproj
│   └── win-VC9
│       ├── README.md
│       ├── tolbase.sln
│       └── tolbase.vcproj
├── tolbaseBLT
│   ├── AUTHORS
│   ├── CMakeLists.txt
│   ├── COPYING
│   ├── ChangeLog
│   ├── INSTALL
│   ├── Makefile.in
│   ├── NEWS
│   ├── README
│   ├── README.md
│   ├── THANKS
│   ├── TODO
│   ├── ThirdParty
│   │   ├── CMakeLists.txt
│   │   ├── Tktable2.10.tar.gz
│   │   └── tclodbc2.5_bayes.tar.gz
│   ├── aclocal.m4
│   ├── bin
│   │   ├── CMakeLists.txt
│   │   ├── tolbase.sh
│   │   └── tolbase.tcl
│   ├── cmake
│   │   ├── linux-i686.toolchain.cmake
│   │   └── modules
│   ├── conf.tcl
│   ├── config.log
│   ├── config.status
│   ├── configure
│   ├── configure.in
│   ├── doc
│   │   ├── AUTHORS
│   │   ├── COPYING
│   │   ├── NEWS
│   │   └── THANKS
│   ├── generic
│   │   ├── CMakeLists.txt
│   │   ├── tkAppInit.c
│   │   ├── tolbase-gnu.rc
│   │   ├── tolbase-msvc.rc
│   │   └── tolbase.c
│   ├── lib
│   │   ├── CMakeLists.txt
│   │   ├── autoscroll
│   │   ├── byswidget
│   │   ├── markupparser
│   │   ├── markupviewer
│   │   ├── mimetex
│   │   ├── mkWidgets1.3
│   │   ├── nbdbmanager
│   │   ├── notebookdb
│   │   ├── pkgIndex.tcl.in
│   │   ├── renderpane
│   │   ├── rmtps_client
│   │   ├── toltk
│   │   ├── trycatch
│   │   └── wtree
│   ├── pkgIndex.tcl
│   ├── pkgIndex.tcl.in
│   ├── tclconfig
│   │   ├── ChangeLog
│   │   ├── README.txt
│   │   ├── install-sh
│   │   ├── missing
│   │   ├── mkinstalldirs
│   │   ├── tcl.m4
│   │   └── tolbase.m4
│   ├── tests
│   │   ├── 030926.tol
│   │   └── 031008.tol
│   ├── tolbase_version.tcl
│   ├── win
│   │   ├── INSTALL
│   │   ├── bayes.ico
│   │   ├── resource.h
│   │   ├── tolbase.dsp
│   │   ├── tolbase.rc
│   │   └── tolbase.vcproj
│   └── win-VC9
│       ├── tolbase.sln
│       └── tolbase.vcproj
├── tolsh
│   ├── Linux
│   │   ├── tclkit-linux-x86.upx.bin
│   │   └── tclkitsh-8.5.8
│   ├── README.md
│   ├── TODO
│   ├── Windows
│   │   ├── tclkit-rt.exe
│   │   ├── tclkitsh.exe
│   │   └── tclkitsh858.exe
│   ├── build.bat
│   ├── build.sh
│   ├── doc
│   │   ├── TPA-first.odp
│   │   ├── protocol.txt
│   │   └── rmtps_client.txt
│   ├── sdx.kit
│   ├── tests
│   │   └── matprod
│   └── tolsh.vfs
│       ├── lib
│       └── main.tcl
├── toltcl
│   ├── AUTHORS
│   ├── CMakeLists.txt
│   ├── COPYING
│   ├── ChangeLog
│   ├── INSTALL
│   ├── Makefile.in
│   ├── NEWS
│   ├── OTAN
│   │   ├── README.md
│   │   ├── ToltclLinux32
│   │   ├── ToltclWin32
│   │   └── _build.tol
│   ├── README
│   ├── README.md
│   ├── THANKS
│   ├── TODO
│   ├── ThirdParty
│   │   ├── CMakeLists.txt
│   │   ├── README.md
│   │   ├── TclCurl-7.19.6.tar.gz
│   │   └── TclCurl-7.22.0.tar.gz
│   ├── aclocal.m4
│   ├── bin
│   │   ├── CMakeLists.txt
│   │   ├── README.md
│   │   └── tolsh.sh
│   ├── build.sh
│   ├── cmake
│   │   ├── README.md
│   │   └── modules
│   ├── common-build
│   ├── configure
│   ├── configure.in
│   ├── debug
│   │   ├── README.md
│   │   └── default_config.sh
│   ├── doc
│   │   ├── README.md
│   │   ├── toltableset.txt
│   │   └── toltcl.txt
│   ├── generic
│   │   ├── CMakeLists.txt
│   │   ├── README.md
│   │   ├── crash.c
│   │   ├── pool.cpp
│   │   ├── tclutils.cpp
│   │   ├── tolaccess.cpp
│   │   ├── tolsergrp.cpp
│   │   ├── tolsh.c
│   │   ├── toltableset.cpp
│   │   ├── toltcl.c
│   │   ├── toltcl.h
│   │   ├── toltclInt.h
│   │   ├── toltime.cpp
│   │   ├── tt_common.h
│   │   ├── tt_crash.h
│   │   ├── tt_pool.h
│   │   └── tt_tclutils.h
│   ├── library
│   │   ├── CMakeLists.txt
│   │   ├── README.md
│   │   ├── pkgIndex.tcl.in
│   │   ├── tolsh.tcl
│   │   └── toltcl.tcl
│   ├── linux-i686.toolchain.cmake
│   ├── pkgIndex.tcl
│   ├── pkgIndex.tcl.in
│   ├── release
│   │   ├── README.md
│   │   └── default_config.sh
│   ├── tclconfig
│   │   ├── ChangeLog
│   │   ├── README.md
│   │   ├── README.txt
│   │   ├── install-sh
│   │   ├── missing -> /usr/share/automake-1.10/missing
│   │   ├── tcl.m4
│   │   └── toltcl.m4
│   ├── tests
│   │   ├── README.md
│   │   └── tableset.tcl
│   ├── win-vc8
│   │   ├── README.md
│   │   ├── ReadMe.txt
│   │   ├── postbuild.bat
│   │   ├── toltcl.sln
│   │   └── toltcl.vcproj
│   └── win-vc9
│       ├── README.md
│       ├── ReadMe.txt
│       ├── postbuild.bat
│       ├── toltcl.sln
│       └── toltcl.vcproj
├── vbtol
│   ├── CMakeLists.txt
│   ├── MIN.EXE
│   ├── README.md
│   ├── VBTol.nsi
│   ├── distribution
│   │   ├── MIN.EXE
│   │   ├── README.md
│   │   ├── VBTol.nsi
│   │   └── makensis.bat
│   ├── doc
│   │   ├── README.md
│   │   ├── VBTol_distribution.txt
│   │   ├── dll_installation.txt
│   │   └── vb_programmer.txt
│   ├── makensis.bat
│   ├── source
│   │   ├── CMakeLists.txt
│   │   ├── README.md
│   │   ├── datatype.cpp
│   │   ├── vbtol.cpp
│   │   ├── vbtol.def
│   │   ├── vbutils.cpp
│   │   └── vbutils.h
│   ├── tests
│   │   ├── README.md
│   │   ├── test1_eval.xls
│   │   ├── test2_decompile.xls
│   │   ├── test3_text.xls
│   │   ├── test4_real.xls
│   │   ├── test5_matrix.xls
│   │   └── test6_+matrix.xls
│   ├── vbasic
│   │   ├── README.md
│   │   └── tol.bas
│   ├── win-vc8
│   │   ├── postbuild.bat
│   │   ├── vbtol.sln
│   │   └── vbtol.vcproj
│   └── win-vc9
│       ├── postbuild.bat
│       ├── vbtol.sln
│       └── vbtol.vcproj
└── windows
    ├── ActiveTOL_Base.exe
    ├── NSIS
    │   ├── Tolbase.nsi.generate.tol
    │   ├── Tolbase.nsi.template
    │   ├── build_setup.bat
    │   ├── create_tag_build.tol
    │   ├── send2web.bat
    │   ├── send2web.stdlib.bat
    │   ├── send2web.tol
    │   ├── store_history.tol
    │   └── tdt.txt
    ├── README.md
    ├── build_tools
    │   ├── README
    │   ├── _uptol.bat
    │   ├── _uptol_new.bat
    │   ├── build_tol_sdk
    │   ├── create_tag_build.bat
    │   ├── download_default_packages.bat
    │   ├── exclude.lst
    │   ├── log2clog.exe
    │   ├── mailtdt.exe
    │   ├── postbuild.bat
    │   ├── sdkenv.bat
    │   ├── send_win-tol-contrib_2web.bat
    │   ├── startenv.lnk
    │   ├── uptol.bat
    │   └── uptol_new.bat
    ├── notes
    │   ├── notas.txt
    │   ├── notas_Tcl.txt
    │   └── notas_WindowsSDK.txt
    ├── setup_contrib.bat
    ├── setx.exe
    └── tol-contrib.exe
```

## 🤝 **Contributing**

We welcome contributions! Please see our [Developer Guide](LINUX_DEVELOPER_GUIDE.md) for:
- Development environment setup
- Coding standards and style guide
- Testing requirements
- Pull request workflow

### **Quick Contribution Steps**
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes and add tests
4. Ensure all tests pass: `make test`
5. Submit a pull request

## 📞 **Support and Community**

### **Getting Help**
- **Documentation**: Comprehensive guides in this repository
- **Issues**: [GitHub Issues](https://github.com/m-marinucci/Tol/issues)
- **Contact**: mmarinucci@numinate.com

### **Reporting Bugs**
Please include:
- System information (OS, version, architecture)
- Complete error messages
- Steps to reproduce
- Expected vs actual behavior

### **Feature Requests**
- Check existing issues first
- Provide clear use case and rationale
- Consider contributing the implementation

## 📄 **License**

This project is licensed under the terms specified in the `COPYING` files within each component directory.

## 🏆 **Acknowledgments**

- **Contributors**: See individual module AUTHORS files
- **Dependencies**: GSL, BLAS/LAPACK, Boost, FFTW, and other open-source libraries
- **Testing Framework**: Built with comprehensive cross-platform support (NUM-11)
- **Community**: Thanks to all users and contributors

---

**TOL Project** - Time-Oriented Language for Mathematical and Statistical Computing
**Maintainer**: Massimiliano Marinucci (mmarinucci@numinate.com)
**Repository**: https://github.com/m-marinucci/Tol
**Documentation**: See guides in this repository
**Last Updated**: 2025-07-06
