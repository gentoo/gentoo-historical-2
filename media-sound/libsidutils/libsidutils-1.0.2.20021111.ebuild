# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/libsidutils/libsidutils-1.0.2.20021111.ebuild,v 1.2 2002/11/11 18:31:05 hanno Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="C64 SID player utilities"
HOMEPAGE="http://sidplay2.sourceforge.net/"
SRC_URI="http://www-ti.informatik.uni-tuebingen.de/~bwurst/${P}.tar.bz2"
IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="virtual/glibc
        >=media-libs/libsidplay-2.0.8"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS INSTALL
}
