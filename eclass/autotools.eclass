# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/autotools.eclass,v 1.89 2010/01/10 18:39:16 scarabeus Exp $

# @ECLASS: autotools.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @BLURB: Regenerates auto* build scripts
# @DESCRIPTION:
# This eclass is for safely handling autotooled software packages that need to
# regenerate their build scripts.  All functions will abort in case of errors.
#
# NB:  If you add anything, please comment it!

inherit eutils libtool

# @ECLASS-VARIABLE: WANT_AUTOCONF
# @DESCRIPTION:
# The major version of autoconf your package needs
[[ -z ${WANT_AUTOCONF} ]] && WANT_AUTOCONF="latest"

# @ECLASS-VARIABLE: WANT_AUTOMAKE
# @DESCRIPTION:
# The major version of automake your package needs
[[ -z ${WANT_AUTOMAKE} ]] && WANT_AUTOMAKE="latest"

_automake_atom="sys-devel/automake"
_autoconf_atom="sys-devel/autoconf"
if [[ -n ${WANT_AUTOMAKE} ]]; then
	case ${WANT_AUTOMAKE} in
		none)   _automake_atom="" ;; # some packages don't require automake at all
		# if you change the “latest” version here, change also autotools_run_tool
		latest) _automake_atom="=sys-devel/automake-1.10*" ;;
		*)      _automake_atom="=sys-devel/automake-${WANT_AUTOMAKE}*" ;;
	esac
	export WANT_AUTOMAKE
fi

if [[ -n ${WANT_AUTOCONF} ]] ; then
	case ${WANT_AUTOCONF} in
		none)       _autoconf_atom="" ;; # some packages don't require autoconf at all
		2.1)        _autoconf_atom="=sys-devel/autoconf-${WANT_AUTOCONF}*" ;;
		# if you change the “latest” version here, change also autotools_run_tool
		latest|2.5) _autoconf_atom=">=sys-devel/autoconf-2.61" ;;
		*)          _autoconf_atom="INCORRECT-WANT_AUTOCONF-SETTING-IN-EBUILD" ;;
	esac
	export WANT_AUTOCONF
fi
DEPEND="${_automake_atom}
	${_autoconf_atom}"
[[ ${CATEGORY}/${PN} != "sys-devel/libtool" ]] && DEPEND="${DEPEND} sys-devel/libtool"
RDEPEND=""
unset _automake_atom _autoconf_atom

# @ECLASS-VARIABLE: AM_OPTS
# @DESCRIPTION:
# Additional options to pass to automake during
# eautoreconf call.

# @ECLASS-VARIABLE: AT_NOELIBTOOLIZE
# @DESCRIPTION:
# Don't run elibtoolize command if set to 'yes',
# useful when elibtoolize needs to be ran with
# particular options

# XXX: M4DIR should be deprecated
# @ECLASS-VARIABLE: AT_M4DIR
# @DESCRIPTION:
# Additional director(y|ies) aclocal should search
AT_M4DIR=${AT_M4DIR:-${M4DIR}}
AT_GNUCONF_UPDATE="no"


# @FUNCTION: eautoreconf
# @DESCRIPTION:
# This function mimes the behavior of autoreconf, but uses the different
# eauto* functions to run the tools. It doesn't accept parameters, but
# the directory with include files can be specified with AT_M4DIR variable.
#
# Should do a full autoreconf - normally what most people will be interested in.
# Also should handle additional directories specified by AC_CONFIG_SUBDIRS.
eautoreconf() {
	local pwd=$(pwd) x auxdir g=

	if [[ -z ${AT_NO_RECURSIVE} ]]; then
		# Take care of subdirs
		for x in $(autotools_get_subdirs); do
			if [[ -d ${x} ]] ; then
				cd "${x}"
				AT_NOELIBTOOLIZE="yes" eautoreconf
				cd "${pwd}"
			fi
		done
	fi

	auxdir=$(autotools_get_auxdir)

	einfo "Running eautoreconf in '$(pwd)' ..."
	[[ -n ${auxdir} ]] && mkdir -p ${auxdir}
	eaclocal
	[[ ${CHOST} == *-darwin* ]] && g=g
	if ${LIBTOOLIZE:-${g}libtoolize} -n --install >& /dev/null ; then
		_elibtoolize --copy --force --install
	else
		_elibtoolize --copy --force
	fi
	eautoconf
	eautoheader
	FROM_EAUTORECONF="yes" eautomake ${AM_OPTS}

	[[ ${AT_NOELIBTOOLIZE} == "yes" ]] && return 0

	# Call it here to prevent failures due to elibtoolize called _before_
	# eautoreconf.  We set $S because elibtoolize runs on that #265319
	S=${pwd} elibtoolize

	return 0
}

# @FUNCTION: eaclocal
# @DESCRIPTION:
# These functions runs the autotools using autotools_run_tool with the
# specified parametes. The name of the tool run is the same of the function
# without e prefix.
# They also force installing the support files for safety.
# Respects AT_M4DIR for additional directories to search for macro's.
eaclocal() {
	local aclocal_opts

	local amflags_file
	for amflags_file in GNUmakefile.am Makefile.am GNUmakefile.in Makefile.in ; do
		[[ -e ${amflags_file} ]] || continue
		aclocal_opts=$(sed -n '/^ACLOCAL_AMFLAGS[[:space:]]*=/s:[^=]*=::p' ${amflags_file})
		eval aclocal_opts=\"${aclocal_opts}\"
		break
	done

	if [[ -n ${AT_M4DIR} ]] ; then
		for x in ${AT_M4DIR} ; do
			case "${x}" in
			"-I")
				# We handle it below
				;;
			*)
				[[ ! -d ${x} ]] && ewarn "eaclocal: '${x}' does not exist"
				aclocal_opts="${aclocal_opts} -I ${x}"
				;;
			esac
		done
	fi

	[[ ! -f aclocal.m4 || -n $(grep -e 'generated.*by aclocal' aclocal.m4) ]] && \
		autotools_run_tool aclocal "$@" ${aclocal_opts}
}

# @FUNCTION: _elibtoolize
# @DESCRIPTION:
# Runs libtoolize.  Note the '_' prefix .. to not collide with elibtoolize() from
# libtool.eclass.
_elibtoolize() {
	local opts g=

	# Check if we should run libtoolize (AM_PROG_LIBTOOL is an older macro,
	# check for both it and the current AC_PROG_LIBTOOL)
	[[ -n $(autotools_check_macro AC_PROG_LIBTOOL AM_PROG_LIBTOOL LT_INIT) ]] || return 0

	[[ -f GNUmakefile.am || -f Makefile.am ]] && opts="--automake"

	[[ ${CHOST} == *-darwin* ]] && g=g
	autotools_run_tool ${LIBTOOLIZE:-${g}libtoolize} "$@" ${opts}

	# Need to rerun aclocal
	eaclocal
}

# @FUNCTION: eautoheader
# @DESCRIPTION:
# Runs autoheader.
eautoheader() {
	# Check if we should run autoheader
	[[ -n $(autotools_check_macro "AC_CONFIG_HEADERS") ]] || return 0
	NO_FAIL=1 autotools_run_tool autoheader "$@"
}

# @FUNCTION: eautoconf
# @DESCRIPTION:
# Runs autoconf.
eautoconf() {
	if [[ ! -f configure.ac && ! -f configure.in ]] ; then
		echo
		eerror "No configure.{ac,in} present in '$(pwd | sed -e 's:.*/::')'!"
		echo
		die "No configure.{ac,in} present!"
	fi

	autotools_run_tool autoconf "$@"
}

# @FUNCTION: eautomake
# @DESCRIPTION:
# Runs automake.
eautomake() {
	local extra_opts
	local makefile_name

	if [[ -f GNUmakefile.am ]]; then
		makefile_name="GNUmakefile"
	elif [[ -f Makefile.am ]]; then
		makefile_name="Makefile"
	else
		return 0
	fi

	if [[ -z ${FROM_EAUTORECONF} && -f ${makefile_name}.in ]]; then
		local used_automake
		local installed_automake

		installed_automake=$(WANT_AUTOMAKE= automake --version | head -n 1 | \
			sed -e 's:.*(GNU automake) ::')
		used_automake=$(head -n 1 < ${makefile_name}.in | \
			sed -e 's:.*by automake \(.*\) from .*:\1:')

		if [[ ${installed_automake} != ${used_automake} ]]; then
			einfo "Automake used for the package (${used_automake}) differs from"
			einfo "the installed version (${installed_automake})."
			eautoreconf
			return 0
		fi
	fi

	[[ -f INSTALL && -f AUTHORS && -f ChangeLog && -f NEWS ]] \
		|| extra_opts="${extra_opts} --foreign"

	# --force-missing seems not to be recognized by some flavours of automake
	autotools_run_tool automake --add-missing --copy ${extra_opts} "$@"
}

# Internal function to run an autotools' tool
autotools_run_tool() {
	if [[ ${EBUILD_PHASE} != "unpack" && ${EBUILD_PHASE} != "prepare" ]]; then
		ewarn "QA Warning: running $1 in ${EBUILD_PHASE} phase"
	fi

	# We do the “latest” → version switch here because it solves
	# possible order problems, see bug #270010 as an example.
	[[ ${WANT_AUTOMAKE} == "latest" ]] && export WANT_AUTOMAKE=1.10
	[[ ${WANT_AUTOCONF} == "latest" ]] && export WANT_AUTOCONF=2.5

	local STDERR_TARGET="${T}/$1.out"
	# most of the time, there will only be one run, but if there are
	# more, make sure we get unique log filenames
	if [[ -e ${STDERR_TARGET} ]] ; then
		STDERR_TARGET="${T}/$1-$$.out"
	fi

	printf "***** $1 *****\n***** PWD: ${PWD}\n***** $*\n\n" > "${STDERR_TARGET}"

	ebegin "Running $@"
	"$@" >> "${STDERR_TARGET}" 2>&1
	eend $?

	if [[ $? != 0 && ${NO_FAIL} != 1 ]] ; then
		echo
		eerror "Failed Running $1 !"
		eerror
		eerror "Include in your bugreport the contents of:"
		eerror
		eerror "  ${STDERR_TARGET}"
		echo
		die "Failed Running $1 !"
	fi
}

# Internal function to check for support
autotools_check_macro() {
	[[ -f configure.ac || -f configure.in ]] || return 0
	local macro
	for macro ; do
		WANT_AUTOCONF="2.5" autoconf --trace="${macro}" 2>/dev/null
	done
	return 0
}

# Internal function to get additional subdirs to configure
autotools_get_subdirs() {
	local subdirs_scan_out

	subdirs_scan_out=$(autotools_check_macro "AC_CONFIG_SUBDIRS")
	[[ -n ${subdirs_scan_out} ]] || return 0

	echo "${subdirs_scan_out}" | gawk \
	'($0 !~ /^[[:space:]]*(#|dnl)/) {
		if (match($0, /AC_CONFIG_SUBDIRS:(.*)$/, res))
			print res[1]
	}' | uniq

	return 0
}

autotools_get_auxdir() {
	local auxdir_scan_out

	auxdir_scan_out=$(autotools_check_macro "AC_CONFIG_AUX_DIR")
	[[ -n ${auxdir_scan_out} ]] || return 0

	echo ${auxdir_scan_out} | gawk \
	'($0 !~ /^[[:space:]]*(#|dnl)/) {
		if (match($0, /AC_CONFIG_AUX_DIR:(.*)$/, res))
			print res[1]
	}' | uniq

	return 0
}
