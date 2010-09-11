# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/kde4-meta.eclass,v 1.40 2010/09/11 04:25:23 reavertm Exp $
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

inherit kde4-base versionator

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_test src_install pkg_postinst pkg_postrm

[[ -z ${KMNAME} ]] && die "kde4-meta.eclass inherited but KMNAME not defined - broken ebuild"

# Add dependencies that all packages in a certain module share.
case ${KMNAME} in
	kdebase|kdebase-apps|kdebase-workspace|kdebase-runtime|kdegraphics)
		COMMONDEPEND+=" >=media-libs/qimageblitz-0.0.4"
		;;
	kdepim|kdepim-runtime)
		case ${PN} in
			akregator|kaddressbook|kjots|kmail|knode|knotes|korganizer|ktimetracker)
				IUSE+=" +kontact"
				RDEPEND+=" kontact? ( $(add_kdebase_dep kontact) )"
				;;
		esac
		;;
	kdegames)
		if [[ ${PN} != libkdegames ]]; then
			COMMONDEPEND+=" $(add_kdebase_dep libkdegames)"
		fi
		;;
	koffice)
		[[ ${PN} != koffice-data ]] && IUSE+=" debug"
		RDEPEND+="
			!app-office/${PN}:0
			!app-office/koffice:0
			!app-office/koffice-meta:0
		"
		if has openexr ${IUSE//+}; then
			COMMONDEPEND+=" media-gfx/imagemagick[openexr?]"
		else
			COMMONDEPEND+=" media-gfx/imagemagick"
		fi

		COMMONDEPEND+="
			dev-cpp/eigen:2
			media-libs/fontconfig
			media-libs/freetype:2
		"
		if [[ ${PN} != koffice-libs && ${PN} != koffice-data ]]; then
			COMMONDEPEND+=" >=app-office/koffice-libs-${PV}:${SLOT}"
		fi
		;;
esac

DEPEND+=" ${COMMONDEPEND}"
RDEPEND+=" ${COMMONDEPEND}"
unset COMMONDEPEND

debug-print "line ${LINENO} ${ECLASS}: DEPEND ${DEPEND} - after metapackage-specific dependencies"
debug-print "line ${LINENO} ${ECLASS}: RDEPEND ${RDEPEND} - after metapackage-specific dependencies"

# Useful to build kde4-meta style stuff from extragear/playground (plasmoids etc)
case ${BUILD_TYPE} in
	live)
		case ${KMNAME} in
			extragear*|playground*)
				ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}"
				ESVN_PROJECT="${KMNAME}${ESVN_PROJECT_SUFFIX}"
				;;
		esac
		;;
esac

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
if [[ -z ${KMMODULE} && ${KMNOMODULE} != true  ]]; then
	KMMODULE=${PN}
fi

# @ECLASS-VARIABLE: KMEXTRA
# @DESCRIPTION:
# All subdirectories listed here will be extracted, compiled & installed.
# $KMMODULE is always added to $KMEXTRA.
# If the handbook USE-flag is set, and if this directory exists,
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
	debug-print-function ${FUNCNAME} "$@"

	kde4-base_pkg_setup
}

# @FUNCTION: kde4-meta_src_unpack
# @DESCRIPTION:
# This function unpacks the source for split ebuilds. See also
# kde4-meta-src_extract.
kde4-meta_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${BUILD_TYPE} = live ]]; then
		migrate_store_dir
		S="${WORKDIR}/${P}"
		mkdir -p "${S}"
		ESVN_RESTRICT="export" subversion_src_unpack
		subversion_wc_info
		subversion_bootstrap
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
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${BUILD_TYPE} = live ]]; then
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

		if [[ ${KMNAME} = kdebase-runtime && ${PN} != kdebase-data ]]; then
			sed -i -e '/^install(PROGRAMS[[:space:]]*[^[:space:]]*\/kde4[[:space:]]/s/^/#DONOTINSTALL /' \
				"${S}"/CMakeLists.txt || die "Sed to exclude bin/kde4 failed"
		fi
	else
		local abort tarball tarfile f extractlist moduleprefix postfix
		case ${PV} in
			4.[45].8[05] | 4.[45].9[023568])
				# Block for normally packed upstream unstable snapshots
				KMTARPARAMS+=" --bzip2" # bz2
				postfix="bz2"
				;;
			*)
				KMTARPARAMS+=" --bzip2" # bz2
				postfix="bz2"
				;;
		esac
		case ${KMNAME} in
			kdebase-apps)
				# kdebase/apps -> kdebase-apps
				tarball="kdebase-${PV}.tar.${postfix}"
				# Go one level deeper for kdebase-apps in tarballs
				moduleprefix=apps/
				KMTARPARAMS+=" --transform=s|apps/||"
				;;
			*)
				# Create tarball name from module name (this is the default)
				tarball="${KMNAME}-${PV}.tar.${postfix}"
				;;
		esac

		# Full path to source tarball
		tarfile="${DISTDIR}/${tarball}"

		# Detect real toplevel dir from tarball name - it will be used upon extraction
		# and in __list_needed_subdirectories
		topdir="${tarball%.tar.*}/"

		ebegin "Unpacking parts of ${tarball} to ${WORKDIR}"

		kde4-meta_create_extractlists

		for f in cmake/ CMakeLists.txt ConfigureChecks.cmake config.h.cmake \
			AUTHORS COPYING INSTALL README NEWS ChangeLog
		do
			extractlist+=" ${topdir}${moduleprefix}${f}"
		done
		extractlist+=" $(__list_needed_subdirectories)"

		pushd "${WORKDIR}" > /dev/null
		[[ -n ${KDE4_STRICTER} ]] && echo tar -xpf "${tarfile}" ${KMTARPARAMS} ${extractlist} >&2
		tar -xpf "${tarfile}" ${KMTARPARAMS} ${extractlist} 2> /dev/null

		# Default $S is based on $P; rename the extracted directory to match $S if necessary
		mv ${topdir} ${P} || die "Died while moving \"${topdir}\" to \"${P}\""

		popd > /dev/null

		eend $?

		# We need to clear it here to make verification below work
		unset moduleprefix

		if [[ -n ${KDE4_STRICTER} ]]; then
			for f in $(__list_needed_subdirectories fatal); do
				if [[ ! -e "${S}/${f#*/}" ]]; then
					eerror "'${f#*/}' is missing"
					abort=true
				fi
			done
			[[ -n ${abort} ]] && die "There were missing files."
		fi

		# We don't need it anymore
		unset topdir
	fi
}

# @FUNCTION: kde4-meta_create_extractlists
# @DESCRIPTION:
# Create lists of files and subdirectories to extract.
# Also see descriptions of KMMODULE, KMNOMODULE, KMEXTRA, KMCOMPILEONLY,
# KMEXTRACTONLY and KMTARPARAMS.
kde4-meta_create_extractlists() {
	debug-print-function ${FUNCNAME} "$@"

	# TODO change to KMEXTRA for more strict check
	if has handbook ${IUSE//+} && use handbook && [[ -n ${KMMODULE} ]]; then
		# We use the basename of $KMMODULE because $KMMODULE can contain
		# the path to the module subdirectory.
		KMEXTRA_NONFATAL+="
			doc/${KMMODULE##*/}"
	fi

	# Add some CMake-files to KMEXTRACTONLY.
	# Note that this actually doesn't include KMEXTRA handling.
	# In those cases you should care to add the relevant files to KMEXTRACTONLY
	case ${KMNAME} in
		kdebase)
			KMEXTRACTONLY+="
				apps/config-apps.h.cmake
				apps/ConfigureChecks.cmake"
			;;
		kdebase-apps)
			KMEXTRACTONLY+="
				config-apps.h.cmake
				ConfigureChecks.cmake"
			;;
		kdebase-runtime)
			KMEXTRACTONLY+="
				config-runtime.h.cmake"
			;;
		kdebase-workspace)
			KMEXTRACTONLY+="
				config-unix.h.cmake
				ConfigureChecks.cmake
				config-workspace.h.cmake
				config-X11.h.cmake
				startkde.cmake
				KDE4WorkspaceConfig.cmake.in"
			;;
		kdegames)
			if [[ ${PN} != libkdegames ]]; then
				KMEXTRACTONLY+="
					libkdegames/"
				KMLOADLIBS="${KMLOADLIBS} libkdegames"
			fi
			;;
		kdepim)
			if [[ ${PN} != libkdepim ]]; then
				KMEXTRACTONLY+="
					libkdepim/"
			fi
			KMEXTRACTONLY+="
				config-enterprise.h.cmake
				kleopatra/ConfigureChecks.cmake"
			if slot_is_at_least 4.5 ${SLOT}; then
				KMEXTRACTONLY+="
					CTestCustom.cmake
					kdepim-version.h.cmake"
			else
				KMEXTRACTONLY+="
					kdepim-version.h"
			fi
			if has kontact ${IUSE//+} && use kontact; then
				KMEXTRA+="
					kontact/plugins/${PLUGINNAME:-${PN}}/"
			fi
			;;
		kdeutils)
			KMEXTRACTONLY+="
				kdeutils-version.h"
			;;
		koffice)
			KMEXTRACTONLY+="
				config-endian.h.cmake
				filters/config-filters.h.cmake
				config-openexr.h.cmake
				config-opengl.h.cmake
				config-prefix.h.cmake
			"
			case ${PV} in
				2.0.*)
					KMEXTRACTONLY+="
						config-openctl.h.cmake"
				;;
			esac
			;;
	esac
	# Don't install cmake modules for split ebuilds, to avoid collisions.
	case ${KMNAME} in
		kdebase-runtime|kdebase-workspace|kdeedu|kdegames|kdegraphics)
			case ${PN} in
				libkdegames|libkdeedu|libkworkspace)
					KMEXTRA+="
						cmake/modules/"
					;;
				*)
					KMCOMPILEONLY+="
						cmake/modules/"
					;;
			esac
		;;
	esac

	debug-print "line ${LINENO} ${ECLASS} ${FUNCNAME}: KMEXTRACTONLY ${KMEXTRACTONLY}"
}

__list_needed_subdirectories() {
	local i j kmextra kmextra_expanded kmmodule_expanded kmcompileonly_expanded extractlist

	# We expand KMEXTRA by adding CMakeLists.txt files
	kmextra="${KMEXTRA}"
	[[ ${1} != fatal ]] && kmextra+=" ${KMEXTRA_NONFATAL}"
	for i in ${kmextra}; do
		kmextra_expanded+=" ${i}"
		j=$(dirname ${i})
		while [[ ${j} != "." ]]; do
			kmextra_expanded+=" ${j}/CMakeLists.txt";
			j=$(dirname ${j})
		done
	done

	# Expand KMMODULE
	if [[ -n ${KMMODULE} ]]; then
		kmmodule_expanded="${KMMODULE}"
		j=$(dirname ${KMMODULE})
		while [[ ${j} != "." ]]; do
			kmmodule_expanded+=" ${j}/CMakeLists.txt";
			j=$(dirname ${j})
		done
	fi

	# Expand KMCOMPILEONLY
	for i in ${KMCOMPILEONLY}; do
		kmcompileonly_expanded+=" ${i}"
		j=$(dirname ${i})
		while [[ ${j} != "." ]]; do
			kmcompileonly_expanded+=" ${j}/CMakeLists.txt";
			j=$(dirname ${j})
		done
	done

	debug-print "line ${LINENO} ${ECLASS} ${FUNCNAME} - kmextra_expanded: ${kmextra_expanded}"
	debug-print "line ${LINENO} ${ECLASS} ${FUNCNAME} - kmmodule_expanded:  ${kmmodule_expanded}"
	debug-print "line ${LINENO} ${ECLASS} ${FUNCNAME} - kmcompileonly_expanded: ${kmcompileonly_expanded}"

	# Create final list of stuff to extract
	# We append topdir only when specified (usually for tarballs)
	for i in ${kmmodule_expanded} ${kmextra_expanded} ${kmcompileonly_expanded} \
		${KMEXTRACTONLY}
	do
		extractlist+=" ${topdir}${moduleprefix}${i}"
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

# @FUNCTION: kde4-meta_change_cmakelists
# @DESCRIPTION:
# Adjust CMakeLists.txt to comply to our splitting.
kde4-meta_change_cmakelists() {
	debug-print-function ${FUNCNAME} "$@"

	pushd "${S}" > /dev/null

	comment_all_add_subdirectory ./

	# Restore "add_subdirectory( cmake )" in ${S}/CMakeLists.txt
	if [[ -f CMakeLists.txt ]]; then
		sed -e '/add_subdirectory[[:space:]]*([[:space:]]*cmake[[:space:]]*)/s/^#DONOTCOMPILE //' \
			-e '/ADD_SUBDIRECTORY[[:space:]]*([[:space:]]*cmake[[:space:]]*)/s/^#DONOTCOMPILE //' \
			-i CMakeLists.txt || die "${LINENO}: cmake sed died"
	fi

	if [[ -z ${KMNOMODULE} ]]; then
		# Restore "add_subdirectory" in $KMMODULE subdirectories
		find "${S}"/${KMMODULE} -name CMakeLists.txt -print0 | \
			xargs -0 sed -i -e 's/^#DONOTCOMPILE //g' || \
				die "${LINENO}: died in KMMODULE section"
		_change_cmakelists_parent_dirs ${KMMODULE}
	fi

	local i

	# KMEXTRACTONLY section - Some ebuilds need to comment out some subdirs in KMMODULE and they use KMEXTRACTONLY
	for i in ${KMEXTRACTONLY}; do
		if [[ -d ${i} && -f ${i}/../CMakeLists.txt ]]; then
			sed -e "/([[:space:]]*$(basename $i)[[:space:]]*)/s/^/#DONOTCOMPILE /" \
				-i ${i}/../CMakeLists.txt || \
				die "${LINENO}: sed died while working in the KMEXTRACTONLY section while processing ${i}"
		fi
	done

	# KMCOMPILEONLY
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

	case ${KMNAME} in
		kdebase-workspace)
			# COLLISION PROTECT section
			# Install the startkde script just once, as a part of kde-base/kdebase-startkde,
			# not as a part of every package.
			if [[ ${PN} != kdebase-startkde && -f CMakeLists.txt ]]; then
				# The startkde script moved to kdebase-workspace for KDE4 versions > 3.93.0.
				sed -e '/startkde/s/^/#DONOTINSTALL /' \
					-i CMakeLists.txt || die "${LINENO}: sed died in the kdebase-startkde collision prevention section"
			fi
			# Strip EXPORT feature section from workspace for KDE4 versions > 4.1.82
			if [[ ${PN} != libkworkspace ]]; then
				sed -e '/install(FILES ${CMAKE_CURRENT_BINARY_DIR}\/KDE4WorkspaceConfig.cmake/,/^[[:space:]]*FILE KDE4WorkspaceLibraryTargets.cmake )[[:space:]]*^/d' \
					-i CMakeLists.txt || die "${LINENO}: sed died in kdebase-workspace strip config install and fix EXPORT section"
			fi
			;;
		kdebase-runtime)
			# COLLISION PROTECT section
			# Only install the kde4 script as part of kde-base/kdebase-data
			if [[ ${PN} != kdebase-data && -f CMakeLists.txt ]]; then
				sed -e '/^install(PROGRAMS[[:space:]]*[^[:space:]]*\/kde4[[:space:]]/s/^/#DONOTINSTALL /' \
					-i CMakeLists.txt || die "Sed to exclude bin/kde4 failed"
			fi
			;;
		kdenetwork)
			# Disable hardcoded kdepimlibs check
			sed -e 's/find_package(KdepimLibs REQUIRED)/macro_optional_find_package(KdepimLibs)/' \
				-i CMakeLists.txt || die "failed to disable hardcoded checks"
			;;
		kdepim)
			# Disable hardcoded checks
			sed -r -e '/find_package\(KdepimLibs/s/REQUIRED//' \
				-e '/find_package\((KdepimLibs|Boost|QGpgme|Akonadi|ZLIB|Strigi|SharedDesktopOntologies|Soprano|Nepomuk)/{/macro_optional_/!s/find/macro_optional_&/}' \
				-e '/macro_log_feature\((Boost|QGPGME|Akonadi|ZLIB|STRIGI|SHAREDDESKTOPONTOLOGIES|Soprano|Nepomuk)_FOUND/s/ TRUE / FALSE /' \
				-e '/if[[:space:]]*([[:space:]]*BUILD_.*)/s/^/#OVERRIDE /' \
				-e '/if[[:space:]]*([[:space:]]*[[:alnum:]]*_FOUND[[:space:]]*)/s/^/#OVERRIDE /' \
				-i CMakeLists.txt || die "failed to disable hardcoded checks"
			# Disable broken or redundant build logic
			if ( has kontact ${IUSE//+} && use kontact ) || [[ ${PN} = kontact ]]; then
				sed -e '/if[[:space:]]*([[:space:]]*BUILD_.*)/s/^/#OVERRIDE /' \
					-e '/if[[:space:]]*([[:space:]]*[[:alnum:]]*_FOUND[[:space:]]*)/s/^/#OVERRIDE /' \
					-i kontact/plugins/CMakeLists.txt || die 'failed to override build logic'
			fi
			if ! slot_is_at_least 4.5 ${SLOT}; then
				case ${PN} in
					kalarm|kmailcvt|kontact|korganizer|korn)
						sed -n -e '/qt4_generate_dbus_interface(.*org\.kde\.kmail\.\(kmail\|mailcomposer\)\.xml/p' \
							-e '/add_custom_target(kmail_xml /,/)/p' \
							-i kmail/CMakeLists.txt || die "uncommenting xml failed"
						_change_cmakelists_parent_dirs kmail
					;;
				esac
			fi
			;;
		kdewebdev)
			# Disable hardcoded checks
			sed -e 's/find_package(KdepimLibs REQUIRED)/macro_optional_find_package(KdepimLibs)/' \
				-e 's/find_package(LibXml2 REQUIRED)/macro_optional_find_package(LibXml2)/' \
				-e 's/find_package(LibXslt REQUIRED)/macro_optional_find_package(LibXslt)/' \
				-e 's/find_package(Boost REQUIRED)/macro_optional_find_package(Boost)/' \
				-i CMakeLists.txt || die "failed to disable hardcoded checks"
			;;
		koffice)
			# Prevent collisions
			if [[ ${PN} != koffice-data ]]; then
				sed -e '/install(.*FindKOfficeLibs.cmake/,/)/ d' \
					-i cmake/modules/CMakeLists.txt || die "${LINENO}: sed died in collision prevention section"
				sed -e '/install(.\+config-openexr\.h.\+)/d' \
					-i CMakeLists.txt || die "${LINENO}: sed died in collision prevention section"
			fi
			# koffice 2.0
			case ${PV} in
				2.0.[1-9])
					sed -i -n -e '1h;1!H;${g;s/install(.\+config-openexr.h.\+)//;p}' \
						"${S}"/CMakeLists.txt || \
						die "${LINENO}: sed died in collision prevention section"
					;;
				*) ;;
			esac
			# koffice 2.1.[8-9][0-9] and 9999
			case ${PV} in
				2.1.8[0-9]|2.1.9[0-9]|9999)
					sed -e '/^option(BUILD/s/ON/OFF/' \
						-e '/^if(NOT BUILD_kchart/,/^endif(NOT BUILD_kchart/d' \
						-e '/^if(BUILD_koreport/,/^endif(BUILD_koreport/d' \
						-e 's/set(SHOULD_BUILD_F_OFFICE TRUE)/set(SHOULD_BUILD_F_OFFICE FALSE)/' \
						-i "${S}"/CMakeLists.txt || die "sed died while fixing cmakelists"
					if [[ ${PN} != koffice-data ]] && [[ ${PV} == 9999 ]]; then
						sed -e '/config-opengl.h/d' \
						-i "${S}"/CMakeLists.txt || die "sed died while fixing cmakelists"

					fi
				;;
				*) ;;
			esac
	esac

	popd > /dev/null
}

# @FUNCTION: kde4-meta_src_configure
# @DESCRIPTION:
# Currently just calls its equivalent in kde4-base.eclass(5). Use this one in split
# ebuilds.
kde4-meta_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	# backwards-compatibility: make mycmakeargs an array, if it isn't already
	if [[ $(declare -p mycmakeargs 2>&-) != "declare -a mycmakeargs="* ]]; then
		mycmakeargs=(${mycmakeargs})
	fi

	# Set some cmake default values here (usually workarounds for automagic deps)
	case ${KMNAME} in
		kdewebdev)
			mycmakeargs=(
				-DWITH_KdepimLibs=OFF
				-DWITH_LibXml2=OFF
				-DWITH_LibXslt=OFF
				-DWITH_Boost=OFF
				-DWITH_LibTidy=OFF
				"${mycmakeargs[@]}"
			)
			;;
		koffice)
			case ${PV} in
				2.1.8[0-9]|2.1.9[0-9]|9999)
					if [[ ${PN} != "kchart" ]]; then
						mycmakeargs=(
							-DBUILD_koreport=OFF
							"${mycmakeargs[@]}"
						)
					fi
				;;
			esac
			;;
	esac

	kde4-base_src_configure
}

# @FUNCTION: kde4-meta_src_compile
# @DESCRIPTION:
# General function for compiling split KDE4 applications.
# Overrides kde4-base_src_compile.
kde4-meta_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	kde4-base_src_compile "$@"
}

# @FUNCTION: kde4-meta_src_test
# @DESCRIPTION:
# Currently just calls its equivalent in kde4-base.eclass(5) if
# I_KNOW_WHAT_I_AM_DOING is set. Use this in split ebuilds.
kde4-meta_src_test() {
	debug-print-function $FUNCNAME "$@"

	if [[ $I_KNOW_WHAT_I_AM_DOING ]]; then
		kde4-base_src_test
	else
		einfo "Tests disabled"
	fi
}

# @FUNCTION: kde4-meta_src_install
# @DESCRIPTION:
# Function for installing KDE4 split applications.
kde4-meta_src_install() {
	debug-print-function $FUNCNAME "$@"

	# Search ${S}/${KMMODULE} and install common documentation files found
	local doc
	for doc in "${S}/${KMMODULE}"/{AUTHORS,CHANGELOG,ChangeLog*,README*,NEWS,TODO,HACKING}; do
		[[ -f "${doc}" ]] && [[ -s "${doc}" ]] && dodoc "${doc}"
	done

	kde4-base_src_install
}

# @FUNCTION: kde4-meta_pkg_postinst
# @DESCRIPTION:
# Invoke kbuildsycoca4.
kde4-meta_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"

	kde4-base_pkg_postinst
}

# @FUNCTION: kde4-meta_pkg_postrm
# @DESCRIPTION:
# Currently just calls its equivalent in kde4-base.eclass(5). Use this in split
# ebuilds.
kde4-meta_pkg_postrm() {
	debug-print-function ${FUNCNAME} "$@"

	kde4-base_pkg_postrm
}
