# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/unsermake/unsermake-0.3.0.4254.0.ebuild,v 1.4 2006/09/23 20:14:55 flameeyes Exp $

IUSE=""
DESCRIPTION="Unsermake - Advanced KDE build system"
HOMEPAGE="http://wiki.kde.org/tiki-index.php?page=unsermake"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
KEYWORDS="~amd64 ppc x86"
LICENSE="GPL-2"
SLOT=0

DEPEND=">=dev-lang/python-2.2"
RDEPEND="${RDEPEND}"

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
