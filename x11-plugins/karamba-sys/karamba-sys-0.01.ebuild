# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/karamba-sys/karamba-sys-0.01.ebuild,v 1.5 2004/03/26 23:10:07 aliz Exp $

IUSE=""
DESCRIPTION="Disk Usage plugin for Karamba"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=5823"
SRC_URI="http://mgoransson.com/GENTOO/KDE/karamba_sys.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"

RDEPEND="|| ( >=x11-misc/karamba-0.17 >=x11-misc/superkaramba-0.21 )"

src_unpack () {
	unpack ${A}
	mv karamba_sys ${P}
}

src_compile () {
	echo -n ""
}

src_install () {
	dodir /usr/share/karamba/themes/sys
	cp -r * ${D}/usr/share/karamba/themes/sys/
	chmod -R go=u,go-w ${D}/usr/share/karamba/themes/sys
}
