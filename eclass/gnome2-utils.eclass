# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gnome2-utils.eclass,v 1.7 2008/02/10 14:47:14 eva Exp $

#
# gnome2-utils.eclass
#
# Set of auxiliary functions used to perform actions commonly needed by packages
# using the GNOME framework.
#
# Maintained by Gentoo's GNOME herd <gnome@gentoo.org>
#



# Path to gconftool-2
GCONFTOOL_BIN=${GCONFTOOL_BIN:="${ROOT}usr/bin/gconftool-2"}

# Directory where scrollkeeper-update should do its work
SCROLLKEEPER_DIR=${SCROLLKEEPER_DIR:="${ROOT}var/lib/scrollkeeper"}

# Path to scrollkeeper-update
SCROLLKEEPER_UPDATE_BIN=${SCROLLKEEPER_UPDATE_BIN:="${ROOT}usr/bin/scrollkeeper-update"}



DEPEND=">=sys-apps/sed-4"



# Applies any schema files installed by the current ebuild to Gconf's database
# using gconftool-2
gnome2_gconf_install() {
	if [[ ! -x ${GCONFTOOL_BIN} ]]; then
		return
	fi

	# We are ready to install the GCONF Scheme now
	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL
	export GCONF_CONFIG_SOURCE=$(${GCONFTOOL_BIN} --get-default-source)

	einfo "Installing GNOME 2 GConf schemas"

	local contents="${ROOT}var/db/pkg/*/${PN}-${PVR}/CONTENTS"
	local F

	for F in $(grep "^obj /etc/gconf/schemas/.\+\.schemas\b" ${contents} | gawk '{print $2}' ); do
		if [[ -e "${F}" ]]; then
			# echo "DEBUG::gconf install  ${F}"
			${GCONFTOOL_BIN} --makefile-install-rule ${F} 1>/dev/null
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


# Removes schema files previously installed by the current ebuild from Gconf's
# database.
gnome2_gconf_uninstall() {
	if [[ ! -x ${GCONFTOOL_BIN} ]]; then
		return
	fi

	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL
	export GCONF_CONFIG_SOURCE=$(${GCONFTOOL_BIN} --get-default-source)

	einfo "Uninstalling GNOME 2 GConf schemas"

	local contents="${ROOT}/var/db/pkg/*/${PN}-${PVR}/CONTENTS"
	local F

	for F in $(grep "obj /etc/gconf/schemas" ${contents} | sed 's:obj \([^ ]*\) .*:\1:' ); do
		# echo "DEBUG::gconf install  ${F}"
		${GCONFTOOL_BIN} --makefile-uninstall-rule ${F} 1>/dev/null
	done
}


# Updates Gtk+ icon cache files under /usr/share/icons if the current ebuild
# have installed anything under that location.
gnome2_icon_cache_update() {
	local updater=$(type -p gtk-update-icon-cache 2> /dev/null)

	if [[ ! -x ${updater} ]] ; then
		debug-print "${updater} is not executable"

		return
	fi

	ebegin "Updating icons cache"

	local retval=0
	local fails=( )

	for dir in $(find "${ROOT}/usr/share/icons" -maxdepth 1 -mindepth 1 -type d)
	do
		if [[ -f "${dir}/index.theme" ]] ; then
			local rv=0

			${updater} -qf ${dir}
			rv=$?

			if [[ ! $rv -eq 0 ]] ; then
				debug-print "Updating cache failed on ${dir}"

				# Add to the list of failures
				fails[$(( ${#fails[@]} + 1 ))]=$dir

				retval=2
			fi
		fi
	done

	eend ${retval}

	for (( i = 0 ; i < ${#fails[@]} ; i++ )) ; do
		### HACK!! This is needed until bash 3.1 is unmasked.
		## The current stable version of bash lists the sizeof fails to be 1
		## when there are no elements in the list because it is declared local.
		## In order to prevent the declaration from being in global scope, we
		## this hack to prevent an empty error message being printed for stable
		## users. -- compnerd && allanonjl
		if [[ "${fails[i]}" != "" && "${fails[i]}" != "()" ]] ; then
			eerror "Failed to update cache with icon ${fails[i]}"
		fi
	done
}


# Workaround applied to Makefile rules in order to remove redundant
# calls to scrollkeeper-update and sandbox violations.
gnome2_omf_fix() {
	local omf_makefiles filename

	omf_makefiles="$@"

	if [[ -f ${S}/omf.make ]] ; then
		omf_makefiles="${omf_makefiles} ${S}/omf.make"
	fi

	# testing fixing of all makefiles found
	for filename in $(find ./ -name "Makefile.in" -o -name "Makefile.am") ; do
		omf_makefiles="${omf_makefiles} ${filename}"
	done

	ebegin "Fixing OMF Makefiles"

	local retval=0
	local fails=( )

	for omf in ${omf_makefiles} ; do
		local rv=0

		sed -i -e 's:scrollkeeper-update:true:' ${omf}
		retval=$?

		if [[ ! $rv -eq 0 ]] ; then
			debug-print "updating of ${omf} failed"

			# Add to the list of failures
			fails[$(( ${#fails[@]} + 1 ))]=$omf

			retval=2
		fi
	done

	eend $retval

	for (( i = 0 ; i < ${#fails[@]} ; i++ )) ; do
		### HACK!! This is needed until bash 3.1 is unmasked.
		## The current stable version of bash lists the sizeof fails to be 1
		## when there are no elements in the list because it is declared local.
		## In order to prevent the declaration from being in global scope, we
		## this hack to prevent an empty error message being printed for stable
		## users. -- compnerd && allanonjl
		if [[ "${fails[i]}" != "" && "${fails[i]}" != "()" ]] ; then
			eerror "Failed to update OMF Makefile ${fails[i]}"
		fi
	done
}


# Updates the global scrollkeeper database.
gnome2_scrollkeeper_update() {
	if [[ -x ${SCROLLKEEPER_UPDATE_BIN} ]]; then
		einfo "Updating scrollkeeper database ..."
		${SCROLLKEEPER_UPDATE_BIN} -q -p ${SCROLLKEEPER_DIR}
	fi
}

