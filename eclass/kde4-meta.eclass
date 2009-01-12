# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/kde4-meta.eclass,v 1.9 2009/01/12 17:25:59 scarabeus Exp $
#
# @ECLASS: kde4-meta.eclass
# @MAINTAINER:
# kde@gentoo.org
# @BLURB: Eclass for writing "split" KDE packages.
# @DESCRIPTION:
# This eclass provides all necessary functions for writing split KDE ebuilds.
#
# You must define KMNAME to use this eclass, and do so before inheriting it. All other variables are optional.
# Do not include the same item in more than one of KMMODULE, KMMEXTRA, KMCOMPILEONLY, KMEXTRACTONLY.

# we want opengl optional in each koffice package
if [[ $KMNAME = koffice ]]; then
	case ${PN} in
		koffice-data)
			;;
		*)
			OPENGL_REQUIRED=optional
			;;
	esac
fi

inherit kde4-base versionator

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_test src_install pkg_postinst pkg_postrm

if [[ -z ${KMNAME} ]]; then
	die "kde4-meta.eclass inherited but KMNAME not defined - broken ebuild"
fi

case ${KDEBASE} in
	kde-base)
		HOMEPAGE="http://www.kde.org/"
		LICENSE="GPL-2"
		;;
	koffice)
		HOMEPAGE="http://www.koffice.org/"
		LICENSE="GPL-2"
		;;
esac

# Add dependencies that all packages in a certain module share.
case ${KMNAME} in
	kdebase|kdebase-workspace|kdebase-runtime)
		DEPEND="${DEPEND} >=kde-base/qimageblitz-0.0.4"
		RDEPEND="${RDEPEND} >=kde-base/qimageblitz-0.0.4"
		;;
	kdepim)
		DEPEND="${DEPEND} dev-libs/boost app-office/akonadi-server"
		RDEPEND="${RDEPEND} dev-libs/boost"
		if [[ $PN != kode ]]; then
			DEPEND="${DEPEND} >=kde-base/kode-${PV}:${SLOT}"
			RDEPEND="${RDEPEND} >=kde-base/kode-${PV}:${SLOT}"
		fi
		case ${PN} in
			akregator|kaddressbook|kjots|kmail|kmobiletools|knode|knotes|korganizer|ktimetracker)
				IUSE="+kontact"
				DEPEND="${DEPEND} kontact? ( >=kde-base/kontactinterfaces-${PV}:${SLOT} )"
				RDEPEND="${RDEPEND} kontact? ( >=kde-base/kontactinterfaces-${PV}:${SLOT} )"
				;;
		esac
		;;
	kdegames)
		if [[ $PN != libkdegames ]]; then
			DEPEND="${DEPEND} >=kde-base/libkdegames-${PV}:${SLOT}"
			RDEPEND="${RDEPEND} >=kde-base/libkdegames-${PV}:${SLOT}"
		fi
		;;
	koffice)
		case ${PV} in
			9999*) DEPEND="${DEPEND} !app-office/${PN}:2" ;;
			1.9*|2*) DEPEND="${DEPEND} !app-office/${PN}:live" ;;
		esac
		DEPEND="${DEPEND}
			!app-office/${PN}:0
			!app-office/koffice:0
			!app-office/koffice-meta:0"
		case ${PN} in
			koffice-data)
				DEPEND="${DEPEND} media-libs/lcms"
				RDEPEND="${RDEPEND} media-libs/lcms"
				;;
			*)
				IUSE="+crypt"
				DEPEND="${DEPEND} crypt? ( >=app-crypt/qca-2 )"
				RDEPEND="${RDEPEND} crypt? ( >=app-crypt/qca-2 )"
				if [[ $PN != koffice-libs ]]; then
					DEPEND="${DEPEND} >=app-office/koffice-libs-${PV}:${SLOT}"
					RDEPEND="${RDEPEND} >=app-office/koffice-libs-${PV}:${SLOT}"
				fi
				;;
		esac
		;;
esac

debug-print "line ${LINENO} ${ECLASS}: DEPEND ${DEPEND} - after metapackage-specific dependencies"
debug-print "line ${LINENO} ${ECLASS}: RDEPEND ${RDEPEND} - after metapackage-specific dependencies"

# @ECLASS-VARIABLE: KMNAME
# @DESCRIPTION:
# Name of the parent-module (e.g. kdebase, kdepim, ...). You _must_ set it
# _before_ inheriting this eclass, (unlike the other parameters), since it's
# used to set $SRC_URI.

# @ECLASS-VARIABLE: KMMODULE
# @DESCRIPTION:
# Specify exactly one subdirectory of $KMNAME here. Defaults to $PN.
# The subdirectory listed here is treated exactly like items in $KMEXTRA.
#
# Example: The ebuild name of "kdebase/l10n" is kde-base/kdebase-l10n, because
# just 'l10n' would be too confusing. Hence it sets KMMODULE="l10n".

# @ECLASS-VARIABLE: KMNOMODULE
# @DESCRIPTION:
# If set to "true", $KMMODULE doesn't have to be defined.
#
# Example usage: If you're installing subdirectories of a package, like plugins,
# you mark the top subdirectory (containing the package) as $KMEXTRACTONLY, and
# set KMNOMODULE="true".
if [[ -z $KMMODULE && $KMNOMODULE != true  ]]; then
	KMMODULE=$PN
fi

# @ECLASS-VARIABLE: KMEXTRA
# @DESCRIPTION:
# All subdirectories listed here will be extracted, compiled & installed.
# $KMMODULE is always added to $KMEXTRA.
# If the htmlhandbook USE-flag is set, and if this directory exists,
# then "doc/$KMMODULE" is added to $KMEXTRA. In other cases, this should be
# handled in the ebuild.
# If the documentation is in a different subdirectory, you should add it to KMEXTRA.

# @ECLASS-VARIABLE: KMCOMPILEONLY
# @DESCRIPTION:
# All subdirectories listed here will be extracted & compiled, but not installed.

# TODO: better formulation may be needed
# @ECLASS-VARIABLE: KMEXTRACTONLY
# @DESCRIPTION:
# All subdirectories listed here will be extracted, but neither compiled nor installed.
# This can be used to avoid compilation in a subdirectory of a directory in $KMMODULE or $KMEXTRA

# @ECLASS-VARIABLE: KMTARPARAMS
# @DESCRIPTION:
# Specify extra parameters to pass to tar, in kde4-meta_src_extract.
# '-xpf -j' are passed to tar by default.

# @FUNCTION: kde4-meta_pkg_setup
# @DESCRIPTION:
# Currently just calls its equivalent in kde4-base.eclass(5). Use this one in
# split ebuilds.
kde4-meta_pkg_setup() {
	kde4-base_pkg_setup
}

# @FUNCTION: kde4-meta_src_unpack
# @DESCRIPTION:
# This function unpacks the source for split ebuilds. See also
# kde4-meta-src_extract.
kde4-meta_src_unpack() {
	debug-print-function  ${FUNCNAME} "$@"
	if [[ $BUILD_TYPE = live ]]; then
		kde4-base_src_unpack
		kde4-meta_src_extract
	else
		kde4-meta_src_extract
	fi
}

# FIXME: the difference between kde4-meta_src_extract and kde4-meta_src_unpack?

# @FUNCTION: kde4-meta_src_extract
# @DESCRIPTION:
# A function to unpack the source for a split KDE ebuild.
# Also see KMMODULE, KMNOMODULE, KMEXTRA, KMCOMPILEONLY, KMEXTRACTONLY and
# KMTARPARAMS.
kde4-meta_src_extract() {
	if [[ $BUILD_TYPE = live ]]; then
		local rsync_options subdir kmnamedir targetdir
		# Export working copy to ${S}
		einfo "Exporting parts of working copy to ${S}"
		kde4-meta_create_extractlists

		rsync_options="--group --links --owner --perms --quiet --exclude=.svn/"

		# Copy ${KMNAME} non-recursively (toplevel files)
		rsync ${rsync_options} "${ESVN_WC_PATH}"/${kmnamedir}* "${S}" \
			|| die "${ESVN}: can't export toplevel files to '${S}'."
		# Copy cmake directory
		if [[ -d "${ESVN_WC_PATH}/${kmnamedir}cmake" ]]; then
			rsync --recursive ${rsync_options} "${ESVN_WC_PATH}/${kmnamedir}cmake" "${S}" \
				|| die "${ESVN}: can't export cmake files to '${S}'."
		fi
		# Copy all subdirectories
		for subdir in $(__list_needed_subdirectories); do
				targetdir=""
				if [[ $subdir = doc/* && ! -e "$ESVN_WC_PATH/$kmnamedir$subdir" ]]; then
					continue
				fi

				[[ ${subdir%/} = */* ]] && targetdir=${subdir%/} && targetdir=${targetdir%/*} && mkdir -p "${S}/${targetdir}"
				rsync --recursive ${rsync_options} "${ESVN_WC_PATH}/${kmnamedir}${subdir%/}" "${S}/${targetdir}" \
					|| die "${ESVN}: can't export subdirectory '${subdir}' to '${S}/${targetdir}'."
		done

		if [[ $KMNAME = kdebase-runtime && $PN != kdebase-data ]]; then
			sed -i -e '/^install(PROGRAMS[[:space:]]*[^[:space:]]*\/kde4[[:space:]]/s/^/#DONOTINSTALL /' \
				"${S}"/CMakeLists.txt || die "Sed to exclude bin/kde4 failed"
		fi
	else
		local abort tarball tarfile f extractlist
		case $KMNAME in
			kdebase-apps)
				tarball="${KMNAME#-apps}-${PV}.tar.bz2"
				;;
			*)
				tarball="${KMNAME}-${PV}.tar.bz2"
				;;
		esac
		tarfile="${DISTDIR}"/${tarball}

		ebegin "Unpacking parts of ${tarball} to ${WORKDIR}"

		kde4-meta_create_extractlists

		for f in cmake/ CMakeLists.txt ConfigureChecks.cmake config.h.cmake \
			AUTHORS COPYING INSTALL README NEWS ChangeLog
		do
			extractlist="${extractlist} ${KMNAME}-${PV}/${f}"
		done
		extractlist="${extractlist} $(__list_needed_subdirectories)"
		KMTARPARAMS="${KMTARPARAMS} -j"

		pushd "${WORKDIR}" > /dev/null
		[[ -n ${KDE4_STRICTER} ]] && echo tar -xpf $tarfile $KMTARPARAMS $extractlist >&2
		tar -xpf $tarfile $KMTARPARAMS $extractlist 2> /dev/null

		# Default $S is based on $P; rename the extracted directory to match $S
		mv ${KMNAME}-${PV} ${P} || die "Died while moving \"${KMNAME}-${PV}\" to \"${P}\""

		popd > /dev/null

		eend $?

		if [[ -n ${KDE4_STRICTER} ]]; then
			for f in $(__list_needed_subdirectories fatal); do
				if [[ ! -e ${S}/${f#*/} ]]; then
					eerror "'${f#*/}' is missing"
					abort=true
				fi
			done
			[[ -n ${abort} ]] && die "There were missing files."
		fi
		kde4-base_src_unpack
	fi
	# fix koffice linking
	if [[ $KMNAME = koffice ]]; then
		koffice_fix_libraries
	fi
}

# @FUNCTION: kde4-meta_create_extractlists
# @DESCRIPTION:
# Create lists of files and subdirectories to extract.
# Also see descriptions of KMMODULE, KMNOMODULE, KMEXTRA, KMCOMPILEONLY,
# KMEXTRACTONLY and KMTARPARAMS.
kde4-meta_create_extractlists() {
	debug-print-function ${FUNCNAME} "$@"

	if has htmlhandbook ${IUSE//+} && use htmlhandbook; then
		# We use the basename of $KMMODULE because $KMMODULE can contain
		# the path to the module subdirectory.
		KMEXTRA_NONFATAL="${KMEXTRA_NONFATAL} doc/${KMMODULE##*/}"
	fi

	# Add some CMake-files to KMEXTRACTONLY.
	# Note that this actually doesn't include KMEXTRA handling.
	# In those cases you should care to add the relevant files to KMEXTRACTONLY
	case ${KMNAME} in
		kdebase)
			KMEXTRACTONLY="${KMEXTRACTONLY}
				apps/config-apps.h.cmake
				apps/ConfigureChecks.cmake"
			;;
		kdebase-apps)
			KMEXTRACTONLY="${KMEXTRACTONLY}
				config-apps.h.cmake
				ConfigureChecks.cmake"
			;;
		kdebase-runtime)
			KMEXTRACTONLY="${KMEXTRACTONLY}
				config-runtime.h.cmake"
			;;
		kdebase-workspace)
			KMEXTRACTONLY="${KMEXTRACTONLY}
				config-unix.h.cmake
				ConfigureChecks.cmake
				config-workspace.h.cmake
				config-X11.h.cmake
				startkde.cmake"
			case ${SLOT} in
				4.2)
					KMEXTRACTONLY="${KMEXTRACTONLY}
						KDE4WorkspaceConfig.cmake.in"
					;;
				*) : ;;
			esac
			;;
		kdegames)
			if [[ ${PN} != "libkdegames" ]]; then
				KMEXTRACTONLY="${KMEXTRACTONLY}
					libkdegames"
			fi
			;;
		kdepim)
			KMEXTRACTONLY="${KMEXTRACTONLY}
				kleopatra/ConfigureChecks.cmake
				libkdepim/kdepim_export.h"
			if has kontact ${IUSE//+} && use kontact; then
				KMEXTRA="${KMEXTRA} kontact/plugins/${PLUGINNAME:-${PN}}"
				KMEXTRACTONLY="${KMEXTRACTONLY} kontactinterfaces/"
			fi
			;;
		koffice)
			KMEXTRACTONLY="${KMEXTRACTONLY}
				config-endian.h.cmake
				filters/config-filters.h.cmake
				config-openctl.h.cmake
				config-openexr.h.cmake
				config-opengl.h.cmake
				config-prefix.h.cmake"
			case ${PN} in
				koffice-libs|koffice-data)
					;;
				*)
					# add basic extract for all packages
					KMEXTRACTONLY="${KMEXTRACTONLY}
						filters/
						libs/
						plugins/"
					if [[ ${PN} != "kplato" ]]; then
						KMEXTRA="${KMEXTRA} filters/${PN}"
					fi
					;;
			esac
			;;
	esac
	# Don't install cmake modules for split ebuilds, to avoid collisions.
	case ${KMNAME} in
		kdebase-runtime|kdebase-workspace|kdeedu|kdegames|kdegraphics|kdepim)
			case ${PN} in
				libkdegames|libkdeedu|marble|libkworkspace)
					KMEXTRA="${KMEXTRA}
						cmake/modules/"
					;;
				*)
					KMCOMPILEONLY="${KMCOMPILEONLY}
						cmake/modules/"
					;;
			esac
		;;
	esac

	debug-print "line ${LINENO} ${ECLASS} ${FUNCNAME}: KMEXTRACTONLY ${KMEXTRACTONLY}"
}

__list_needed_subdirectories() {
	local i j kmextra kmextra_expanded kmmodule_expanded kmcompileonly_expanded extractlist topdir

	# We expand KMEXTRA by adding CMakeLists.txt files
	kmextra="${KMEXTRA}"
	[[ ${1} != fatal ]] && kmextra="${kmextra} ${KMEXTRA_NONFATAL}"
	for i in ${kmextra}; do
		kmextra_expanded="${kmextra_expanded} ${i}"
		j=$(dirname ${i})
		while [[ ${j} != "." ]]; do
			kmextra_expanded="${kmextra_expanded} ${j}/CMakeLists.txt";
			j=$(dirname ${j})
		done
	done

	# Expand KMMODULE
	if [[ -n $KMMODULE  ]]; then
		kmmodule_expanded="${KMMODULE}"
		j=$(dirname ${KMMODULE})
		while [[ ${j} != "." ]]; do
			kmmodule_expanded="${kmmodule_expanded} $j/CMakeLists.txt";
			j=$(dirname $j)
		done
	fi

	# Expand KMCOMPILEONLY
	for i in ${KMCOMPILEONLY}; do
		kmcompileonly_expanded="${kmcompileonly_expanded} ${i}"
		j=$(dirname ${i})
		while [[ ${j} != "." ]]; do
			kmcompileonly_expanded="${kmcompileonly_expanded} ${j}/CMakeLists.txt";
			j=$(dirname ${j})
		done
	done

	debug-print "line ${LINENO} ${ECLASS} ${FUNCNAME} - kmextra_expanded: ${kmextra_expanded}"
	debug-print "line ${LINENO} ${ECLASS} ${FUNCNAME} - kmmodule_expanded:  ${kmmodule_expanded}"
	debug-print "line ${LINENO} ${ECLASS} ${FUNCNAME} - kmcompileonly_expanded: ${kmcompileonly_expanded}"


	case ${PV} in
		scm|9999*) : ;;
		*) topdir="${KMNAME}-${PV}/" ;;
	esac

	# Create final list of stuff to extract
	for i in ${kmmodule_expanded} ${kmextra_expanded} ${kmcompileonly_expanded} \
		${KMEXTRACTONLY}
	do
		extractlist="${extractlist} ${topdir}${i}"
	done

	echo ${extractlist}
}

# @FUNCTION: kde4-meta_src_prepare
# @DESCRIPTION:
# Meta-package build system configuration handling - commenting out targets, etc..
kde4-meta_src_prepare() {
	debug-print-function  ${FUNCNAME} "$@"

	kde4-meta_change_cmakelists
	kde4-base_src_prepare
}


# FIXME: no comment here?
_change_cmakelists_parent_dirs() {
	debug-print-function ${FUNCNAME} "$@"

	local _olddir _dir
	_dir="${S}"/${1}
	until [[ ${_dir} == "${S}" ]]; do
		_olddir=$(basename "${_dir}")
		_dir=$(dirname "${_dir}")
		debug-print "${LINENO}: processing ${_dir} CMakeLists.txt searching for ${_olddir}"
		if [[ -f ${_dir}/CMakeLists.txt ]]; then
			sed -e "/add_subdirectory[[:space:]]*([[:space:]]*${_olddir}[[:space:]]*)/s/#DONOTCOMPILE //g" \
				-e "/ADD_SUBDIRECTORY[[:space:]]*([[:space:]]*${_olddir}[[:space:]]*)/s/#DONOTCOMPILE //g" \
				-i ${_dir}/CMakeLists.txt || die "${LINENO}: died in ${FUNCNAME} while processing ${_dir}"
		fi
	done
}

# FIXME: add description
# @FUNCTION: kde4-meta_change_cmakelists
# @DESCRIPTION:
kde4-meta_change_cmakelists() {
	debug-print-function  ${FUNCNAME} "$@"

	pushd "${S}" > /dev/null

	comment_all_add_subdirectory ./

	# Restore "add_subdirectory( cmake )" in ${S}/CMakeLists.txt
	if [[ -f "${S}"/CMakeLists.txt ]]; then
		sed -e '/add_subdirectory[[:space:]]*([[:space:]]*cmake[[:space:]]*)/s/^#DONOTCOMPILE //' \
			-e '/ADD_SUBDIRECTORY[[:space:]]*([[:space:]]*cmake[[:space:]]*)/s/^#DONOTCOMPILE //' \
			-i "${S}"/CMakeLists.txt || die "${LINENO}: cmake sed died"
	fi

	if [[ -z ${KMNOMODULE} ]]; then
		# Restore "add_subdirectory" in $KMMODULE subdirectories
		find "${S}"/${KMMODULE} -name CMakeLists.txt -print0 | xargs -0 sed -i -e 's/^#DONOTCOMPILE //g' || \
			die "${LINENO}: died in KMMODULE section"
		_change_cmakelists_parent_dirs ${KMMODULE}
	fi

	# KMCOMPILEONLY
	local i
	for i in ${KMCOMPILEONLY}; do
		debug-print "${LINENO}: KMCOMPILEONLY, processing ${i}"
		# Uncomment "add_subdirectory" instructions inside $KMCOMPILEONLY, then comment "install" instructions.
		find "${S}"/${i} -name CMakeLists.txt -print0 | \
			xargs -0 sed -i \
				-e 's/^#DONOTCOMPILE //g' \
				-e '/install(.*)/{s/^/#DONOTINSTALL /;}' \
				-e '/^install(/,/)/{s/^/#DONOTINSTALL /;}' \
				-e '/kde4_install_icons(.*)/{s/^/#DONOTINSTALL /;}' || \
				die "${LINENO}: sed died in the KMCOMPILEONLY section while processing ${i}"
		_change_cmakelists_parent_dirs ${i}
	done

	# KMEXTRA section
	for i in ${KMEXTRA}; do
		debug-print "${LINENO}: KMEXTRA section, processing ${i}"
		find "${S}"/${i} -name CMakeLists.txt -print0 | \
			xargs -0 sed -i -e 's/^#DONOTCOMPILE //g' || \
			die "${LINENO}: sed died uncommenting add_subdirectory instructions in KMEXTRA section while processing ${i}"
		_change_cmakelists_parent_dirs ${i}
	done
	# KMEXTRA_NONFATAL section
	for i in ${KMEXTRA_NONFATAL}; do
		if [[ -d "${S}"/${i} ]]; then
			find "${S}"/${i} -name CMakeLists.txt -print0 | \
				xargs -0 sed -i -e 's/^#DONOTCOMPILE //g' || \
				die "${LINENO}: sed died uncommenting add_subdirectory instructions in KMEXTRA section while processing ${i}"
			_change_cmakelists_parent_dirs ${i}
		fi
	done

	# KMEXTRACTONLY section - Some ebuilds need to comment out some subdirs in KMMODULE and they use KMEXTRACTONLY
	for i in ${KMEXTRACTONLY}; do
		if [[ -d "${S}"/${i} && -f "${S}"/${i}/../CMakeLists.txt ]]; then
			sed -i -e "/([[:space:]]*$(basename $i)[[:space:]]*)/s/^/#DONOTCOMPILE /" "${S}"/${i}/../CMakeLists.txt || \
				die "${LINENO}: sed died while working in the KMEXTRACTONLY section while processing ${i}"
		fi
	done

	case ${KMNAME} in
		kdebase-workspace)
			# COLLISION PROTECT section
			# Install the startkde script just once, as a part of kde-base/kdebase-startkde,
			# not as a part of every package.
			if [[ ${PN} != "kdebase-startkde" && -f "${S}"/CMakeLists.txt ]]; then
				# The startkde script moved to kdebase-workspace for KDE4 versions > 3.93.0.
				sed -i -e '/startkde/s/^/#DONOTINSTALL /' "${S}"/CMakeLists.txt || \
					die "${LINENO}: sed died in the kdebase-startkde collision prevention section"
			fi
			# Strip EXPORT feature section from workspace for KDE4 versions > 4.1.82
			if [[ ${SLOT} == 4.2 ]] || [[ ${PV} == 9999 ]]; then
				if [[ ${PN} != libkworkspace ]]; then
					sed -i -e '/install(FILES ${CMAKE_CURRENT_BINARY_DIR}\/KDE4WorkspaceConfig.cmake/,/^[[:space:]]*FILE KDE4WorkspaceLibraryTargets.cmake )[[:space:]]*^/d' \
						CMakeLists.txt || die "${LINENO}: sed died in kdebase-workspace strip EXPORT section"
				fi
			fi
			;;
		kdebase-runtime)
			# COLLISION PROTECT section
			# Only install the kde4 script as part of kde-base/kdebase-data
			if [[ ${PN} != "kdebase-data" && -f "${S}"/CMakeLists.txt ]]; then
				sed -i -e '/^install(PROGRAMS[[:space:]]*[^[:space:]]*\/kde4[[:space:]]/s/^/#DONOTINSTALL /' \
					"${S}"/CMakeLists.txt || die "Sed to exclude bin/kde4 failed"
			fi
			;;
		kdepim)
			case ${PN} in
				kaddressbook|kalarm|kmailcvt|kontact|korganizer|korn)
					sed -i -n -e '/qt4_generate_dbus_interface(.*org\.kde\.kmail\.\(kmail\|mailcomposer\)\.xml/p' \
						-e '/add_custom_target(kmail_xml /,/)/p' "${S}"/kmail/CMakeLists.txt || die "uncommenting xml failed"
					_change_cmakelists_parent_dirs kmail
				;;
			esac
			;;
	esac

	popd > /dev/null
}

# @FUNCTION: kde4-meta_src_configure
# @DESCRIPTION:
# Currently just calls its equivalent in kde4-base.eclass(5). Use this one in split
# ebuilds.
kde4-meta_src_configure() {
	debug-print-function  ${FUNCNAME} "$@"

	kde4-base_src_configure
}

# @FUNCTION: kde4-meta_src_compile
# @DESCRIPTION:
# General function for compiling split KDE4 applications.
# Overrides kde4-base_src_compile.
kde4-meta_src_compile() {
	debug-print-function  ${FUNCNAME} "$@"

	kde4-base_src_make
}

# @FUNCTION: kde4-meta_src_test
# @DESCRIPTION:
# Currently just calls its equivalent in kde4-base.eclass(5). Use this in split
# ebuilds.
kde4-meta_src_test() {
	debug-print-function $FUNCNAME "$@"

	kde4-base_src_test
}

# @FUNCTION: kde4-meta_src_install
# @DESCRIPTION:
# Function for installing KDE4 split applications.
kde4-meta_src_install() {
	debug-print-function $FUNCNAME "$@"

	kde4-meta_src_make_doc
	cmake-utils_src_install

	if [[ -n ${KMSAVELIBS} ]]; then
		install_library_dependencies
	fi

	# remove unvanted koffice stuff
	if [[ $KMNAME = koffice && $PN != koffice-data ]]; then
		rm "$D/$KDEDIR/include/config-openexr.h"
		rm "$D/$KDEDIR/share/apps/cmake/modules/FindKOfficeLibs.cmake"
	fi
}

# @FUNCTION: kde4-meta_src_make_doc
# @DESCRIPTION:
# This function searches in ${S}/${KMMODULE},
# and tries to install "AUTHORS ChangeLog* README* NEWS todo" if these files exist.
kde4-meta_src_make_doc() {
	debug-print-function  $FUNCNAME "$@"

	local doc
	for doc in AUTHORS ChangeLog* README* NEWS TODO; do
		[[ -s ${KMMODULE}/$doc ]] && newdoc "${KMMODULE}/${doc}" "${doc}.${KMMODULE##*/}"
	done

	kde4-base_src_make_doc
}

# @FUNCTION: kde4-meta_pkg_postinst
# @DESCRIPTION:
# Currently just calls its equivalent in kde4-base.eclass(5). Use this in split
# ebuilds.
kde4-meta_pkg_postinst() {
	kde4-base_pkg_postinst
}

# @FUNCTION: kde4-meta_pkg_postrm
# @DESCRIPTION:
# Currently just calls its equivalent in kde4-base.eclass(5). Use this in split
# ebuilds.
kde4-meta_pkg_postrm() {
	kde4-base_pkg_postrm
}

