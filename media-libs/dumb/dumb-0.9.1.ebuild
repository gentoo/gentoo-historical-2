# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/dumb/dumb-0.9.1.ebuild,v 1.4 2004/06/24 22:58:02 agriffis Exp $

DESCRIPTION="IT, XM, S3M and MOD player library"
SRC_URI="mirror://sourceforge/dumb/${P}.tar.gz"
HOMEPAGE="http://dumb.sourceforge.net/"

LICENSE="DUMB"
SLOT="0"
KEYWORDS="x86 ~alpha ~ia64"

RDEPEND="media-libs/allegro"

S=${WORKDIR}/${PN}

src_compile() {
	make -f make/makefile.uni OFLAGS="${CFLAGS}" all || die
}

src_install() {
	dodir /usr/lib /usr/include
	make -f make/makefile.uni install PREFIX=${D}/usr || die

	dodoc readme.txt release.txt docs/*
	insinto /usr/share/${PN}
	doins examples/*.{c,ini}
}
