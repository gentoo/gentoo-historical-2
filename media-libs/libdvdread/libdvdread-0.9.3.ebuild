# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdvdread/libdvdread-0.9.3.ebuild,v 1.8 2003/09/06 23:59:48 msterret Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Provides a simple foundation for reading DVD-Video images."
SRC_URI="http://www.dtek.chalmers.se/groups/dvd/dist/libdvdread-${PV}.tar.gz"
HOMEPAGE="http://www.dtek.chalmers.se/groups/dvd/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc "

DEPEND=">=media-libs/libdvdcss-1.1.1"

src_compile() {

	econf || die
	make || die
}

src_install() {

	einstall || die

	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
}
