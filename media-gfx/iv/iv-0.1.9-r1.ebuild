# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/iv/iv-0.1.9-r1.ebuild,v 1.1 2002/10/30 21:04:49 lostlogic Exp $

S=${WORKDIR}/${P}
DESCRIPTION="This is an image viewer"
SRC_URI="ftp://wolfpack.twu.net/users/wolfpack/iv-0.1.9.tar.bz2"
HOMEPAGE="http://wolfpack.twu.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND=">=media-libs/imlib-1.9.13
	=x11-libs/gtk+-1.2*"

src_unpack() {
	unpack ${A}
	cd ${P}
	patch -p1 < ${FILESDIR}/${P}-gentoo.patch || die "Patch failed"
}

src_compile() {
	cd iv
	emake || die
}

src_install () {
	dobin iv/iv
	dodir /usr/share/icons
	insinto /usr/share/icons
	doins iv/images/iv.xpm
	doman iv/iv.1
	dodoc LICENSE README
}
