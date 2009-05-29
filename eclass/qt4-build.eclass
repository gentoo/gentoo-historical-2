# Copyright 2007-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/qt4-build.eclass,v 1.36 2009/05/29 14:48:00 hwoarang Exp $

# @ECLASS: qt4-build.eclass
# @MAINTAINER:
# Ben de Groot <yngwin@gentoo.org>,
# Markos Chandras <hwoarang@gentoo.org>,
# Caleb Tennis <caleb@gentoo.org>
# @BLURB: Eclass for Qt4 split ebuilds.
# @DESCRIPTION:
# This eclass contains various functions that are used when building Qt4

inherit eutils multilib toolchain-funcs flag-o-matic versionator

IUSE="${IUSE} custom-cxxflags debug pch"
RDEPEND="
	!<x11-libs/qt-assistant-${PV}
	!>x11-libs/qt-assistant-${PV}-r9999
	!<x11-libs/qt-core-${PV}
	!>x11-libs/qt-core-${PV}-r9999
	!<x11-libs/qt-dbus-${PV}
	!>x11-libs/qt-dbus-${PV}-r9999
	!<x11-libs/qt-demo-${PV}
	!>x11-libs/qt-demo-${PV}-r9999
	!<x11-libs/qt-gui-${PV}
	!>x11-libs/qt-gui-${PV}-r9999
	!<x11-libs/qt-opengl-${PV}
	!>x11-libs/qt-opengl-${PV}-r9999
	!<x11-libs/qt-phonon-${PV}
	!>x11-libs/qt-phonon-${PV}-r9999
	!<x11-libs/qt-qt3support-${PV}
	!>x11-libs/qt-qt3support-${PV}-r9999
	!<x11-libs/qt-script-${PV}
	!>x11-libs/qt-script-${PV}-r9999
	!<x11-libs/qt-sql-${PV}
	!>x11-libs/qt-sql-${PV}-r9999
	!<x11-libs/qt-svg-${PV}
	!>x11-libs/qt-svg-${PV}-r9999
	!<x11-libs/qt-test-${PV}
	!>x11-libs/qt-test-${PV}-r9999
	!<x11-libs/qt-webkit-${PV}
	!>x11-libs/qt-webkit-${PV}-r9999
	!<x11-libs/qt-xmlpatterns-${PV}
	!>x11-libs/qt-xmlpatterns-${PV}-r9999
"
case "${PV}" in
	4.?.?_rc*)
		SRCTYPE="${SRCTYPE:-opensource-src}"
		MY_PV="${PV/_rc/-rc}"
		;;
	*)
		SRCTYPE="${SRCTYPE:-opensource-src}"
		MY_PV="${PV}"
		;;
esac
MY_P=qt-x11-${SRCTYPE}-${MY_PV}
S=${WORKDIR}/${MY_P}

HOMEPAGE="http://www.qtsoftware.com/"
SRC_URI="http://download.qtsoftware.com/qt/source/${MY_P}.tar.bz2"

case "${PV}" in
	4.4.?) SRC_URI="${SRC_URI} mirror://gentoo/${MY_P}-headers.tar.bz2" ;;
	*)     ;;
esac

if version_is_at_least 4.5 ${PV} ; then
	LICENSE="|| ( LGPL-2.1 GPL-3 )"
fi

# @FUNCTION: qt4-build_pkg_setup
# @DESCRIPTION:
# Sets up installation directories, PLATFORM, PATH, and LD_LIBRARY_PATH
qt4-build_pkg_setup() {
	# EAPI=2 ebuilds set use-deps, others need this:
	if [[ $EAPI != 2 ]]; then
		# Make sure debug setting corresponds with qt-core (bug 258512)
		if [[ $PN != "qt-core" ]]; then
			use debug && QT4_BUILT_WITH_USE_CHECK="${QT4_BUILT_WITH_USE_CHECK}
				~x11-libs/qt-core-${PV} debug"
		fi

		# Check USE requirements
		qt4-build_check_use
	fi
	# Set up installation directories
	QTBASEDIR=/usr/$(get_libdir)/qt4
	QTPREFIXDIR=/usr
	QTBINDIR=/usr/bin
	QTLIBDIR=/usr/$(get_libdir)/qt4
	QTPCDIR=/usr/$(get_libdir)/pkgconfig
	QTDATADIR=/usr/share/qt4
	QTDOCDIR=/usr/share/doc/qt-${PV}
	QTHEADERDIR=/usr/include/qt4
	QTPLUGINDIR=${QTLIBDIR}/plugins
	QTSYSCONFDIR=/etc/qt4
	QTTRANSDIR=${QTDATADIR}/translations
	QTEXAMPLESDIR=${QTDATADIR}/examples
	QTDEMOSDIR=${QTDATADIR}/demos

	PLATFORM=$(qt_mkspecs_dir)

	PATH="${S}/bin:${PATH}"
	LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"

	if ! version_is_at_least 4.1 $(gcc-version) ; then
		ewarn "Using a GCC version lower than 4.1 is not supported!"
		echo
		ebeep 3
	fi

	if use custom-cxxflags; then
		echo
		ewarn "You have set USE=custom-cxxflags, which means Qt will be built with the"
		ewarn "CXXFLAGS you have set in /etc/make.conf. This is not supported, and we"
		ewarn "recommend to unset this useflag. But you are free to experiment with it."
		ewarn "Just do not start crying if it breaks your system, or eats your kitten"
		ewarn "for breakfast. ;-) "
		echo
	fi

}

# @ECLASS-VARIABLE: QT4_TARGET_DIRECTORIES
# @DESCRIPTION:
# Arguments for build_target_directories. Takes the directories, in which the
# code should be compiled. This is a space-separated list

# @ECLASS-VARIABLE: QT4_EXTRACT_DIRECTORIES
# @DESCRIPTION:
# Space separated list including the directories that will be extracted from Qt
# tarball

# @FUNCTION: qt4-build_src_unpack
# @DESCRIPTION:
# Unpacks the sources
qt4-build_src_unpack() {
	local target targets licenses
	if version_is_at_least 4.5 ${PV} ; then
		licenses="LICENSE.GPL3 LICENSE.LGPL"
	else
		licenses="LICENSE.GPL2 LICENSE.GPL3"
	fi
	for target in configure ${licenses} projects.pro \
		src/{qbase,qt_targets,qt_install}.pri bin config.tests mkspecs qmake \
		${QT4_EXTRACT_DIRECTORIES}; do
			targets="${targets} ${MY_P}/${target}"
	done

	echo tar xjpf "${DISTDIR}"/${MY_P}.tar.bz2 ${targets}
	tar xjpf "${DISTDIR}"/${MY_P}.tar.bz2 ${targets}

	case "${PV}" in
		4.4.?)
			echo tar xjpf "${DISTDIR}"/${MY_P}-headers.tar.bz2
			tar xjpf "${DISTDIR}"/${MY_P}-headers.tar.bz2
			;;
	esac

	# Be backwards compatible for now
	if [[ $EAPI != 2 ]]; then
		qt4-build_src_prepare
	fi
}


# @FUNCTION: qt4-build_src_prepare
# @DESCRIPTION:
# Prepare the sources before the configure phase. Strip CFLAGS if necessary, and fix
# source files in order to respect CFLAGS/CXXFLAGS/LDFLAGS specified on /etc/make.conf.
qt4-build_src_prepare() {
	cd "${S}"

	if [[ ${PN} != qt-core ]]; then
		skip_qmake_build_patch
		skip_project_generation_patch
		symlink_binaries_to_buildtree
	fi

	if ! use custom-cxxflags;then
		# Don't let the user go too overboard with flags.
		strip-flags
		replace-flags -O3 -O2
	fi

	# Bug 178652
	if [[ "$(gcc-major-version)" == "3" ]] && use amd64; then
		ewarn "Appending -fno-gcse to CFLAGS/CXXFLAGS"
		append-flags -fno-gcse
	fi

	# Unsupported old gcc versions - hardened needs this :(
	if [[ $(gcc-major-version) -lt "4" ]] ; then
		ewarn "Appending -fno-stack-protector to CXXFLAGS"
		append-cxxflags -fno-stack-protector
		# Bug 253127
		sed -e "/^QMAKE_CFLAGS\t/ s:$: -fno-stack-protector-all:" \
		-i "${S}"/mkspecs/common/g++.conf || die "sed ${S}/mkspecs/common/g++.conf failed"
	fi

	# Bug 172219
	sed -e "s:QMAKE_CFLAGS_RELEASE.*=.*:QMAKE_CFLAGS_RELEASE=${CFLAGS}:" \
		-e "s:QMAKE_CXXFLAGS_RELEASE.*=.*:QMAKE_CXXFLAGS_RELEASE=${CXXFLAGS}:" \
		-e "s:QMAKE_LFLAGS_RELEASE.*=.*:QMAKE_LFLAGS_RELEASE=${LDFLAGS}:" \
		-e "s:X11R6/::" \
		-i "${S}"/mkspecs/$(qt_mkspecs_dir)/qmake.conf || die "sed ${S}/mkspecs/$(qt_mkspecs_dir)/qmake.conf failed"

	sed -e "s:QMAKE_CFLAGS_RELEASE.*=.*:QMAKE_CFLAGS_RELEASE=${CFLAGS}:" \
		-e "s:QMAKE_CXXFLAGS_RELEASE.*=.*:QMAKE_CXXFLAGS_RELEASE=${CXXFLAGS}:" \
		-e "s:QMAKE_LFLAGS_RELEASE.*=.*:QMAKE_LFLAGS_RELEASE=${LDFLAGS}:" \
		-i "${S}"/mkspecs/common/g++.conf || die "sed ${S}/mkspecs/common/g++.conf failed"

}

# @FUNCTION: qt4-build_src_configure
# @DESCRIPTION:
# Default configure phase
qt4-build_src_configure() {

	myconf="$(standard_configure_options) ${myconf}"

	echo ./configure ${myconf}
	./configure ${myconf} || die "./configure failed"
}

# @FUNCTION: qt4-build_src_compile
# @DESCRIPTION: Actual compile phase
qt4-build_src_compile() {
	# Be backwards compatible for now
	if [[ $EAPI != 2 ]]; then
		qt4-build_src_configure
	fi

	build_directories "${QT4_TARGET_DIRECTORIES}"
}

# @FUNCTION: qt4-build_src_install
# @DESCRIPTION:
# Perform the actual installation including some library fixes.
qt4-build_src_install() {
	install_directories "${QT4_TARGET_DIRECTORIES}"
	install_qconfigs
	fix_library_files
}

# @FUNCTION: standard_configure_options
# @DESCRIPTION:
# Sets up some standard configure options, like libdir (if necessary), whether
# debug info is wanted or not.
standard_configure_options() {
	local myconf=""

	[[ $(get_libdir) != "lib" ]] && myconf="${myconf} -L/usr/$(get_libdir)"

	# Disable visibility explicitly if gcc version isn't 4
	if [[ "$(gcc-major-version)" -lt "4" ]]; then
		myconf="${myconf} -no-reduce-exports"
	fi

	# precompiled headers doesn't work on hardened, where the flag is masked.
	if use pch; then
		myconf="${myconf} -pch"
	else
		myconf="${myconf} -no-pch"
	fi

	if use debug; then
		myconf="${myconf} -debug -no-separate-debug-info"
	else
		myconf="${myconf} -release -no-separate-debug-info"
	fi

	# ARCH is set on Gentoo. Qt now falls back to generic on an unsupported
	# $(tc-arch). Therefore we convert it to supported values.
	case "$(tc-arch)" in
		amd64) myconf="${myconf} -arch x86_64" ;;
		ppc|ppc64) myconf="${myconf} -arch powerpc" ;;
		x86|x86-*) myconf="${myconf} -arch i386" ;;
		alpha|arm|ia64|mips|s390|sparc) myconf="${myconf} -arch $(tc-arch)" ;;
		hppa|sh) myconf="${myconf} -arch generic" ;;
		*) die "$(tc-arch) is unsupported by this eclass. Please file a bug." ;;
	esac

	# Bug 261412 Qt configure detects archs by uname
	case "$(tc-arch)" in
		ppc) myconf="${myconf} -platform linux-g++-32";;
	esac

	myconf="${myconf} -stl -verbose -largefile -confirm-license -no-rpath
		-prefix ${QTPREFIXDIR} -bindir ${QTBINDIR} -libdir ${QTLIBDIR}
		-datadir ${QTDATADIR} -docdir ${QTDOCDIR} -headerdir ${QTHEADERDIR}
		-plugindir ${QTPLUGINDIR} -sysconfdir ${QTSYSCONFDIR}
		-translationdir ${QTTRANSDIR} -examplesdir ${QTEXAMPLESDIR}
		-demosdir ${QTDEMOSDIR} -silent -fast
		$([[ ${PN} == qt-xmlpatterns ]] || echo -no-exceptions)
		-reduce-relocations -nomake examples -nomake demos"
	
	# Make eclass 4.5.{1,2} ready
	case "${MY_PV}" in
		4.5.1 | 4.5.2)
			myconf="${myconf} -opensource"
			;;
	esac

	echo "${myconf}"
}

# @FUNCTION: build_directories
# @USAGE: < directories >
# @DESCRIPTION:
# Compiles the code in $QT4_TARGET_DIRECTORIES
build_directories() {
	local dirs="$@"
	for x in ${dirs}; do
		cd "${S}"/${x}
		"${S}"/bin/qmake "LIBS+=-L${QTLIBDIR}" "CONFIG+=nostrip" || die "qmake failed"
		emake || die "emake failed"
	done
}

# @FUNCTION: install_directories
# @USAGE: < directories >
# @DESCRIPTION:
# run emake install in the given directories, which are separated by spaces
install_directories() {
	local dirs="$@"
	for x in ${dirs}; do
		pushd "${S}"/${x} >/dev/null || die "Can't pushd ${S}/${x}"
		emake INSTALL_ROOT="${D}" install || die "emake install failed"
		popd >/dev/null || die "Can't popd from ${S}/${x}"
	done
}

# @ECLASS-VARIABLE: QCONFIG_ADD
# @DESCRIPTION:
# List options that need to be added to QT_CONFIG in qconfig.pri
QCONFIG_ADD="${QCONFIG_ADD:-}"

# @ECLASS-VARIABLE: QCONFIG_REMOVE
# @DESCRIPTION:
# List options that need to be removed from QT_CONFIG in qconfig.pri
QCONFIG_REMOVE="${QCONFIG_REMOVE:-}"

# @ECLASS-VARIABLE: QCONFIG_DEFINE
# @DESCRIPTION:
# List variables that should be defined at the top of QtCore/qconfig.h
QCONFIG_DEFINE="${QCONFIG_DEFINE:-}"

# @FUNCTION: install_qconfigs
# @DESCRIPTION: Install gentoo-specific mkspecs configurations
install_qconfigs() {
	local x
	if [[ -n ${QCONFIG_ADD} || -n ${QCONFIG_REMOVE} ]]; then
		for x in QCONFIG_ADD QCONFIG_REMOVE; do
			[[ -n ${!x} ]] && echo ${x}=${!x} >> "${T}"/${PN}-qconfig.pri
		done
		insinto ${QTDATADIR}/mkspecs/gentoo
		doins "${T}"/${PN}-qconfig.pri || die "installing ${PN}-qconfig.pri failed"
	fi

	if [[ -n ${QCONFIG_DEFINE} ]]; then
		for x in ${QCONFIG_DEFINE}; do
			echo "#define ${x}" >> "${T}"/gentoo-${PN}-qconfig.h
		done
		insinto ${QTHEADERDIR}/Gentoo
		doins "${T}"/gentoo-${PN}-qconfig.h || die "installing ${PN}-qconfig.h failed"
	fi
}

# @FUNCTION: generate_qconfigs
# @DESCRIPTION: Generates gentoo-specific configurations
generate_qconfigs() {
	if [[ -n ${QCONFIG_ADD} || -n ${QCONFIG_REMOVE} || -n ${QCONFIG_DEFINE} || ${CATEGORY}/${PN} == x11-libs/qt-core ]]; then
		local x qconfig_add qconfig_remove qconfig_new
		for x in "${ROOT}${QTDATADIR}"/mkspecs/gentoo/*-qconfig.pri; do
			[[ -f ${x} ]] || continue
			qconfig_add="${qconfig_add} $(sed -n 's/^QCONFIG_ADD=//p' "${x}")"
			qconfig_remove="${qconfig_remove} $(sed -n 's/^QCONFIG_REMOVE=//p' "${x}")"
		done

		# these error checks do not use die because dying in pkg_post{inst,rm}
		# just makes things worse.
		if [[ -e "${ROOT}${QTDATADIR}"/mkspecs/gentoo/qconfig.pri ]]; then
			# start with the qconfig.pri that qt-core installed
			if ! cp "${ROOT}${QTDATADIR}"/mkspecs/gentoo/qconfig.pri \
				"${ROOT}${QTDATADIR}"/mkspecs/qconfig.pri; then
				eerror "cp qconfig failed."
				return 1
			fi

			# generate list of QT_CONFIG entries from the existing list
			# including qconfig_add and excluding qconfig_remove
			for x in $(sed -n 's/^QT_CONFIG +=//p' \
				"${ROOT}${QTDATADIR}"/mkspecs/qconfig.pri) ${qconfig_add}; do
					hasq ${x} ${qconfig_remove} || qconfig_new="${qconfig_new} ${x}"
			done

			# replace the existing QT_CONFIG list with qconfig_new
			if ! sed -i -e "s/QT_CONFIG +=.*/QT_CONFIG += ${qconfig_new}/" \
				"${ROOT}${QTDATADIR}"/mkspecs/qconfig.pri; then
				eerror "Sed for QT_CONFIG failed"
				return 1
			fi

			# create Gentoo/qconfig.h
			if [[ ! -e ${ROOT}${QTHEADERDIR}/Gentoo ]]; then
				if ! mkdir -p "${ROOT}${QTHEADERDIR}"/Gentoo; then
					eerror "mkdir ${QTHEADERDIR}/Gentoo failed"
					return 1
				fi
			fi
			: > "${ROOT}${QTHEADERDIR}"/Gentoo/gentoo-qconfig.h
			for x in "${ROOT}${QTHEADERDIR}"/Gentoo/gentoo-*-qconfig.h; do
				[[ -f ${x} ]] || continue
				cat "${x}" >> "${ROOT}${QTHEADERDIR}"/Gentoo/gentoo-qconfig.h
			done
		else
			rm -f "${ROOT}${QTDATADIR}"/mkspecs/qconfig.pri
			rm -f "${ROOT}${QTHEADERDIR}"/Gentoo/gentoo-qconfig.h
			rmdir "${ROOT}${QTDATADIR}"/mkspecs \
				"${ROOT}${QTDATADIR}" \
				"${ROOT}${QTHEADERDIR}"/Gentoo \
				"${ROOT}${QTHEADERDIR}" 2>/dev/null
		fi
	fi
}

# @FUNCTION: qt4-build_pkg_postrm
# @DESCRIPTION: Generate configurations when the package is completely removed
qt4-build_pkg_postrm() {
	generate_qconfigs
}

# @FUNCTION: qt4-build_pkg_postinst
# @DESCRIPTION: Generate configuration, plus throws a message about possible
# breakages and proposed solutions.
qt4-build_pkg_postinst() {
	generate_qconfigs
	echo
	ewarn "After a rebuild or upgrade of Qt, it can happen that Qt plugins (such as Qt"
	ewarn "and KDE styles and widgets) can no longer be loaded. In this situation you"
	ewarn "should recompile the packages providing these plugins. Also, make sure you"
	ewarn "compile the Qt packages, and the packages that depend on it, with the same"
	ewarn "GCC version and the same USE flag settings (especially the debug flag)."
	ewarn
	ewarn "Packages that typically need to be recompiled are kdelibs from KDE4, any"
	ewarn "additional KDE4/Qt4 styles, qscintilla and PyQt4. Before filing a bug report,"
	ewarn "make sure all your Qt4 packages are up-to-date and built with the same"
	ewarn "configuration."
	ewarn
	ewarn "For more information, see http://doc.trolltech.com/4.4/plugins-howto.html"
	echo
}

# @FUNCTION: skip_qmake_build_patch
# @DESCRIPTION:
# Don't need to build qmake, as it's already installed from qt-core
skip_qmake_build_patch() {
	# Don't need to build qmake, as it's already installed from qt-core
	sed -i -e "s:if true:if false:g" "${S}"/configure || die "Sed failed"
}

# @FUNCTION: skip_project_generation_patch
# @DESCRIPTION:
# Exit the script early by throwing in an exit before all of the .pro files are scanned
skip_project_generation_patch() {
	# Exit the script early by throwing in an exit before all of the .pro files are scanned
	sed -e "s:echo \"Finding:exit 0\n\necho \"Finding:g" \
		-i "${S}"/configure || die "Sed failed"
}

# @FUNCTION: symlink_binaries_to_buildtree
# @DESCRIPTION:
# Symlink generated binaries to buildtree so they can be used during compilation
# time
symlink_binaries_to_buildtree() {
	for bin in qmake moc uic rcc; do
		ln -s ${QTBINDIR}/${bin} "${S}"/bin/ || die "Symlinking ${bin} to ${S}/bin failed."
	done
}

# @FUNCTION: fix_library_files
# @DESCRIPTION:
# Fixes the pathes in *.la, *.prl, *.pc, as they are wrong due to sandbox and
# moves the *.pc-files into the pkgconfig directory
fix_library_files() {
	for libfile in "${D}"/${QTLIBDIR}/{*.la,*.prl,pkgconfig/*.pc}; do
		if [[ -e ${libfile} ]]; then
			sed -i -e "s:${S}/lib:${QTLIBDIR}:g" ${libfile} || die "Sed on ${libfile} failed."
		fi
	done

	# pkgconfig files refer to WORKDIR/bin as the moc and uic locations.  Fix:
	for libfile in "${D}"/${QTLIBDIR}/pkgconfig/*.pc; do
		if [[ -e ${libfile} ]]; then
			sed -i -e "s:${S}/bin:${QTBINDIR}:g" ${libfile} || die "Sed failed"

	# Move .pc files into the pkgconfig directory
		dodir ${QTPCDIR}
		mv ${libfile} "${D}"/${QTPCDIR}/ \
			|| die "Moving ${libfile} to ${D}/${QTPCDIR}/ failed."
		fi
	done

	# Don't install an empty directory
	rmdir "${D}"/${QTLIBDIR}/pkgconfig
}

# @FUNCTION: qt_use
# @USAGE: < flag > [ feature ] [ enableval ]
# @DESCRIPTION:	
# This will echo "${enableval}-${feature}" if <flag> is enabled, or
# "-no-${feature} if the flag is disabled. If [feature] is not specified <flag>
# will be used for that. If [enableval] is not specified, it omits the
# assignment-part
qt_use() {
	local flag="${1}"
	local feature="${1}"
	local enableval=

	[[ -n ${2} ]] && feature=${2}
	[[ -n ${3} ]] && enableval="-${3}"

	if use ${flag}; then
		echo "${enableval}-${feature}"
	else
		echo "-no-${feature}"
	fi
}

# @ECLASS-VARIABLE: QT4_BUILT_WITH_USE_CHECK
# @DESCRIPTION:
# The contents of $QT4_BUILT_WITH_USE_CHECK gets fed to built_with_use
# (eutils.eclass), line per line.
#
# Example:
# @CODE
# pkg_setup() {
# 	use qt3support && QT4_BUILT_WITH_USE_CHECK="${QT4_BUILT_WITH_USE_CHECK}
# 		~x11-libs/qt-gui-${PV} qt3support"
# 	qt4-build_check_use
# }
# @CODE

# Run built_with_use on each flag and print appropriate error messages if any
# flags are missing

_qt_built_with_use() {
	local missing opt pkg flag flags

	if [[ ${1} = "--missing" ]]; then
		missing="${1} ${2}" && shift 2
	fi
	if [[ ${1:0:1} = "-" ]]; then
		opt=${1} && shift
	fi

	pkg=${1} && shift

	for flag in "${@}"; do
		flags="${flags} ${flag}"
		if ! built_with_use ${missing} ${opt} ${pkg} ${flag}; then
			flags="${flags}*"
		else
			[[ ${opt} = "-o" ]] && return 0
		fi
	done
	if [[ "${flags# }" = "${@}" ]]; then
		return 0
	fi
	if [[ ${opt} = "-o" ]]; then
		eerror "This package requires '${pkg}' to be built with any of the following USE flags: '$*'."
	else
		eerror "This package requires '${pkg}' to be built with the following USE flags: '${flags# }'."
	fi
	return 1
}

# @FUNCTION: qt4-build_check_use
# @DESCRIPTION:
# Check if the listed packages in $QT4_BUILT_WITH_USE_CHECK are built with the
# USE flags listed.
#
# If any of the required USE flags are missing, an eerror will be printed for
# each package with missing USE flags.
qt4-build_check_use() {
	local line missing
	while read line; do
		[[ -z ${line} ]] && continue
		if ! _qt_built_with_use ${line}; then
			missing=true
		fi
	done <<< "${QT4_BUILT_WITH_USE_CHECK}"
	if [[ -n ${missing} ]]; then
		echo
		eerror "Flags marked with an * are missing."
		die "Missing USE flags found"
	fi
}

# @FUNCTION: qt_mkspecs_dir
# @RETURN: the specs-directory w/o path
# @DESCRIPTION:	
# Allows us to define which mkspecs dir we want to use.
qt_mkspecs_dir() {
	# Allows us to define which mkspecs dir we want to use.
	local spec

	case ${CHOST} in
		*-freebsd*|*-dragonfly*)
			spec="freebsd" ;;
		*-openbsd*)
			spec="openbsd" ;;
		*-netbsd*)
			spec="netbsd" ;;
		*-darwin*)
			spec="darwin" ;;
		*-linux-*|*-linux)
			spec="linux" ;;
		*)
			die "Unknown CHOST, no platform choosen."
	esac

	CXX=$(tc-getCXX)
	if [[ ${CXX/g++/} != ${CXX} ]]; then
		spec="${spec}-g++"
	elif [[ ${CXX/icpc/} != ${CXX} ]]; then
		spec="${spec}-icc"
	else
		die "Unknown compiler ${CXX}."
	fi

	echo "${spec}"
}

case ${EAPI:-0} in
	0|1) EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_install pkg_postrm pkg_postinst ;;
	2) EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install pkg_postrm pkg_postinst ;;
esac
