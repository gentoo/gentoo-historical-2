# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/stldb4/stldb4-0.3.7.ebuild,v 1.2 2004/04/14 02:36:06 vapier Exp $

inherit flag-o-matic

DESCRIPTION="a nice C++ wrapper for db4"
HOMEPAGE="http://witme.sourceforge.net/libferris.web/"
SRC_URI="mirror://sourceforge/witme/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=dev-libs/ferrisloki-2.0.3
	>=dev-libs/libferrisstreams-0.3.6
	dev-libs/STLport"

src_unpack() {
	unpack ${A}
	cd ${S}
	ln -s ${S}/db-4.1.25/dist STLdb4
	append-flags -I${S}
}

src_compile() {
	econf --enable-wrapdebug --enable-rpc --with-uniquename=stldb4 || die
	emake || die
}

src_install() {
	make install DESTDIR=${D} || die
	dodoc AUTHORS ChangeLog NEWS README
}
