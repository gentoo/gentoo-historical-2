# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gif2png/gif2png-2.4.6.ebuild,v 1.4 2004/06/24 22:38:03 agriffis Exp $

IUSE=""

S=${WORKDIR}/${P}
DESCRIPTION="gif2png"
SRC_URI="http://catb.org/~esr/${PN}/${P}.tar.gz"
HOMEPAGE="http://catb.org/~esr/gif2png/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

DEPEND="media-libs/libpng"

src_compile() {
	econf --prefix=/usr || die "econf failed"
	emake || die "emake failed"
}


src_install() {
	dodir ${D}/usr/bin
	make \
		DESTDIR=${D} \
		install || die "make install failed"
}

