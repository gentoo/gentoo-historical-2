# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/unsermake/unsermake-0.0_pre20040505.ebuild,v 1.2 2004/05/07 14:21:27 dholm Exp $

IUSE=""
DESCRIPTION="Unsermake - Advanced KDE build system"
HOMEPAGE="http://www.kde.org"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
KEYWORDS="~x86 ~ppc"
LICENSE="GPL-2"
SLOT=0

S=${WORKDIR}/${PN}

DEPEND=">=dev-lang/python-2.2"
RDEPEND="$DEPEND"

src_compile()
{
	return
}

src_install()
{
	dodir /usr/kde/unsermake
	cp -a ${S}/* ${D}/usr/kde/unsermake
}

pkg_postinst()
{
	einfo
	einfo "To enable kde builds with unsermake, set the unsermake environent"
	einfo "variable:  export UNSERMAKE=\"/usr/kde/unsermake/unsermake\""
	einfo
	einfo "Unsermake builds are highly experimental; use at your own risk"
	einfo
}
