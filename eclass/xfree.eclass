# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/xfree.eclass,v 1.8 2003/09/30 07:01:57 spyderous Exp $
#
# Author: Seemant Kulleen <seemant@gentoo.org>
#
# The xfree.eclass is designed to ease the checking functions that are
# performed in xfree and xfree-drm ebuilds.  In the new scheme, a variable
# called VIDEO_CARDS will be used to indicate which cards a user wishes to
# build support for.  Note, that this variable is only unlocked if the USE
# variable "expertxfree" is switched on, at least for xfree.

ECLASS=xfree
INHERITED="${INHERITED} ${ECLASS}"

EXPORT_FUNCTIONS vcards is_kernel strip_bins

vcards() {	
	has "$1" ${VIDEO_CARDS} && return 0
	return 1
}

filter-patch() {
	mv ${PATCH_DIR}/"*${1}*" ${PATCH_DIR}/excluded
}

# This is to ease kernel checks for patching and other things. (spyderous)
# Kernel checker is_kernel $1 $2 where $1 is KV_major and $2 is KV_minor.
# is_kernel "2" "4" should map to a 2.4 kernel, etc.

get_KV_info() {
	check_KV

	# Get the kernel version of sources in /usr/src/linux ...
	export KV_full="$(awk '/UTS_RELEASE/ { gsub("\"", "", $3); print $3 }' \
		"${ROOT}/usr/src/linux/include/linux/version.h")"
	export KV_major="$(echo "${KV_full}" | cut -d. -f1)"
	export KV_minor="$(echo "${KV_full}" | cut -d. -f2)"
	export KV_micro="$(echo "${KV_full}" | cut -d. -f3 | sed -e 's:[^0-9].*::')"
}

is_kernel() {
        get_KV_info
                                                                                
        if [ "${KV_major}" -eq ${1} -a "${KV_minor}" -eq ${2} ]
        then
                return 0
        else
                return 1
        fi
}

# For stripping binaries, but not drivers or modules.
strip_bins() {
        einfo "Stripping binaries..."
        # This bit I got from Redhat ... strip binaries and drivers ..
        # NOTE:  We do NOT want to strip the drivers, modules or DRI modules!
        for x in $(find ${D}/ -type f -perm +0111 -exec file {} \; | \
                grep -v ' shared object,' | \
                sed -n -e 's/^\(.*\):[  ]*ELF.*, not stripped/\1/p')
        do
        if [ -f ${x} ]
                then
                        # Dont do the modules ...
                        if [ "${x/\/lib\/modules}" = "${x}" ]
                        then
                                echo "`echo ${x} | sed -e "s|${D}||"`"
                                strip ${x} || :
                        fi
                        if [ "${x/\usr\/X11R6\/lib\/modules}" = "${x}" ]
                        then
                                echo "`echo ${x} | sed -e "s|${D}||"`"
                                strip ${x} || :
                        fi
                fi
        done
}
