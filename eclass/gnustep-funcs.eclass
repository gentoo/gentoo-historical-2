# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gnustep-funcs.eclass,v 1.4 2005/03/18 02:47:00 fafhrd Exp $

inherit toolchain-funcs eutils

ECLASS=gnustep-funcs
INHERITED="$INHERITED $ECLASS"

DESCRIPTION="EClass that centralizes access to GNUstep environment information."

###########################################################################
# Functions
# ---------

# Prints out the dirname of GNUSTEP_SYSTEM_ROOT, i.e., "System" is installed
#  in egnustep_prefix
egnustep_prefix() {
	# Generally, only gnustep-make should be the one setting this value
	#if [ "$1" ] && [ ! -f /etc/conf.d/net ]; then
	if [ "$1" ]; then
		__GS_PREFIX="$(dirname $1/prune)"
		return 0
	fi

	if [ -f /etc/conf.d/gnustep.env ]; then
		. /etc/conf.d/gnustep.env
		if [ -z "${GNUSTEP_SYSTEM_ROOT}" ] || [ "/" != "${GNUSTEP_SYSTEM_ROOT:0:1}" ]; then
			die "Please check /etc/conf.d/gnustep.env for consistency or remove it."
		fi
		__GS_PREFIX=$(dirname ${GNUSTEP_SYSTEM_ROOT})
	elif [ -z "${__GS_PREFIX}" ]; then
		__GS_PREFIX="/usr/GNUstep"
		__GS_SYSTEM_ROOT="/usr/GNUstep/System"
	fi

	echo "${__GS_PREFIX}"
}

# Prints/sets the GNUstep install domain; Generally, this will only be
#  "System" or "Local"
egnustep_install_domain() {
	if [ -z "$1" ]; then
		if [ -z "$__GS_INSTALL_DOMAIN" ]; then
			# backwards comapatbility for older ebuilds
			__GS_INSTALL_DOMAIN="GNUSTEP_SYSTEM_ROOT"
		fi
		echo ${!__GS_INSTALL_DOMAIN}
		return 0
	else
		if [ "$1" == "System" ]; then
			__GS_INSTALL_DOMAIN="GNUSTEP_SYSTEM_ROOT"
		elif [ "$1" == "Local" ]; then
			__GS_INSTALL_DOMAIN="GNUSTEP_LOCAL_ROOT"
#		elif [ "$1" == "Network" ]; then
#			__GS_INSTALL_DOMAIN="GNUSTEP_NETWORK_ROOT"
		else
			die "An invalid parameter has been passed to ${FUNCNAME}"
		fi
	fi
}

# Clean/reset an ebuild to the installed GNUstep evironment; generally,
#  this is called once an ebuild (at least), and packages that will
#  inherit from gnustep.eclass already do this
egnustep_env() {
	GNUSTEP_SYSTEM_ROOT="$(egnustep_prefix)/System"
	if [ -f ${GNUSTEP_SYSTEM_ROOT}/Library/Makefiles/GNUstep.sh ] ; then
		. ${GNUSTEP_SYSTEM_ROOT}/Library/Makefiles/GNUstep-reset.sh
		if [ -f /etc/conf.d/gnustep.env ]; then 
			. /etc/conf.d/gnustep.env
		else
			GNUSTEP_SYSTEM_ROOT="/usr/GNUstep/System"
		fi
		. ${GNUSTEP_SYSTEM_ROOT}/Library/Makefiles/GNUstep.sh

		__GS_SYSTEM_ROOT=${GNUSTEP_SYSTEM_ROOT}
		__GS_LOCAL_ROOT=${GNUSTEP_LOCAL_ROOT}
		__GS_NETWORK_ROOT=${GNUSTEP_NETWORK_ROOT}
		__GS_USER_ROOT=${GNUSTEP_USER_ROOT}
		__GS_USER_ROOT_SUFFIX=$(dirname ${GNUSTEP_USER_ROOT#*$USER}/prune)/
		
		# "gs_prefix" is the prefix that GNUstep is installed into, e.g.
		#  gs_prefix=/usr/GNUstep => GNUSTEP_SYSTEM_ROOT=${gs_prefix}/System
		local gs_prefix=`egnustep_prefix`
		echo ${gs_prefix//\//XXX_SED_FSLASH} > ${TMP}/sed.gs_prefix

		# "gs_user_root_suffix" what is left over from the difference of
		# GNUSTEP_USER_ROOT and HOME, e.g.:
		# "/home/something/whatever/.config/GNUstep" => ".config/GNUstep"
		echo ${__GS_USER_ROOT_SUFFIX//\//XXX_SED_FSLASH} > ${TMP}/sed.gs_user_root_suffix

		# Set up common env vars for make operations
		__GS_MAKE_EVAL="HOME=\${TMP} \
			GNUSTEP_USER_ROOT=\${TMP} \
			GNUSTEP_DEFAULTS_ROOT=\${TMP}/\${__GS_USER_ROOT_SUFFIX} \
			INSTALL_ROOT_DIR=\${D} \
			GNUSTEP_INSTALLATION_DIR=\${D}/\$(egnustep_install_domain)
			GNUSTEP_MAKEFILES=\${GNUSTEP_SYSTEM_ROOT}/Library/Makefiles \
			GNUSTEP_NETWORK_ROOT=\${GNUSTEP_NETWORK_ROOT} \
			GNUSTEP_LOCAL_ROOT=\${GNUSTEP_LOCAL_ROOT} \
			GNUSTEP_SYSTEM_ROOT=\${GNUSTEP_SYSTEM_ROOT} \
			TAR_OPTIONS=\"\${TAR_OPTIONS} --no-same-owner\" \
			-j1"
	else
		die "gnustep-make not installed!"
	fi
}

# Get/Set the GNUstep system root
egnustep_system_root() {
	if [ "$1" ]; then
		__GS_SYSTEM_ROOT="$(dirname $1/prune)"
	else
		echo ${__GS_SYSTEM_ROOT}
	fi
}

# Get/Set the GNUstep local root
egnustep_local_root() {
	if [ "$1" ]; then
		__GS_LOCAL_ROOT="$(dirname $1/prune)"
	else
		echo ${__GS_LOCAL_ROOT}
	fi
}

# Get/Set the GNUstep network root
egnustep_network_root() {
	if [ "$1" ]; then
		__GS_NETWORK_ROOT="$(dirname $1/prune)"
	else
		echo ${__GS_NETWORK_ROOT}
	fi
}

# Get/Set the GNUstep user root
# Note: watch out for this one -- ~ and such must be enclosed in single-quotes when passed in
egnustep_user_root() {
	if [ "$1" ]; then
		__GS_USER_ROOT="$(dirname $1/prune)"
	else
		echo ${__GS_USER_ROOT}
	fi
}

# Print the "suffix" of the user_root, or simply
# e.g ~/GNUstep => GNUstep
egnustep_user_root_suffix() {
	echo ${!__GS_USER_ROOT_SUFFIX}
}

# Make utilizing GNUstep Makefiles
egnustep_make() {
	if [ -f ./[mM]akefile -o -f ./GNUmakefile ] ; then
		local gs_make_opts="${1}"
		if use debug ; then
			gs_make_opts="${gs_make_opts} debug=yes"
		fi
		if use profile; then
			gs_make_opts="${gs_make_opts} profile=yes"
		fi
		eval emake ${__GS_MAKE_EVAL} ${gs_make_opts} all || die "package make failed"
	else
		die "no Makefile found"
	fi
	return 0
}

# Copies "convenience scripts"
egnustep_package_config() {
	if [ -f ${FILESDIR}/config-${PN}.sh ]; then
		dodir `egnustep_install_domain`/Tools/Gentoo
		exeinto `egnustep_install_domain`/Tools/Gentoo
		doexe ${FILESDIR}/config-${PN}.sh
	fi
}

# Informs user about existence of "convenience script"
egnustep_package_config_info() {
	if [ -f ${FILESDIR}/config-${PN}.sh ]; then
		einfo "Make sure to set happy defaults for this package by executing:"
		einfo "  `egnustep_install_domain`/Tools/Gentoo/config-${PN}.sh"
		einfo "as the user you will run the package as." 
	fi
}

# Make-install utilizing GNUstep Makefiles
egnustep_install() {
	if [ -f ./[mM]akefile -o -f ./GNUmakefile ] ; then
		local gs_make_opts="${1}"
		if use debug ; then
			gs_make_opts="${gs_make_opts} debug=yes"
		fi
		if use profile; then
			gs_make_opts="${gs_make_opts} profile=yes"
		fi
		eval emake ${__GS_MAKE_EVAL} ${gs_make_opts} install || die "package install failed"
	else
		die "no Makefile found"
	fi
	return 0
}

# Make and install docs utilzing GNUstep Makefiles
# Note: docs installed with this from a GNUMakefile,
#  not just some files in a Documentation directory
egnustep_doc() {
	cd ${S}/Documentation
	if [ -f ./[mM]akefile -o -f ./GNUmakefile ] ; then
		local gs_make_opts="${1}"
		if use debug ; then
			gs_make_opts="${gs_make_opts} debug=yes"
		fi
		if use profile; then
			gs_make_opts="${gs_make_opts} profile=yes"
		fi
		eval emake ${__GS_MAKE_EVAL} ${gs_make_opts} all || die "doc make failed"
		eval emake ${__GS_MAKE_EVAL} ${gs_make_opts} install || die "doc install failed"
#XXX: I have no idea why this is called by ebuilds that don't have 'doc' in the
#  USE flags, but user has 'doc' in global USE in make.conf
#	else
#		die "no Makefile found"
	fi
	cd ..
	return 0
}

###########################################################################
# Tests
# -----

objc_available() {
	export OBJC_TEST="${TMP}/objc_test.m"
	cat > "${OBJC_TEST}" << EOF
/**
 * This example taken from the tutorial at:
 * http://gnustep.made-it.com/GSPT/xml/Tutorial_en.html
 <quote>
 A GNUstep Programming Tutorial
 Time is on our side...
 Yen-Ju Chen
 Dennis Leeuw

 Copyright Â© 2003 Yen-Ju Chen, Dennis Leeuw

 Permission is granted to copy, distribute and/or modify this document under the terms of the GNU Free Documentation License, Version 1.2 or any later version published by the Free Software Foundation; with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
 </quote>
 */
#include <objc/Object.h>
@interface Greeter:Object
{
	/* This is left empty on purpose:
	 * Normally instance variables would be declared here,
	 * but these are not used in our example.
	 */
}
- (void)greet;
@end

#include <stdio.h>
@implementation Greeter
- (void)greet
{
	printf("Hello, World!\n");
}
@end

#include <stdlib.h>
int main(void)
{
	id myGreeter;
	myGreeter=[Greeter new];
	[myGreeter greet];
	[myGreeter free];
	return EXIT_SUCCESS;
}
EOF

	local available
	available="yes"
	eval $(tc-getCC) ${OBJC_TEST} -o ${OBJC_TEST}-out -lobjc || available="no"

	echo ${available}
}

objc_not_available_info() {
	einfo "gcc must be compiled with Objective-C support! See the objc USE flag."
	einfo "NOTE: if you have to recompile gcc anyway, now may be the time to also add the 'gcj' use flag, so that libffi will also be compiled.  Any gcc-3 version with 'gcj' should work, however, if you are testing >=gcc-3.4.3-r1 'objc' USE flag on should also install libffi."
}

ffi_available() {
	export FFI_TEST="${TMP}/ffi_test.m"
	cat > "${FFI_TEST}" << EOF
#include <ffi.h>

int main(int argc, char *argv[])
{
	int n = argc;

	return 0;
}
EOF

	local available
	available="yes"
	# XXX
	# Support dev-libs/libffi until it is deprecate
	# (not that these -I and -L really matter
	eval $(tc-getCC) ${FFI_TEST} -o ${FFI_TEST}-out -lffi || available="no"

	echo ${available}
}

ffi_not_available_info() {
	einfo "Your FFI libraries and headers seem to be installed incorrectly."
	einfo "This is not as bad as it sounds -- not many projects use libffi at the moment, and gcc may have installed the headers in an inavailable place.  Especially check for 'ffi.h' in your /usr/lib/gcc/\"\$CHOST\"/\"gcc-version\"/include directory, and that any other ffi related files it #include's (e.g. 'ffitarget.h') are in that directory as well; this can be solved by moving the files, or with a symlink.  This is a quick fix, and newer ebuilds of gcc should install the files in the correct places, but for now, it could save you a recompilation of gcc."
	einfo "If this still fails for you, consider not using the 'gcc-libffi' USE flag and letting dev-libs/libffi build as a dependency.  It is important that either 'gcj' is a USE flag for gcc, or 'gcj' or 'objc' for >=gcc-3.4.3-r1."
}

###########################################################################

