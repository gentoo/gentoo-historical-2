# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/uriparser/uriparser-0.7.1.ebuild,v 1.5 2008/06/20 10:39:03 opfer Exp $

DESCRIPTION="Uriparser is a strictly RFC 3986 compliant URI parsing library in C"
HOMEPAGE="http://uriparser.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="doc"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

src_compile() {
	econf --disable-dependency-tracking
	emake || die "emake failed"

	if use doc; then
		cd doc
		econf
		doxygen Doxyfile || die "doxygen failed."
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog THANKS doc/*.txt
	dohtml doc/*.htm

	if use doc; then
		dohtml doc/html/*
	fi
}
