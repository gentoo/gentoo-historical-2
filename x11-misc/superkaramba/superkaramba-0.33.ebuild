# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/superkaramba/superkaramba-0.33.ebuild,v 1.1 2003/10/21 15:03:05 mholzer Exp $

IUSE="doc"

inherit kde

need-kde 3

DESCRIPTION="A version of Karamba with extra extensions in-built"
HOMEPAGE="http://netdragon.sourceforge.net/"
SRC_URI="mirror://sourceforge/netdragon/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
RESTRICT="nomirror"

newdepend ">=kde-base/kdelibs-3.1
	>=sys-apps/portage-2.0.49-r3"

src_install () {
	einstall
	dodir /usr/share/karamba/themes /usr/share/karamba/bin
	keepdir /usr/share/karamba/themes /usr/share/karamba/bin
	dodir /etc/env.d
	cp ${FILESDIR}/karamba-env ${D}/etc/env.d/99karamba
	if [ `use doc` ]; then
		dodir /usr/share/doc/${P}/examples
		mv ${D}/usr/share/doc/* ${D}/usr/share/doc/${P}
		cp ${S}/examples/* ${D}/usr/share/doc/${P}/examples
	else
		rm -Rf ${D}/usr/share/doc
	fi
}
