# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/xfree.eclass,v 1.4 2003/07/18 16:08:01 seemant Exp $
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

EXPORT_FUNCTIONS vcards


vcards() {
	
	has "$1" "${VIDEO_CARDS}" && return 0
	return 1
}

filter-patch() {
	mv ${PATCH_DIR}/"*${1}*" ${PATCH_DIR}/excluded
}
