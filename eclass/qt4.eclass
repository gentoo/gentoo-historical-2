# Copyright 2005-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/qt4.eclass,v 1.52 2009/03/14 23:30:05 yngwin Exp $

# @ECLASS: qt4.eclass
# @MAINTAINER:
# Ben de Groot <yngwin@gentoo.org>,
# Markos Chandras <hwoarang@gentoo.org>,
# Caleb Tennis <caleb@gentoo.org>,
# Przemyslaw Maciag <troll@gentoo.org>,
# Davide Pesavento <davidepesa@gmail.com>
# @BLURB: Eclass for Qt4 packages
# @DESCRIPTION:
# This eclass contains various functions that may be useful
# when dealing with packages using Qt4 libraries.

inherit base eutils multilib toolchain-funcs versionator

qt4_monolithic_to_split_flag() {
	case ${1} in
		zlib)
			# Qt 4.4+ is always built with zlib enabled, so this flag isn't needed
			;;
		gif|jpeg|png)
			# qt-gui always installs with these enabled
			checkpkgs+=" x11-libs/qt-gui"
			;;
		dbus|opengl)
			# Make sure the qt-${1} package has been installed already
			checkpkgs+=" x11-libs/qt-${1}"
			;;
		qt3support)
			checkpkgs+=" x11-libs/qt-${1}"
			checkflags+=" x11-libs/qt-core:${1} x11-libs/qt-gui:${1} x11-libs/qt-sql:${1}"
			;;
		ssl)
			# qt-core controls this flag
			checkflags+=" x11-libs/qt-core:${1}"
			;;
		cups|mng|nas|nis|tiff|xinerama|input_devices_wacom)
			# qt-gui controls these flags
			checkflags+=" x11-libs/qt-gui:${1}"
			;;
		firebird|mysql|odbc|postgres|sqlite3)
			# qt-sql controls these flags. sqlite2 is no longer supported so it uses sqlite instead of sqlite3.
			checkflags+=" x11-libs/qt-sql:${1%3}"
			;;
		accessibility)
			eerror "(QA message): Use guiaccessibility and/or qt3accessibility to specify which of qt-gui and qt-qt3support are relevant for this package."
			# deal with this gracefully by checking the flag for what is available
			for y in gui qt3support; do
				has_version x11-libs/qt-${y} && checkflags+=" x11-libs/qt-${y}:${1}"
			done
			;;
		guiaccessibility)
			checkflags+=" x11-libs/qt-gui:accessibility"
			;;
		qt3accessibility)
			checkflags+=" x11-libs/qt-qt3support:accessibility"
			;;
		debug|doc|examples|glib|pch|sqlite|*)
			# packages probably shouldn't be checking these flags so we don't handle them currently
			eerror "qt4.eclass currently doesn't handle the use flag ${1} in QT4_BUILT_WITH_USE_CHECK for qt-4.4. This is either an"
			eerror "eclass bug or an ebuild bug. Please report it at http://bugs.gentoo.org/"
			((fatalerrors+=1))
			;;
	esac
}

# @FUNCTION: qt4_pkg_setup
# @DESCRIPTION:
# Default pkg_setup function for packages that depends on qt4. If you have to
# create ebuilds own pkg_setup in your ebuild, call qt4_pkg_setup in it.
# This function uses two global vars from ebuild:
# - QT4_BUILT_WITH_USE_CHECK - contains use flags that need to be turned on for
#   =x11-libs/qt-4*
# - QT4_OPTIONAL_BUILT_WITH_USE_CHECK - qt4 flags that provides some
#   functionality, but can alternatively be disabled in ${CATEGORY}/${PN}
#   (so qt4 don't have to be recompiled)
#
# NOTE: Using the above vars is now deprecated in favor of eapi-2 use deps
#
# flags to watch for for Qt4.4:
# zlib png | opengl dbus qt3support | sqlite3 ssl
qt4_pkg_setup() {
	local x y checkpkgs checkflags fatalerrors=0 requiredflags=""

	# lots of has_version calls can be very expensive
	if [[ -n ${QT4_BUILT_WITH_USE_CHECK}${QT4_OPTIONAL_BUILT_WITH_USE_CHECK} ]]; then
		ewarn "QA notice: The QT4_BUILT_WITH_USE functionality is deprecated and"
		ewarn "will be removed from future versions of qt4.eclass. Please update"
		ewarn "the ebuild to use eapi-2 use dependencies instead."
		has_version x11-libs/qt-core && local QT44=true
	fi

	for x in ${QT4_BUILT_WITH_USE_CHECK}; do
		if [[ -n ${QT44} ]]; then
			# The use flags are different in 4.4 and above, and it's split packages, so this is used to catch
			# the various use flag combos specified in the ebuilds to make sure we don't error out for no reason.
			qt4_monolithic_to_split_flag ${x}
		else
			[[ ${x} == *accessibility ]] && x=${x#gui} && x=${x#qt3}
			if ! built_with_use =x11-libs/qt-4* ${x}; then
				requiredflags="${requiredflags} ${x}"
			fi
		fi
	done

	local optionalflags=""
	for x in ${QT4_OPTIONAL_BUILT_WITH_USE_CHECK}; do
		if use ${x}; then
			if [[ -n ${QT44} ]]; then
				# The use flags are different in 4.4 and above, and it's split packages, so this is used to catch
				# the various use flag combos specified in the ebuilds to make sure we don't error out for no reason.
				qt4_monolithic_to_split_flag ${x}
			elif ! built_with_use =x11-libs/qt-4* ${x}; then
				optionalflags="${optionalflags} ${x}"
			fi
		fi
	done

	# The use flags are different in 4.4 and above, and it's split packages, so this is used to catch
	# the various use flag combos specified in the ebuilds to make sure we don't error out for no reason.
	for y in ${checkpkgs}; do
		if ! has_version ${y}; then
			eerror "You must first install the ${y} package. It should be added to the dependencies for this package (${CATEGORY}/${PN}). See bug #217161."
			((fatalerrors+=1))
		fi
	done
	for y in ${checkflags}; do
		if ! has_version ${y%:*}; then
			eerror "You must first install the ${y%:*} package with the ${y##*:} flag enabled."
			eerror "It should be added to the dependencies for this package (${CATEGORY}/${PN}). See bug #217161."
			((fatalerrors+=1))
		else
			if ! built_with_use ${y%:*} ${y##*:}; then
				eerror "You must first install the ${y%:*} package with the ${y##*:} flag enabled."
				((fatalerrors+=1))
			fi
		fi
	done

	local diemessage=""
	if [[ ${fatalerrors} -ne 0 ]]; then
		diemessage="${fatalerrors} fatal errors were detected. Please read the above error messages and act accordingly."
	fi
	if [[ -n ${requiredflags} ]]; then
		eerror
		eerror "(1) In order to compile ${CATEGORY}/${PN} first you need to build"
		eerror "=x11-libs/qt-4* with USE=\"${requiredflags}\" flag(s)"
		eerror
		diemessage="(1) recompile qt4 with \"${requiredflags}\" USE flag(s) ; "
	fi
	if [[ -n ${optionalflags} ]]; then
		eerror
		eerror "(2) You are trying to compile ${CATEGORY}/${PN} package with"
		eerror "USE=\"${optionalflags}\""
		eerror "while qt4 is built without this particular flag(s): it will"
		eerror "not work."
		eerror
		eerror "Possible solutions to this problem are:"
		eerror "a) install package ${CATEGORY}/${PN} without \"${optionalflags}\" USE flag(s)"
		eerror "b) re-emerge qt4 with \"${optionalflags}\" USE flag(s)"
		eerror
		diemessage="${diemessage}(2) recompile qt4 with \"${optionalflags}\" USE flag(s) or disable them for ${PN} package\n"
	fi

	[[ -n ${diemessage} ]] && die "can't install ${CATEGORY}/${PN}: ${diemessage}"
}

# @ECLASS-VARIABLE: PATCHES
# @DESCRIPTION:
# In case you have patches to apply, specify them in the PATCHES variable.
# Make sure to specify the full path. This variable is necessary for the
# src_prepare phase.
# example:
# PATCHES="${FILESDIR}/mypatch.patch
# 	${FILESDIR}/mypatch2.patch"
#
# @FUNCTION: qt4_src_prepare
# @DESCRIPTION:
# Default src_prepare function for packages that depend on qt4. If you have to
# override src_prepare in your ebuild, you should call qt4_src_prepare in it,
# otherwise autopatcher will not work!
qt4_src_prepare() {
	debug-print-function $FUNCNAME "$@"
	base_src_prepare
}

# @FUNCTION: qt4_src_configure
# @DESCRIPTION:
# Default src_configure function for packages that depend on qt4. If you have to
# override src_configure in your ebuild, call qt4_src_configure in it.
#qt4_src_configure() {
#    debug-print-function $FUNCNAME "$@"
#    eqmake4
#}

# @FUNCTION: qt4_src_compile
# @DESCRIPTION:
# Default src_compile function for packages that depend on qt4. If you have to
# override src_compile in your ebuild (probably you don't need to), call
# qt4_src_compile in it.
#qt4_src_compile() {
#	debug-print-function $FUNCNAME "$@"
#	case "${EAPI:-0}" in
#		2)
#			emake || die "emake failed"
#			;;
#		0|1)
#			qt4_src_prepare
#			qt4_src_configure
#			emake || die "emake failed"
#			;;
#	esac
#}

# @FUNCTION: eqmake4
# @USAGE: [.pro file] [additional parameters to qmake]
# @DESCRIPTION:
# Runs qmake on the specified .pro file (defaults to
# ${PN}.pro if eqmake4 was called with no argument).
# Additional parameters are passed unmodified to qmake.
eqmake4() {
	local LOGFILE="${T}/qmake-$$.out"
	local projprofile="${1}"
	[[ -z ${projprofile} ]] && projprofile="${PN}.pro"
	shift 1

	ebegin "Processing qmake ${projprofile}"

	# file exists?
	if [[ ! -f ${projprofile} ]]; then
		echo
		eerror "Project .pro file \"${projprofile}\" does not exists"
		eerror "qmake cannot handle non-existing .pro files"
		echo
		eerror "This shouldn't happen - please send a bug report to bugs.gentoo.org"
		echo
		die "Project file not found in ${PN} sources"
	fi

	echo >> ${LOGFILE}
	echo "******  qmake ${projprofile}  ******" >> ${LOGFILE}
	echo >> ${LOGFILE}

	# as a workaround for broken qmake, put everything into file
	if has debug ${IUSE} && use debug; then
		echo -e "\nCONFIG -= release\nCONFIG += no_fixpath debug" >> ${projprofile}
	else
		echo -e "\nCONFIG -= debug\nCONFIG += no_fixpath release" >> ${projprofile}
	fi

	/usr/bin/qmake ${projprofile} \
		QTDIR=/usr/$(get_libdir) \
		QMAKE=/usr/bin/qmake \
		QMAKE_CC=$(tc-getCC) \
		QMAKE_CXX=$(tc-getCXX) \
		QMAKE_LINK=$(tc-getCXX) \
		QMAKE_CFLAGS_RELEASE="${CFLAGS}" \
		QMAKE_CFLAGS_DEBUG="${CFLAGS}" \
		QMAKE_CXXFLAGS_RELEASE="${CXXFLAGS}" \
		QMAKE_CXXFLAGS_DEBUG="${CXXFLAGS}" \
		QMAKE_LFLAGS_RELEASE="${LDFLAGS}" \
		QMAKE_LFLAGS_DEBUG="${LDFLAGS}" \
		QMAKE_RPATH= \
		QMAKE_STRIP= \
		"${@}" >> ${LOGFILE} 2>&1

	local result=$?
	eend ${result}

	# was qmake successful?
	if [[ ${result} -ne 0 ]]; then
		echo
		eerror "Running qmake on \"${projprofile}\" has failed"
		echo
		eerror "This shouldn't happen - please send a bug report to bugs.gentoo.org"
		echo
		die "qmake failed on ${projprofile}"
	fi

	return ${result}
}

case ${EAPI:-0} in
	2)
		EXPORT_FUNCTIONS pkg_setup src_prepare
		;;
	0|1)
		EXPORT_FUNCTIONS pkg_setup
		;;
esac
