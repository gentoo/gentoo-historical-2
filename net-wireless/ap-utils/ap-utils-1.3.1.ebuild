# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/ap-utils/ap-utils-1.3.1.ebuild,v 1.4 2003/10/27 11:02:13 aliz Exp $

IUSE="nls"

DESCRIPTION="Wireless Access Point Utilites for Unix"
HOMEPAGE="http://ap-utils.polesye.net/"
SRC_URI="mirror://sourceforge/ap-utils/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
DEPEND=">=bison-1.34"
RDEPEND=""

src_compile() {
	econf --build=${CHOST} `use_enable nls` || die
	emake || die
}

src_install () {
	einstall || die
}
