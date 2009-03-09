# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/kde4-functions.eclass,v 1.14 2009/03/09 19:41:26 scarabeus Exp $

# @ECLASS: kde4-functions.eclass
# @MAINTAINER:
# kde@gentoo.org
# @BLURB: Common ebuild functions for KDE 4 packages
# @DESCRIPTION:
# This eclass contains all functions shared by the different eclasses,
# for KDE 4 ebuilds.

# @ECLASS-VARIABLE: EAPI
# @DESCRIPTION:
# By default kde4 eclasses wants eapi 2 which might be redefinable to newer
# versions.
case ${EAPI:-0} in
	2) : ;;
	*) die "No way! EAPI other than 2 is not supported for now." ;;
esac

# @ECLASS-VARIABLE: KDEBASE
# @DESCRIPTION:
# This gets set to a non-zero value when a package is considered a kde or
# koffice ebuild.

if [[ $CATEGORY = kde-base ]]; then
	debug-print "${ECLASS}: KDEBASE ebuild recognized"
	KDEBASE=kde-base
fi

# is this a koffice ebuild?
if [[ $KMNAME = koffice || $PN = koffice ]]; then
	debug-print "${ECLASS}: KOFFICE ebuild recognized"
	KDEBASE=koffice
fi

# @ECLASS-VARIABLE: KDE_SLOTS
# @DESCRIPTION:
# The slots used by all KDE versions later than 4.0. The live-ebuilds use
# KDE_LIVE_SLOTS instead.
KDE_SLOTS=( kde-4 4.1 4.2 4.3 )

# @ECLASS-VARIABLE: KDE_LIVE_SLOTS
# @DESCRIPTION:
# The slots used by all KDE live versions.
KDE_LIVE_SLOTS=( live )

# @FUNCTION: buildsycoca
# @DESCRIPTION:
# Function to rebuild the KDE System Configuration Cache.
# All KDE ebuilds should run this in pkg_postinst and pkg_postrm.
#
# Note that kde4-base.eclass already does this.
buildsycoca() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -z ${ROOT%%/} && -x ${KDEDIR}/bin/kbuildsycoca4 ]]; then
		# Make sure tha cache file exists, or kbuildsycoca4 will fail
		touch "${KDEDIR}/share/kde4/services/ksycoca4"

		# We have to unset DISPLAY and DBUS_SESSION_BUS_ADDRESS, the ones
		# in the user's environment (through su [without '-']) may cause
		# kbuildsycoca4 to hang.

		ebegin "Running kbuildsycoca4 to build global database"
		# This is needed because we support multiple kde versions installed together.
		XDG_DATA_DIRS="/usr/share:${KDEDIR}/share:/usr/local/share" \
			DISPLAY="" DBUS_SESSION_BUS_ADDRESS="" \
			${KDEDIR}/bin/kbuildsycoca4 --global --noincremental &> /dev/null
		eend $?
	fi
}

# @FUNCTION: comment_all_add_subdirectory
# @USAGE: [list of directory names]
# @DESCRIPTION:
# Recursively comment all add_subdirectory instructions in listed directories,
# except those in cmake/.
comment_all_add_subdirectory() {
	find "$@" -name CMakeLists.txt -print0 | grep -vFzZ "./cmake" | \
		xargs -0 sed -i -e '/add_subdirectory/s/^/#DONOTCOMPILE /' -e '/ADD_SUBDIRECTORY/s/^/#DONOTCOMPILE /' || \
		die "${LINENO}: Initial sed died"
}

# @ECLASS-VARIABLE: KDE_LINGUAS
# @DESCRIPTION:
# This is a whitespace-separated list of translations this ebuild supports.
# These translations are automatically added to IUSE. Therefore ebuilds must set
# this variable before inheriting any eclasses. To enable only selected
# translations, ebuilds must call enable_selected_linguas(). kde4-base.eclass does
# this for you.
#
# Example: KDE_LINGUAS="en_GB de nl"
for _lingua in ${KDE_LINGUAS}; do
	IUSE="${IUSE} linguas_${_lingua}"
done

# @FUNCTION: enable_selected_linguas
# @DESCRIPTION:
# Enable translations based on LINGUAS settings and translations supported by
# the package (see KDE_LINGUAS). By default, translations are found in "${S}"/po
# but this default can be overridden by defining KDE_LINGUAS_DIR.
enable_selected_linguas() {
	local lingua sr_mess wp

	# ebuild overridable linguas directory definition
	KDE_LINGUAS_DIR=${KDE_LINGUAS_DIR:=${S}/po}
	cd "$KDE_LINGUAS_DIR" || die "wrong linguas dir specified"

	# fix all various crazy sr@Latn variations
	# this part is only ease for ebuilds, so there wont be any die when this
	# fail at any point
	sr_mess="sr@latn sr@latin sr@Latin"
	for wp in ${sr_mess}; do
		[[ -e "$wp.po" ]] && mv "$wp.po" "sr@Latn.po"
		if [[ -d "$wp" ]]; then
			# move dir and fix cmakelists
			mv "$wp" "sr@Latn"
			sed -i \
				-e "s:$wp:sr@Latin:g" \
				CMakeLists.txt
		fi
	done

	for lingua in ${KDE_LINGUAS}; do
		if [[ -e "$lingua.po" ]]; then
			mv "$lingua.po" "$lingua.po.old"
		fi
	done
	comment_all_add_subdirectory "${KDE_LINGUAS_DIR}"
	for lingua in ${LINGUAS}; do
		ebegin "Enabling LANGUAGE: ${lingua}"
		if [[ -d "$lingua" ]]; then
			sed -e "/add_subdirectory([[:space:]]*${lingua}[[:space:]]*)[[:space:]]*$/ s/^#DONOTCOMPILE //" \
				-e "/ADD_SUBDIRECTORY([[:space:]]*${lingua}[[:space:]]*)[[:space:]]*$/ s/^#DONOTCOMPILE //" \
				-i CMakeLists.txt || die "Sed to uncomment linguas_${lingua} failed."
		fi
		if [[ -e "$lingua.po.old" ]]; then
			mv "$lingua.po.old" "$lingua.po"
		fi
		eend $?
	done
}

# @FUNCTION: get_build_type
# @DESCRIPTION:
# Determine whether we are using live ebuild or tbzs.
get_build_type() {
	if [[ $SLOT = live || $PV = 9999* ]]; then
		BUILD_TYPE="live"
	else
		BUILD_TYPE="release"
	fi
	export BUILD_TYPE
}

# @FUNCTION: get_latest_kdedir
# @DESCRIPTION:
# We set up KDEDIR according to the latest KDE version installed; installing our
# package for all available installs is just insane.
# We can check for kdelibs because it is the most basic package; no KDE package
# working without it. This might be changed in future.
get_latest_kdedir() {
	case ${KDE_WANTED} in
		# note this will need to be updated as stable moves and so on
		live)
			_versions="9999 4.2.61 4.2.0 4.1.0"
			;;
		snapshot)
			_versions="4.2.61 4.2.0 4.1.0 9999"
			;;
		testing)
			_versions="4.2.0 4.1.0 4.2.61 9999"
			;;
		stable)
			_versions="4.2.0 4.1.0 4.1.61 9999"
			;;
		*) die "KDE_WANTED=${KDE_WANTED} not supported here." ;;
	esac
	# check if exists and fallback as we go
	for X in ${_versions}; do
		if has_version ">=kde-base/kdelibs-${X}"; then
			# figure out which X we are in and set it into _kdedir
			case ${X} in
				# also keep track here same for kde_wanted
				9999)
					_kdedir="live"
					break
				;;
				4.3.0 | 4.2.61)
					_kdedir="4.3"
					break
				;;
				4.2.0 | 4.1.61)
					_kdedir="4.2"
					break
				;;
				4.1.0)
					_kdedir="4.1"
					break
				;;
			esac
		fi
	done

	debug-print-function ${FUNCNAME} "$@" "KDE_WANTED=${KDE_WANTED} -> _kdedir=${_kdedir}"
}

# @FUNCTION: migrate_store_dir
# @DESCRIPTION:
# Migrate the remnants of ${ESVN_STORE_DIR}/KDE/ to ${ESVN_STORE_DIR}/.
# Perform experimental split of kdebase to kdebase-apps.
migrate_store_dir() {
	local cleandir
	cleandir="${ESVN_STORE_DIR}/KDE"
	if [[ -d "${cleandir}" ]]; then
		ewarn "'${cleandir}' has been found. Moving contents to new location."
		addwrite "${ESVN_STORE_DIR}"
		# Split kdebase
		local module
		if pushd "${cleandir}"/kdebase/kdebase > /dev/null; then
			for module in `find . -maxdepth 1 -type d -name [a-z0-9]\*`; do
				module="${module#./}"
				mkdir -p "${ESVN_STORE_DIR}/kdebase-${module}" && mv -f "${module}" "${ESVN_STORE_DIR}/kdebase-${module}" || \
					die "Failed to move to '${ESVN_STORE_DIR}/kdebase-${module}'."
			done
			popd > /dev/null
			rm -fr "${cleandir}/kdebase" || \
				die "Failed to remove ${cleandir}/kdebase. You need to remove it manually."
		fi
		# Move the rest
		local pkg
		for pkg in "${cleandir}"/*; do
			mv -f "${pkg}" "${ESVN_STORE_DIR}"/ || eerror "failed to move ${pkg}"
		done
		rmdir "${cleandir}" || die "Could not move obsolete KDE store dir. Please move '${cleandir}' contents to appropriate location (possibly ${ESVN_STORE_DIR}) and manually remove '${cleandir}' in order to continue."
	fi
}

# Functions handling KMLOADLIBS and KMSAVELIBS

# @FUNCTION: save_library_dependencies
# @DESCRIPTION:
# Add exporting CMake dependencies for current package
save_library_dependencies() {
	local depsfile="${T}/${PN}:${SLOT}"

	ebegin "Saving library dependendencies in ${depsfile##*/}"
	echo "EXPORT_LIBRARY_DEPENDENCIES(\"${depsfile}\")" >> "${S}/CMakeLists.txt" || \
		die "Failed to save the library dependencies."
	eend $?
}

# @FUNCTION: install_library_dependencies
# @DESCRIPTION:
# Install generated CMake library dependencies to /var/lib/kde
install_library_dependencies() {
	local depsfile="$T/$PN:$SLOT"
	ebegin "Installing library dependendencies as ${depsfile##*/}"
	insinto /var/lib/kde
	doins "${depsfile}" || die "Failed to install library dependencies."
	eend $?
}

# @FUNCTION: load_library_dependencies
# @DESCRIPTION:
# Inject specified library dependencies in current package
load_library_dependencies() {
	local pn i depsfile
	ebegin "Injecting library dependendencies from '${KMLOADLIBS}'"

	i=0
	for pn in ${KMLOADLIBS} ; do
		((i++))
		depsfile="/var/lib/kde/${pn}:${SLOT}"
		[[ -r "${depsfile}" ]] || die "Depsfile '${depsfile}' not accessible. You probably need to reinstall ${pn}."
		sed -i -e "${i}iINCLUDE(\"${depsfile}\")" "${S}/CMakeLists.txt" || \
			die "Failed to include library dependencies for ${pn}"
	done
	eend $?
}
