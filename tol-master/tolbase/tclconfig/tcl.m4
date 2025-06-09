# tcl.m4 --
#
#	This file provides a set of autoconf macros to help TEA-enable
#	a Tcl extension.
#
# Copyright (c) 1999-2000 Ajuba Solutions.
# Copyright (c) 2002-2003 ActiveState Corporation.
#
# See the file "license.terms" for information on usage and redistribution
# of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
# RCS: @(#) $Id: tcl.m4,v 1.2 2007/11/06 18:48:31 danirus Exp $

AC_PREREQ(2.50)

#------------------------------------------------------------------------
# TEA_PATH_TCLCONFIG --
#
#	Locate the tclConfig.sh file and perform a sanity check on
#	the Tcl compile flags
#
# Arguments:
#	none
#
# Results:
#
#	Adds the following arguments to configure:
#		--with-tcl=...
#
#	Defines the following vars:
#		TCL_BIN_DIR	Full path to the directory containing
#				the tclConfig.sh file
#------------------------------------------------------------------------

AC_DEFUN([TEA_PATH_TCLCONFIG], [
    dnl Make sure we are initialized
    AC_REQUIRE([TEA_INIT])
    #
    # Ok, lets find the tcl configuration
    # First, look for one uninstalled.
    # the alternative search directory is invoked by --with-tcl
    #

    if test x"${no_tcl}" = x ; then
	# we reset no_tcl in case something fails here
	no_tcl=true
	AC_ARG_WITH(tcl, [  --with-tcl              directory containing tcl configuration (tclConfig.sh)], with_tclconfig=${withval})
	AC_MSG_CHECKING([for Tcl configuration])
	AC_CACHE_VAL(ac_cv_c_tclconfig,[

	    # First check to see if --with-tcl was specified.
	    if test x"${with_tclconfig}" != x ; then
		if test -f "${with_tclconfig}/tclConfig.sh" ; then
		    ac_cv_c_tclconfig=`(cd ${with_tclconfig}; pwd)`
		else
		    AC_MSG_ERROR([${with_tclconfig} directory doesn't contain tclConfig.sh])
		fi
	    fi

	    # then check for a private Tcl installation
	    if test x"${ac_cv_c_tclconfig}" = x ; then
		for i in \
			../tcl \
			`ls -dr ../tcl[[8-9]].[[0-9]]* 2>/dev/null` \
			../../tcl \
			`ls -dr ../../tcl[[8-9]].[[0-9]]* 2>/dev/null` \
			../../../tcl \
			`ls -dr ../../../tcl[[8-9]].[[0-9]]* 2>/dev/null` ; do
		    if test -f "$i/unix/tclConfig.sh" ; then
			ac_cv_c_tclconfig=`(cd $i/unix; pwd)`
			break
		    fi
		done
	    fi

	    # check in a few common install locations
	    if test x"${ac_cv_c_tclconfig}" = x ; then
		for i in `ls -d ${exec_prefix}/lib 2>/dev/null` \
			`ls -d ${prefix}/lib 2>/dev/null` \
			`ls -d /usr/local/lib 2>/dev/null` \
			`ls -d /usr/contrib/lib 2>/dev/null` \
			`ls -d /usr/lib 2>/dev/null` \
			; do
		    if test -f "$i/tclConfig.sh" ; then
			ac_cv_c_tclconfig=`(cd $i; pwd)`
			break
		    fi
		done
	    fi

	    # check in a few other private locations
	    if test x"${ac_cv_c_tclconfig}" = x ; then
		for i in \
			${srcdir}/../tcl \
			`ls -dr ${srcdir}/../tcl[[8-9]].[[0-9]]* 2>/dev/null` ; do
		    if test -f "$i/unix/tclConfig.sh" ; then
		    ac_cv_c_tclconfig=`(cd $i/unix; pwd)`
		    break
		fi
		done
	    fi
	])

	if test x"${ac_cv_c_tclconfig}" = x ; then
	    TCL_BIN_DIR="# no Tcl configs found"
	    AC_MSG_WARN("Cannot find Tcl configuration definitions")
	    exit 0
	else
	    no_tcl=
	    TCL_BIN_DIR=${ac_cv_c_tclconfig}
	    AC_MSG_RESULT([found $TCL_BIN_DIR/tclConfig.sh])
	fi
    fi
])

#------------------------------------------------------------------------
# TEA_PATH_TKCONFIG --
#
#	Locate the tkConfig.sh file
#
# Arguments:
#	none
#
# Results:
#
#	Adds the following arguments to configure:
#		--with-tk=...
#
#	Defines the following vars:
#		TK_BIN_DIR	Full path to the directory containing
#				the tkConfig.sh file
#------------------------------------------------------------------------

AC_DEFUN([TEA_PATH_TKCONFIG], [
    #
    # Ok, lets find the tk configuration
    # First, look for one uninstalled.
    # the alternative search directory is invoked by --with-tk
    #

    if test x"${no_tk}" = x ; then
	# we reset no_tk in case something fails here
	no_tk=true
	AC_ARG_WITH(tk, [  --with-tk               directory containing tk configuration (tkConfig.sh)], with_tkconfig=${withval})
	AC_MSG_CHECKING([for Tk configuration])
	AC_CACHE_VAL(ac_cv_c_tkconfig,[

	    # First check to see if --with-tkconfig was specified.
	    if test x"${with_tkconfig}" != x ; then
		if test -f "${with_tkconfig}/tkConfig.sh" ; then
		    ac_cv_c_tkconfig=`(cd ${with_tkconfig}; pwd)`
		else
		    AC_MSG_ERROR([${with_tkconfig} directory doesn't contain tkConfig.sh])
		fi
	    fi

	    # then check for a private Tk library
	    if test x"${ac_cv_c_tkconfig}" = x ; then
		for i in \
			../tk \
			`ls -dr ../tk[[8-9]].[[0-9]]* 2>/dev/null` \
			../../tk \
			`ls -dr ../../tk[[8-9]].[[0-9]]* 2>/dev/null` \
			../../../tk \
			`ls -dr ../../../tk[[8-9]].[[0-9]]* 2>/dev/null` ; do
		    if test -f "$i/unix/tkConfig.sh" ; then
			ac_cv_c_tkconfig=`(cd $i/unix; pwd)`
			break
		    fi
		done
	    fi
	    # check in a few common install locations
	    if test x"${ac_cv_c_tkconfig}" = x ; then
		for i in `ls -d ${exec_prefix}/lib 2>/dev/null` \
			`ls -d ${prefix}/lib 2>/dev/null` \
			`ls -d /usr/local/lib 2>/dev/null` \
			`ls -d /usr/contrib/lib 2>/dev/null` \
			`ls -d /usr/lib 2>/dev/null` \
			; do
		    if test -f "$i/tkConfig.sh" ; then
			ac_cv_c_tkconfig=`(cd $i; pwd)`
			break
		    fi
		done
	    fi
	    # check in a few other private locations
	    if test x"${ac_cv_c_tkconfig}" = x ; then
		for i in \
			${srcdir}/../tk \
			`ls -dr ${srcdir}/../tk[[8-9]].[[0-9]]* 2>/dev/null` ; do
		    if test -f "$i/unix/tkConfig.sh" ; then
			ac_cv_c_tkconfig=`(cd $i/unix; pwd)`
			break
		    fi
		done
	    fi
	])
	if test x"${ac_cv_c_tkconfig}" = x ; then
	    TK_BIN_DIR="# no Tk configs found"
	    AC_MSG_WARN("Cannot find Tk configuration definitions")
	    exit 0
	else
	    no_tk=
	    TK_BIN_DIR=${ac_cv_c_tkconfig}
	    AC_MSG_RESULT([found $TK_BIN_DIR/tkConfig.sh])
	fi
    fi

])

#------------------------------------------------------------------------
# TEA_LOAD_TCLCONFIG --
#
#	Load the tclConfig.sh file
#
# Arguments:
#	
#	Requires the following vars to be set:
#		TCL_BIN_DIR
#
# Results:
#
#	Subst the following vars:
#		TCL_BIN_DIR
#		TCL_SRC_DIR
#		TCL_LIB_FILE
#
#------------------------------------------------------------------------

AC_DEFUN([TEA_LOAD_TCLCONFIG], [
    AC_MSG_CHECKING([for existence of $TCL_BIN_DIR/tclConfig.sh])

    if test -f "$TCL_BIN_DIR/tclConfig.sh" ; then
        AC_MSG_RESULT([loading])
	. $TCL_BIN_DIR/tclConfig.sh
    else
        AC_MSG_RESULT([file not found])
    fi

    #
    # If the TCL_BIN_DIR is the build directory (not the install directory),
    # then set the common variable name to the value of the build variables.
    # For example, the variable TCL_LIB_SPEC will be set to the value
    # of TCL_BUILD_LIB_SPEC. An extension should make use of TCL_LIB_SPEC
    # instead of TCL_BUILD_LIB_SPEC since it will work with both an
    # installed and uninstalled version of Tcl.
    #

    if test -f $TCL_BIN_DIR/Makefile ; then
        TCL_LIB_SPEC=${TCL_BUILD_LIB_SPEC}
        TCL_STUB_LIB_SPEC=${TCL_BUILD_STUB_LIB_SPEC}
        TCL_STUB_LIB_PATH=${TCL_BUILD_STUB_LIB_PATH}
    fi

    #
    # eval is required to do the TCL_DBGX substitution
    #

    eval "TCL_LIB_FILE=\"${TCL_LIB_FILE}\""
    eval "TCL_LIB_FLAG=\"${TCL_LIB_FLAG}\""
    eval "TCL_LIB_SPEC=\"${TCL_LIB_SPEC}\""

    eval "TCL_STUB_LIB_FILE=\"${TCL_STUB_LIB_FILE}\""
    eval "TCL_STUB_LIB_FLAG=\"${TCL_STUB_LIB_FLAG}\""
    eval "TCL_STUB_LIB_SPEC=\"${TCL_STUB_LIB_SPEC}\""

    AC_SUBST(TCL_VERSION)
    AC_SUBST(TCL_BIN_DIR)
    AC_SUBST(TCL_SRC_DIR)

    AC_SUBST(TCL_LIB_FILE)
    AC_SUBST(TCL_LIB_FLAG)
    AC_SUBST(TCL_LIB_SPEC)

    AC_SUBST(TCL_STUB_LIB_FILE)
    AC_SUBST(TCL_STUB_LIB_FLAG)
    AC_SUBST(TCL_STUB_LIB_SPEC)

    #AC_SUBST(TCL_DBGX)
    AC_SUBST(TCL_LIBS)
    AC_SUBST(TCL_DEFS)
    AC_SUBST(TCL_EXTRA_CFLAGS)
    AC_SUBST(TCL_LD_FLAGS)
    AC_SUBST(TCL_SHLIB_LD_LIBS)
    #AC_SUBST(TCL_BUILD_LIB_SPEC)
    #AC_SUBST(TCL_BUILD_STUB_LIB_SPEC)
])

#------------------------------------------------------------------------
# TEA_LOAD_TKCONFIG --
#
#	Load the tkConfig.sh file
#
# Arguments:
#	
#	Requires the following vars to be set:
#		TK_BIN_DIR
#
# Results:
#
#	Sets the following vars that should be in tkConfig.sh:
#		TK_BIN_DIR
#------------------------------------------------------------------------

AC_DEFUN([TEA_LOAD_TKCONFIG], [
    AC_MSG_CHECKING([for existence of ${TK_BIN_DIR}/tkConfig.sh])

    if test -f "${TK_BIN_DIR}/tkConfig.sh" ; then
        AC_MSG_RESULT([loading])
	. $TK_BIN_DIR/tkConfig.sh
    else
        AC_MSG_RESULT([could not find ${TK_BIN_DIR}/tkConfig.sh])
    fi

    #
    # If the TK_BIN_DIR is the build directory (not the install directory),
    # then set the common variable name to the value of the build variables.
    # For example, the variable TK_LIB_SPEC will be set to the value
    # of TK_BUILD_LIB_SPEC. An extension should make use of TK_LIB_SPEC
    # instead of TK_BUILD_LIB_SPEC since it will work with both an
    # installed and uninstalled version of Tcl.
    #

    if test -f $TK_BIN_DIR/Makefile ; then
        TK_LIB_SPEC=${TK_BUILD_LIB_SPEC}
        TK_STUB_LIB_SPEC=${TK_BUILD_STUB_LIB_SPEC}
        TK_STUB_LIB_PATH=${TK_BUILD_STUB_LIB_PATH}
    fi

    #
    # eval is required to do the TK_DBGX substitution
    #

    eval "TK_LIB_FILE=\"${TK_LIB_FILE}\""
    eval "TK_LIB_FLAG=\"${TK_LIB_FLAG}\""
    eval "TK_LIB_SPEC=\"${TK_LIB_SPEC}\""

    eval "TK_STUB_LIB_FILE=\"${TK_STUB_LIB_FILE}\""
    eval "TK_STUB_LIB_FLAG=\"${TK_STUB_LIB_FLAG}\""
    eval "TK_STUB_LIB_SPEC=\"${TK_STUB_LIB_SPEC}\""

    AC_SUBST(TK_VERSION)
    AC_SUBST(TK_BIN_DIR)
    AC_SUBST(TK_SRC_DIR)

    AC_SUBST(TK_LIB_FILE)
    AC_SUBST(TK_LIB_FLAG)
    AC_SUBST(TK_LIB_SPEC)

    AC_SUBST(TK_STUB_LIB_FILE)
    AC_SUBST(TK_STUB_LIB_FLAG)
    AC_SUBST(TK_STUB_LIB_SPEC)

    AC_SUBST(TK_LIBS)
    AC_SUBST(TK_XINCLUDES)
])

#------------------------------------------------------------------------
# TEA_ENABLE_SHARED --
#
#	Allows the building of shared libraries
#
# Arguments:
#	none
#	
# Results:
#
#	Adds the following arguments to configure:
#		--enable-shared=yes|no
#
#	Defines the following vars:
#		STATIC_BUILD	Used for building import/export libraries
#				on Windows.
#
#	Sets the following vars:
#		SHARED_BUILD	Value of 1 or 0
#------------------------------------------------------------------------

AC_DEFUN([TEA_ENABLE_SHARED], [
    AC_MSG_CHECKING([how to build libraries])
    AC_ARG_ENABLE(shared,
	[  --enable-shared         build and link with shared libraries [--enable-shared]],
	[tcl_ok=$enableval], [tcl_ok=yes])

    if test "${enable_shared+set}" = set; then
	enableval="$enable_shared"
	tcl_ok=$enableval
    else
	tcl_ok=yes
    fi

    if test "$tcl_ok" = "yes" ; then
	AC_MSG_RESULT([shared])
	SHARED_BUILD=1
    else
	AC_MSG_RESULT([static])
	SHARED_BUILD=0
	AC_DEFINE(STATIC_BUILD)
    fi
    AC_SUBST(SHARED_BUILD)
])

#------------------------------------------------------------------------
# TEA_ENABLE_THREADS --
#
#	Specify if thread support should be enabled.  If "yes" is
#	specified as an arg (optional), threads are enabled by default.
#
# Arguments:
#	none
#	
# Results:
#
#	Adds the following arguments to configure:
#		--enable-threads
#
#	Sets the following vars:
#		THREADS_LIBS	Thread library(s)
#
#	Defines the following vars:
#		TCL_THREADS
#		_REENTRANT
#
#------------------------------------------------------------------------

AC_DEFUN([TEA_ENABLE_THREADS], [
    AC_ARG_ENABLE(threads, [  --enable-threads        build with threads],
	[tcl_ok=$enableval], [tcl_ok=$1])

    if test "$tcl_ok" = "yes"; then
	TCL_THREADS=1

	if test "${TEA_PLATFORM}" != "windows" ; then
	    # We are always OK on Windows, so check what this platform wants.
	    AC_DEFINE(USE_THREAD_ALLOC)
	    AC_DEFINE(_REENTRANT)
	    AC_DEFINE(_THREAD_SAFE)
	    AC_CHECK_LIB(pthread,pthread_mutex_init,tcl_ok=yes,tcl_ok=no)
	    if test "$tcl_ok" = "no"; then
		# Check a little harder for __pthread_mutex_init in the
		# same library, as some systems hide it there until
		# pthread.h is defined.	 We could alternatively do an
		# AC_TRY_COMPILE with pthread.h, but that will work with
		# libpthread really doesn't exist, like AIX 4.2.
		# [Bug: 4359]
		AC_CHECK_LIB(pthread, __pthread_mutex_init,
		    tcl_ok=yes, tcl_ok=no)
	    fi
	    
	    if test "$tcl_ok" = "yes"; then
		# The space is needed
		THREADS_LIBS=" -lpthread"
	    else
		AC_CHECK_LIB(pthreads, pthread_mutex_init,
		    tcl_ok=yes, tcl_ok=no)
		if test "$tcl_ok" = "yes"; then
		    # The space is needed
		    THREADS_LIBS=" -lpthreads"
		else
		    AC_CHECK_LIB(c, pthread_mutex_init,
			tcl_ok=yes, tcl_ok=no)
		    if test "$tcl_ok" = "no"; then
			AC_CHECK_LIB(c_r, pthread_mutex_init,
			    tcl_ok=yes, tcl_ok=no)
			if test "$tcl_ok" = "yes"; then
			    # The space is needed
			    THREADS_LIBS=" -pthread"
			else
			    TCL_THREADS=0
			    AC_MSG_WARN("Don t know how to find pthread lib on your system - thread support disabled")
			fi
		    fi
		fi
	    fi

	    # Does the pthread-implementation provide
	    # 'pthread_attr_setstacksize' ?

	    ac_saved_libs=$LIBS
	    LIBS="$LIBS $THREADS_LIBS"
	    AC_CHECK_FUNCS(pthread_attr_setstacksize)
	    LIBS=$ac_saved_libs
	    AC_CHECK_FUNCS(readdir_r)
	fi
    else
	TCL_THREADS=0
    fi
    # Do checking message here to not mess up interleaved configure output
    AC_MSG_CHECKING([for building with threads])
    if test "${TCL_THREADS}" = "1"; then
	AC_DEFINE(TCL_THREADS)
	AC_MSG_RESULT([yes])
    else
	AC_MSG_RESULT([no (default)])
    fi
    # TCL_THREADS sanity checking.  See if our request for building with
    # threads is the same as the way Tcl was built.  If not, warn the user.
    case ${TCL_DEFS} in
	*THREADS=1*)
	    if test "${TCL_THREADS}" = "0"; then
		AC_MSG_WARN([
    Building ${PACKAGE} without threads enabled, but building against a Tcl
    that IS thread-enabled.])
	    fi
	    ;;
	*)
	    if test "${TCL_THREADS}" = "1"; then
		AC_MSG_WARN([
    --enable-threads requested, but attempting building against a Tcl
    that is NOT thread-enabled.])
	    fi
	    ;;
    esac
    AC_SUBST(TCL_THREADS)
])

#------------------------------------------------------------------------
# TEA_ENABLE_SYMBOLS --
#
#	Specify if debugging symbols should be used
#	Memory (TCL_MEM_DEBUG) debugging can also be enabled.
#
# Arguments:
#	none
#	
#	Requires the following vars to be set:
#		CFLAGS_DEBUG
#		CFLAGS_OPTIMIZE
#		LDFLAGS_DEBUG
#		LDFLAGS_OPTIMIZE
#	
# Results:
#
#	Adds the following arguments to configure:
#		--enable-symbols
#
#	Defines the following vars:
#		CFLAGS_DEFAULT	Sets to CFLAGS_DEBUG if true
#				Sets to CFLAGS_OPTIMIZE if false
#		LDFLAGS_DEFAULT	Sets to LDFLAGS_DEBUG if true
#				Sets to LDFLAGS_OPTIMIZE if false
#		DBGX		Debug library extension
#
#------------------------------------------------------------------------

AC_DEFUN([TEA_ENABLE_SYMBOLS], [
    dnl Make sure we are initialized
    AC_REQUIRE([TEA_INIT])

    if test "${TEA_PLATFORM}" = "windows" ; then
	tcl_dbgx=d
    else
	tcl_dbgx=g
    fi

    AC_MSG_CHECKING([for build with symbols])
    AC_ARG_ENABLE(symbols, [  --enable-symbols        build with debugging symbols [--disable-symbols]],    [tcl_ok=$enableval], [tcl_ok=no])
    if test "$tcl_ok" = "no"; then
	CFLAGS_DEFAULT='$(CFLAGS_OPTIMIZE)'
	LDFLAGS_DEFAULT='$(LDFLAGS_OPTIMIZE)'
	DBGX=""
	TCL_DBGX=""
	AC_MSG_RESULT([no])
    else
	CFLAGS_DEFAULT='$(CFLAGS_DEBUG)'
	LDFLAGS_DEFAULT='$(LDFLAGS_DEBUG)'
	DBGX=${tcl_dbgx}
	TCL_DBGX=${tcl_dbgx}
	if test "$tcl_ok" = "yes"; then
	    AC_MSG_RESULT([yes (standard debugging)])
	fi
    fi

    AC_SUBST(TCL_DBGX)
    AC_SUBST(CFLAGS_DEFAULT)
    AC_SUBST(LDFLAGS_DEFAULT)

    if test "$tcl_ok" = "mem" -o "$tcl_ok" = "all"; then
	AC_DEFINE(TCL_MEM_DEBUG)
    fi

    if test "$tcl_ok" != "yes" -a "$tcl_ok" != "no"; then
	if test "$tcl_ok" = "all"; then
	    AC_MSG_RESULT([enabled symbols mem debugging])
	else
	    AC_MSG_RESULT([enabled $tcl_ok debugging])
	fi
    fi
])

#------------------------------------------------------------------------
# TEA_ENABLE_LANGINFO --
#
#	Allows use of modern nl_langinfo check for better l10n.
#	This is only relevant for Unix.
#
# Arguments:
#	none
#	
# Results:
#
#	Adds the following arguments to configure:
#		--enable-langinfo=yes|no (default is yes)
#
#	Defines the following vars:
#		HAVE_LANGINFO	Triggers use of nl_langinfo if defined.
#
#------------------------------------------------------------------------

AC_DEFUN([TEA_ENABLE_LANGINFO], [
    AC_ARG_ENABLE(langinfo,
	[  --enable-langinfo	  use nl_langinfo if possible to determine
			  encoding at startup, otherwise use old heuristic],
	[langinfo_ok=$enableval], [langinfo_ok=yes])

    HAVE_LANGINFO=0
    if test "$langinfo_ok" = "yes"; then
	if test "$langinfo_ok" = "yes"; then
	    AC_CHECK_HEADER(langinfo.h,[langinfo_ok=yes],[langinfo_ok=no])
	fi
    fi
    AC_MSG_CHECKING([whether to use nl_langinfo])
    if test "$langinfo_ok" = "yes"; then
	AC_TRY_COMPILE([#include <langinfo.h>],
		[nl_langinfo(CODESET);],[langinfo_ok=yes],[langinfo_ok=no])
	if test "$langinfo_ok" = "no"; then
	    langinfo_ok="no (could not compile with nl_langinfo)";
	fi
	if test "$langinfo_ok" = "yes"; then
	    AC_DEFINE(HAVE_LANGINFO)
	fi
    fi
    AC_MSG_RESULT([$langinfo_ok])
])

#--------------------------------------------------------------------
# TEA_CONFIG_CFLAGS
#
#	Try to determine the proper flags to pass to the compiler
#	for building shared libraries and other such nonsense.
#
# Arguments:
#	none
#
# Results:
#
#	Defines the following vars:
#
#       DL_OBJS -       Name of the object file that implements dynamic
#                       loading for Tcl on this system.
#       DL_LIBS -       Library file(s) to include in tclsh and other base
#                       applications in order for the "load" command to work.
#       LDFLAGS -      Flags to pass to the compiler when linking object
#                       files into an executable application binary such
#                       as tclsh.
#       LD_SEARCH_FLAGS-Flags to pass to ld, such as "-R /usr/local/tcl/lib",
#                       that tell the run-time dynamic linker where to look
#                       for shared libraries such as libtcl.so.  Depends on
#                       the variable LIB_RUNTIME_DIR in the Makefile.
#       SHLIB_CFLAGS -  Flags to pass to cc when compiling the components
#                       of a shared library (may request position-independent
#                       code, among other things).
#       SHLIB_LD -      Base command to use for combining object files
#                       into a shared library.
#       SHLIB_LD_LIBS - Dependent libraries for the linker to scan when
#                       creating shared libraries.  This symbol typically
#                       goes at the end of the "ld" commands that build
#                       shared libraries. The value of the symbol is
#                       "${LIBS}" if all of the dependent libraries should
#                       be specified when creating a shared library.  If
#                       dependent libraries should not be specified (as on
#                       SunOS 4.x, where they cause the link to fail, or in
#                       general if Tcl and Tk aren't themselves shared
#                       libraries), then this symbol has an empty string
#                       as its value.
#       SHLIB_SUFFIX -  Suffix to use for the names of dynamically loadable
#                       extensions.  An empty string means we don't know how
#                       to use shared libraries on this platform.
#       TCL_LIB_FILE -  Name of the file that contains the Tcl library, such
#                       as libtcl7.8.so or libtcl7.8.a.
#       TCL_LIB_SUFFIX -Specifies everything that comes after the "libtcl"
#                       in the shared library name, using the $VERSION variable
#                       to put the version in the right place.  This is used
#                       by platforms that need non-standard library names.
#                       Examples:  ${VERSION}.so.1.1 on NetBSD, since it needs
#                       to have a version after the .so, and ${VERSION}.a
#                       on AIX, since the Tcl shared library needs to have
#                       a .a extension whereas shared objects for loadable
#                       extensions have a .so extension.  Defaults to
#                       ${VERSION}${SHLIB_SUFFIX}.
#       TCL_NEEDS_EXP_FILE -
#                       1 means that an export file is needed to link to a
#                       shared library.
#       TCL_EXP_FILE -  The name of the installed export / import file which
#                       should be used to link to the Tcl shared library.
#                       Empty if Tcl is unshared.
#       TCL_BUILD_EXP_FILE -
#                       The name of the built export / import file which
#                       should be used to link to the Tcl shared library.
#                       Empty if Tcl is unshared.
#	CFLAGS_DEBUG -
#			Flags used when running the compiler in debug mode
#	CFLAGS_OPTIMIZE -
#			Flags used when running the compiler in optimize mode
#	EXTRA_CFLAGS -
#			Extra CFLAGS to pass to the compiler
#
#	Subst's the following vars:
#		DL_LIBS
#		CFLAGS_DEBUG
#		CFLAGS_OPTIMIZE
#		CFLAGS_WARNING
#
#		STLIB_LD
#		SHLIB_LD
#		SHLIB_CFLAGS
#		SHLIB_LDFLAGS
#		LDFLAGS_DEBUG
#		LDFLAGS_OPTIMIZE
#--------------------------------------------------------------------

AC_DEFUN([TEA_CONFIG_CFLAGS], [
    dnl Make sure we are initialized
    AC_REQUIRE([TEA_INIT])

    # Step 0: Enable 64 bit support?

    AC_MSG_CHECKING([if 64bit support is enabled])
    AC_ARG_ENABLE(64bit,[  --enable-64bit          enable 64bit support (where applicable)], [do64bit=$enableval], [do64bit=no])
    AC_MSG_RESULT([$do64bit])
 
    # Step 0.b: Enable Solaris 64 bit VIS support?

    AC_MSG_CHECKING([if 64bit Sparc VIS support is requested])
    AC_ARG_ENABLE(64bit-vis,[  --enable-64bit-vis      enable 64bit Sparc VIS support], [do64bitVIS=$enableval], [do64bitVIS=no])
    AC_MSG_RESULT([$do64bitVIS])

    if test "$do64bitVIS" = "yes" ; then
	# Force 64bit on with VIS
	do64bit=yes
    fi

    # Step 0.c: Cross-compiling options for Windows/CE builds?

    if test "${TEA_PLATFORM}" = "windows" ; then
	AC_MSG_CHECKING([if Windows/CE build is requested])
	AC_ARG_ENABLE(wince,[  --enable-wince          enable Win/CE support (where applicable)], [doWince=$enableval], [doWince=no])
	AC_MSG_RESULT($doWince)
    fi

    # Step 1: set the variable "system" to hold the name and version number
    # for the system.  This can usually be done via the "uname" command, but
    # there are a few systems, like Next, where this doesn't work.

    AC_MSG_CHECKING([system version (for dynamic loading)])
    if test -f /usr/lib/NextStep/software_version; then
	system=NEXTSTEP-`awk '/3/,/3/' /usr/lib/NextStep/software_version`
    else
	system=`uname -s`-`uname -r`
	if test "$?" -ne 0 ; then
	    AC_MSG_RESULT([unknown (can't find uname command)])
	    system=unknown
	else
	    # Special check for weird MP-RAS system (uname returns weird
	    # results, and the version is kept in special file).
	
	    if test -r /etc/.relid -a "X`uname -n`" = "X`uname -s`" ; then
		system=MP-RAS-`awk '{print $3}' /etc/.relid'`
	    fi
	    if test "`uname -s`" = "AIX" ; then
		system=AIX-`uname -v`.`uname -r`
	    fi
	    if test "${TEA_PLATFORM}" = "windows" ; then
		system=windows
	    fi
	    AC_MSG_RESULT([$system])
	fi
    fi

    # Step 2: check for existence of -ldl library.  This is needed because
    # Linux can use either -ldl or -ldld for dynamic loading.

    AC_CHECK_LIB(dl, dlopen, have_dl=yes, have_dl=no)

    # Step 3: set configuration options based on system name and version.

    do64bit_ok=no
    EXTRA_CFLAGS=""
    TCL_EXPORT_FILE_SUFFIX=""
    UNSHARED_LIB_SUFFIX=""
    TCL_TRIM_DOTS='`echo ${VERSION} | tr -d .`'
    ECHO_VERSION='`echo ${VERSION}`'
    TCL_LIB_VERSIONS_OK=ok
    CFLAGS_DEBUG=-g
    CFLAGS_OPTIMIZE=-O
    if test "$GCC" = "yes" ; then
	CFLAGS_WARNING="-Wall -Wconversion -Wno-implicit-int"
    else
	CFLAGS_WARNING=""
    fi
    TCL_NEEDS_EXP_FILE=0
    TCL_BUILD_EXP_FILE=""
    TCL_EXP_FILE=""
dnl FIXME: Replace AC_CHECK_PROG with AC_CHECK_TOOL once cross compiling is fixed.
dnl AC_CHECK_TOOL(AR, ar, :)
    AC_CHECK_PROG(AR, ar, ar)
    STLIB_LD='${AR} cr'
    case $system in
	windows)
	    # This is a 2-stage check to make sure we have the 64-bit SDK
	    # We have to know where the SDK is installed.
	    if test "$do64bit" = "yes" ; then
		if test "x${MSSDK}x" = "xx" ; then
		    MSSDK="C:/Progra~1/Microsoft SDK"
		fi
		# In order to work in the tortured autoconf environment,
		# we need to ensure that this path has no spaces
		MSSDK=`cygpath -w -s "$MSSDK" | sed -e 's!\\\!/!g'`
		if test ! -d "${MSSDK}/bin/win64" ; then
		    AC_MSG_WARN("could not find 64-bit SDK to enable 64bit mode")
		    do64bit="no"
		else
		    do64bit_ok="yes"
		fi
	    fi

	    if test "$doWince" != "no" ; then
		if test "$do64bit" = "yes" ; then
		    AC_MSG_ERROR([Windows/CE and 64-bit builds incompatible])
		fi
		if test "$GCC" = "yes" ; then
		    AC_MSG_ERROR([Windows/CE and GCC builds incompatible])
		fi
		TEA_PATH_CELIB
		# set defaults
		# Currently Tcl requires 300+
		CEVERSION=300;	  # could be 211 300 301 ...
		TARGETCPU=ARM;	  # could be ARM MIPS SH3 X86 ...
		PLATFORM="Pocket PC 2002"
		if test "$doWince" = "yes"; then
		    doWince="300,ARM,ARM,Pocket PC 2002"
		fi
		eval `echo $doWince | awk -F "," '{ \
		    if (length([$]1)) { printf "CEVERSION=%s\n", [$]1 }; \
		    if (length([$]2)) { printf "TARGETCPU=%s\n", toupper([$]2) }; \
		    if (length([$]3)) { printf "ARCH=%s\n", toupper([$]3) }; \
		    if (length([$]4)) { printf "PLATFORM=%s\n", [$]4 }; \
		    }'`
		OSVERSION=WCE$CEVERSION;
		if test "x${ARCH}" = "x" ; then
	            ARCH=$TARGETCPU;  # could be ARM MIPS SH3 X86 X86EM ...
		fi
		if test "x${WCEROOT}" = "x" ; then
		    WCEROOT="C:/Program Files/Microsoft eMbedded Tools"
		fi
		if test "x${SDKROOT}" = "x" ; then
		    SDKROOT="C:/Windows CE Tools"
		fi
		# In order to work in the tortured autoconf environment,
		# we need to ensure that this path has no spaces
		WCEROOT=`cygpath -w -s "$WCEROOT" | sed -e 's!\\\!/!g'`
		SDKROOT=`cygpath -w -s "$SDKROOT" | sed -e 's!\\\!/!g'`
		CELIB_DIR=`cygpath -w -s "$CELIB_DIR" | sed -e 's!\\\!/!g'`
		if test ! -d "${SDKROOT}/${OSVERSION}/${PLATFORM}/Lib/${TARGETCPU}" \
		    -o ! -d "${WCEROOT}/EVC/${OSVERSION}/bin"; then
		    AC_MSG_ERROR([could not find PocketPC SDK or target compiler to enable WinCE mode [$CEVERSION,$TARGETCPU,$ARCH,$PLATFORM]])
		    doWince="no"
		else
		    CEINCLUDE=`cygpath -w -s "${SDKROOT}/${OSVERSION}/${PLATFORM}/include" | sed -e 's!\\\!/!g'`
		    CELIBPATH=`cygpath -w -s "${SDKROOT}/${OSVERSION}/${PLATFORM}/Lib/${TARGETCPU}" | sed -e 's!\\\!/!g'`
    		fi
	    fi

	    if test "$GCC" != "yes" ; then
	        if test "${SHARED_BUILD}" = "0" ; then
		    runtime=-MT
	        else
		    runtime=-MD
	        fi

                if test "$do64bit" = "yes" ; then
		    # All this magic is necessary for the Win64 SDK RC1 - hobbs
		    export CC="${MSSDK}/Bin/Win64/cl.exe \
	                -I${MSSDK}/Include/prerelease \
                        -I${MSSDK}/Include/Win64/crt \
	                -I${MSSDK}/Include"
		    export RC="${MSSDK}/bin/rc.exe"
		    export lflags="-MACHINE:IA64 -LIBPATH:${MSSDK}/Lib/IA64 \
	                -LIBPATH:${MSSDK}/Lib/Prerelease/IA64"
		    export STLIB_LD="${MSSDK}/bin/win64/lib.exe -nologo ${lflags}"
		    export LINKBIN="${MSSDK}/bin/win64/link.exe ${lflags}"
		    CFLAGS_DEBUG="-nologo -Zi -Od -W3 ${runtime}d"
		    CFLAGS_OPTIMIZE="-nologo -O2 -Gs -W2 ${runtime}"
		elif test "$doWince" != "no" ; then
		    if test "${TARGETCPU}" = "X86"; then
			CC="${WCEROOT}/EVC/${OSVERSION}/bin/cl.exe -I\"${CELIB_DIR}/inc\" -I\"${CEINCLUDE}\""
		    else
			CC="${WCEROOT}/EVC/${OSVERSION}/bin/cl${TARGETCPU}.exe -I\"${CELIB_DIR}/inc\" -I\"${CEINCLUDE}\""
		    fi
		    RC="${WCEROOT}/Common/EVC/bin/rc.exe"
		    cpulower=`echo ${TARGETCPU} | awk '{print tolower([$]0)}'`
		    defs="${TARGETCPU} _${TARGETCPU}_ ${cpulower} _${cpulower}_ POCKET_SIZE PALM_SIZE _MT _DLL _WINDOWS"
		    for i in $defs ; do
			AC_DEFINE_UNQUOTED($i)
		    done
		    AC_DEFINE_UNQUOTED(_WIN32_WCE, $CEVERSION)
		    AC_DEFINE_UNQUOTED(UNDER_CE, $CEVERSION)
		    CFLAGS_DEBUG="-nologo -Zi -Od"
		    CFLAGS_OPTIMIZE="-nologo -Ox"
		    lflags="-MACHINE:${TARGETCPU} -LIBPATH:\"${CELIBPATH}\" -subsystem:windowsce,3.00"
		    STLIB_LD="${WCEROOT}/EVC/${OSVERSION}/bin/lib.exe -nologo ${lflags}"
		    LINKBIN="${WCEROOT}/EVC/${OSVERSION}/bin/link.exe ${lflags}"
		else
		    RC="rc"
		    STLIB_LD="lib -nologo"
    		    LINKBIN="link -link50compat"
		    CFLAGS_DEBUG="-nologo -Z7 -Od -W3 -WX ${runtime}d"
		    CFLAGS_OPTIMIZE="-nologo -O2 -Gs -GD -W2 ${runtime}"
		fi
	    fi

	    if test "$GCC" = "yes"; then
		# mingw gcc mode
		RC="windres"
		CFLAGS_DEBUG="-g"
		CFLAGS_OPTIMIZE="-O2"
		SHLIB_LD="$CC -shared"
		UNSHARED_LIB_SUFFIX='${TCL_TRIM_DOTS}\$\{DBGX\}.a'
		LDFLAGS_CONSOLE="-wl,--subsystem,console ${lflags}"
		LDFLAGS_WINDOW="-wl,--subsystem,windows ${lflags}"
	    else
		SHLIB_LD="${LINKBIN} -dll -nologo"
		UNSHARED_LIB_SUFFIX='${TCL_TRIM_DOTS}\$\{DBGX\}.lib'
		EXTRA_CFLAGS="-YX"
		PATHTYPE=-w
		# For information on what debugtype is most useful, see:
		# http://msdn.microsoft.com/library/en-us/dnvc60/html/gendepdebug.asp
		# This essentially turns it all on.
		LDFLAGS_DEBUG="-debug:full -debugtype:both -warn:2"
		LDFLAGS_OPTIMIZE="-release"
		if test "$doWince" != "no" ; then
		    LDFLAGS_CONSOLE="-link ${lflags}"
		    LDFLAGS_WINDOW=${LDFLAGS_CONSOLE}
		else
		    LDFLAGS_CONSOLE="-link -subsystem:console ${lflags}"
		    LDFLAGS_WINDOW="-link -subsystem:windows ${lflags}"
		fi
	    fi

	    SHLIB_LD_LIBS='${LIBS}'
	    SHLIB_SUFFIX=".dll"
	    SHARED_LIB_SUFFIX='${TCL_TRIM_DOTS}\$\{DBGX\}.dll'

	    TCL_LIB_VERSIONS_OK=nodots
	    # Bogus to avoid getting this turned off
	    DL_OBJS="tclLoadNone.obj"
    	    ;;
	AIX-*)
	    if test "${TCL_THREADS}" = "1" -a "$GCC" != "yes" ; then
		# AIX requires the _r compiler when gcc isn't being used
		if test "${CC}" != "cc_r" ; then
		    CC=${CC}_r
		fi
		AC_MSG_RESULT([Using $CC for compiling with threads])
	    fi
	    LIBS="$LIBS -lc"
	    SHLIB_CFLAGS=""
	    SHLIB_SUFFIX=".so"
	    SHLIB_LD_LIBS='${LIBS}'

	    DL_OBJS="tclLoadDl.o"
	    LDFLAGS=""

	    # AIX v<=4.1 has some different flags than 4.2+
	    if test "$system" = "AIX-4.1" -o "`uname -v`" -lt "4" ; then
		#LIBOBJS="$LIBOBJS tclLoadAix.o"
		AC_LIBOBJ([tclLoadAix])
		DL_LIBS="-lld"
	    fi

	    # Check to enable 64-bit flags for compiler/linker on AIX 4+
	    if test "$do64bit" = "yes" -a "`uname -v`" -gt "3" ; then
		if test "$GCC" = "yes" ; then
		    AC_MSG_WARN("64bit mode not supported with GCC on $system")
		else 
		    do64bit_ok=yes
		    EXTRA_CFLAGS="-q64"
		    LDFLAGS="-q64"
		    RANLIB="${RANLIB} -X64"
		    AR="${AR} -X64"
		    SHLIB_LDFLAGS="-b64"
		fi
	    fi

	    if test "$(uname -m)" = "ia64" ; then
		# AIX-5 uses ELF style dynamic libraries on IA-64, but not PPC
		SHLIB_LD="/usr/ccs/bin/ld -G -z text"
		# AIX-5 has dl* in libc.so
		DL_LIBS=""
		if test "$GCC" = "yes" ; then
		    LD_SEARCH_FLAGS='-Wl,-R,${LIB_RUNTIME_DIR}'
		else
		    LD_SEARCH_FLAGS='-R${LIB_RUNTIME_DIR}'
		fi
	    else
		SHLIB_LD="${TCL_SRC_DIR}/unix/ldAix /bin/ld -bhalt:4 -bM:SRE -bE:lib.exp -H512 -T512 -bnoentry ${SHLIB_LD_FLAGS}"
		DL_LIBS="-ldl"
		LD_SEARCH_FLAGS='-L${LIB_RUNTIME_DIR}'
		TCL_NEEDS_EXP_FILE=1
		TCL_EXPORT_FILE_SUFFIX='${VERSION}\$\{DBGX\}.exp'
	    fi

	    # On AIX <=v4 systems, libbsd.a has to be linked in to support
	    # non-blocking file IO.  This library has to be linked in after
	    # the MATH_LIBS or it breaks the pow() function.  The way to
	    # insure proper sequencing, is to add it to the tail of MATH_LIBS.
	    # This library also supplies gettimeofday.
	    #
	    # AIX does not have a timezone field in struct tm. When the AIX
	    # bsd library is used, the timezone global and the gettimeofday
	    # methods are to be avoided for timezone deduction instead, we
	    # deduce the timezone by comparing the localtime result on a
	    # known GMT value.

	    AC_CHECK_LIB(bsd, gettimeofday, libbsd=yes, libbsd=no)
	    if test $libbsd = yes; then
	    	MATH_LIBS="$MATH_LIBS -lbsd"
	    	AC_DEFINE(USE_DELTA_FOR_TZ)
	    fi
	    ;;
	BSD/OS-2.1*|BSD/OS-3*)
	    SHLIB_CFLAGS=""
	    SHLIB_LD="shlicc -r"
	    SHLIB_LD_LIBS='${LIBS}'
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    LDFLAGS=""
	    LD_SEARCH_FLAGS=""
	    ;;
	BSD/OS-4.*)
	    SHLIB_CFLAGS="-export-dynamic -fPIC"
	    SHLIB_LD="cc -shared"
	    SHLIB_LD_LIBS='${LIBS}'
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    LDFLAGS="-export-dynamic"
	    LD_SEARCH_FLAGS=""
	    ;;
	dgux*)
	    SHLIB_CFLAGS="-K PIC"
	    SHLIB_LD="cc -G"
	    SHLIB_LD_LIBS=""
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    LDFLAGS=""
	    LD_SEARCH_FLAGS=""
	    ;;
	HP-UX-*.11.*)
	    # Use updated header definitions where possible
	    AC_DEFINE(_XOPEN_SOURCE_EXTENDED)

	    SHLIB_SUFFIX=".sl"
	    AC_CHECK_LIB(dld, shl_load, tcl_ok=yes, tcl_ok=no)
	    if test "$tcl_ok" = yes; then
		SHLIB_CFLAGS="+z"
		SHLIB_LD="ld -b"
		SHLIB_LD_LIBS='${LIBS}'
		DL_OBJS="tclLoadShl.o"
		DL_LIBS="-ldld"
		LDFLAGS="-Wl,-E"
		LD_SEARCH_FLAGS='-Wl,+s,+b,${LIB_RUNTIME_DIR}:.'
	    fi

	    # Users may want PA-RISC 1.1/2.0 portable code - needs HP cc
	    #EXTRA_CFLAGS="+DAportable"

	    # Check to enable 64-bit flags for compiler/linker
	    if test "$do64bit" = "yes" ; then
		if test "$GCC" = "yes" ; then
		    hpux_arch=`${CC} -dumpmachine`
		    case $hpux_arch in
			hppa64*)
			    # 64-bit gcc in use.  Fix flags for GNU ld.
			    do64bit_ok=yes
			    SHLIB_LD="${CC} -shared"
			    SHLIB_LD_LIBS=""
			    LD_SEARCH_FLAGS=''
			    ;;
			*)
			    AC_MSG_WARN("64bit mode not supported with GCC on $system")
			    ;;
		    esac
		else
		    do64bit_ok=yes
		    if test "`uname -m`" = "ia64" ; then
			EXTRA_CFLAGS="+DD64"
			LDFLAGS="+DD64 $LDFLAGS"
		    else
			EXTRA_CFLAGS="+DA2.0W"
			LDFLAGS="+DA2.0W $LDFLAGS"
		    fi
		fi
	    fi
	    ;;
	HP-UX-*.08.*|HP-UX-*.09.*|HP-UX-*.10.*)
	    SHLIB_SUFFIX=".sl"
	    AC_CHECK_LIB(dld, shl_load, tcl_ok=yes, tcl_ok=no)
	    if test "$tcl_ok" = yes; then
		SHLIB_CFLAGS="+z"
		SHLIB_LD="ld -b"
		SHLIB_LD_LIBS=""
		DL_OBJS="tclLoadShl.o"
		DL_LIBS="-ldld"
		LDFLAGS="-Wl,-E"
		LD_SEARCH_FLAGS='-Wl,+s,+b,${LIB_RUNTIME_DIR}:.'
	    fi
	    ;;
	IRIX-4.*)
	    SHLIB_CFLAGS="-G 0"
	    SHLIB_SUFFIX=".a"
	    SHLIB_LD="echo tclLdAout $CC \{$SHLIB_CFLAGS\} | `pwd`/tclsh -r -G 0"
	    SHLIB_LD_LIBS='${LIBS}'
	    DL_OBJS="tclLoadAout.o"
	    DL_LIBS=""
	    LDFLAGS="-Wl,-D,08000000"
	    LD_SEARCH_FLAGS='-L${LIB_RUNTIME_DIR}'
	    SHARED_LIB_SUFFIX='${VERSION}\$\{DBGX\}.a'
	    ;;
	IRIX-5.*)
	    SHLIB_CFLAGS=""
	    SHLIB_LD="ld -shared -rdata_shared"
	    SHLIB_LD_LIBS='${LIBS}'
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS=""
	    LD_SEARCH_FLAGS='-Wl,-rpath,${LIB_RUNTIME_DIR}'
	    EXTRA_CFLAGS=""
	    LDFLAGS=""
	    ;;
	IRIX-6.*|IRIX64-6.5*)
	    SHLIB_CFLAGS=""
	    SHLIB_LD="ld -n32 -shared -rdata_shared"
	    SHLIB_LD_LIBS='${LIBS}'
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS=""
	    LD_SEARCH_FLAGS='-Wl,-rpath,${LIB_RUNTIME_DIR}'
	    if test "$GCC" = "yes" ; then
		EXTRA_CFLAGS="-mabi=n32"
		LDFLAGS="-mabi=n32"
	    else
		case $system in
		    IRIX-6.3)
			# Use to build 6.2 compatible binaries on 6.3.
			EXTRA_CFLAGS="-n32 -D_OLD_TERMIOS"
			;;
		    *)
			EXTRA_CFLAGS="-n32"
			;;
		esac
		LDFLAGS="-n32"
	    fi
	    ;;
	IRIX64-6.*)
	    SHLIB_CFLAGS=""
	    SHLIB_LD="ld -n32 -shared -rdata_shared"
	    SHLIB_LD_LIBS='${LIBS}'
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS=""
	    LDFLAGS=""
	    LD_SEARCH_FLAGS='-Wl,-rpath,${LIB_RUNTIME_DIR}'

	    # Check to enable 64-bit flags for compiler/linker

	    if test "$do64bit" = "yes" ; then
	        if test "$GCC" = "yes" ; then
	            AC_MSG_WARN([64bit mode not supported by gcc])
	        else
	            do64bit_ok=yes
	            SHLIB_LD="ld -64 -shared -rdata_shared"
	            EXTRA_CFLAGS="-64"
	            LDFLAGS="-64"
	        fi
	    fi
	    ;;
	Linux*)
	    SHLIB_CFLAGS="-fPIC"
	    SHLIB_LD_LIBS='${LIBS}'
	    SHLIB_SUFFIX=".so"

	    # egcs-2.91.66 on Redhat Linux 6.0 generates lots of warnings 
	    # when you inline the string and math operations.  Turn this off to
	    # get rid of the warnings.

	    #CFLAGS_OPTIMIZE="${CFLAGS_OPTIMIZE} -D__NO_STRING_INLINES -D__NO_MATH_INLINES"

	    if test "$have_dl" = yes; then
		SHLIB_LD="${CC} -shared"
		DL_OBJS="tclLoadDl.o"
		DL_LIBS="-ldl"
		LDFLAGS="-rdynamic"
		LD_SEARCH_FLAGS='-Wl,-rpath,${LIB_RUNTIME_DIR}'
	    else
		AC_CHECK_HEADER(dld.h, [
		    SHLIB_LD="ld -shared"
		    DL_OBJS="tclLoadDld.o"
		    DL_LIBS="-ldld"
		    LDFLAGS=""
		    LD_SEARCH_FLAGS=""])
	    fi
	    if test "$(uname -m)" = "alpha" ; then
		EXTRA_CFLAGS="-mieee"
	    fi

	    # The combo of gcc + glibc has a bug related
	    # to inlining of functions like strtod(). The
	    # -fno-builtin flag should address this problem
	    # but it does not work. The -fno-inline flag
	    # is kind of overkill but it works.
	    # Disable inlining only when one of the
	    # files in compat/*.c is being linked in.
	    if test x"${USE_COMPAT}" != x ; then
	        EXTRA_CFLAGS="${EXTRA_CFLAGS} -fno-inline"
	    fi

	    ;;
	GNU*)
	    SHLIB_CFLAGS="-fPIC"
	    SHLIB_LD_LIBS='${LIBS}'
	    SHLIB_SUFFIX=".so"

	    if test "$have_dl" = yes; then
		SHLIB_LD="${CC} -shared"
		DL_OBJS=""
		DL_LIBS="-ldl"
		LDFLAGS="-rdynamic"
		LD_SEARCH_FLAGS=""
	    else
		AC_CHECK_HEADER(dld.h, [
		    SHLIB_LD="ld -shared"
		    DL_OBJS=""
		    DL_LIBS="-ldld"
		    LDFLAGS=""
		    LD_SEARCH_FLAGS=""])
	    fi
	    if test "$(uname -m)" = "alpha" ; then
		EXTRA_CFLAGS="-mieee"
	    fi
	    ;;
	MP-RAS-02*)
	    SHLIB_CFLAGS="-K PIC"
	    SHLIB_LD="cc -G"
	    SHLIB_LD_LIBS=""
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    LDFLAGS=""
	    LD_SEARCH_FLAGS=""
	    ;;
	MP-RAS-*)
	    SHLIB_CFLAGS="-K PIC"
	    SHLIB_LD="cc -G"
	    SHLIB_LD_LIBS=""
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    LDFLAGS="-Wl,-Bexport"
	    LD_SEARCH_FLAGS=""
	    ;;
	NetBSD-*|FreeBSD-[[1-2]].*|OpenBSD-*)
	    # Not available on all versions:  check for include file.
	    AC_CHECK_HEADER(dlfcn.h, [
		# NetBSD/SPARC needs -fPIC, -fpic will not do.
		SHLIB_CFLAGS="-fPIC"
		SHLIB_LD="ld -Bshareable -x"
		SHLIB_LD_LIBS=""
		SHLIB_SUFFIX=".so"
		DL_OBJS="tclLoadDl.o"
		DL_LIBS=""
		LDFLAGS=""
		LD_SEARCH_FLAGS='-Wl,-rpath,${LIB_RUNTIME_DIR}'
		AC_MSG_CHECKING([for ELF])
		AC_EGREP_CPP(yes, [
#ifdef __ELF__
	yes
#endif
		],
		    AC_MSG_RESULT([yes])
		    SHARED_LIB_SUFFIX='${TCL_TRIM_DOTS}\$\{DBGX\}.so',
		    AC_MSG_RESULT([no])
		    SHARED_LIB_SUFFIX='${TCL_TRIM_DOTS}\$\{DBGX\}.so.1.0'
		)
	    ], [
		SHLIB_CFLAGS=""
		SHLD
