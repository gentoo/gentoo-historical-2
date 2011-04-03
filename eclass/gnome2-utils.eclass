# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gnome2-utils.eclass,v 1.22 2011/04/03 18:12:34 eva Exp $

# @ECLASS: gnome2-utils.eclass
# @MAINTAINER: 
# gnome@gentoo.org
# @BLURB: Auxiliary functions commonly used by Gnome packages.
# @DESCRIPTION:
# This eclass provides a set of auxiliary functions needed by most Gnome
# packages. It may be used by non-Gnome packages as needed for handling various
# Gnome stack related functions such as:
#  * Gtk+ icon cache management
#  * GSettings schemas management
#  * GConf schemas management
#  * scrollkeeper (old Gnome help system) management

case "${EAPI:-0}" in
	0|1|2|3|4) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

# @ECLASS-VARIABLE: GCONFTOOL_BIN
# @INTERNAL
# @DESCRIPTION:
# Path to gconftool-2
: ${GCONFTOOL_BIN:="/usr/bin/gconftool-2"}

# @ECLASS-VARIABLE: SCROLLKEEPER_DIR
# @INTERNAL
# @DESCRIPTION:
# Directory where scrollkeeper-update should do its work
: ${SCROLLKEEPER_DIR:="/var/lib/scrollkeeper"}

# @ECLASS-VARIABLE: SCROLLKEEPER_UPDATE_BIN
# @INTERNAL
# @DESCRIPTION:
# Path to scrollkeeper-update
: ${SCROLLKEEPER_UPDATE_BIN:="/usr/bin/scrollkeeper-update"}

# @ECLASS-VARIABLE: GTK_UPDATE_ICON_CACHE
# @INTERNAL
# @DESCRIPTION:
# Path to gtk-update-icon-cache
: ${GTK_UPDATE_ICON_CACHE:="/usr/bin/gtk-update-icon-cache"}

# @ECLASS-VARIABLE: GLIB_COMPILE_SCHEMAS
# @INTERNAL
# @DESCRIPTION:
# Path to glib-compile-schemas
: ${GLIB_COMPILE_SCHEMAS:="/usr/bin/glib-compile-schemas"}

# @ECLASS-VARIABLE: GNOME2_ECLASS_SCHEMAS
# @INTERNAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of GConf schemas provided by the package

# @ECLASS-VARIABLE: GNOME2_ECLASS_ICONS
# @INTERNAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of icons provided by the package

# @ECLASS-VARIABLE: GNOME2_ECLASS_GLIB_SCHEMAS
# @INTERNAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of GSettings schemas provided by the package


DEPEND=">=sys-apps/sed-4"


# @FUNCTION: gnome2_gconf_savelist
# @DESCRIPTION:
# Find the GConf schemas that are about to be installed and save their location
# in the GNOME2_ECLASS_SCHEMAS environment variable.
# This function should be called from pkg_preinst.
gnome2_gconf_savelist() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && ED="${D}"
	pushd "${ED}" &> /dev/null
	export GNOME2_ECLASS_SCHEMAS=$(find 'etc/gconf/schemas/' -name '*.schemas' 2> /dev/null)
	popd &> /dev/null
}

# @FUNCTION: gnome2_gconf_install
# @DESCRIPTION:
# Applies any schema files installed by the current ebuild to Gconf's database
# using gconftool-2.
# This function should be called from pkg_postinst.
gnome2_gconf_install() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && EROOT="${ROOT}"
	local updater="${EROOT}${GCONFTOOL_BIN}"

	if [[ ! -x "${updater}" ]]; then
		debug-print "${updater} is not executable"
		return
	fi

	if [[ -z "${GNOME2_ECLASS_SCHEMAS}" ]]; then
		debug-print "No GNOME 2 GConf schemas found"
		return
	fi

	# We are ready to install the GCONF Scheme now
	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL
	export GCONF_CONFIG_SOURCE="$("${updater}" --get-default-source | sed "s;:/;:${ROOT};")"

	einfo "Installing GNOME 2 GConf schemas"

	local F
	for F in ${GNOME2_ECLASS_SCHEMAS}; do
		if [[ -e "${EROOT}${F}" ]]; then
			debug-print "Installing schema: ${F}"
			"${updater}" --makefile-install-rule "${EROOT}${F}" 1>/dev/null
		fi
	done

	# have gconf reload the new schemas
	pids=$(pgrep -x gconfd-2)
	if [[ $? == 0 ]] ; then
		ebegin "Reloading GConf schemas"
		kill -HUP ${pids}
		eend $?
	fi
}

# @FUNCTION: gnome2_gconf_uninstall
# @DESCRIPTION:
# Removes schema files previously installed by the current ebuild from Gconf's
# database.
gnome2_gconf_uninstall() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && EROOT="${ROOT}"
	local updater="${EROOT}${GCONFTOOL_BIN}"

	if [[ ! -x "${updater}" ]]; then
		debug-print "${updater} is not executable"
		return
	fi

	if [[ -z "${GNOME2_ECLASS_SCHEMAS}" ]]; then
		debug-print "No GNOME 2 GConf schemas found"
		return
	fi

	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL
	export GCONF_CONFIG_SOURCE="$("${updater}" --get-default-source | sed "s;:/;:${ROOT};")"

	einfo "Uninstalling GNOME 2 GConf schemas"

	local F
	for F in ${GNOME2_ECLASS_SCHEMAS}; do
		if [[ -e "${EROOT}${F}" ]]; then
			debug-print "Uninstalling gconf schema: ${F}"
			"${updater}" --makefile-uninstall-rule "${EROOT}${F}" 1>/dev/null
		fi
	done

	# have gconf reload the new schemas
	pids=$(pgrep -x gconfd-2)
	if [[ $? == 0 ]] ; then
		ebegin "Reloading GConf schemas"
		kill -HUP ${pids}
		eend $?
	fi
}

# @FUNCTION: gnome2_icon_savelist
# @DESCRIPTION:
# Find the icons that are about to be installed and save their location
# in the GNOME2_ECLASS_ICONS environment variable.
# This function should be called from pkg_preinst.
gnome2_icon_savelist() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && ED="${D}"
	pushd "${ED}" &> /dev/null
	export GNOME2_ECLASS_ICONS=$(find 'usr/share/icons' -maxdepth 1 -mindepth 1 -type d 2> /dev/null)
	popd &> /dev/null
}

# @FUNCTION: gnome2_icon_cache_update
# @DESCRIPTION:
# Updates Gtk+ icon cache files under /usr/share/icons if the current ebuild
# have installed anything under that location.
# This function should be called from pkg_postinst and pkg_postrm.
gnome2_icon_cache_update() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && EROOT="${ROOT}"
	local updater="${EROOT}${GTK_UPDATE_ICON_CACHE}"

	if [[ ! -x "${updater}" ]] ; then
		debug-print "${updater} is not executable"
		return
	fi

	if [[ -z "${GNOME2_ECLASS_ICONS}" ]]; then
		debug-print "No icon cache to update"
		return
	fi

	ebegin "Updating icons cache"

	local retval=0
	local fails=( )

	for dir in ${GNOME2_ECLASS_ICONS}
	do
		if [[ -f "${EROOT}${dir}/index.theme" ]] ; then
			local rv=0

			"${updater}" -qf "${EROOT}${dir}"
			rv=$?

			if [[ ! $rv -eq 0 ]] ; then
				debug-print "Updating cache failed on ${EROOT}${dir}"

				# Add to the list of failures
				fails[$(( ${#fails[@]} + 1 ))]="${EROOT}${dir}"

				retval=2
			fi
		fi
	done

	eend ${retval}

	for f in "${fails[@]}" ; do
		eerror "Failed to update cache with icon $f"
	done
}

# @FUNCTION: gnome2_omf_fix
# @DESCRIPTION:
# Workaround applied to Makefile rules in order to remove redundant
# calls to scrollkeeper-update and sandbox violations.
# This function should be called from src_prepare.
gnome2_omf_fix() {
	local omf_makefiles filename

	omf_makefiles="$@"

	if [[ -f ${S}/omf.make ]] ; then
		omf_makefiles="${omf_makefiles} ${S}/omf.make"
	fi

	# testing fixing of all makefiles found
	# The sort is important to ensure .am is listed before the respective .in for
	# maintainer mode regeneration not kicking in due to .am being newer than .in
	for filename in $(find ./ -name "Makefile.in" -o -name "Makefile.am" |sort) ; do
		omf_makefiles="${omf_makefiles} ${filename}"
	done

	ebegin "Fixing OMF Makefiles"

	local retval=0
	local fails=( )

	for omf in ${omf_makefiles} ; do
		local rv=0

		sed -i -e 's:scrollkeeper-update:true:' "${omf}"
		retval=$?

		if [[ ! $rv -eq 0 ]] ; then
			debug-print "updating of ${omf} failed"

			# Add to the list of failures
			fails[$(( ${#fails[@]} + 1 ))]=$omf

			retval=2
		fi
	done

	eend $retval

	for f in "${fails[@]}" ; do
		eerror "Failed to update OMF Makefile $f"
	done
}

# @FUNCTION: gnome2_scrollkeeper_update
# @DESCRIPTION:
# Updates the global scrollkeeper database.
# This function should be called from pkg_postinst and pkg_postrm.
gnome2_scrollkeeper_update() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && EROOT="${ROOT}"
	if [[ -x "${EROOT}${SCROLLKEEPER_UPDATE_BIN}" ]]; then
		einfo "Updating scrollkeeper database ..."
		"${EROOT}${SCROLLKEEPER_UPDATE_BIN}" -q -p "${EROOT}${SCROLLKEEPER_DIR}"
	fi
}

# @FUNCTION: gnome2_schemas_savelist
# @DESCRIPTION:
# Find if there is any GSettings schema to install and save the list in
# GNOME2_ECLASS_GLIB_SCHEMAS variable.
# This function should be called from pkg_preinst.
gnome2_schemas_savelist() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && ED="${D}"
	pushd "${ED}" &>/dev/null
	export GNOME2_ECLASS_GLIB_SCHEMAS=$(find 'usr/share/glib-2.0/schemas' -name '*.gschema.xml' 2>/dev/null)
	popd &>/dev/null
}

# @FUNCTION: gnome2_schemas_update
# @USAGE: gnome2_schemas_update [--uninstall]
# @DESCRIPTION:
# Updates GSettings schemas if GNOME2_ECLASS_GLIB_SCHEMAS has some.
# This function should be called from pkg_postinst and pkg_postrm with --uninstall.
gnome2_schemas_update() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && EROOT="${ROOT}"
	local updater="${EROOT}${GLIB_COMPILE_SCHEMAS}"

	if [[ ! -x ${updater} ]]; then
		debug-print "${updater} is not executable"
		return
	fi

	if [[ -z ${GNOME2_ECLASS_GLIB_SCHEMAS} ]]; then
		debug-print "No GSettings schemas to update"
		return
	fi

	ebegin "Updating GSettings schemas"
	${updater} --allow-any-name "$@" "${EROOT%/}/usr/share/glib-2.0/schemas" &>/dev/null
	eend $?
}
