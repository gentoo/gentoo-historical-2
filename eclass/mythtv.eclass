# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/mythtv.eclass,v 1.2 2006/09/20 03:43:24 cardoe Exp $
#
# Author: Doug Goldstein <cardoe@gentoo.org>
#
# Downloads the MythTV source packages and any patches from the fixes branch
#
inherit eutils

# Release version
MY_PV="${PV%_*}"

# SVN revision number to increment from the released version
if [ "x${MY_PV}" != "x${PV}" ]; then
	PATCHREV="${PV##*_p}"
fi

if [ "x${PN}" = "xmythtv" ]; then
	MY_PN="mythtv"
else
	MY_PN="mythplugins"
fi

HOMEPAGE="http://www.mythtv.org"
LICENSE="GPL-2"
SRC_URI="http://ftp.osuosl.org/pub/mythtv/${MY_PN}-${MY_PV}.tar.bz2"
if [ -n "${PATCHREV}" ] ; then
	SRC_URI="${SRC_URI} http://dev.gentoo.org/~cardoe/files/mythtv/${MY_PN}-${MY_PV}_svn${PATCHREV}.patch.bz2"
fi

mythtv-fixes_patch() {
	if [ -n "$PATCHREV" ]; then
		epatch ${WORKDIR}/${MY_PN}-${MY_PV}_svn${PATCHREV}.patch
	fi
}
