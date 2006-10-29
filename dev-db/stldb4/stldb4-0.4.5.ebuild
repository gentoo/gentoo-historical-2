# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/stldb4/stldb4-0.4.5.ebuild,v 1.1 2006/10/29 03:00:18 vapier Exp $

DESCRIPTION="a nice C++ wrapper for db4"
HOMEPAGE="http://witme.sourceforge.net/libferris.web/"
SRC_URI="mirror://sourceforge/witme/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/ferrisloki-2.0.3
	>=dev-libs/libferrisstreams-0.3.6
	dev-libs/STLport"

fsrc_unpack() {
	unpack ${A}
	cd "${S}"/db-4.1.25/dist
	make -s distclean || die
}

src_compile() {
	econf \
		--enable-wrapdebug \
		--enable-rpc \
		--with-uniquename=stldb4 || die
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README
}
