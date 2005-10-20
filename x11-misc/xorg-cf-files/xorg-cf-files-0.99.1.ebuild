# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xorg-cf-files/xorg-cf-files-0.99.1.ebuild,v 1.1 2005/10/20 06:50:48 joshuabaergen Exp $

# Must be before x-modular eclass is inherited
# SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="Old Imake-related build files"
KEYWORDS="~x86"
RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	x-modular_src_install

	# Hack to supply missing files until it's fixed upstream
	echo "" >> ${D}/usr/lib/X11/config/host.def
	echo "" >> ${D}/usr/lib/X11/config/version.def
	echo "" >> ${D}/usr/lib/X11/config/date.def
}
