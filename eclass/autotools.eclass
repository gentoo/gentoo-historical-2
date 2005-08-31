# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/autotools.eclass,v 1.16 2005/08/31 01:44:02 azarah Exp $
#
# Author: Diego Pettenò <flameeyes@gentoo.org>
# Enhancements: Martin Schlemmer <azarah@gentoo.org>
#
# This eclass is for handling autotooled software packages that
# needs to regenerate their build scripts.
#
# NB:  If you add anything, please comment it!

inherit eutils gnuconfig

#DEPEND="sys-devel/automake
#	sys-devel/autoconf
#	sys-devel/libtool"
#
# Ebuilds should rather depend on the proper version of the tool.

# Variables:
#
#   AT_M4DIR - Additional director(y|ies) aclocal should include
#   AT_GNUCONF_UPDATE - Should gnuconfig_update() be run (normally handled by
#                  econf()) [yes|no]

# XXX: M4DIR should be depreciated
AT_M4DIR=${AT_M4DIR:-${M4DIR}}
AT_GNUCONF_UPDATE="no"

# Internal function to run an autotools' tool
autotools_run_tool() {
	local STDERR_TARGET="${T}/$$.out"
	local PATCH_TARGET="${T}/$$.patch"
	local ris

	echo "***** $1 *****" > ${STDERR_TARGET%/*}/$1-${STDERR_TARGET##*/}
	echo >> ${STDERR_TARGET%/*}/$1-${STDERR_TARGET##*/}

	ebegin "Running $1"
	$@ >> ${STDERR_TARGET%/*}/$1-${STDERR_TARGET##*/} 2>&1
	ris=$?
	eend ${ris}

	if [[ ${ris} != 0 ]]; then
		echo
		eerror "Failed Running $1 !"
		eerror
		eerror "Include in your bugreport the contents of:"
		eerror
		eerror "  ${STDERR_TARGET%/*}/$1-${STDERR_TARGET##*/}"
		echo
		die "Failed Running $1 !"
	fi
}

# Internal function to check for support
autotools_check_macro() {
	[[ -f configure.ac || -f configure.in ]] && \
		autoconf --trace=$1 2>/dev/null
	return 0
}

# Internal function to get additional subdirs to configure
autotools_get_subdirs() {
	local subdirs_scan_out

	subdirs_scan_out=$(autotools_check_macro "AC_CONFIG_SUBDIRS")
	[[ -n ${subdirs_scan_out} ]] || return 0

	echo "${subdirs_scan_out}" | gawk \
	'($0 !~ /^[[:space:]]*(#|dnl)/) {
		if (match($0, "AC_CONFIG_SUBDIRS\\(\\[?([^\\])]*)", res)) {
			split(res[1], DIRS, /[\])]/)
			print DIRS[1]
		}
	}' | uniq

	return 0
}



# These functions runs the autotools using autotools_run_tool with the
# specified parametes. The name of the tool run is the same of the function
# without e prefix.
# They also force installing the support files for safety.
eaclocal() {
	local aclocal_opts

	# XXX: M4DIR should be depreciated
	AT_M4DIR=${AT_M4DIR:-${M4DIR}}

	if [[ -n ${AT_M4DIR} ]] ; then
		for x in ${AT_M4DIR} ; do
			case "${x}" in
			"-I")
				# We handle it below
				;;
			"-I"*)
				# Invalid syntax, but maybe we should help out ...
				ewarn "eaclocal: Proper syntax is (note the space after '-I'): aclocal -I <dir>"
				aclocal_opts="${aclocal_opts} -I ${x}"
				;;
			*)
				[[ ! -d ${x} ]] && ewarn "eaclocal: '${x}' does not exist"
				aclocal_opts="${aclocal_opts} -I ${x}"
				;;
			esac
		done
	fi

	[[ -f aclocal.m4 && -n $(grep -e 'generated.*by aclocal' aclocal.m4) ]] && \
		autotools_run_tool aclocal "$@" ${aclocal_opts}
}

_elibtoolize() {
	# Check if we should run libtoolize
	[[ -n $(autotools_check_macro "AC_PROG_LIBTOOL") ]] || return 0
	use userland_Darwin && LIBTOOLIZE="glibtoolize"
	autotools_run_tool ${LIBTOOLIZE:-libtoolize} "$@"

	# Need to rerun aclocal
	eaclocal
}

eautoheader() {
	# Check if we should run autoheader
	[[ -n $(autotools_check_macro "AC_CONFIG_HEADERS") ]] || return 0
	autotools_run_tool autoheader "$@"
}

eautoconf() {
	if [[ ! -f configure.ac && ! -f configure.in ]] ; then
		echo
		eerror "No configure.{ac,in} present in '$(pwd | sed -e 's:.*/::')'!"
		echo
		die "No configure.{ac,in} present!"
	fi

	autotools_run_tool autoconf "$@"
}

eautomake() {
	[[ -f Makefile.am ]] || return 0
	# --force-missing seems not to be recognized by some flavours of automake
	autotools_run_tool automake --add-missing --copy "$@"
}

# This function mimes the behavior of autoreconf, but uses the different
# eauto* functions to run the tools. It doesn't accept parameters, but
# the directory with include files can be specified with AT_M4DIR variable.
#
# Note: doesn't run autopoint right now, but runs gnuconfig_update.
eautoreconf() {
	local pwd=$(pwd) x

	# Take care of subdirs
	for x in $(autotools_get_subdirs); do
		if [[ -d ${x} ]] ; then
			cd "${x}"
			eautoreconf
			cd "${pwd}"
		fi
	done

	eaclocal
	_elibtoolize --copy --force
	eautoconf
	eautoheader
	eautomake

	# Normally run by econf()
	[[ ${AT_GNUCONF_UPDATE} == "yes" ]] && gnuconfig_update
}
