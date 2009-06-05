# Copyright 2007-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/kde4-base.eclass,v 1.41 2009/06/05 09:48:46 scarabeus Exp $

# @ECLASS: kde4-base.eclass
# @MAINTAINER:
# kde@gentoo.org
# @BLURB: This eclass provides functions for kde 4.X ebuilds
# @DESCRIPTION:
# The kde4-base.eclass provides support for building KDE4 based ebuilds
# and KDE4 applications.
#
# NOTE: KDE 4 ebuilds by default define EAPI="2", this can be redefined but
# eclass will fail with version older than 2.

inherit base cmake-utils eutils kde4-functions

get_build_type
if [[ ${BUILD_TYPE} = live ]]; then
	inherit subversion
fi

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_test src_install pkg_postinst pkg_postrm

# @ECLASS-VARIABLE: OPENGL_REQUIRED
# @DESCRIPTION:
# Is qt-opengl required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
OPENGL_REQUIRED="${OPENGL_REQUIRED:-never}"

# @ECLASS-VARIABLE: WEBKIT_REQUIRED
# @DESCRIPTION:
# Is qt-webkit requred? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
WEBKIT_REQUIRED="${WEBKIT_REQUIRED:-never}"

# @ECLASS-VARIABLE: CPPUNIT_REQUIRED
# @DESCRIPTION:
# Is cppunit required for tests? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
CPPUNIT_REQUIRED="${CPPUNIT_REQUIRED:-never}"

# @ECLASS-VARIABLE: KDE_REQUIRED
# @DESCRIPTION:
# Is kde required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'always'
# If set to always or optional, KDE_MINIMAL may be overriden as well.
# Note that for kde-base packages this variable is fixed to 'always'.
KDE_REQUIRED="${KDE_REQUIRED:-always}"

# Verify KDE_MINIMAL (display QA notice in pkg_setup, still we need to fix it here)
if [[ -n ${KDE_MINIMAL} ]]; then
	for slot in ${KDE_SLOTS[@]} ${KDE_LIVE_SLOTS[@]}; do
		[[ ${KDE_MINIMAL} = ${slot} ]] && KDE_MINIMAL_VALID=1 && break
	done
	unset slot
	[[ -z ${KDE_MINIMAL_VALID} ]] && unset KDE_MINIMAL
else
	KDE_MINIMAL_VALID=1
fi

# @ECLASS-VARIABLE: KDE_MINIMAL
# @DESCRIPTION:
# This wariable is used when KDE_REQUIRED is set, to specify required KDE minimal
# version for apps to work. Currently defaults to 4.2
# One may override this variable to raise version requirements.
# For possible values look at KDE_SLOTS and KDE_LIVE_SLOTS variables.
# Note that for kde-base packages is fixed to ${SLOT}.
KDE_MINIMAL="${KDE_MINIMAL:-4.2}"

# Fallback behaviour (for now)
# TODO Remove when tree is clean
if [[ -n ${NEED_KDE} ]]; then
	case ${NEED_KDE} in
		none)
			KDE_REQUIRED="never"
			;;
		*)
			KDE_REQUIRED="always"
			KDE_MINIMAL="${NEED_KDE}"
			;;
	esac
fi

# @ECLASS-VARIABLE: QT_DEPEND
# @DESCRIPTION:
# Determine version of qt we enforce as minimal for the package. 4.4.0 4.5.1..
# Currently defaults to 4.5.1
QT_DEPEND="${QT_DEPEND:-4.5.1}"

# OpenGL dependencies
qtopengldepend="
	>=x11-libs/qt-opengl-${QT_DEPEND}:4
"
case ${OPENGL_REQUIRED} in
	always)
		COMMONDEPEND="${COMMONDEPEND} ${qtopengldepend}"
		;;
	optional)
		IUSE="${IUSE} opengl"
		COMMONDEPEND="${COMMONDEPEND}
			opengl? ( ${qtopengldepend} )
		"
		;;
	*) ;;
esac
unset qtopengldepend

# WebKit dependencies
qtwebkitdepend="
	>=x11-libs/qt-webkit-${QT_DEPEND}:4
"
case ${WEBKIT_REQUIRED} in
	always)
		COMMONDEPEND="${COMMONDEPEND} ${qtwebkitdepend}"
		;;
	optional)
		IUSE="${IUSE} webkit"
		COMMONDEPEND="${COMMONDEPEND}
			webkit? ( ${qtwebkitdepend} )
		"
		;;
	*) ;;
esac
unset qtwebkitdepend

# CppUnit dependencies
cppuintdepend="
	dev-util/cppunit
"
case ${CPPUNIT_REQUIRED} in
	always)
		DEPEND="${DEPEND} ${cppuintdepend}"
		;;
	optional)
		IUSE="${IUSE} test"
		DEPEND="${DEPEND}
			test? ( ${cppuintdepend} )
		"
		;;
	*) ;;
esac
unset cppuintdepend

# DEPRECATED block
if [[ ${NEED_KDE} != "none" ]]; then
	# localization deps
	# DISABLED UNTIL PMS decide correct approach :(
	if [[ -n ${KDE_LINGUAS} ]]; then
		LNG_DEP=""
		for _lng in ${KDE_LINGUAS}; do
			# there must be or due to issue if lingua is not present in kde-l10n so
			# it wont die but pick kde-l10n as-is.
			LNG_DEP="${LNG_DEP}
				|| (
					kde-base/kde-l10n[linguas_${_lng},kdeprefix=]
					kde-base/kde-l10n[kdeprefix=]
				)
			"
		done
	fi
fi # NEED_KDE != NONE block

# Setup packages inheriting this eclass
case ${KDEBASE} in
	kde-base)
		if [[ $BUILD_TYPE = live ]]; then
			# Disable tests for live ebuilds
			RESTRICT="${RESTRICT} test"
			# Live ebuilds in kde-base default to kdeprefix by default
			IUSE="${IUSE} +kdeprefix"
		else
			# All other ebuild types default to -kdeprefix as before
			IUSE="${IUSE} kdeprefix"
		fi
		# Determine SLOT from PVs
		case ${PV} in
			*.9999*) SLOT="${PV/.9999*/}" ;; # stable live
			4.3* | 4.2.9* | 4.2.8* | 4.2.7* | 4.2.6*) SLOT="4.3" ;;
			4.2* | 4.1.9* | 4.1.8* | 4.1.7* | 4.1.6*) SLOT="4.2" ;;
			9999*) SLOT="live" ;; # regular live
			*) die "Unsupported ${PV}" ;;
		esac
		_kdedir="${SLOT}"
		_pv="-${PV}:${SLOT}"
		_pvn="-${PV}"

		# Block installation of other SLOTS unless kdeprefix
		for slot in ${KDE_SLOTS[@]}; do
			# Block non kdeprefix ${PN} on other slots
			if [[ ${SLOT} != ${slot} ]]; then
				RDEPEND="${RDEPEND}
					!kdeprefix? ( !kde-base/${PN}:${slot}[-kdeprefix] )
				"
			fi
		done
		unset slot
		;;
	koffice)
		SLOT="2"
		_pv="-${KDE_MINIMAL}"
		_pvn="${_pv}"
		;;
	*)
		_pv="-${KDE_MINIMAL}"
		_pvn="${_pv}"
		;;

esac

# KDE dependencies
kdecommondepend="
	dev-lang/perl
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXxf86vm
	>=x11-libs/qt-core-${QT_DEPEND}:4[qt3support,ssl]
	>=x11-libs/qt-gui-${QT_DEPEND}:4[accessibility,dbus]
	>=x11-libs/qt-qt3support-${QT_DEPEND}:4[accessibility]
	>=x11-libs/qt-script-${QT_DEPEND}:4
	>=x11-libs/qt-sql-${QT_DEPEND}:4[qt3support]
	>=x11-libs/qt-svg-${QT_DEPEND}:4
	>=x11-libs/qt-test-${QT_DEPEND}:4
"
if [[ ${PN} != kdelibs ]]; then
	if [[ ${KDEBASE} = kde-base ]]; then
		kdecommondepend="${kdecommondepend}
			kdeprefix? ( >=kde-base/kdelibs${_pv}[kdeprefix] )
			!kdeprefix? ( >=kde-base/kdelibs${_pvn}[-kdeprefix] )
		"
	else
		kdecommondepend="${kdecommondepend}
			>=kde-base/kdelibs${_pv}
		"
	fi
fi
unset _pv _pvn
kdedepend="
	dev-util/pkgconfig
	>=sys-apps/sandbox-1.3.2
"
case ${KDE_REQUIRED} in
	always)
		COMMONDEPEND="${COMMONDEPEND} ${kdecommondepend}"
		DEPEND="${DEPEND} ${kdedepend}"
		;;
	optional)
		IUSE="${IUSE} kde"
		COMMONDEPEND="${COMMONDEPEND}
			kde? ( ${kdecommondepend} )"
		DEPEND="${DEPEND}
			kde? ( ${kdedepend} )"
		;;
	*) ;;
esac
unset kdecommondepend kdedepend

debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: COMMONDEPEND is ${COMMONDEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: DEPEND (only) is ${DEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: RDEPEND (only) is ${RDEPEND}"

# Accumulate dependencies set by this eclass
DEPEND="${DEPEND} ${COMMONDEPEND}"
RDEPEND="${RDEPEND} ${COMMONDEPEND}"

# Fetch section - If the ebuild's category is not 'kde-base' and if it is not a
# koffice ebuild, the URI should be set in the ebuild itself
case ${BUILD_TYPE} in
	live)
		# Determine branch URL based on live type
		local branch_prefix
		case ${PV} in
			9999*)
				# trunk
				branch_prefix="trunk/KDE"
				;;
			*)
				# branch
				branch_prefix="branches/KDE/${SLOT}"
				# @ECLASS-VARIABLE: ESVN_PROJECT_SUFFIX
				# @DESCRIPTION
				# Suffix appended to ESVN_PROJECT depending on fetched branch.
				# Defaults is empty (for -9999 = trunk), and "-${PV}" otherwise.
				ESVN_PROJECT_SUFFIX="-${PV}"
				;;
		esac
		SRC_URI=""
		# @ECLASS-VARIABLE: ESVN_MIRROR
		# @DESCRIPTION:
		# This variable allows easy overriding of default kde mirror service
		# (anonsvn) with anything else you might want to use.
		ESVN_MIRROR=${ESVN_MIRROR:=svn://anonsvn.kde.org/home/kde}
		# Split ebuild, or extragear stuff
		if [[ -n ${KMNAME} ]]; then
		    ESVN_PROJECT="${KMNAME}${ESVN_PROJECT_SUFFIX}"
			if [[ -z ${KMNOMODULE} ]] && [[ -z ${KMMODULE} ]]; then
				KMMODULE="${PN}"
			fi
			# Split kde-base/ ebuilds: (they reside in trunk/KDE)
			case ${KMNAME} in
				kdebase-*)
					ESVN_REPO_URI="${ESVN_MIRROR}/${branch_prefix}/kdebase/${KMNAME#kdebase-}"
					;;
				kdereview)
					ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
					;;
				kdesupport)
					ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
					ESVN_PROJECT="${PN}${ESVN_PROJECT_SUFFIX}"
					;;
				kde*)
					ESVN_REPO_URI="${ESVN_MIRROR}/${branch_prefix}/${KMNAME}"
					;;
				extragear*|playground*)
					# Unpack them in toplevel dir, so that they won't conflict with kde4-meta
					# build packages from same svn location.
					ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
					ESVN_PROJECT="${PN}${ESVN_PROJECT_SUFFIX}"
					;;
				koffice)
					ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}"
					;;
				*)
					ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
					;;
			esac
		else
			# kdelibs, kdepimlibs
			ESVN_REPO_URI="${ESVN_MIRROR}/${branch_prefix}/${PN}"
			ESVN_PROJECT="${PN}${ESVN_PROJECT_SUFFIX}"
		fi
		# @ECLASS-VARIABLE: ESVN_UP_FREQ
		# @DESCRIPTION:
		# This variable is used for specifying the timeout between svn synces
		# for kde-base and koffice modules. Does not affect misc apps.
		# Default value is 1 hour.
		[[ ${KDEBASE} = kde-base || ${KDEBASE} = koffice ]] && ESVN_UP_FREQ=${ESVN_UP_FREQ:-1}
		;;
	*)
		if [[ -n ${KDEBASE} ]]; then
			if [[ -n ${KMNAME} ]]; then
				case ${KMNAME} in
					kdebase-apps)
						_kmname="kdebase" ;;
					*)
						_kmname="${KMNAME}" ;;
				esac
			else
				_kmname=${PN}
			fi
			_kmname_pv="${_kmname}-${PV}"
			if [[ $NEED_KDE != live ]]; then
			case ${KDEBASE} in
				kde-base)
					case ${PV} in
						4.2.85|4.2.90)
							# block for normally packed unstable releases
							SRC_URI="mirror://kde/unstable/${PV}/src/${_kmname_pv}.tar.bz2" ;;
						4.2.9* | 4.2.8* | 4.2.7* | 4.2.6*)
							SRC_URI="http://dev.gentooexperimental.org/~alexxy/kde/${PV}/${_kmname_pv}.tar.lzma" ;;
						4.1.9* | 4.1.8* | 4.1.7* | 4.1.6* | 4.0.9* | 4.0.8*)
							SRC_URI="mirror://kde/unstable/${PV}/src/${_kmname_pv}.tar.bz2" ;;
						*)	SRC_URI="mirror://kde/stable/${PV}/src/${_kmname_pv}.tar.bz2" ;;
					esac
					;;
				koffice)
					case ${PV} in
						1.9*)
							SRC_URI="mirror://kde/unstable/${_kmname_pv}/src/${_kmname_pv}.tar.bz2"
							;;
						*) SRC_URI="mirror://kde/stable/${_kmname_pv}/src/${_kmname_pv}.tar.bz2" ;;
					esac
				;;
			esac
			fi
			unset _kmname _kmname_pv
		fi
		;;
esac

debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: SRC_URI is ${SRC_URI}"

# @ECLASS-VARIABLE: PREFIX
# @DESCRIPTION:
# Set the installation PREFIX for non kde-base applications. It defaults to /usr.
# kde-base packages go into KDE4 installation directory (KDEDIR) by default.
# No matter the PREFIX, package will be built agains KDE installed in KDEDIR.

# @FUNCTION: kde4-base_pkg_setup
# @DESCRIPTION:
# Do the basic kdeprefix KDEDIR settings and determine with which kde should
# optional applications link
kde4-base_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"

	# QA ebuilds
	case ${NEED_KDE} in
		none) ewarn "QA Notice: using deprecated NEED_KDE variable, use KDE_REQUIRED=\"never\" or KDE_REQUIRED=\"optional\" instead. You may want to override KDE_MINIMAL as well (default is KDE_MINIMAL=\"${KDE_MINIMAL}\")." ;;
		*) [[ -n ${NEED_KDE} ]] && ewarn "QA Notice: using deprecated NEED_KDE variable, use KDE_MINIMAL instead (default is KDE_MINIMAL=\"${KDE_MINIMAL}\")." ;;
	esac
	[[ -z ${KDE_MINIMAL_VALID} ]] && ewarn "QA Notice: ignoring invalid KDE_MINIMAL (defaulting to ${KDE_MINIMAL})."

	# Don't set KDEHOME during compilation, it will cause access violations
	unset KDEHOME

	if [[ ${KDEBASE} = kde-base ]]; then
		if use kdeprefix; then
			KDEDIR="${ROOT}usr/kde/${_kdedir}"
		else
			KDEDIR="${ROOT}usr"
		fi
		PREFIX="${PREFIX:-${KDEDIR}}"
	else
		# Determine KDEDIR by loooking for the closest match with KDE_MINIMAL
		KDEDIR=
		local kde_minimal_met
		for slot in ${KDE_SLOTS[@]} ${KDE_LIVE_SLOTS[@]}; do
			[[ -z ${kde_minimal_met} ]] && [[ ${slot} = ${KDE_MINIMAL} ]] && kde_minimal_met=1
			if [[ -n ${kde_minimal_met} ]] && has_version "kde-base/kdelibs:${slot}"; then
				if has_version "kde-base/kdelibs:${slot}[kdeprefix]"; then
					KDEDIR="${ROOT}usr/kde/${slot}"
				else
					KDEDIR="${ROOT}usr"
				fi
				break;
			fi
		done
		unset slot

		# Bail out if kdelibs required but not found
		if [[ ${KDE_REQUIRED} = always ]] || { [[ ${KDE_REQUIRED} = optional ]] && use kde; }; then
			[[ -z ${KDEDIR} ]] && die "Failed to determine KDEDIR!"
		else
			[[ -z ${KDEDIR} ]] && KDEDIR="${ROOT}usr"
		fi

		PREFIX="${PREFIX:-${ROOT}usr}"
	fi

	# Not needed anymore
	unset _kdedir
}

# @FUNCTION: kde4-base_src_unpack
# @DESCRIPTION:
# This function unpacks the source tarballs for KDE4 applications.
kde4-base_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${BUILD_TYPE} = live ]]; then
		migrate_store_dir
		subversion_src_unpack
	else
		base_src_unpack
	fi
}

# @FUNCTION: kde4-base_src_compile
# @DESCRIPTION:
# General pre-configure and pre-compile function for KDE4 applications.
# It also handles translations if KDE_LINGUAS is defined. See KDE_LINGUAS and
# enable_selected_linguas() in kde4-functions.eclass(5) for further details.
kde4-base_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	# Only enable selected languages, used for KDE extragear apps.
	if [[ -n ${KDE_LINGUAS} ]]; then
		enable_selected_linguas
	fi

	[[ ${BUILD_TYPE} = live ]] && subversion_src_prepare
	base_src_prepare

	# Save library dependencies
	if [[ -n ${KMSAVELIBS} ]] ; then
		save_library_dependencies
	fi

	# Inject library dependencies
	if [[ -n ${KMLOADLIBS} ]] ; then
		load_library_dependencies
	fi
}

# @FUNCTION: kde4-base_src_configure
# @DESCRIPTION:
# Function for configuring the build of KDE4 applications.
kde4-base_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	# Handle common release builds
	if ! has debug ${IUSE//+} || ! use debug; then
		append-cppflags -DQT_NO_DEBUG
	fi

	# Build tests in src_test only, where we override this value
	local cmakeargs="-DKDE4_BUILD_TESTS=OFF"

	# set "real" debug mode
	if has debug ${IUSE//+} && use debug; then
		CMAKE_BUILD_TYPE="Debugfull"
	fi

	# Set distribution name
	[[ ${PN} = kdelibs ]] && cmakeargs="${cmakeargs} -DKDE_DISTRIBUTION_TEXT=Gentoo"

	# Here we set the install prefix
	cmakeargs="${cmakeargs} -DCMAKE_INSTALL_PREFIX=${PREFIX}"

	# Set environment
	QTEST_COLORED=1
	QT_PLUGIN_PATH="${KDEDIR}/$(get_libdir)/kde4/plugins/"

	# Point pkg-config path to KDE *.pc files
	export PKG_CONFIG_PATH="${KDEDIR}/$(get_libdir)/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}"

	# Shadow existing /usr installations
	unset KDEDIRS

	if [[ ${KDEDIR} != "${ROOT}usr" ]]; then
		# Override some environment variables - only when kdeprefix is different,
		# to not break ccache/distcc
		PATH="${KDEDIR}/bin:${PATH}"
		LDPATH="${KDEDIR}/$(get_libdir):${LDPATH}"

		# Append full RPATH
		cmakeargs="${cmakeargs} -DCMAKE_SKIP_RPATH=OFF"
	fi

	if has kdeprefix ${IUSE//+} && use kdeprefix; then
		# Set cmake prefixes to allow buildsystem to localize valid KDE installation
		# when more are present
		cmakeargs="${cmakeargs} -DCMAKE_SYSTEM_PREFIX_PATH=${KDEDIR}"
	else
		# If prefix is /usr, sysconf needs to be /etc, not /usr/etc
		cmakeargs="${cmakeargs} -DSYSCONF_INSTALL_DIR=${ROOT}etc"
	fi

	mycmakeargs="${cmakeargs} ${mycmakeargs}"

	cmake-utils_src_configure
}

# @FUNCTION: kde4-base_src_compile
# @DESCRIPTION:
# General function for compiling KDE4 applications.
kde4-base_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	cmake-utils_src_compile
}

# @FUNCTION: kde4-base_src_test
# @DESCRIPTION:
# Function for testing KDE4 applications.
kde4-base_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	# Override this value, set in kde4-base_src_configure()
	mycmakeargs="${mycmakeargs} -DKDE4_BUILD_TESTS=ON"
	cmake-utils_src_configure
	kde4-base_src_compile

	cmake-utils_src_test
}

# @FUNCTION: kde4-base_src_install
# @DESCRIPTION:
# Function for installing KDE4 applications.
kde4-base_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -n ${KMSAVELIBS} ]] ; then
		install_library_dependencies
	fi

	kde4-base_src_make_doc
	cmake-utils_src_install
}

# @FUNCTION: kde4-base_src_make_doc
# @DESCRIPTION:
# Function for installing the documentation of KDE4 applications.
kde4-base_src_make_doc() {
	debug-print-function ${FUNCNAME} "$@"

	local doc
	for doc in AUTHORS ChangeLog* README* NEWS TODO; do
		[[ -s ${doc} ]] && dodoc ${doc}
	done

	if [[ -z ${KMNAME} ]]; then
		for doc in {apps,runtime,workspace,.}/*/{AUTHORS,README*}; do
			if [[ -s ${doc} ]]; then
				local doc_complete=${doc}
				doc="${doc#*/}"
				newdoc "$doc_complete" "${doc%/*}.${doc##*/}"
			fi
		done
	fi

	if [[ -n ${KDEBASE} ]] && [[ -d "${D}${ROOT}usr/share/doc/${PF}" ]]; then
		# work around bug #97196
		dodir /usr/share/doc/KDE4 && \
			mv "${D}${ROOT}usr/share/doc/${PF}" "${D}${ROOT}usr/share/doc/KDE4/" || \
			die "Failed to move docs to KDE4/."
	fi
}

# @FUNCTION: kde4-base_pkg_postinst
# @DESCRIPTION:
# Function to rebuild the KDE System Configuration Cache after an application has been installed.
kde4-base_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"

	buildsycoca

	if [[ ${BUILD_TYPE} = live ]] && [[ -z ${I_KNOW_WHAT_I_AM_DOING} ]]; then
		echo
		einfo "WARNING! This is an experimental live ebuild of ${KMNAME:-${PN}}"
		einfo "Use it at your own risk."
		einfo "Do _NOT_ file bugs at bugs.gentoo.org because of this ebuild!"
		echo
	elif [[ ${BUILD_TYPE} != live ]] && [[ -z ${I_KNOW_WHAT_I_AM_DOING} ]] && has kdeprefix ${IUSE//+} && use kdeprefix; then
		# warning about kdeprefix for non-live users
		echo
		ewarn "WARNING! You have kdeprefix useflag enabled."
		ewarn "This setting is strongly discouraged and might lead to potential troubles"
		ewarn "with KDE update strategies."
		ewarn "You are using this setup at your own risk and kde team does not"
		ewarn "take responsibilities for dead kittens."
		echo
	fi
}

# @FUNCTION: kde4-base_pkg_postrm
# @DESCRIPTION:
# Function to rebuild the KDE System Configuration Cache after an application has been removed.
kde4-base_pkg_postrm() {
	debug-print-function ${FUNCNAME} "$@"

	buildsycoca
}
